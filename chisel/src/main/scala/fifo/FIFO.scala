/* vim: set syntax=spinal et sw=2 ts=2: */

package fifo

import chisel3._
import chisel3.experimental.BundleLiterals._
// _root_ disambiguates from package chisel3.util.circt if user imports chisel3.util._
import _root_.circt.stage.ChiselStage

class VData[T <: Data](T : T) extends Bundle {
  val data  = T
  val valid = Bool()
}

class HandShake[T <: Data](T : T) extends Bundle {
  val vdata = Output(new VData(T))
  val ready = Input(Bool())
}

class WrCntr[T <: Data](T : T, depth : Int) extends Module {
  val i_port = IO(Flipped(new HandShake(T)))
  val o_mem  = IO(new Bundle {
    val addr = Output(UInt(depth.W))
    val data = Output(T)
    val en   = Output(Bool())
  })
  val i_addr = IO(Input(UInt((depth+1).W)))
  val o_addr = IO(Output(UInt((depth+1).W)))

  // Регистр адреса записи
  val addr = RegInit(0.U((depth+1).W))
  when (o_mem.en) {
    addr := addr+1.U
  }

  // Можем принять данные, если в памяти есть место
  i_port.ready := addr =/= (i_addr+(1.U<<depth))

  // Пишем в память, если можем принять данные и если пришли данные
  o_mem.addr := addr
  o_mem.data := i_port.vdata.data
  o_mem.en   := i_port.ready & i_port.vdata.valid

  o_addr := addr
}

class RdCntr[T <: Data](T : T, depth : Int) extends Module {
  val o_port = IO(new HandShake(T))
  val o_mem  = IO(new Bundle {
    val addr = Output(UInt(depth.W))
    val data = Input(T)
    val en   = Output(Bool())
  })
  val i_addr = IO(Input(UInt((depth+1).W)))
  val o_addr = IO(Output(UInt((depth+1).W)))

  // Регистр адреса чтения
  val addr = RegInit(0.U((depth+1).W))
  when (o_mem.en) {
    addr := addr+1.U
  }

  // Результат чтения из памяти
  val buf0 = Wire(new VData(T))
  buf0.data  := o_mem.data
  buf0.valid := RegNext(o_mem.en, false.B)

  // Регистры skid buffer'а
  val buf1 = RegInit((new VData(T)).Lit(_.valid -> false.B))
  val buf2 = RegInit({ val init = Wire(new VData(T)); init := DontCare; init.valid := false.B; init })

  when (buf0.valid || !buf2.valid) {
    buf1 := buf0;
  }

  when (o_port.ready) {
    buf2.valid := false.B
  } .elsewhen (! buf2.valid) {
    buf2 := buf1
  }

  // Читаем из памяти, если в памяти есть данные и просят данные или если в buf0, buf1 и buf2 не более одного валидного данного
  o_mem.addr := addr
  o_mem.en   := addr =/= i_addr && ( o_port.ready ||
                                     ((buf0.valid || buf1.valid || buf2.valid) === false.B) ||
                                     ((buf0.valid ^ buf1.valid ^ buf1.valid) === true.B && (buf0.valid && buf1.valid && buf1.valid) === false.B) )

  // Выдаем данные либо из buf2, либо из buf1
  o_port.vdata := Mux(buf2.valid, buf2, buf1);

  o_addr := addr
}

class FIFO[T <: Data](T : T, depth : Int) extends Module {
  val i_port = IO(Flipped(new HandShake(T)))
  val o_port = IO(new HandShake(T))

  // Описание внутренних модулей
  val wctrl = Module(new WrCntr(T, depth))
  val rctrl = Module(new RdCntr(T, depth))

  // Подключение портов
  wctrl.i_port <> i_port
  rctrl.o_port <> o_port

  // Подключение сигналов
  wctrl.i_addr := rctrl.o_addr
  rctrl.i_addr := wctrl.o_addr

  // Объявление и использование памяти
  val mem = SyncReadMem(1<<depth, T)
  when (wctrl.o_mem.en) {
    mem.write(wctrl.o_mem.addr, wctrl.o_mem.data)
  }
  rctrl.o_mem.data := mem.read(rctrl.o_mem.addr, rctrl.o_mem.en)
}

object FIFOSystemVerilog extends App {
  ChiselStage.emitSystemVerilogFile(
    new FIFO(UInt(16.W), 5),
    args = Array("--target-dir", "gen"),
    firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
  )
}

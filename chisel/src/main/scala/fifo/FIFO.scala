/* vim: set syntax=spinal et sw=2 ts=2: */

package fifo

import chisel3._
import chisel3.experimental.BundleLiterals._
// _root_ disambiguates from package chisel3.util.circt if user imports chisel3.util._
import _root_.circt.stage.ChiselStage

class VData[T <: Data](T : T) extends Bundle {
  val data  = T // T.cloneType, если нужно несколько полей T
  val valid = Bool()
}

class HandShake[T <: Data](T : T) extends Bundle {
  val vdata = Output(new VData(T))
  val ready = Input(Bool())
}

class FIFOWriteController[T <: Data](T : T, depth : Int) extends Module {
  val i_port = IO(Flipped(new HandShake(T)))
  val o_wmem = IO(new Bundle {
    val addr = Output(UInt(depth.W))
    val data = Output(T)
    val en   = Output(Bool())
  })
  val i_addr = IO(Input(UInt((depth+1).W)))
  val o_addr = IO(Output(UInt((depth+1).W)))

  val addr = RegInit(0.U((depth+1).W))
  when (o_wmem.en) {
    addr := addr+1.U
  }

  i_port.ready := addr =/= (i_addr+(1.U<<depth))

  o_wmem.addr := addr
  o_wmem.data := i_port.vdata.data
  o_wmem.en   := i_port.ready & i_port.vdata.valid

  o_addr := addr
}

class FIFOReadController[T <: Data](T : T, depth : Int) extends Module {
  val o_port = IO(new HandShake(T))
  val o_rmem = IO(new Bundle {
    val addr = Output(UInt(depth.W))
    val data = Input(T)
    val en   = Output(Bool())
  })
  val i_addr = IO(Input(UInt((depth+1).W)))
  val o_addr = IO(Output(UInt((depth+1).W)))

  val addr = RegInit(0.U((depth+1).W))

  val buf0 = Wire(new VData(T))
  val buf1 = RegInit((new VData(T)).Lit(_.valid -> false.B))
  val buf2 = RegInit({ val init = Wire(new VData(T)); init := DontCare; init.valid := false.B; init })

  o_rmem.addr := addr
  o_rmem.en   := addr =/= i_addr && ( o_port.ready ||
                                      ((buf0.valid || buf1.valid || buf2.valid) === false.B) ||
                                      ((buf0.valid ^ buf1.valid ^ buf1.valid) === true.B && (buf0.valid && buf1.valid && buf1.valid) === false.B) )
  when (o_rmem.en) {
    addr := addr+1.U
  }

  buf0.data  := o_rmem.data
  buf0.valid := RegNext(o_rmem.en, false.B)

  when (buf0.valid || !buf2.valid) {
    buf1 := buf0;
  }

  when (o_port.ready) {
    buf2.valid := false.B
  } .elsewhen (! buf2.valid) {
    buf2 := buf1
  }

  o_port.vdata := Mux(buf2.valid, buf2, buf1);

  o_addr := addr
}

class FIFO[T <: Data](T : T, depth : Int) extends Module {
  val i_port = IO(Flipped(new HandShake(T)))
  val o_port = IO(new HandShake(T))

  val mem = SyncReadMem(1<<depth, T)
  val wctrl = Module(new FIFOWriteController(T, depth))
  val rctrl = Module(new FIFOReadController(T, depth))

  wctrl.i_port <> i_port
  rctrl.o_port <> o_port

  when (wctrl.o_wmem.en) {
    mem.write(wctrl.o_wmem.addr, wctrl.o_wmem.data)
  }
  rctrl.o_rmem.data := mem.read(rctrl.o_rmem.addr, rctrl.o_rmem.en)

  wctrl.i_addr := rctrl.o_addr
  rctrl.i_addr := wctrl.o_addr
}

object FIFOSystemVerilog extends App {
  ChiselStage.emitSystemVerilogFile(
    new FIFO(UInt(16.W), 5),
    args = Array("--target-dir", "gen"),
    firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
  )
}

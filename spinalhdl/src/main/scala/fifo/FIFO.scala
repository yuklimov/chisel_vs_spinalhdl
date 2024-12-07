/* vim: set syntax=spinal et sw=2 ts=2: */

package fifo

import spinal.core._
import spinal.lib._

case class VData[T <: Data](T : HardType[T]) extends Bundle {
  val data  = T()
  val valid = Bool()
}

case class HandShake[T <: Data](T : HardType[T]) extends Bundle with IMasterSlave {
  val vdata = VData(T)
  val ready = Bool()

  override def asMaster(): Unit = {
    out(vdata)
    in(ready)
  }
}

case class WrCntr[T <: Data](T : HardType[T], depth : Int) extends Component {
  val i_port = slave(HandShake(T))
  val o_mem  = new Bundle {
    val addr = out(UInt(depth bits))
    val data = out(T())
    val en   = out(Bool())
  }
  val i_addr = in(UInt(depth+1 bits))
  val o_addr = out(UInt(depth+1 bits))

  // Регистр адреса записи
  val addr = RegInit(U(0, depth+1 bits))
  when (o_mem.en) {
    addr := addr+1
  }

  // Можем принять данные, если в памяти есть место
  i_port.ready := addr =/= (i_addr+(1<<depth))

  // Пишем в память, если можем принять данные и если пришли данные
  o_mem.addr := addr.resize(depth bits)
  o_mem.data := i_port.vdata.data
  o_mem.en   := i_port.ready & i_port.vdata.valid

  o_addr := addr
}

case class RdCntr[T <: Data](T : HardType[T], depth : Int) extends Component {
  val o_port = master(HandShake(T))
  val o_mem  = new Bundle {
    val addr = out(UInt(depth bits))
    val data = in(T())
    val en   = out(Bool())
  }
  val i_addr = in(UInt(depth+1 bits))
  val o_addr = out(UInt(depth+1 bits))

  // Регистр адреса чтения
  val addr = Reg(UInt(depth+1 bits)) init(0)
  when (o_mem.en) {
    addr := addr+1
  }

  // Результат чтения из памяти
  val buf0 = VData(T);
  buf0.data  := o_mem.data
  buf0.valid := RegNext(o_mem.en) init(False)

  // Регистры skid buffer'а
  val buf1 = Reg(VData(T)); buf1.valid.init(False)
  val buf2 = Reg(VData(T)) init({val tmp = VData(T); tmp.data.assignDontCare(); tmp.valid := False; tmp})

  when (buf0.valid || !buf2.valid) {
    buf1 := buf0;
  }

  when (o_port.ready) {
    buf2.valid := False
  } elsewhen (! buf2.valid) {
    buf2 := buf1
  }

  // Читаем из памяти, если в памяти есть данные и просят данные или если в buf0, buf1 и buf2 не более одного валидного данного
  o_mem.addr := addr.resize(depth bits)
  o_mem.en   := addr =/= i_addr && ( o_port.ready ||
                                     ((buf0.valid || buf1.valid || buf2.valid) === False) ||
                                     ((buf0.valid ^ buf1.valid ^ buf1.valid) === True && (buf0.valid && buf1.valid && buf1.valid) === False) )

  // Выдаем данные либо из buf2, либо из buf1
  o_port.vdata := Mux(buf2.valid, buf2, buf1);

  o_addr := addr
}

case class FIFO[T <: Data](T : HardType[T], depth : Int) extends Component {
  val i_port = slave(HandShake(T))
  val o_port = master(HandShake(T))

  // Описание внутренних модулей
  val wctrl = WrCntr(T, depth)
  val rctrl = RdCntr(T, depth)

  // Подключение портов
  wctrl.i_port <> i_port
  rctrl.o_port <> o_port

  // Подключение сигналов
  wctrl.i_addr := rctrl.o_addr
  rctrl.i_addr := wctrl.o_addr

  // Объявление и использование памяти
  val mem = Mem(T, 1<<depth)
  mem.write(wctrl.o_mem.addr, wctrl.o_mem.data, wctrl.o_mem.en)
  rctrl.o_mem.data := mem.readSync(rctrl.o_mem.addr, rctrl.o_mem.en)
}

object FIFOVerilog extends App {
  Config.spinal.generateVerilog(FIFO(Bits(16 bits), 5))
}

object FIFOVhdl extends App {
  Config.spinal.generateVhdl(FIFO(Bits(16 bits), 5))
}

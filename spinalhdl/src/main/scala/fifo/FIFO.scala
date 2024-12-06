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

case class FIFOWriteController[T <: Data](T : HardType[T], depth : Int) extends Component {
  val i_port = slave(HandShake(T))
  val o_wmem = new Bundle {
    val addr = out(UInt(depth bits))
    val data = out(T())
    val en   = out(Bool())
  }
  val i_addr = in(UInt(depth+1 bits))
  val o_addr = out(UInt(depth+1 bits))

  val addr = RegInit(U(0, depth+1 bits))
  when (o_wmem.en) {
    addr := addr+1
  }

  i_port.ready := addr =/= (i_addr+(1<<depth))

  o_wmem.addr := addr.resize(depth bits)
  o_wmem.data := i_port.vdata.data
  o_wmem.en   := i_port.ready & i_port.vdata.valid

  o_addr := addr
}

case class FIFOReadController[T <: Data](T : HardType[T], depth : Int) extends Component {
  val o_port = master(HandShake(T))
  val o_rmem = new Bundle {
    val addr = out(UInt(depth bits))
    val data = in(T())
    val en   = out(Bool())
  }
  val i_addr = in(UInt(depth+1 bits))
  val o_addr = out(UInt(depth+1 bits))

  val addr = Reg(UInt(depth+1 bits)) init(0)

  val buf0 = VData(T);
  val buf1 = Reg(VData(T)); buf1.valid.init(False)
  val buf2 = Reg(VData(T)) init({val tmp = VData(T); tmp.data.assignDontCare(); tmp.valid := False; tmp})

  o_rmem.addr := addr.resize(depth bits)
  o_rmem.en   := addr =/= i_addr && ( o_port.ready ||
                                      ((buf0.valid || buf1.valid || buf2.valid) === False) ||
                                      ((buf0.valid ^ buf1.valid ^ buf1.valid) === True && (buf0.valid && buf1.valid && buf1.valid) === False) )
  when (o_rmem.en) {
    addr := addr+1
  }

  buf0.data  := o_rmem.data
  buf0.valid := RegNext(o_rmem.en) init(False)

  when (buf0.valid || !buf2.valid) {
    buf1 := buf0;
  }

  when (o_port.ready) {
    buf2.valid := False
  } elsewhen (! buf2.valid) {
    buf2 := buf1
  }

  o_port.vdata := Mux(buf2.valid, buf2, buf1);

  o_addr := addr
}

case class FIFO[T <: Data](T : HardType[T], depth : Int) extends Component {
  val i_port = slave(HandShake(T))
  val o_port = master(HandShake(T))

  val mem = Mem(T, 1<<depth)
  val wctrl = FIFOWriteController(T, depth)
  val rctrl = FIFOReadController(T, depth)

  wctrl.i_port <> i_port
  rctrl.o_port <> o_port

  mem.write(wctrl.o_wmem.addr, wctrl.o_wmem.data, wctrl.o_wmem.en)
  rctrl.o_rmem.data := mem.readSync(rctrl.o_rmem.addr, rctrl.o_rmem.en)

  wctrl.i_addr := rctrl.o_addr
  rctrl.i_addr := wctrl.o_addr
}

object FIFOVerilog extends App {
  Config.spinal.generateVerilog(FIFO(Bits(16 bits), 5))
}

object FIFOVhdl extends App {
  Config.spinal.generateVhdl(FIFO(Bits(16 bits), 5))
}

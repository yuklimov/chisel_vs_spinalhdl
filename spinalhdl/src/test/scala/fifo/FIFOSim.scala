/* vim: set syntax=scala et sw=2 ts=2: */

package fifo

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

class FIFOSim extends AnyFunSuite {
  test("FIFO") {
    Config.sim.withWave.compile(FIFO(Bits(16 bits), 4)).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10)
      dut.clockDomain.waitRisingEdge()

      val queue = scala.collection.mutable.Queue[Int]()
      for (idx <- 0 to 1000) {
        dut.i_port.vdata.data.randomize()
        if (idx < 100) {
          dut.i_port.vdata.valid #= true
        } else {
          dut.i_port.vdata.valid.randomize()
        }
        if (idx < 900) {
          dut.o_port.ready.randomize()
        } else {
          dut.o_port.ready #= true
        }

        if (dut.i_port.vdata.valid.toBoolean && dut.i_port.ready.toBoolean) {
          //println("Push: "+ dut.i_port.vdata.data.toInt)
          queue.enqueue(dut.i_port.vdata.data.toInt)
        }

        if (dut.o_port.vdata.valid.toBoolean && dut.o_port.ready.toBoolean) {
          //println("Pop:  "+ dut.o_port.vdata.data.toInt)
          assert(queue.dequeue() == dut.o_port.vdata.data.toInt)
        }
        dut.clockDomain.waitRisingEdge()
      }
    }
  }
}

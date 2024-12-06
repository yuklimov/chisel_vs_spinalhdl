/* vim: set syntax=scala et sw=2 ts=2: */

package fifo

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.funsuite.AnyFunSuite

class FIFOSim extends AnyFunSuite {
  test("FIFO") {
    simulate(new FIFO(UInt(16.W), 4)) { dut =>
      dut.reset.poke(true)
      dut.clock.step()
      dut.reset.poke(false)
      dut.clock.step()

      val queue = scala.collection.mutable.Queue[Int]()
      for (idx <- 0 to 1000) {
        dut.i_port.vdata.data.poke(scala.util.Random.between(0, 1<<16))
        if (idx < 100) {
          dut.i_port.vdata.valid.poke(true)
        } else {
          dut.i_port.vdata.valid.poke(scala.util.Random.nextBoolean())
        }
        if (idx < 900) {
          dut.o_port.ready.poke(scala.util.Random.nextBoolean())
        } else {
          dut.o_port.ready.poke(true)
        }

        if (dut.i_port.vdata.valid.peek().litToBoolean && dut.i_port.ready.peek().litToBoolean) {
          //println("Push: "+ dut.i_port.vdata.data.peekValue().asBigInt)
          queue.enqueue(dut.i_port.vdata.data.peekValue().asBigInt.toInt)
        }

        if (dut.o_port.vdata.valid.peek().litToBoolean && dut.o_port.ready.peek().litToBoolean) {
          //println("Pop:  "+ dut.o_port.vdata.data.peekValue().asBigInt)
          assert(queue.dequeue() == dut.o_port.vdata.data.peekValue().asBigInt)
        }
        dut.clock.step()
      }
    }
  }
}

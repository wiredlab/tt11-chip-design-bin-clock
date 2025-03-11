# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

#
# this is to test that the hours properly roll over as well as testing the incrementing function
#

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ms (100 Hz)
    clock = Clock(dut.clk, 10, units="ms")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in[4].value = 1    # set to 1 to change the time
    dut.ui_in[3].value = 1    # set to 1 to increment

    dut.ui_in[2].value = 1    # increment hour for 12 clock cycles
    await ClockCycles(dut.clk, 12)
    dut.ui_in[2].value = 0    # stop incrementing hour

    await ClockCycles(dut.clk, 1)

    dut.ui_in[1].value = 1    # increment minutes for 59 clock cycles
    await ClockCycles(dut.clk, 59)
    dut.ui_in[1].value = 0    # stop incrementing minutes

    await ClockCycles(dut.clk, 1)

    dut.ui_in[0].value = 1    # increment seconds for 50 clock cycles
    await ClockCycles(dut.clk, 50)
    dut.ui_in[0].value = 0    # stop incrementing seconds

    # the clock is now set to 12:59:50
    await ClockCycles(dut.clk, 1)

    dut.ui_in[4].value = 0    # let the clock run


    await ClockCycles(dut.clk, 15000)   # run for 15

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    #assert dut.uo_out.value == 183

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

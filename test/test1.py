# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

#
# this test is just to confirm that the io and wire routing is correct
# from the top module "tt_um_obliviouX" to the internal module "tt_bin_clock."
# paste these lines at the end of "tt_bin_clock.v" to test the outputs:
#
#    assign hour_out = 11;        // 1011
#    assign minute_out = 30;      // 0111 10
#    assign seconds_out = 45;     // 101101
#
# and then edit "Makefile" to use "test1" instead of "test" toward the bottom
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
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 183

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

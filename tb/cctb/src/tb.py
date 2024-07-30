# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer


async def generate_clock(dut):

    for cycle in range(10):
        dut.clk.value = 0
        await Timer(1, units="ns")
        dut.clk.value = 1
        await Timer(1, units="ns")

async def do_reset(dut):

    dut.rst_n.value = 0
    dut.we.value = 0
    dut.re.value = 0
    await Timer(3, units="ns")
    dut.rst_n.value = 1
    await Timer(7, units="ns")

async def do_write(dut, data=0):

    await FallingEdge(dut.clk)  # wait for falling edge/"negedge"
    dut.din.value = data
    dut.we.value = 1
    await RisingEdge(dut.clk)
    dut.we.value = 0
    await FallingEdge(dut.clk)  # wait for falling edge/"negedge"

@cocotb.test()
async def fifo_basic_test(dut):
    """Try accessing the design."""

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await cocotb.start(do_reset(dut))        # assert reset

    await Timer(4, units="ns")  # wait a bit
    await FallingEdge(dut.clk)  # wait for falling edge/"negedge"

    dut._log.info("Empty is %s", dut.empty.value)
    assert dut.full.value == 0, "FIFO shouldn't be full!"
    await Timer(2,units="ns")
    await cocotb.start(do_write(dut,12))        # assert reset
    await Timer(3,units="ns")

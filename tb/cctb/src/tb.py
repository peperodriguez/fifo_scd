import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock


async def do_reset(dut):

    dut.rst_n.value = 0
    dut.we.value = 0
    dut.re.value = 0
    await Timer(3, units="ns")
    dut.rst_n.value = 1

async def do_write(dut, data=0):

    await FallingEdge(dut.clk)
    dut.din.value = data
    dut.we.value = 1
    await RisingEdge(dut.clk)
    dut.we.value = 0
    await FallingEdge(dut.clk)

async def do_read(dut):

    await FallingEdge(dut.clk)
    dut.re.value = 1
    await RisingEdge(dut.clk)
    dut.re.value = 0
    await FallingEdge(dut.clk)

@cocotb.test()
async def fifo_basic_test(dut):

    c = Clock(dut.clk,1,units="ns")

    await cocotb.start(c.start())

    await do_reset(dut)

    await Timer(4, units="ns")
    await FallingEdge(dut.clk)

    dut._log.info("Empty is %s", dut.empty.value)
    assert dut.full.value == 0, "FIFO shouldn't be full!"

    await Timer(2,units="ns")

    for i in range(10):
        await do_write(dut,i)

    for i in range(10):
        await do_read(dut)

    await Timer(10,units="ns")

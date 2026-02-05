# SPDX-FileCopyrightText: © 2025 Leo Moser <leomoser99@gmail.com>
# SPDX-License-Identifier: Apache-2.0

import os
import random
import cocotb
from pathlib import Path
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge
from cocotb.regression import TestFactory
from cocotb_tools.runner import get_runner
from cocotbext.uart import UartSource, UartSink

hello_world = {
    'firmware': '../../../firmware/hello_world/hello_world.hex'
}

custom_instruction = {
    'firmware': '../../../firmware/custom_instruction_dummy/custom_instruction_dummy.hex'
}

enabled = custom_instruction

async def start_clock(clock, freq=50):
    """ Start the clock @ freq MHz """
    c = Clock(clock, 1/50*1000, 'ns')
    cocotb.start_soon(c.start())

async def reset(reset, active_low=True, time_ns=1000):
    """ Reset dut """
    cocotb.log.info("Reset asserted...")
    
    reset.value = not active_low
    await Timer(time_ns, "ns")
    reset.value = active_low
    
    cocotb.log.info("Reset deasserted.")

async def start_up(dut):
    """ Startup sequence """
    dut.fetch_enable_i.value = 1 # Start fetching
    await start_clock(dut.clk_i)
    await reset(dut.rst_ni)

@cocotb.test(skip=enabled!=hello_world)
async def test_hello_world(dut):
    """Run the "Hello World!" program"""

    # Setup UART
    uart_source = UartSource(dut.uart0_rx, baud=115200, bits=8)
    uart_sink = UartSink(dut.uart0_tx, baud=115200, bits=8)

    # Start up
    await start_up(dut)
    
    # Wait for UART to get clocked
    await ClockCycles(dut.clk_i, int(50000*2.5))
    
    # Send char
    await uart_source.write(b'A')
    
    # Read char
    data = await uart_sink.read(1)
    print(data)
    assert data == b'A'

    # Wait for message
    await ClockCycles(dut.clk_i, int(50000*2.0))
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    assert data == b'Hello World!\n'

@cocotb.test(skip=enabled!=custom_instruction)
async def test_custom_instruction(dut):
    """Run the custom instruction program"""

    # Setup UART
    uart_source = UartSource(dut.uart0_rx, baud=115200, bits=8)
    uart_sink = UartSink(dut.uart0_tx, baud=115200, bits=8)

    # Start up
    await start_up(dut)

    # Wait for message
    await ClockCycles(dut.clk_i, int(50000*5.2))
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    assert data == b'0xDEADBEEF\n'

if __name__ == "__main__":
    testbench_path = Path(__file__).resolve().parent
    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", testbench_path / '../../IHP-Open-PDK')
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")
    
    verilog_sources = [
        testbench_path / 'greyhound_soc_tb.sv',
        testbench_path / 'spiflash.v',
    ]
    defines = {}


    # SCL models (for the clock gate)
    verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )

    verilog_sources.append(testbench_path / 'greyhound_soc_slang.sv')
    verilog_sources.append(testbench_path / '../simlib.v')

        
    defines = {'RTL': True}

    hdl_toplevel = "greyhound_soc_tb"

    runner = get_runner(sim)
    runner.build(
        sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
        defines=defines,
        always=True,
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module="greyhound_soc_tb,",
        plusargs=['-fst', f'+firmware={enabled["firmware"]}'],
        waves=True
    )

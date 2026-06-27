# SPDX-FileCopyrightText: © 2026 FABulous Contributors
# SPDX-License-Identifier: Apache-2.0

import os
from pathlib import Path
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
from cocotb.types import LogicArray, Logic

from ..common import zero_bitstream, upload_bitstream, PCF, fabric, tile_library

testname = Path(__file__).stem
proj_path = Path(__file__).resolve().parent

@cocotb.test()
async def test_counter(dut):
    """Load bitstream for counter"""

    pcf = PCF(dut, proj_path / f"../../../fabrics/{fabric}/constraints.pcf")
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "clk2", "rst", "ena", "c"])
    
    # Reset
    pcf.set("clk1", Logic(0), index=0)
    pcf.set("clk2", Logic(0), index=0)
    pcf.set("rst", Logic(1), index=0)
    pcf.set("ena", Logic(1), index=0)
    await Timer(10, unit="ns")

    # Zero all config bits
    await zero_bitstream(dut)
    await Timer(10, unit="ns")

    # Upload the bitstream
    await upload_bitstream(dut, proj_path / f'../../../user_designs/designs/{tile_library}/{testname}/{testname}.bit')
    await Timer(10, unit="ns")

    # Start a clock on clk1
    clock = pcf.get_raw("clk1", "OUT")
    cocotb.start_soon(Clock(clock, 10, 'ns').start())

    await ClockCycles(clock, 10)
    
    pcf.set("rst", Logic(0), index=0)
    pcf.set("ena", Logic(0), index=0)

    await ClockCycles(clock, 10)

    pcf.set("ena", Logic(1), index=0)

    NUM_CYCLES = 123
    await ClockCycles(clock, NUM_CYCLES)

    assert pcf.get("c").to_unsigned() == NUM_CYCLES-1

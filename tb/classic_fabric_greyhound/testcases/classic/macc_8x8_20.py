# SPDX-FileCopyrightText: © 2026 FABulous Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import random
from pathlib import Path
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
from cocotb.types import LogicArray, Logic

from ..common import zero_bitstream, upload_bitstream, PCF, fabric, tile_library

testname = Path(__file__).stem
proj_path = Path(__file__).resolve().parent

@cocotb.test()
async def test_macc_8x8_20(dut):
    """Load bitstream for macc_8x8_20"""

    pcf = PCF(dut, proj_path / f"../../../fabrics/{fabric}/constraints.pcf")
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "rst", "ena", "a", "b", "product"])

    # Reset
    pcf.set("clk1", Logic(0), index=0)
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
    clock1 = pcf.get_raw("clk1", "OUT")
    cocotb.start_soon(Clock(clock1, 10, 'ns').start())
    
    await ClockCycles(clock1, 10)
    
    for i in range(32):
        # Get a random value
        value_a = random.randint(0, 2**len(pcf.get("a"))-1)
        value_b = random.randint(0, 2**len(pcf.get("b"))-1)
        
        result = value_a * value_b

        pcf.set("a", LogicArray.from_unsigned(value_a, len(pcf.get("a"))))
        pcf.set("b", LogicArray.from_unsigned(value_b, len(pcf.get("b"))))
        
        await ClockCycles(clock1, 1)
        assert(pcf.get("product").to_unsigned() == result)

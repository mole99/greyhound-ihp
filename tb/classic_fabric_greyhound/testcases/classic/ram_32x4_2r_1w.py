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
async def test_ram_32x4_2r_1w(dut):
    """Load bitstream for ram_32x4_2r_1w"""

    pcf = PCF(dut, proj_path / f"../../../fabrics/{fabric}/constraints.pcf")
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "clk2", "word_a", "addr_a", "addr_b", "addr_c", "word_b", "word_c"])

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
    clock1 = pcf.get_raw("clk1", "OUT")
    cocotb.start_soon(Clock(clock1, 10, 'ns').start())
    
    # Start a clock on clk1
    clock2 = pcf.get_raw("clk2", "OUT")
    cocotb.start_soon(Clock(clock2, 20, 'ns').start())
    
    await ClockCycles(clock1, 10)
    
    # Fill the memory with data
    for i in range(32):
        #print(i)
        #print(LogicArray.from_unsigned(i & 0xF, len(pcf.get("word_a"))))
        #print(LogicArray.from_unsigned(i, len(pcf.get("addr_a"))))
    
        pcf.set("word_a", LogicArray.from_unsigned(i & 0xF, len(pcf.get("word_a"))))
        pcf.set("addr_a", LogicArray.from_unsigned(i, len(pcf.get("addr_a"))))
        await ClockCycles(clock1, 1)

    await ClockCycles(clock2, 10)
    
    # Read from both read ports
    for i in range(32):
        value = 31 - i
    
        pcf.set("addr_b", LogicArray.from_unsigned(value, len(pcf.get("addr_b"))))
        pcf.set("addr_c", LogicArray.from_unsigned(value & 0x3, len(pcf.get("addr_c"))))
        await ClockCycles(clock2, 2)
    
        #print(f"B[{31 - i}]: {pcf.get('word_b')}")
        #print(f"C[{i & 0x3}]: {pcf.get('word_c')}")
        
        assert(pcf.get("word_b").to_unsigned() == value & 0xF)
        assert(pcf.get("word_c").to_unsigned() == value % 0x4)

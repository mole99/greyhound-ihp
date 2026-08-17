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
async def test_sys_reset(dut):
    """Load bitstream for sys_reset"""

    pcf = PCF(dut, proj_path / f"../../../fabrics/{fabric}/constraints.pcf")
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "a", "b"])

    # Find SYS_RESET.RESET
    sys_reset = None
    for element in dut:
        if "SYS_RESET_RESET_top" in element._name:
            sys_reset = element
    
    if sys_reset is None:
        assert(0), "Couldn't find SYS_RESET_RESET_top"

    sys_reset.value = 1

    # Zero all config bits
    await zero_bitstream(dut)
    await Timer(10, unit="ns")

    # Start a clock on clk1
    clock1 = pcf.get_raw("clk1", "OUT")
    cocotb.start_soon(Clock(clock1, 10, 'ns').start())

    # Upload the bitstream
    await upload_bitstream(dut, proj_path / f'../../../user_designs/designs/{tile_library}/{testname}/{testname}.bit')
    await Timer(10, unit="ns")

    pcf.set("a", LogicArray.from_unsigned(0x13, len(pcf.get("a"))))
    assert pcf.get("b").to_unsigned() == 0x37

    sys_reset.value = 0
    await Timer(20, unit="ns")

    assert pcf.get("b").to_unsigned() == 0x13

# SPDX-FileCopyrightText: © 2025 Leo Moser <leomoser99@gmail.com>
# SPDX-License-Identifier: Apache-2.0

import os
import random
import cocotb
from pathlib import Path
from cocotb.clock import Clock
from cocotb.queue import Queue
from cocotb.triggers import ClockCycles
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge, Event
from cocotb.regression import TestFactory
from cocotb_tools.runner import get_runner

hello_world = {
    'firmware': '../../../firmware/hello_world/hello_world.hex'
}

custom_instruction = {
    'firmware': '../../../firmware/custom_instruction_dummy/custom_instruction_dummy.hex'
}

enabled = hello_world

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

class UartSource:
    def __init__(self, tx_handle, baud=115200, bits=8):
        self.tx_handle = tx_handle
        self.baud = baud
        self.bits = bits
        self.tx_handle.value = 1 # idle
        assert(self.bits == 8)
    
    async def write(self, data: bytearray):
        for byte in data:
            # Start bit
            self.tx_handle.value = 0 # start
            await Timer(round(1.0 / self.baud / 1e-9), "ns")
        
            # LSB first
            for i in range(self.bits):
                self.tx_handle.value = (byte >> i) & 0x1
                await Timer(round(1.0 / self.baud / 1e-9), "ns")
            
            # Stop bit
            self.tx_handle.value = 1 # stop
            await Timer(round(1.0 / self.baud / 1e-9), "ns")

class UartSink:
    def __init__(self, rx_handle, baud=115200, bits=8):
        self.rx_handle = rx_handle
        self.baud = baud
        self.bits = bits
        assert(self.bits == 8)
        
        self.recv_data = Queue()
        self.recv_wait = Event()
        
        self.coroutine = cocotb.start_soon(self.recv())
    
    async def recv(self):
        while True:
            await FallingEdge(self.rx_handle)
            
            # Shift by half a bit
            await Timer(round(1.0 / self.baud / 1e-9) // 2, "ns")
            
            byte = 0
            # LSB first
            for i in range(self.bits):
                await Timer(round(1.0 / self.baud / 1e-9), "ns")
                byte = byte | (int(self.rx_handle.value) << i)
            
            # Check the stop bit
            await Timer(round(1.0 / self.baud / 1e-9), "ns")
            assert(self.rx_handle.value == 1)
            
            self.recv_data.put_nowait(byte)
            self.recv_wait.set()

    def read_nowait(self, num_bytes=-1):
        data = bytearray()
        if num_bytes < 0:
            num_bytes = self.recv_data.qsize()
        for _ in range(num_bytes):
            data.append(self.recv_data.get_nowait())
        return data

    async def read(self, num_bytes):
        while self.recv_data.qsize() < num_bytes:
            self.recv_wait.clear()
            await self.recv_wait.wait()
        return self.read_nowait(num_bytes)

@cocotb.test(skip=enabled!=hello_world)
async def test_hello_world(dut):
    """Run the "Hello World!" program"""

    # Setup UART
    uart_source = UartSource(dut.uart0_rx, baud=115200, bits=8)
    uart_sink = UartSink(dut.uart0_tx, baud=115200, bits=8)

    # Start up
    await start_up(dut)
    
    # Wait for UART to get clocked
    await ClockCycles(dut.clk_i, int(50000*1.0))
    
    # Send char
    await uart_source.write(b'A')
    
    # Read char
    data = await uart_sink.read(1)
    print(data)
    assert data == b'A'

    # Wait for message
    await ClockCycles(dut.clk_i, int(50000*1.9))
    
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
    await ClockCycles(dut.clk_i, int(50000*3))
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    assert data == b'0xDEADBEEF\n'

if __name__ == "__main__":

    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", os.path.expanduser("~/.ciel"))
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")

    testbench_path = Path(__file__).resolve().parent
    
    sources = [
        testbench_path / 'greyhound_soc_tb.sv',
        testbench_path / 'spiflash.v',
    ]
    defines = {}


    # SCL models (for the clock gate)
    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"sg13g2_udp.v" )

    sources.append(testbench_path / '../../src/soc/greyhound_soc_slang.sv')
    sources.append(testbench_path / '../simlib.v')
    
    # Core files
    
    # For now, Icarus Verilog does not support all SV features required
    # Therefore, convert the SV to a simpler form using yosys-slang
    
    """
    # PACKAGES
    sources.append(testbench_path / "../../src/soc/soc_pkg.sv")
    sources.append(testbench_path / "../../src/soc/cf_math_pkg.sv")
    sources.append(testbench_path / "../../ip/cv32e40x/rtl/include/cv32e40x_pkg.sv")
    sources.append(testbench_path / "../../ip/obi/src/obi_pkg.sv")
    # RTL_OBI
    sources.append(testbench_path / "../../ip/obi/src/obi_intf.sv")
    sources.append(testbench_path / "../../ip/obi/src/obi_mux.sv")
    sources.append(testbench_path / "../../ip/obi/src/obi_demux.sv")
    sources.append(testbench_path / "../../ip/obi/src/obi_err_sbr.sv")
    sources.append(testbench_path / "../../ip/obi/src/obi_sram_shim.sv")
    # RTL_COMMON
    sources.append(testbench_path / "../../ip/common_cells/src/fifo_v3.sv")
    sources.append(testbench_path / "../../ip/common_cells/src/rr_arb_tree.sv")
    sources.append(testbench_path / "../../ip/common_cells/src/delta_counter.sv")
    sources.append(testbench_path / "../../ip/common_cells/src/lzc.sv")
    # Core and SoC
    sources.extend(list(testbench_path.glob("../../ip/cv32e40x/rtl/*.sv")))
    sources.append(testbench_path / "../../src/soc/greyhound_soc.sv")
    sources.append(testbench_path / "../../src/soc/dummy_extension.sv")
    sources.append(testbench_path / "../../src/soc/fabric_extension.sv")
    sources.append(testbench_path / "../../src/soc/obi2ahbm_adapter.sv")
    sources.append(testbench_path / "../../src/soc/cv32e40x_clock_gate.sv")
    # QSPI XiP
    sources.append(testbench_path / "../../ip/EF_QSPI_XIP_CTRL/hdl/rtl/EF_QSPI_XIP_CTRL.v")
    sources.append(testbench_path / "../../ip/EF_QSPI_XIP_CTRL/hdl/rtl/DMC.v")
    sources.append(testbench_path / "../../ip/EF_QSPI_XIP_CTRL/hdl/rtl/bus_wrappers/EF_QSPI_XIP_CTRL_AHBL.v")
    # QSPI PSRAM
    sources.append(testbench_path / "../../ip/EF_PSRAM_CTRL/hdl/rtl/EF_PSRAM_CTRL.v")
    sources.append(testbench_path / "../../ip/EF_PSRAM_CTRL/hdl/rtl/bus_wrapper/EF_PSRAM_CTRL_AHBL.v")
    # UART
    sources.append(testbench_path / "../../ip/EF_UART/hdl/rtl/EF_UART.v")
    sources.append(testbench_path / "../../ip/EF_UART/hdl/rtl/bus_wrappers/EF_UART_AHBL.v")
    # Util
    sources.append(testbench_path / "../../ip/EF_IP_UTIL/hdl/ef_util_lib.v")
    """
        
    defines = {'RTL': True}

    hdl_toplevel = "greyhound_soc_tb"

    runner = get_runner(sim)
    runner.build(
        sources=sources,
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

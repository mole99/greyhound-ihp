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
#from cocotb_tools.runner import get_runner
#from cocotbext.uart import UartSource, UartSink

from cocotbext.spi import SpiBus, SpiConfig, SpiMaster

testbench_path = Path(__file__).resolve().parent

sim             = os.getenv("SIM", "icarus")
pdk_root        = os.getenv("PDK_ROOT", Path("~/.ciel").expanduser())
pdk             = os.getenv("PDK", "ihp-sg13g2")
scl             = os.getenv("SCL", "sg13g2_stdcell")
gl              = os.getenv("GL", False)
tile_library    = os.getenv("TILE_LIBRARY", "classic")
fabric          = os.getenv("FABRIC", "classic_fabric_greyhound")

hdl_toplevel = "greyhound_ihp_top"
tb_toplevel = "greyhound_ihp_top_tb"

hello_world = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
}

fpga_all_ones = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': False,
}

fpga_all_zeros = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/all_zeros/all_zeros.hex',
    'flash1_slot1': '',
    'connect_flash1': True,
    'dump_waveforms': False,
}

cpu_trigger_fpga = {
    'flash0_slot0': '../../../firmware/trigger_fpga/trigger_fpga.hex',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/all_zeros/all_zeros.hex',
    'flash1_slot1': '../../../ip/fabric/user_designs/all_ones/all_ones.hex',
    'connect_flash1': True,
    'dump_waveforms': False,
}

custom_instruction = {
    'flash0_slot0': '../../../firmware/custom_instruction/custom_instruction.hex',
    'flash0_slot1': '../../../ip/fabric/user_designs/custom_instruction/custom_instruction.hex',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': False,
}

fpga_peripheral = {
    'flash0_slot0': '../../../firmware/access_peripheral/access_peripheral.hex',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/peripheral/peripheral.hex',
    'flash1_slot1': '',
    'connect_flash1': True,
    'dump_waveforms': False,
}

fpga_peripheral_sram = {
    'flash0_slot0': '../../../firmware/access_peripheral_sram/access_peripheral_sram.hex',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/peripheral_sram/peripheral_sram.hex',
    'flash1_slot1': '',
    'connect_flash1': True,
    'dump_waveforms': False,
}

fpga_irq = {
    'flash0_slot0': '../../../firmware/wait_for_irq/wait_for_irq.hex',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/trigger_irq/trigger_irq.hex',
    'flash1_slot1': '',
    'connect_flash1': True,
    'dump_waveforms': True,
}

fpga_blinky = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '../../../ip/fabric/user_designs/trigger_slot1/trigger_slot1.hex',
    'flash1_slot1': '../../../ip/fabric/user_designs/trigger_slot0/trigger_slot0.hex',
    'connect_flash1': True,
    'dump_waveforms': False,
}

enabled = cpu_trigger_fpga

async def start_clock(clock, freq=50):
    """ Start the clock @ freq MHz """
    c = Clock(clock, 1/freq*1000, 'ns')
    await cocotb.start(c.start())

async def reset(reset, active_low=True, time_ns=1000):
    """ Reset dut """
    cocotb.log.info("Reset asserted...")
    
    reset.value = not active_low
    await Timer(time_ns, "ns")
    reset.value = active_low
    
    cocotb.log.info("Reset deasserted.")

async def start_up(dut):
    """ Startup sequence """
    await start_clock(dut.io_clock_PAD)
    await reset(dut.io_reset_PAD)

async def write_bitstream_spi(filename, spi_master):
    with open(filename, 'br') as f:
        data = f.read(4)
        while data:
            number = int.from_bytes(data, "big")
            
            number_bytes = []            
            for _ in range(4):
                number_bytes.append((number & 0xFF000000) >> 24)
                number = number << 8
            
            print(f'Bitstream data: {number_bytes}')
            await spi_master.write(number_bytes)

            data = f.read(4)

@cocotb.test(skip=enabled!=hello_world)
async def test_hello_world(dut):
    """Run the "Hello World!" program"""

    # Setup UART
    uart_source = UartSource(dut.io_ser_rx_PAD, baud=115200, bits=8)
    uart_sink = UartSink(dut.io_ser_tx_PAD, baud=115200, bits=8)

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

    # Start up
    await start_up(dut)
    
    # Wait for UART to get clocked
    await ClockCycles(dut.io_clock_PAD, int(50000*1))
    
    # Send char
    await uart_source.write(b'A')
    
    # Read char
    data = await uart_sink.read(1)
    print(data)
    assert data == b'A'

    # Wait for message
    await ClockCycles(dut.io_clock_PAD, int(50000*1.8))
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    assert data == b'Hello World!\n'

@cocotb.test(skip=enabled!=custom_instruction)
async def test_custom_instruction(dut):
    """Run the custom instruction program"""

    # Setup UART
    uart_source = UartSource(dut.io_ser_rx_PAD, baud=115200, bits=8)
    uart_sink = UartSink(dut.io_ser_tx_PAD, baud=115200, bits=8)

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

    # Start up
    await start_up(dut)

    # Wait for message
    #await ClockCycles(dut.io_clock_PAD, int(50000*3))
    
    # Ignore x -> 0 rising edge
    await ClockCycles(dut.io_clock_PAD, 10)
    
    # Wait until core has finished
    await RisingEdge(dut.io_core_sleep_PAD)
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    
    # 0x0EED42E6 + 0x258AE222 = 0x34782508
    assert data == b'0x34782508\n'

@cocotb.test(skip=enabled!=fpga_all_zeros)
async def test_fpga_all_zeros(dut):
    """Run the all_zeros FPGA bitstream"""

    # Static setup
    dut.io_fetch_enable_PAD.value = 0
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Start up
    await start_up(dut)
    
    print("Waiting for configuration to start.")
    await RisingEdge(dut.io_config_busy_PAD)
    print("Waiting for configuration to end.")
    await FallingEdge(dut.io_config_busy_PAD)
    
    print("FPGA configured!")

    await ClockCycles(dut.io_clock_PAD, 10)
    
    assert(dut.io_gpio_PAD.value == 0x00000000)

@cocotb.test(skip=enabled!=fpga_all_ones)
async def test_fpga_all_ones(dut):
    """Run the all_ones FPGA bitstream"""

    # Setup SPI
    spi_bus = SpiBus.from_prefix(dut, "io_fpga", bus_separator="_", sclk_name="sclk_PAD", cs_name="cs_n_PAD", mosi_name='mosi_PAD', miso_name='miso_PAD')

    spi_config = SpiConfig(
        word_width = 8,
        sclk_freq  = 10e6,
        cpol       = False,
        cpha       = True,
        msb_first  = True,
        frame_spacing_ns = 500
    )

    spi_master = SpiMaster(spi_bus, spi_config)

    # Static setup
    dut.io_fetch_enable_PAD.value = 0
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

    # Start up
    await start_up(dut)

    print("Writing bitstream via SPI!")

    # Configure FPGA via SPI
    spi_coroutine = await cocotb.start(write_bitstream_spi('../../../ip/fabric/user_designs/all_ones/all_ones.bit', spi_master))

    # Wait until FPGA is configured
    await spi_coroutine
    
    print("FPGA configured!")
    
    await ClockCycles(dut.io_clock_PAD, 10)
    
    assert(dut.io_config_busy_PAD.value == 0)
    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

@cocotb.test(skip=enabled!=cpu_trigger_fpga)
async def test_cpu_trigger_fpga(dut):
    """Run the trigger_fpga program"""

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

    # Start up
    await start_up(dut)
    
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Ignore x -> 0 rising edge
    await ClockCycles(dut.io_clock_PAD, 10)

    # Wait until core has finished waiting for the FPGA
    await RisingEdge(dut.io_core_sleep_PAD)
    
    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

@cocotb.test(skip=enabled!=fpga_peripheral)
async def test_fpga_peripheral(dut):
    """Run the access_peripheral program"""

    # Setup UART
    uart_source = UartSource(dut.io_ser_rx_PAD, baud=115200, bits=8)
    uart_sink = UartSink(dut.io_ser_tx_PAD, baud=115200, bits=8)

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Start up
    await start_up(dut)

    # Ignore x -> 0 rising edge
    await ClockCycles(dut.io_clock_PAD, 10)
    
    # Wait until core has finished
    await RisingEdge(dut.io_core_sleep_PAD)
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    
    assert data == b'Ok!\n'

@cocotb.test(skip=enabled!=fpga_peripheral_sram)
async def test_fpga_peripheral_sram(dut):
    """Run the access_peripheral_sram program"""

    # Setup UART
    uart_source = UartSource(dut.io_ser_rx_PAD, baud=115200, bits=8)
    uart_sink = UartSink(dut.io_ser_tx_PAD, baud=115200, bits=8)

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Start up
    await start_up(dut)

    # Ignore x -> 0 rising edge
    await ClockCycles(dut.io_clock_PAD, 10)
    
    # Wait until core has finished
    await RisingEdge(dut.io_core_sleep_PAD)
    
    # Read message
    data = uart_sink.read_nowait(-1)
    print(data)
    
    assert data == b'Ok!\n'

@cocotb.test(skip=enabled!=fpga_irq)
async def test_fpga_irq(dut):
    """Run the wait_for_irq program"""

    # Static setup
    dut.io_fetch_enable_PAD.value = 1
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Start up
    await start_up(dut)

    # Ignore x -> 0 rising edge
    await ClockCycles(dut.io_clock_PAD, 10)

    # Wait until core is sleeping
    await RisingEdge(dut.io_core_sleep_PAD)
    
    print("Core is sleeping!")
    
    # Wait until core has woken up from the IRQ
    await FallingEdge(dut.io_core_sleep_PAD)
    
    print("Core has woken up!")
    
    #await ClockCycles(dut.io_clock_PAD, 10)
    
    assert(dut.io_gpio_PAD.value == 0xCAFECAFE)

@cocotb.test(skip=enabled!=fpga_blinky)
async def test_fpga_blinky(dut):
    """Alternate between two bistreams in slot 0 and slot 1"""

    # Static setup
    dut.io_fetch_enable_PAD.value = 0
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

    # Start up
    await start_up(dut)
    
    print("Waiting for configuration to start.")
    await RisingEdge(dut.io_config_busy_PAD)
    print("Waiting for configuration to end.")
    await FallingEdge(dut.io_config_busy_PAD)
    
    print("FPGA configured!")
    
    await ClockCycles(dut.io_clock_PAD, 10)
    assert(dut.io_gpio_PAD.value == 0x00000000)
    
    print("Waiting for configuration to start.")
    await RisingEdge(dut.io_config_busy_PAD)
    print("Waiting for configuration to end.")
    await FallingEdge(dut.io_config_busy_PAD)
    
    print("FPGA configured!")
    
    await ClockCycles(dut.io_clock_PAD, 10)
    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)
    
    print("Waiting for configuration to start.")
    await RisingEdge(dut.io_config_busy_PAD)
    print("Waiting for configuration to end.")
    await FallingEdge(dut.io_config_busy_PAD)
    
    print("FPGA configured!")
    
    await ClockCycles(dut.io_clock_PAD, 10)
    assert(dut.io_gpio_PAD.value == 0x00000000)

if __name__ == "__main__":
    
    includes = [testbench_path / '../../rtl/include']
    
    verilog_sources = []
    defines = {}

    if gl:
        # SCL models
        verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
        
        verilog_sources.append(testbench_path / f'../../final/nl/{hdl_toplevel}.nl.v')
        #verilog_sources.append(testbench_path / f'../../final/pnl/{hdl_toplevel}.pnl.v')
        
        verilog_sources.append(testbench_path / '../../ip/bondpad_70x70/bondpad_70x70.v')
        
        defines = {'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    else:
        # SCL models (for the clock gate)
        verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
        verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"sg13g2_udp.v" )
    
        verilog_sources.append(testbench_path / f'{hdl_toplevel}_slang.sv')
        verilog_sources.append(testbench_path / '../simlib.v')
        
        defines = {'RTL': True, 'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    
    verilog_sources += [
        testbench_path / f'{tb_toplevel}.v',
        testbench_path / 'spiflash.v',
        testbench_path / 'spiflash_powered.v',
        
        # SRAM models
        Path(pdk_root) / pdk / "libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x32_c2_bm_bist.v",
        Path(pdk_root) / pdk / "libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_core_behavioral_bm_bist.v",
        
        # BRAM models
        Path(pdk_root) / pdk / "libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_1024x16_c2_bm_bist.v",
        Path(pdk_root) / pdk / "libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_core_behavioral_bm_bist_ideal.v",
        
        # IO Pad models
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_io" / "verilog" / "sg13g2_io.v",
        
    ]

    # Tiles

    tiles_path = Path(testbench_path / "../../ip" / "fabulous-tiles")
    primitives_path = Path(tiles_path) / "primitives"
    tile_library_path = Path(tiles_path) / "tiles" / tile_library

    extra_tiles_path = Path(testbench_path / "../../ip" / "extra-tiles")
    extra_primitives_path = Path(extra_tiles_path) / "primitives"
    extra_tile_library_path = Path(extra_tiles_path) / "tiles" / tile_library

    primitives_files = list(primitives_path.glob('**/fabulous/*.v'))
    tile_files = list(tile_library_path.glob(f'**/macro/{pdk}/fabulous/*.v'))
    
    primitives_files += list(extra_primitives_path.glob('**/fabulous/*.v'))
    tile_files += list(extra_tile_library_path.glob(f'**/macro/{pdk}/fabulous/*.v'))

    verilog_sources.extend(primitives_files)
    verilog_sources.extend(tile_files)

    # Add models pack
    verilog_sources.append(tiles_path / "models_pack.v")

    # Add custom cells
    verilog_sources.append(tiles_path / "custom.v")

    # Add FPGA fabric
    verilog_sources.append(testbench_path / f'../../fabrics/classic_fabric_greyhound/macro/{pdk}/fabulous/classic_fabric_greyhound.v')


    defines['USE_POWER_PINS'] = True
    
    if enabled["connect_flash1"]:
        defines['BITSTREAM_FLASH'] = True
    
    if enabled["dump_waveforms"]:
        defines['DUMP_WAVEFORMS'] = True

    build_args = []

    if sim == 'icarus':
        build_args = ['-Winfloop', '-pfileline=1']

    if sim == 'verilator':
        build_args = ['--timing', '--trace', '--trace-fst', '--trace-structs']

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel=tb_toplevel,
        defines=defines,
        always=True,
        includes=includes,
        build_args=build_args,
    )

    plusargs = []
    if enabled["flash0_slot0"]:
        plusargs += [f'+flash0_slot0={enabled["flash0_slot0"]}']
    if enabled["flash0_slot1"]:
        plusargs += [f'+flash0_slot1={enabled["flash0_slot1"]}']
    if enabled["flash1_slot0"]:
        plusargs += [f'+flash1_slot0={enabled["flash1_slot0"]}']
    if enabled["flash1_slot1"]:
        plusargs += [f'+flash1_slot1={enabled["flash1_slot1"]}']

    if sim == 'icarus':
        plusargs += ['-fst']

    runner.test(
        hdl_toplevel=tb_toplevel,
        test_module="greyhound_ihp_top_tb,",
        plusargs=plusargs,
        waves=True,
    )

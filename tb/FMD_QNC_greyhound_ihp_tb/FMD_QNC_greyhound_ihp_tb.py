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
from cocotb.runner import get_runner
#from cocotb_tools.runner import get_runner
from cocotbext.uart import UartSource, UartSink
from cocotbext.spi import SpiBus, SpiConfig, SpiMaster
import logging
from cocotbext.jtag import JTAGDriver, JTAGBus, JTAGDevice

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

jtag_enable = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'enable':'',
}

jtag_sample = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'sample':'',
}

jtag_extest = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'extest':'',
}

jtag_intest = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'intest':'',
}

jtag_isc = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'isc':'',
}

jtag_commands = {
    'flash0_slot0': '',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'commands':'',
}

enabled = jtag_intest

async def start_clock(clock, freq=50):
    """ Start the clock @ freq MHz """
    c = Clock(clock, 1/freq*1000, 'ns')
    await cocotb.start(c.start())

async def reset(system_reset, tap_reset, active_low=True, time_ns=1000):
    """ Reset dut """
    cocotb.log.info("Reset asserted...")
    
    system_reset.value = not active_low
    if tap_reset is not None: 
        tap_reset.value = not active_low
    await Timer(time_ns, "ns")
    system_reset.value = active_low
    if tap_reset is not None: 
        tap_reset.value = active_low
    
    cocotb.log.info("Reset deasserted.")

async def start_up(dut, tap_reset=True):
    """ Startup sequence """
    await start_clock(dut.io_clock_PAD)
    
    trst_pad = None
    if tap_reset:
        trst_pad = dut.io_fpga_mode_PAD
    
    await reset(dut.io_reset_PAD, trst_pad) # Tap reset is shared with fpga mode

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

    # Start up
    await start_up(dut)
    
    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

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

    # Start up
    await start_up(dut)
    
    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 1 # Configure FPGA as receiver

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller

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

    # Start up
    await start_up(dut)

    # Static setup, apply after reset happened (fpga_mode and tap reset share a line)
    dut.io_fpga_mode_PAD.value = 0 # Configure FPGA as controller
    
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

# Define JTAG devices
class JTAGCore(JTAGDevice):
    def __init__(self, name="jtagcore", idcode=0x2_5256_001, ir_len=5):
        super().__init__(name, idcode, ir_len)
        self.add_jtag_reg("IDCODE", 32, 0x1)
        self.idle_delay = 10

class JTAGFPGA(JTAGDevice):
    def __init__(self, name="jtagfpga", idcode=0x2_4646_001, ir_len=5):
        super().__init__(name, idcode, ir_len)
        self.add_jtag_reg("IDCODE", 32, 0x1)
        self.add_jtag_reg("USERCODE", 32,0x2)
        self.add_jtag_reg("SAMPLE", 64, 0x3)
        self.add_jtag_reg("PRELOAD", 64, 0x3)
        self.add_jtag_reg("EXTEST", 64, 0x4)
        self.add_jtag_reg("INTEST", 64, 0x5)
        self.add_jtag_reg("EJTAG", 1, 0x10)
        self.add_jtag_reg("ISC_ENABLE", 1, 0x14)
        self.add_jtag_reg("ISC_DISABLE", 1,0x15)
        self.add_jtag_reg("ISC_PROGRAM", 32,0x16)
        self.add_jtag_reg("ISC_NOOP", 1, 0x17)

        self.idle_delay = 10

async def setup_for_jtag(dut):
    """Setup soc for jtag"""
    # Setup JTAG
    jtag_signals:dict = {"tck" :"io_fpga_sclk_PAD",
                         "tms" :"io_fpga_cs_n_PAD",
                         "tdi" :"io_fpga_mosi_PAD",
                         "tdo" :"io_fpga_miso_PAD",
                         "trst":"io_fpga_mode_PAD"}

    bus = JTAGBus(dut, signals=jtag_signals)
    jtag = JTAGDriver(bus)
    jtag.add_device(JTAGCore())
    jtag.add_device(JTAGFPGA())
    jtag.devices[0].print_regs()
    jtag.devices[1].print_regs()

    # Static setup
    dut.io_fetch_enable_PAD.value = 1

    # Start up
    await start_up(dut, False)
    
    # TODO test without tdo connected to output
    # Enable JTAG mode of FPGA
    await ClockCycles(dut.io_clock_PAD, 10)
    cocotb.log.info("Enable JTAG interface.")
    dut.io_reset_PAD.value = 0
    await ClockCycles(dut.io_clock_PAD, 10)

    # All jtag operations have to be one after the other, else jtag lib runs into issues
    # Test perm enable of JTAG interface
    await jtag.write("EJTAG", 0x1, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    dut.io_reset_PAD.value = 1
    cocotb.log.info("JTAG interface enabled.")
    return jtag

@cocotb.test(skip=enabled!=jtag_enable)
async def test_jtag_enable(dut):
    jtag = await setup_for_jtag(dut)

    # Test interface enabled
    assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.en_jtag_receiver == 0x1)

    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("EJTAG", 0x0, device=1)
    cocotb.log.info("JTAG interface disabled.")
    # Test interface disable
    assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.en_jtag_receiver == 0x0)
    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=enabled!=jtag_sample)
async def test_jtag_sample(dut):
    jtag = await setup_for_jtag(dut)
    # TODO do this by specifiing boundary cell values


@cocotb.test(skip=enabled!=jtag_extest)
async def test_jtag_extest(dut):
    jtag = await setup_for_jtag(dut)
    
    dut.io_gpio_PAD[1].value = 0
    dut.io_gpio_PAD[3].value = 0
    dut.io_gpio_PAD[4].value = 0
    dut.io_gpio_PAD[6].value = 0
    dut.io_gpio_PAD[9].value = 0
    dut.io_gpio_PAD[11].value = 0
    dut.io_gpio_PAD[12].value = 0
    dut.io_gpio_PAD[14].value = 0
    dut.io_gpio_PAD[17].value = 0
    dut.io_gpio_PAD[19].value = 0
    dut.io_gpio_PAD[20].value = 0
    dut.io_gpio_PAD[22].value = 0
    dut.io_gpio_PAD[25].value = 0
    dut.io_gpio_PAD[27].value = 0
    dut.io_gpio_PAD[28].value = 0
    dut.io_gpio_PAD[30].value = 0
    
    # Test instr TODO find how to access returned value
    await jtag.write("PRELOAD", 0xc639c639_c639c639, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("EXTEST", 0xc639c639_c639c639, ret_val=0xc431c431_c431c431, device=1)
    await jtag.write("EXTEST", 0xc639c639_c639c639, ret_val=0xc431c431_c431c431, device=1)
    dut.io_gpio_PAD[1].value = 1
    dut.io_gpio_PAD[3].value = 1
    dut.io_gpio_PAD[4].value = 1
    dut.io_gpio_PAD[6].value = 1
    dut.io_gpio_PAD[9].value = 1
    dut.io_gpio_PAD[11].value = 1
    dut.io_gpio_PAD[12].value = 1
    await jtag.write("EXTEST", 0xc639c639_c639c639, ret_val=0xe6b9e6b1_c431c431, device=1)
    dut.io_gpio_PAD[14].value = 1
    dut.io_gpio_PAD[17].value = 1
    dut.io_gpio_PAD[19].value = 1
    dut.io_gpio_PAD[20].value = 1
    dut.io_gpio_PAD[22].value = 1
    dut.io_gpio_PAD[25].value = 1
    dut.io_gpio_PAD[27].value = 1
    dut.io_gpio_PAD[28].value = 1
    dut.io_gpio_PAD[30].value = 1
    await jtag.write("EXTEST", 0xc639c639_c639c639, ret_val=0xe6b9e6b9_e6b9e6b8, device=1)

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=enabled!=jtag_intest)
async def test_jtag_intest(dut):
    # TODO this testcase
    jtag = await setup_for_jtag(dut)
    dut.io_gpio_PAD[1].value = 0
    dut.io_gpio_PAD[3].value = 0
    dut.io_gpio_PAD[4].value = 0
    dut.io_gpio_PAD[6].value = 0
    dut.io_gpio_PAD[9].value = 0
    dut.io_gpio_PAD[11].value = 0
    dut.io_gpio_PAD[12].value = 0
    dut.io_gpio_PAD[14].value = 0
    dut.io_gpio_PAD[17].value = 0
    dut.io_gpio_PAD[19].value = 0
    dut.io_gpio_PAD[20].value = 0
    dut.io_gpio_PAD[22].value = 0
    dut.io_gpio_PAD[25].value = 0
    dut.io_gpio_PAD[27].value = 0
    dut.io_gpio_PAD[28].value = 0
    dut.io_gpio_PAD[30].value = 0
    
    # Test instr TODO find how to access returned value
    await jtag.write("PRELOAD", 0xc639c639_c639c639, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("INTEST", 0xc639c639_c639c639, ret_val=0xc431c431_c431c431, device=1)
    await jtag.write("INTEST", 0xc639c639_c639c639, ret_val=0xc431c431_c431c431, device=1)
    dut.io_gpio_PAD[1].value = 1
    dut.io_gpio_PAD[3].value = 1
    dut.io_gpio_PAD[4].value = 1
    dut.io_gpio_PAD[6].value = 1
    dut.io_gpio_PAD[9].value = 1
    dut.io_gpio_PAD[11].value = 1
    dut.io_gpio_PAD[12].value = 1
    await jtag.write("INTEST", 0xc639c639_c639c639, ret_val=0xe6b9e6b1_c431c431, device=1)
    dut.io_gpio_PAD[14].value = 1
    dut.io_gpio_PAD[17].value = 1
    dut.io_gpio_PAD[19].value = 1
    dut.io_gpio_PAD[20].value = 1
    dut.io_gpio_PAD[22].value = 1
    dut.io_gpio_PAD[25].value = 1
    dut.io_gpio_PAD[27].value = 1
    dut.io_gpio_PAD[28].value = 1
    dut.io_gpio_PAD[30].value = 1
    await jtag.write("INTEST", 0xc639c639_c639c639, ret_val=0xe6b9e6b9_e6b9e6b8, device=1)

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=enabled!=jtag_isc)
async def test_jtag_isc(dut):
    jtag = await setup_for_jtag(dut)

@cocotb.test(skip=enabled!=jtag_commands)
async def test_jtag_commands(dut):
    # TODO needs env COCOTB_RESOLVE_X=ZEROS to startup until tdo is set to output
    """Run the JTAG command test"""
    jtag = await setup_for_jtag(dut)

    # Test jtag boundary scan functions
    # TODO check pattern in boundary reg
    await jtag.write("USERCODE", 0xa5a5a5a5, device=1)        # Need rom downloaded
    await jtag.write("SAMPLE", 0xaaaaaaaa_55555555, device=1) # Better sample test (need fpga rom downloaded)
    await jtag.write("PRELOAD", 0xc639c639_c639c639, device=1)
    await jtag.write("EXTEST", 0x1c0ffee1_deadbeef, device=1)
    await jtag.write("PRELOAD", 0xc639c639_c639c639, device=1) 
    await jtag.write("INTEST", 0xdeadbeef_1c0ffee1, device=1)
    await jtag.write("SAMPLE", 0x55555555_aaaaaaaa, device=1)

    # Test ics functions with simple device programming
    # TODO check pattern from fig 6 page 26 IEEE1532 after writing JTAG instr. 
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    await jtag.write("ISC_PROGRAM", 0xdeadbeef, device=1)
    await jtag.write("ISC_PROGRAM", 0x1c0ffee1, device=1)
    await jtag.write("ISC_NOOP", 0x1, device=1)
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    await jtag.write("ISC_ENABLE", 0x1, device=1)

    # TODO Check sample, usercode and intest after programming

    await ClockCycles(dut.io_clock_PAD, 100)

if __name__ == "__main__":

    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", Path("~/.ciel").expanduser())
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")
    gl          = os.getenv("GL", False)

    testbench_path = Path(__file__).resolve().parent
    
    includes = [testbench_path / '../../rtl/include']
    
    verilog_sources = []
    defines = {}

    if gl:
        # SCL models
        verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
        
        verilog_sources.append(testbench_path / '../../final/nl/FMD_QNC_greyhound_ihp.nl.v')
        #verilog_sources.append(testbench_path / '../../final/pnl/FMD_QNC_greyhound_ihp.pnl.v')
        
        verilog_sources.append(testbench_path / '../../ip/bondpad_70x70/bondpad_70x70.v')
        
        defines = {'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    else:
        # SCL models (for the clock gate)
        verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
    
        verilog_sources.append(testbench_path / 'FMD_QNC_greyhound_ihp_slang.sv')
        verilog_sources.append(testbench_path / '../simlib.v')
        
        defines = {'RTL': True, 'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    
    verilog_sources += [
        testbench_path / 'FMD_QNC_greyhound_ihp_tb.v',
        testbench_path / 'spiflash.v',
        testbench_path / 'spiflash_powered.v',
        
        # SRAM models
        testbench_path / '../../ip' / "RM_IHPSG13_1P_1024x32_c2_bm_bist" / "verilog" / "RM_IHPSG13_1P_1024x32_c2_bm_bist.v",
        testbench_path / '../../ip' / "RM_IHPSG13_1P_1024x32_c2_bm_bist" / "verilog" / "RM_IHPSG13_1P_core_behavioral_bm_bist.v",
        
        # BRAM models
        testbench_path / '../../ip' / "RM_IHPSG13_2P_1024x16_c2_bm_bist" / "verilog" / "RM_IHPSG13_2P_1024x16_c2_bm_bist.v",
        testbench_path / '../../ip' / "RM_IHPSG13_2P_1024x16_c2_bm_bist" / "verilog" / "RM_IHPSG13_2P_core_behavioral_bm_bist_ideal.v",
        
        # IO Pad models
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_io" / "verilog" / "sg13g2_io.v",
        
    ]
    
    # Add FPGA fabric
    verilog_sources.append(testbench_path / f'../../ip/fabric/macro/{pdk}/fabulous/eFPGA.v')

    # Paths
    TILES_ROOT = testbench_path / '../../ip/tile_library/tiles'
    PRIMITIVES_ROOT = testbench_path / '../../ip/tile_library/primitives/'
    
    # Primitives
    verilog_sources.append(f'{PRIMITIVES_ROOT}/CPU_IRQ/CPU_IRQ.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/CUSTOM_INSTRUCTION/CUSTOM_INSTRUCTION.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/IHP_SRAM_1024x32/IHP_SRAM_1024x32.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/IHP_BRAM_1024x16/IHP_BRAM_1024x16.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/IO_1_bidirectional_frame_config_pass/IO_1_bidirectional_frame_config_pass.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/LUT4c_frame_config_dffesr/LUT4c_frame_config_dffesr.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/MULADD/MULADD.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/MUX8LUT_frame_config_mux/MUX8LUT_frame_config_mux.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/OBI_PERIPHERAL/OBI_PERIPHERAL.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/RegFile_32x4/RegFile_32x4.v')
    verilog_sources.append(f'{PRIMITIVES_ROOT}/WARMBOOT/WARMBOOT.v')
    
    # DSP
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_bot/DSP_bot.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_bot/DSP_bot_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_bot/DSP_bot_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_top/DSP_top.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_top/DSP_top_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/DSP/DSP_top/DSP_top_switch_matrix.v')
    
    # LUT4AB
    verilog_sources.append(f'{TILES_ROOT}/LUT4AB/LUT4AB.v')
    verilog_sources.append(f'{TILES_ROOT}/LUT4AB/LUT4AB_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/LUT4AB/LUT4AB_switch_matrix.v')
    
    # N_term_DSP
    verilog_sources.append(f'{TILES_ROOT}/N_term_DSP/N_term_DSP.v')
    verilog_sources.append(f'{TILES_ROOT}/N_term_DSP/N_term_DSP_switch_matrix.v')
    
    # N_term_single
    verilog_sources.append(f'{TILES_ROOT}/N_term_single/N_term_single.v')
    verilog_sources.append(f'{TILES_ROOT}/N_term_single/N_term_single_switch_matrix.v')
    
    # N_term_single2
    verilog_sources.append(f'{TILES_ROOT}/N_term_single2/N_term_single2.v')
    verilog_sources.append(f'{TILES_ROOT}/N_term_single2/N_term_single2_switch_matrix.v')

    # RegFile
    verilog_sources.append(f'{TILES_ROOT}/RegFile/RegFile.v')
    verilog_sources.append(f'{TILES_ROOT}/RegFile/RegFile_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/RegFile/RegFile_switch_matrix.v')
    
    # S_term_DSP
    verilog_sources.append(f'{TILES_ROOT}/S_term_DSP/S_term_DSP.v')
    verilog_sources.append(f'{TILES_ROOT}/S_term_DSP/S_term_DSP_switch_matrix.v')
    
    # S_term_single
    verilog_sources.append(f'{TILES_ROOT}/S_term_single/S_term_single.v')
    verilog_sources.append(f'{TILES_ROOT}/S_term_single/S_term_single_switch_matrix.v')

    # S_term_single2
    verilog_sources.append(f'{TILES_ROOT}/S_term_single2/S_term_single2.v')
    verilog_sources.append(f'{TILES_ROOT}/S_term_single2/S_term_single2_switch_matrix.v')

    # W_IO
    verilog_sources.append(f'{TILES_ROOT}/W_IO/W_IO.v')
    verilog_sources.append(f'{TILES_ROOT}/W_IO/W_IO_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/W_IO/W_IO_switch_matrix.v')

    # S_WARMBOOT
    verilog_sources.append(f'{TILES_ROOT}/S_WARMBOOT/S_WARMBOOT.v')
    verilog_sources.append(f'{TILES_ROOT}/S_WARMBOOT/S_WARMBOOT_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_WARMBOOT/S_WARMBOOT_switch_matrix.v')
    
    # S_CPU_IF
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IF/S_CPU_IF.v')
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IF/S_CPU_IF_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IF/S_CPU_IF_switch_matrix.v')

    # S_CPU_IRQ
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IRQ/S_CPU_IRQ.v')
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IRQ/S_CPU_IRQ_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_CPU_IRQ/S_CPU_IRQ_switch_matrix.v')

    # IHP_SRAM
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_bot/IHP_SRAM_bot.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_bot/IHP_SRAM_bot_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_bot/IHP_SRAM_bot_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_top/IHP_SRAM_top.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_top/IHP_SRAM_top_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_SRAM/IHP_SRAM_top/IHP_SRAM_top_switch_matrix.v')

    # IHP_BRAM
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_bot/IHP_BRAM_bot.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_bot/IHP_BRAM_bot_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_bot/IHP_BRAM_bot_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_top/IHP_BRAM_top.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_top/IHP_BRAM_top_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/IHP_BRAM/IHP_BRAM_top/IHP_BRAM_top_switch_matrix.v')

    # N_term_IHP_SRAM
    verilog_sources.append(f'{TILES_ROOT}/N_term_IHP_SRAM/N_term_IHP_SRAM.v')
    verilog_sources.append(f'{TILES_ROOT}/N_term_IHP_SRAM/N_term_IHP_SRAM_switch_matrix.v')

    # S_term_IHP_SRAM
    verilog_sources.append(f'{TILES_ROOT}/S_term_IHP_SRAM/S_term_IHP_SRAM.v')
    verilog_sources.append(f'{TILES_ROOT}/S_term_IHP_SRAM/S_term_IHP_SRAM_switch_matrix.v')

    # S_OBI
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_left/S_OBI_left.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_left/S_OBI_left_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_left/S_OBI_left_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_middle/S_OBI_middle.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_middle/S_OBI_middle_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_middle/S_OBI_middle_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_right/S_OBI_right.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_right/S_OBI_right_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_OBI/S_OBI_right/S_OBI_right_switch_matrix.v')

    # S_XIF
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_left/S_XIF_left.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_left/S_XIF_left_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_left/S_XIF_left_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_middle/S_XIF_middle.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_middle/S_XIF_middle_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_middle/S_XIF_middle_switch_matrix.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_right/S_XIF_right.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_right/S_XIF_right_ConfigMem.v')
    verilog_sources.append(f'{TILES_ROOT}/S_XIF/S_XIF_right/S_XIF_right_switch_matrix.v')

    verilog_sources.append(testbench_path / '../../ip/tile_library/models_pack.v')

    defines['USE_POWER_PINS'] = True
    
    if enabled["connect_flash1"]:
        defines['BITSTREAM_FLASH'] = True
    
    if enabled["dump_waveforms"]:
        defines['DUMP_WAVEFORMS'] = True
    
    hdl_toplevel = "FMD_QNC_greyhound_ihp_tb"

    build_args = []

    if sim == 'icarus':
        build_args = ['-Winfloop', '-pfileline=1']

    if sim == 'verilator':
        build_args = ['--timing', '--trace', '--trace-fst', '--trace-structs']

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
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
        hdl_toplevel=hdl_toplevel,
        test_module="FMD_QNC_greyhound_ihp_tb,",
        plusargs=plusargs,
        waves=True,
    )

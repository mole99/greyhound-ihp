# SPDX-FileCopyrightText: © 2025 Leo Moser <leomoser99@gmail.com>
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

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

jtag_bsr_none = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'bsr_length': 1,
}

jtag_bsr_external = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'bsr_length': 64,
}

jtag_bsr_internal = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'bsr_length': 245,
}

jtag_bsr_all = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
    'bsr_length': 309,
}

jtag_cpu = {
    'flash0_slot0': '../../../firmware/write_fpga/write_fpga.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
}

enabled = hello_world

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
    await ClockCycles(dut.io_clock_PAD, int(50000*2.5))
    
    # Send char
    await uart_source.write(b'A')
    
    # Read char
    data = await uart_sink.read(1)
    print(data)
    assert data == b'A'

    # Wait for message
    await ClockCycles(dut.io_clock_PAD, int(50000*2.0))
    
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
        bsr_length = 1

        if 'bsr_length' in enabled:
            bsr_length = enabled['bsr_length']
        
        self.add_jtag_reg("SAMPLE", bsr_length, 0x3)
        self.add_jtag_reg("PRELOAD", bsr_length, 0x3)
        self.add_jtag_reg("EXTEST", bsr_length, 0x4)
        self.add_jtag_reg("INTEST", bsr_length, 0x5)

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

@cocotb.test(skip=(enabled!=jtag_bsr_none and enabled!=jtag_bsr_external and enabled!=jtag_bsr_internal and enabled != jtag_bsr_all))
async def test_jtag_enable(dut):
    """Permanently enable jtag interface"""
    jtag = await setup_for_jtag(dut)
    gl   = os.getenv("GL", False)

    # Test interface enabled
    if gl:
        await jtag.read("IDCODE", device=1)
        print("Returned %x" % (jtag.ret_val))
        assert (jtag.ret_val == 0x4646001)
    else:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.en_jtag_receiver == 0x1)

    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("EJTAG", 0x0, device=1)
    cocotb.log.info("JTAG interface disabled.")
    # Test interface disable
    if gl:
        await jtag.read("IDCODE", device=1)
        print("Returned %x" % (jtag.ret_val))
        assert (jtag.ret_val == 0x0)
    else:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.en_jtag_receiver == 0x0)

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=(enabled!=jtag_bsr_external and enabled!=jtag_bsr_internal and enabled != jtag_bsr_all) or os.getenv("GL", False))
async def test_jtag_sample(dut):
    """JTAG SAMPLE command"""
    jtag = await setup_for_jtag(dut)

    # Set outputs
    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        # GPIOs
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_oe_o.value = 0xffffffff
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o.value = 0x0
    
    if enabled == jtag_bsr_internal or enabled == jtag_bsr_all:
        # CPU_IRQ
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_irq_dm.value = 0 # 4 bit
        # CUSTOM_INSTRUCTION
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_ready_dm.value  = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_accept_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_valid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_id_dm.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_rd_dm.value    = 0 # 5 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_dm.value       = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_valid_soc.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_instr_soc.value = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op0_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op1_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_id_soc.value    = 0 # 4 bit
        # OBI_PERIPHERAL
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_gnt_dm.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rvalid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rdata_dm.value  = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_req_soc.value   = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_we_soc.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_be_soc.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_addr_soc.value  = 0 # 24 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_wdata_soc.value = 0 # 32 bit

    # Set expected test vectors
    if enabled == jtag_bsr_external:
        ret_val = [0x55555555_55555555, 0xd7f57d5f_d7f57d5f]
    if enabled == jtag_bsr_internal:
        ret_val = [0x0,
                   0x180000_000001ef_67ab23cd_45890555_55555a22_f7b3d591_e6a2c407_77777774]
    if enabled == jtag_bsr_all:
        ret_val = [0xaaaaa_aaaaaaaa_aaa00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
                   0x1afeaf_abfafeaf_abf80000_000001ef_67ab23cd_45890555_55555a22_f7b3d591_e6a2c407_77777774]

    # Change isc state to operational (without device programming)
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    await jtag.read("SAMPLE", device=1)
    assert(jtag.ret_val == ret_val[0])

    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o.value = 0xc639c639
    
    if enabled == jtag_bsr_internal or enabled == jtag_bsr_all:
        # CPU_IRQ
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_irq_dm.value = 0x3 # 4 bit
        # CUSTOM_INSTRUCTION
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_accept_dm.value = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_id_dm.value    = 0x2 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_rd_dm.value    = 0x5 # 5 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_dm.value       = 0xaaaaaaaa # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_instr_soc.value = 0x12345678 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op0_soc.value   = 0x9abcdef0 # 32 bit
        # OBI_PERIPHERAL
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rdata_dm.value  = 0xbbbbbbbb # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_req_soc.value   = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_addr_soc.value  = 0x234567 # 24 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_wdata_soc.value = 0x89abcdef # 32 bit

    await jtag.read("SAMPLE", device=1)
    assert(jtag.ret_val == ret_val[1])

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=(enabled!=jtag_bsr_external and enabled!=jtag_bsr_internal and enabled != jtag_bsr_all))
async def test_jtag_extest(dut):
    """JTAG EXTEST command, with stepping through ICS (IEEE1532) testmode"""
    jtag = await setup_for_jtag(dut)
    gl   = os.getenv("GL", False)

    # Set extest inputs
    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        # GPIOs
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
   
    if not gl and (enabled == jtag_bsr_internal or enabled == jtag_bsr_all):
        # CPU_IRQ
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_irq_dm.value = 0x3 # 4 bit
        # CUSTOM_INSTRUCTION
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_ready_dm.value  = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_accept_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_valid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_id_dm.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_rd_dm.value    = 0 # 5 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_dm.value       = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_valid_soc.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_instr_soc.value = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op0_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op1_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_id_soc.value    = 0 # 4 bit
        # OBI_PERIPHERAL
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_gnt_dm.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rvalid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rdata_dm.value  = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_req_soc.value   = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_we_soc.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_be_soc.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_addr_soc.value  = 0 # 24 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_wdata_soc.value = 0 # 32 bit
    
    # Set expected test vectors
    if enabled == jtag_bsr_external:
        write_val = 0xc639c639_c639c639
        ret_val   = [0xc431c431_c431c431, 0xc431c431_c431c431, 0xe6b9e6b1_c431c431, 0xe6b9e6b9_e6b9e6b9]
        mask_val  = 0xffffffff_ffffffff
    if enabled == jtag_bsr_internal:
        write_val = 0x000000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val   = [0x180000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
                     0x180000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
                     0x1861ef_67ab23cd_45890aaa_aaaab000_00000000_00000000_00000000_00000000,
                     0x1861ef_67ab23cd_45890aaa_aaaab000_00000000_f7b3d591_e6a2c484_00000000]
        mask_val  =  0x0
    if enabled == jtag_bsr_all:
        write_val = 0x18c738_c738c738_c7200000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val   = [0x188638_86388638_86380000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
                     0x188638_86388638_86380000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
                     0x1cd73c_d6388638_863861ef_67ab23cd_45890aaa_aaaab000_00000000_00000000_00000000_00000000,
                     0x1cd73c_d73cd73c_d73861ef_67ab23cd_45890aaa_aaaab000_00000000_f7b3d591_e6a2c484_00000000]
        mask_val  = 0xffffff_ffffffff_ffe00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000

    if gl:
        write_val = write_val & mask_val

    # Test isc preload
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x0) # ISC Unprogrammed
    await jtag.write("PRELOAD", write_val, device=1)
    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        print("%x == %x" % ((jtag.ret_val & mask_val), (ret_val[0] & mask_val)))
        assert((jtag.ret_val & mask_val) == (ret_val[0] & mask_val))
    else:
        assert(jtag.ret_val == ret_val[0])
    
    await jtag.write("BYPASS", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x0) # ISC Unprogrammed

    # Change isc state to operational (without device programming) and test testmode behaviour
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0b1) # ISC Accessed
    
    await jtag.write("EXTEST", write_val, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0x1) # ISC Accessed
    
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_disable_completing_q.value == 0x1) # ISC Complete
    
    await jtag.write("EXTEST", write_val, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    # Test if preload holds the value until test
    await jtag.write("PRELOAD", write_val, device=1)
    await jtag.write("BYPASS", 0x1, device=1)

    # Check for correct extest scan reg value, when input changes (output is set by test vector)
    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        assert((jtag.ret_val & mask_val) == (ret_val[0] & mask_val))
    else:
        assert(jtag.ret_val == ret_val[0])

    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        assert((jtag.ret_val & mask_val) == (ret_val[1] & mask_val))
    else:
        assert(jtag.ret_val == ret_val[1])

    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        # GPIOs
        dut.io_gpio_PAD[1].value = 1
        dut.io_gpio_PAD[3].value = 1
        dut.io_gpio_PAD[4].value = 1
        dut.io_gpio_PAD[6].value = 1
        dut.io_gpio_PAD[9].value = 1
        dut.io_gpio_PAD[11].value = 1
        dut.io_gpio_PAD[12].value = 1

    if not gl and (enabled == jtag_bsr_internal or enabled == jtag_bsr_all):
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_valid_soc.value = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_instr_soc.value = 0xaaaaaaaa # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op0_soc.value   = 0x12345678 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op1_soc.value   = 0x9abcdef0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_id_soc.value    = 0xc # 4 bit

    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        assert((jtag.ret_val & mask_val) == (ret_val[2] & mask_val))
    else:
        assert(jtag.ret_val == ret_val[2])

    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        # GPIOs
        dut.io_gpio_PAD[14].value = 1
        dut.io_gpio_PAD[17].value = 1
        dut.io_gpio_PAD[19].value = 1
        dut.io_gpio_PAD[20].value = 1
        dut.io_gpio_PAD[22].value = 1
        dut.io_gpio_PAD[25].value = 1
        dut.io_gpio_PAD[27].value = 1
        dut.io_gpio_PAD[28].value = 1
        dut.io_gpio_PAD[30].value = 1

    if not gl and (enabled == jtag_bsr_internal or enabled == jtag_bsr_all):
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_req_soc.value   = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_we_soc.value    = 0x0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_be_soc.value    = 0x1 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_addr_soc.value  = 0x234567 # 24 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_wdata_soc.value = 0x89abcdef # 32 bit

    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        assert((jtag.ret_val & mask_val) == (ret_val[3] & mask_val))
    else:
        assert(jtag.ret_val == ret_val[3])

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=(enabled!=jtag_bsr_external and enabled!=jtag_bsr_internal and enabled != jtag_bsr_all) or os.getenv("GL", False))
async def test_jtag_intest(dut):
    """JTAG INTEST command"""
    jtag = await setup_for_jtag(dut)

    # Set intest outputs
    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        # GPIOs
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_oe_o.value = 0xa5a5a5a5
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[0].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[2].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[5].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[7].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[8].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[10].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[13].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[15].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[16].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[18].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[21].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[23].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[24].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[26].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[29].value = 0
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[31].value = 0

    if enabled == jtag_bsr_internal or enabled == jtag_bsr_all:
        # CPU_IRQ
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_irq_dm.value = 0x3 # 4 bit
        # CUSTOM_INSTRUCTION
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_ready_dm.value  = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_accept_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_valid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_id_dm.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_rd_dm.value    = 0 # 5 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_dm.value       = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_valid_soc.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_instr_soc.value = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op0_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_op1_soc.value   = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_id_soc.value    = 0 # 4 bit
        # OBI_PERIPHERAL
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_gnt_dm.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rvalid_dm.value = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rdata_dm.value  = 0 # 32 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_req_soc.value   = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_we_soc.value    = 0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_be_soc.value    = 0 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_addr_soc.value  = 0 # 24 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_wdata_soc.value = 0 # 32 bit

    # Set expected test vectors
    if enabled == jtag_bsr_external:
        write_val = 0xc639c639_c639c639
        ret_val   = [0x46194619_46194619, 0x46194619_46194619, 0xce3bce39_46194619, 0xce3bce3b_ce3bce3b]
    if enabled == jtag_bsr_internal:
        write_val = 0x000000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val   = [0x180000_0000001a_bfafeaff_aefaf000_00000000_00000000_0c123454_00000000,
                     0x180000_0000001a_bfafeaff_aefaf000_00000000_00000000_0c123454_00000000,
                     0x180000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123454_00000000,
                     0x180000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123456_479a8b11]
    if enabled == jtag_bsr_all:
        write_val = 0x18c738_c738c738_c7200000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val   = [0x08c328_c328c328_c3380000_0000001a_bfafeaff_aefaf000_00000000_00000000_0c123454_00000000,
                     0x08c328_c328c328_c3380000_0000001a_bfafeaff_aefaf000_00000000_00000000_0c123454_00000000,
                     0x19c779_c728c328_c3380000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123454_00000000,
                     0x19c779_c779c779_c7780000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123456_479a8b11]

    # Change isc state to operational (without device programming)
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    # Test if preload holds the value until test
    await jtag.write("PRELOAD", write_val, device=1)
    await jtag.write("BYPASS", 0x1, device=1)

    # Check for correct intest scan reg value, when output changes (input is set by test vector)
    await jtag.write("INTEST", write_val, device=1)
    assert(jtag.ret_val == ret_val[0])

    await jtag.write("INTEST", write_val, device=1)
    assert(jtag.ret_val == ret_val[1])

    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[0].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[2].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[5].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[7].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[8].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[10].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[13].value = 1

    if enabled == jtag_bsr_internal or enabled == jtag_bsr_all:
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_ready_dm.value  = 0x0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_issue_accept_dm.value = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_valid_dm.value = 0x0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_id_dm.value    = 0x5 # 4 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_rd_dm.value    = 0x16 # 5 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_result_dm.value       = 0x89abcdef # 32 bit

    await jtag.write("INTEST", write_val, device=1)
    assert(jtag.ret_val == ret_val[2])

    if enabled == jtag_bsr_external or enabled == jtag_bsr_all:
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[15].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[16].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[18].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[21].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[23].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[24].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[26].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[29].value = 1
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_io_west_out_o[31].value = 1

    if enabled == jtag_bsr_internal or enabled == jtag_bsr_all:
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_gnt_dm.value    = 0x1 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rvalid_dm.value = 0x0 # 1 bit
        dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fabric_rdata_dm.value  = 0x23456789 # 32 bit

    await jtag.write("INTEST", write_val, device=1)
    assert(jtag.ret_val == ret_val[3])

    await ClockCycles(dut.io_clock_PAD, 10)

async def write_bitstream_jtag(filename, jtag):
    with open(filename, 'br') as f:
        data = f.read(4)
        nbr = 0
        while data:
            number = int.from_bytes(data, "big")
            cocotb.log.info("Program word %d of %d" % (nbr, 4565))
            await jtag.write("ISC_PROGRAM", number, device=1)
            data = f.read(4)
            nbr = nbr + 1

@cocotb.test(skip=(enabled!=jtag_bsr_none and enabled!=jtag_bsr_external and enabled!=jtag_bsr_internal and enabled != jtag_bsr_all))
async def test_jtag_isc(dut):
    """ISC (IEEE1532) device programming, with USERCODE command support"""
    jtag = await setup_for_jtag(dut)
    gl   = os.getenv("GL", False)

    # Test USERCODE
    await jtag.read("USERCODE", device=1)
    assert(jtag.ret_val == 0x0)

    # Program device over jtag
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x0) # ISC Unprogrammed
    
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0b1) # ISC Accessed
    
    await write_bitstream_jtag('../../../ip/fabric/user_designs/all_ones/all_ones.bit', jtag)
    
    # Finished programming
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0b1) # ISC Accessed
    
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_disable_completing_q.value == 0x1) # ISC Complete
    
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    # Should be back in accessed state
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0b1) # ISC Accessed
    
    # Test NOOP
    await jtag.write("ISC_NOOP", 0x1, device=1)
    await jtag.write("ISC_NOOP", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_enabled_q.value == 0b1) # ISC Accessed
    
    # Test Operational
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_disable_completing_q.value == 0x1) # ISC Complete
    
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_disable_completing_q.value == 0x1) # ISC Complete
    
    await jtag.write("ISC_DISABLE", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.isc_disable_completing_q.value == 0x1) # ISC Complete
    
    await jtag.write("BYPASS", 0x1, device=1)

    # Should be in operational state
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    # Check program
    assert(dut.io_config_busy_PAD.value == 0)

    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

    # Test USERCODE
    await jtag.read("USERCODE", device=1)
    assert(jtag.ret_val == 0x1)

    if (enabled==jtag_bsr_none):
        return

    # Short test ex/intest
    if enabled == jtag_bsr_external:
        write_val  = 0xc639c639_c639c639
        ret_val_ex = 0xe6b9e6b9_e6b9e6b9
        ret_val_in = 0xce3bce3b_ce3bce3b
        mask_val   = 0xffffffff_ffffffff
    if enabled == jtag_bsr_internal:
        write_val  = 0x000000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val_ex = 0x1861ef_67ab23cd_45890aaa_aaaab000_00000000_f7b3d591_e6a2c484_00000000
        ret_val_in = 0x180000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123456_479a8b11
        mask_val   = 0x0
    if enabled == jtag_bsr_all:
        write_val  = 0x18c738_c738c738_c7200000_0000001a_bfafeaff_aefafbaa_bfafeafc_00000000_0c123456_bfafeafc
        ret_val_ex = 0x1cd73c_d73cd73c_d73861ef_67ab23cd_45890aaa_aaaab000_00000000_f7b3d591_e6a2c484_00000000
        ret_val_in = 0x19c779_c779c779_c7780000_0000001a_bfafeaff_aefaff7b_3d5916d2_00000000_0c123456_479a8b11
        mask_val   = 0xffffff_ffffffff_ffe00000_00000000_00000000_00000000_00000000_00000000_00000000_00000000

    await jtag.write("PRELOAD", write_val, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("EXTEST", write_val, device=1)
    if gl:
        print("RET_VAL ex: %x" % (jtag.ret_val))
        assert((jtag.ret_val & mask_val) == (ret_val_ex & mask_val))
    else:
        assert(jtag.ret_val == ret_val_ex)

    await jtag.read("SAMPLE", device=1)
    if gl:
        print("SAMPLE_VAL: %x" % (jtag.ret_val))
        #assert(jtag.ret_val == )
    else:
        True
        #assert(jtag.ret_val == )

    await jtag.write("PRELOAD", write_val, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("INTEST", write_val, device=1)
    if gl:
        print("RET_VAL in: %x" % (jtag.ret_val))
        assert((jtag.ret_val & mask_val) == (ret_val_in & mask_val))
    else:
        assert(jtag.ret_val == ret_val_in)

    await ClockCycles(dut.io_clock_PAD, 10)

@cocotb.test(skip=enabled!=jtag_cpu)
async def test_jtag_cpu(dut):
    """Program fabric with jtag and cpu"""
    jtag = await setup_for_jtag(dut)
    gl   = os.getenv("GL", False)

    # Program with cpu, jtag not running but in jtag mode
    cocotb.log.info("Waiting for configuration to start.")
    await RisingEdge(dut.io_config_busy_PAD)
    cocotb.log.info("Waiting for configuration to end.")
    await FallingEdge(dut.io_config_busy_PAD)

    # Clock jtag port (to update the fpga io's)
    await jtag.write("BYPASS", 0x1, device=1)
    await jtag.write("BYPASS", 0x1, device=1)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

    # Check if device is programmed
    await jtag.read("USERCODE", device=1)
    assert(jtag.ret_val == 0x1)

    # Reprogram device (only reprogram parts as to save sim time)
    await jtag.write("ISC_ENABLE", 0x1, device=1)
    bitstream = [0x00aaff01, 0x00000002, 0x00000000, 0x00000000, 0xfab0fab1, 0x00000001,
                 0x00000000, 0xcb940000, 0xc9900000, 0xc9900000, 0xc3840000, 0xc1800000, 
                 0xcb940000, 0xc3840000, 0xc3840000, 0xc9900000, 0xcf9c0000, 0xc1800000,
                 0xcb940000, 0xc5880000, 0xcb940000, 0xc3840000, 0xcd980000, 0x00000000,
                 0x00100000]

    for i in range(len(bitstream)):
        await jtag.write("ISC_PROGRAM", bitstream[i], device=1)

    await jtag.write("ISC_DISABLE", 0x1, device=1)
    await jtag.read("USERCODE", device=1)
    assert(jtag.ret_val == 0x2)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational
    
    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

    # Keep running in system mode until fabric is reconfigured
    # Test if isc state changes when fabric is busy
    for _ in range(100):
        await jtag.write("BYPASS", 0x1, device=1)
        await jtag.write("ISC_NOOP", 0x1, device=1)

    await jtag.read("USERCODE", device=1)
    assert(jtag.ret_val == 0x3)
    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

    await jtag.write("EJTAG", 0x0, device=1)
    await ClockCycles(dut.io_clock_PAD, 10)
    cocotb.log.info("JTAG interface disabled.")

    await ClockCycles(dut.io_clock_PAD, 10)

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
        extra_env = {"COCOTB_RESOLVE_X": "ZEROS"}, # Needed because JTAG pins are not always reserved
    )

# SPDX-FileCopyrightText: © 2025 Leo Moser <leomoser99@gmail.com>
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

import os
import subprocess
import random
import cocotb
import sys
import threading
import telnetlib
from pathlib import Path
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge
from cocotb.regression import TestFactory
from cocotb_tools.runner import get_runner
from cocotbext.uart import UartSource, UartSink

hello_world = {
    'flash0_slot0': '../../../firmware/hello_world_dbg/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
}

bitstream_upload = {
    'flash0_slot0': '../../../firmware/hello_world/hello_world.hex',
    'flash0_slot1': '',
    'flash1_slot0': '',
    'flash1_slot1': '',
    'connect_flash1': False,
    'dump_waveforms': True,
}

enabled = bitstream_upload

# Process control
sem_openocd = threading.Semaphore(0)
sem_gdb = threading.Semaphore(0)
sem_telnet = threading.Semaphore(0)
ev_stop_printing = threading.Event()

async def start_clock(clock, freq=50):
    """ Start the clock @ freq MHz """
    c = Clock(clock, 1/freq*1000, 'ns')
    cocotb.start_soon(c.start())

async def start_up(dut):
    """ Startup sequence """
    await start_clock(dut.io_clock_PAD)
        
    dut.reset_SimJTAG.value = False
    dut.io_reset_PAD.value  = False
    await Timer(1000, "ns")
    dut.reset_SimJTAG.value = True

    # Wait for jtag to be enabled
    gl = os.getenv("GL", False)
    if gl:
        await ClockCycles(dut.io_clock_PAD, int(50*4)) # Wait for 4µs
    else:
        await RisingEdge(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.en_jtag_receiver)
    
    dut.io_reset_PAD.value  = True

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

    # Wait for UART to get clocked, OpenOCD to connect to JTAG interface and GDB to startup
    await ClockCycles(dut.io_clock_PAD, int(50000*5.5))

    # Send char
    await uart_source.write(b'A')
    
    # Read char
    data = await uart_sink.read(1)
    cocotb.log.info(data)
    assert data == b'A'

    # Wait for message
    await ClockCycles(dut.io_clock_PAD, int(50000*2.0))
    
    # Read message
    data = uart_sink.read_nowait(-1)
    cocotb.log.info(data)
    assert data == b'Hello JTAG!\n'

@cocotb.test(skip=enabled!=bitstream_upload)
async def test_bitstream_upload(dut):
    """Upload bitstream over jtag"""
    gl = os.getenv("GL", False)

    # Static setup
    dut.io_fetch_enable_PAD.value = 1

    # Start up
    await start_up(dut)

    # Wait for telnet bitstream upload (takes ~22ms sim time)
    for i in range(22):
        cocotb.log.info("Progress: %3d %%" % (int(i*4.5)))
        await ClockCycles(dut.io_clock_PAD, 50000)

    # Check result
    cocotb.log.info(dut.io_gpio_PAD.value)
    if not gl:
        assert(dut.FMD_QNC_greyhound_ihp.i_greyhound_ihp.fpga_dm.i_dm_jtag_tap.tap_isc_state_q.value == 0x2) # ISC Operational

    assert(dut.io_gpio_PAD.value == 0xFFFFFFFF)

def streamPrinter(stream, tag:str, run_openocd:bool=False, run_gdb:bool=False, stop_gdb:bool=False, run_telnet:bool=False, stop_printing:bool=False, out=sys.__stdout__):
    started_openocd = run_openocd
    started_gdb = run_gdb
    stopped_gdb = stop_gdb
    started_telnet = run_telnet

    openocd_ready = False
    gdb_ready = False
    telnet_ready = False

    try:
        for line in stream:
            if (stop_printing and ev_stop_printing.is_set()):
                # Do not print but still clear pipe
                continue

            if not line.strip():
                print()
            else:
                print('[' + tag + '] ' + line, end='', file=out, flush=True)
                if not openocd_ready and ("Ready for Remote Connections" in line):
                    openocd_ready = True
                
                if started_openocd and ("Attempting to accept client socket" in line):
                    # OpenOCD jtag shim is running now
                    sem_openocd.release()
                    started_openocd = False

                if started_telnet and ("Listening on port 4444 for telnet connections" in line):
                    started_telnet = False
                    telnet_ready = True

                if telnet_ready and openocd_ready:
                    # OpenOCD finished startup
                    sem_telnet.release()
                    telnet_ready = False

                if started_gdb and ("Listening on port 3333 for gdb connections" in line):
                    started_gdb = False
                    gdb_ready = True

                if gdb_ready and openocd_ready:
                    # OpenOCD finished startup
                    sem_gdb.release()
                    gdb_ready = False

                if stopped_gdb and ("Exit GDB after next command" in line):
                    # Stop GDB on next command
                    stopped_gdb = False
                    for line in stream:
                        sem_gdb.release()
                        return
    except ValueError: # Happens when Pipe is closed
        return

def run_openocd():
    """Run OpenOCD"""
    # Has to be run like this as otherwise simulator is blocked by cocotb during startup
    # Wait for msg string
    sem_openocd.acquire()

    # Start openocd
    openocd = subprocess.Popen(["openocd", "-f", "FMD_QNC_greyhound_ihp_dbg_tb.cfg"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Start printers for logging
    threading.Thread(target=streamPrinter, args=(openocd.stdout, "OpenOCD std ", False, False, False, False, True), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(openocd.stderr, "OpenOCD err ", False, enabled==hello_world, False, enabled==bitstream_upload, True, sys.__stderr__), daemon=True).start()

    sem_openocd.acquire()
    # GDB has dropped the connection now -- OpenOCD has to run or library blocks simulator
    ev_stop_printing.set()

    # Sim finished -- Stop OpenOCD now
    sem_openocd.acquire()
    openocd.terminate()
    openocd.stdout.close()
    openocd.stderr.close()
    openocd.wait()

def run_gdb():
    """Run GDB"""
    # Has to be run like this as otherwise simulator is blocked by cocotb during startup
    # Wait for msg string
    sem_gdb.acquire()

    # Start gdb
    riscv = os.getenv('RISCV', default='/opt/riscv')
    gdb_args = [riscv + "/bin/riscv32-unknown-elf-gdb", 
                "../../firmware/hello_world_dbg/hello_world.elf",
                "-ex", "set remotetimeout 10",
                "-ex", "tar ext :3333",
                "-ex", "set hello={ 'H', 'e', 'l', 'l', 'o', ' ', 'J', 'T', 'A', 'G', '!', '\n', 0 }",
                "-ex", "echo Exit GDB after next command\n",
                "-ex", "c"]

    gdb = subprocess.Popen(gdb_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Start printers for logging
    threading.Thread(target=streamPrinter, args=(gdb.stdout, "GDB std     ", False, False, True), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(gdb.stderr, "GDB err     ", False, False, False, False, False, sys.__stderr__), daemon=True).start()

    sem_gdb.acquire()
    # GDB run finished close it
    gdb.kill()
    gdb.stdout.close()
    gdb.stderr.close()
    gdb.wait()

    # GDB has exited now stop openocd
    sem_openocd.release()

def run_telnet():
    """Run Telnet"""
    # Has to be run like this as otherwise simulator is blocked by cocotb during startup
    # Wait for msg string
    sem_telnet.acquire()

    tel = telnetlib.Telnet('localhost', 4444)

    # Disable background polling
    tel.write(("poll off\r\n").encode())

    # ISC Enable
    tel.write(b"irscan greyhound.fabric 0x14\r\n")

    # ISC Program
    tel.write(b"irscan greyhound.fabric 0x16\r\n")

    # Write bitstream
    with open('../../ip/fabric/user_designs/all_ones/all_ones.bit', 'br') as f:
        data = f.read(4)
        while data:
            number = int.from_bytes(data, "big")
            tel.write(b"drscan greyhound.fabric 32 %d\r\n" % (number))
            data = f.read(4)

    # ISC Disable
    tel.write(b"irscan greyhound.fabric 0x15\r\n")

    # BYPASS to activate
    tel.write(b"irscan greyhound.fabric 0x1f\r\n")

    # Reenable background polling
    tel.write(b"poll on\r\n")

    # Finished writing telnet
    sem_openocd.release()
    sem_telnet.acquire()

    # Telnet run finished
    tel.close()

if __name__ == "__main__":
    # Create pipes
    cocotbstd_r, cocotbstd_w = os.pipe()
    cocotberr_r, cocotberr_w = os.pipe()
    icarusbuild_r, icarusbuild_w = os.pipe()
    icarusrun_r, icarusrun_w = os.pipe()

    # Redirect std out and err
    sys.stdout = open(cocotbstd_w, "w")
    sys.stderr = open(cocotberr_w, "w")

    cocotbstd_r_stream = open(cocotbstd_r, "r")
    cocotberr_r_stream = open(cocotberr_r, "r")
    icarusbuild_r_stream = open(icarusbuild_r, "r")
    icarusrun_r_stream = open(icarusrun_r, "r")

    # Start printers for logging
    threading.Thread(target=streamPrinter, args=(cocotbstd_r_stream  , "Cocotb std  "), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(cocotberr_r_stream  , "Cocotb err  ", False, False, False, False, False, sys.__stderr__), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(icarusbuild_r_stream, "Icarus build"), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(icarusrun_r_stream  , "Icarus run  ", True), daemon=True).start()

    # Start wrapper for openocd
    openocd_thread = threading.Thread(target=run_openocd, daemon=True)
    openocd_thread.start()

    # Start wrapper for gdb
    if enabled==hello_world:
        gdb_thread = threading.Thread(target=run_gdb, daemon=True)
        gdb_thread.start()

    if enabled==bitstream_upload:
        # Start wrapper for telnet
        telnet_thread = threading.Thread(target=run_telnet, daemon=True)
        telnet_thread.start()

    testbench_path = Path(__file__).resolve().parent
    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", testbench_path / '../../IHP-Open-PDK')
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")
    gl          = os.getenv("GL", False)
    
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
    
        verilog_sources.append(testbench_path / '../FMD_QNC_greyhound_ihp_tb/FMD_QNC_greyhound_ihp_slang.sv')
        verilog_sources.append(testbench_path / '../simlib.v')
        
        defines = {'RTL': True, 'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    
    verilog_sources += [
        testbench_path / 'FMD_QNC_greyhound_ihp_dbg_tb.v',
        testbench_path / 'spiflash.v',
        testbench_path / 'spiflash_powered.v',
        testbench_path / '../greyhound_soc_dbg_tb/SimJTAG.sv',
        
        # SRAM models
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_sram" / "verilog" / "RM_IHPSG13_1P_1024x32_c2_bm_bist.v",
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_sram" / "verilog" / "RM_IHPSG13_1P_core_behavioral_bm_bist.v",
        
        # BRAM models
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_sram" / "verilog" / "RM_IHPSG13_2P_1024x16_c2_bm_bist.v",
        Path(pdk_root) / pdk / "libs.ref" / "sg13g2_sram" / "verilog" / "RM_IHPSG13_2P_core_behavioral_bm_bist_ideal.v",
        
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
    
    hdl_toplevel = "FMD_QNC_greyhound_ihp_dbg_tb"

    simjtag_lib = str(testbench_path / '../greyhound_soc_dbg_tb/sim_build')

    build_args = []

    if sim == 'icarus':
        build_args = ['-Winfloop', '-pfileline=1']

    if sim == 'verilator':
        build_args = ['--timing', '--trace', '--trace-fst', '--trace-structs']

    runner = get_runner(sim)
    runner.build(
        sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
        defines=defines,
        always=True,
        includes=includes,
        build_args=build_args,
        log_file=icarusbuild_w,
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
        test_module="FMD_QNC_greyhound_ihp_dbg_tb,",
        plusargs=plusargs,
        waves=True,
        test_args=["-M" + simjtag_lib, "-mremote_bitbang"],
        extra_env = {"COCOTB_RESOLVE_X": "ZEROS"}, # Needed because JTAG pins are not always reserved
        log_file=icarusrun_w,
    )

    if enabled==bitstream_upload:
        sem_telnet.release()
        telnet_thread.join()

    if enabled==hello_world:
        gdb_thread.join()

    sem_openocd.release()
    openocd_thread.join()

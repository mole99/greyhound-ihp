# SPDX-FileCopyrightText: © 2025 Leo Moser <leomoser99@gmail.com>
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

import os
import subprocess
import random
import cocotb
import sys
import threading
from pathlib import Path
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge
from cocotb.regression import TestFactory
from cocotb_tools.runner import get_runner
from cocotbext.uart import UartSource, UartSink

hello_world = {
    'firmware': '../../../firmware/hello_world_dbg/hello_world.hex'
}

custom_instruction = {
    'firmware': '../../../firmware/custom_instruction_dummy/custom_instruction_dummy.hex'
}

enabled = hello_world

# Process control
sem_openocd = threading.Semaphore(0)
sem_gdb = threading.Semaphore(0)
ev_stop_printing = threading.Event()

async def start_clock(clock, freq=50):
    """ Start the clock @ freq MHz """
    c = Clock(clock, 1/50*1000, 'ns')
    cocotb.start_soon(c.start())
    cocotb.log.info("Startus3")

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

    cocotb.log.info("Startus1")
    # Start up
    await start_up(dut)
    cocotb.log.info("Startus2")

    # Wait for UART to get clocked, OpenOCD to connect to JTAG interface and GDB to startup
    await ClockCycles(dut.clk_i, int(50000*5.5))

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
    assert data == b'Hello JTAG!\n'

@cocotb.test(skip=enabled!=custom_instruction)
async def test_custom_instruction(dut):
    """Run the custom instruction program"""

    print("Not impl yet")

def streamPrinter(stream, tag:str, run_openocd:bool=False, run_gdb:bool=False, stop_gdb:bool=False, stop_printing:bool=False, out=sys.__stdout__):
    started_openocd = run_openocd
    started_gdb = run_gdb
    stopped_gdb = stop_gdb

    try:
        for line in stream:
            if (stop_printing and ev_stop_printing.is_set()):
                # Do not print but still clear pipe
                continue

            if not line.strip():
                print()
            else:
                print('[' + tag + '] ' + line, end='', file=out, flush=True)
                if started_openocd and ("Attempting to accept client socket" in line):
                    # OpenOCD jtag shim is running now
                    sem_openocd.release()
                    started_openocd = False

                if started_gdb and ("Listening on port 3333 for gdb connections" in line):
                    # OpenOCD finished startup
                    sem_gdb.release()
                    started_gdb = False

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
    openocd = subprocess.Popen(["openocd", "-f", "greyhound_soc_dbg_tb.cfg"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Start printers for logging
    threading.Thread(target=streamPrinter, args=(openocd.stdout, "OpenOCD std ", False, False, False, True), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(openocd.stderr, "OpenOCD err ", False, True, False, True, sys.__stderr__), daemon=True).start()

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
    threading.Thread(target=streamPrinter, args=(gdb.stderr, "GDB err     ", False, False, False, False, sys.__stderr__), daemon=True).start()

    sem_gdb.acquire()
    # GDB run finished close it
    gdb.kill()
    gdb.stdout.close()
    gdb.stderr.close()
    gdb.wait()

    # GDB has exited now stop openocd
    sem_openocd.release()

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
    threading.Thread(target=streamPrinter, args=(cocotberr_r_stream  , "Cocotb err  ", False, False, False, False, sys.__stderr__), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(icarusbuild_r_stream, "Icarus build"), daemon=True).start()
    threading.Thread(target=streamPrinter, args=(icarusrun_r_stream  , "Icarus run  ", True), daemon=True).start()

    # Start wrapper for openocd
    openocd_thread = threading.Thread(target=run_openocd, daemon=True)
    openocd_thread.start()

    # Start wrapper for gdb
    gdb_thread = threading.Thread(target=run_gdb, daemon=True)
    gdb_thread.start()

    testbench_path = Path(__file__).resolve().parent
    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", testbench_path / '../../IHP-Open-PDK')
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")
    
    verilog_sources = [
        testbench_path / 'greyhound_soc_dbg_tb.sv',
        testbench_path / 'spiflash.v',
    ]
    defines = {}

    # SCL models (for the clock gate)
    verilog_sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )

    verilog_sources.append(testbench_path / '../greyhound_soc_tb/greyhound_soc_slang.sv')
    verilog_sources.append(testbench_path / '../simlib.v')
    verilog_sources.append(testbench_path / 'SimJTAG.sv')

    defines = {'RTL': True}

    hdl_toplevel = "greyhound_soc_dbg_tb"

    simjtag_lib = str(testbench_path / 'sim_build')

    runner = get_runner(sim)
    runner.build(
        sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
        defines=defines,
        always=True,
        log_file=icarusbuild_w
    )

    # Load remote_bitbang VPI in test_args
    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module="greyhound_soc_dbg_tb,",
        plusargs=['-fst', f'+firmware={enabled["firmware"]}'],
        waves=True,
        test_args=["-M" + simjtag_lib, "-mremote_bitbang"],
        log_file=icarusrun_w
    )

    gdb_thread.join()
    sem_openocd.release()
    openocd_thread.join()

# SPDX-FileCopyrightText: © 2026 FABulous Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import re
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb_tools.runner import get_runner
from cocotb.types import LogicArray, Logic

FRAME_BITS_PER_ROW = 32
MAX_FRAMES_PER_COL = 20
FRAME_SELECT_WIDTH = 5 # hardcoded, should be based on FABRIC_NUM_COLUMNS

BITSTREAM_START = 0xFAB0FAB1
DESYNC_FLAG = 20

fabric = os.getenv("FABRIC", "classic_fabric_greyhound")
tile_library = os.getenv("TILE_LIBRARY", "classic")

async def zero_bitstream(dut, delay=10):
    """
    Upload an all-zeros bitstream in reverse to prevent
    logic loops before uploading a new user design.
    """

    dut.FrameData.value = 0
    dut.FrameStrobe.value = (1<<len(dut.FrameStrobe))-1
    await Timer(delay, unit="ns")
    
    dut.FrameStrobe.value = 0
    await Timer(delay, unit="ns")

async def upload_bitstream(dut, bitstream_path, delay=10):
    """
    Read data until start of bitstream is detected
    Write data until desync bit is in header
    """

    print(f'Uploading bitstream: {bitstream_path}')
    
    framedata_bits = len(dut.FrameData)
    framestrobe_bits = len(dut.FrameStrobe)
    
    num_rows = framedata_bits//FRAME_BITS_PER_ROW
    num_columns = framestrobe_bits//MAX_FRAMES_PER_COL

    with open(bitstream_path, 'br') as f:

        # Wait for start of bitstream
        while (data := f.read(4)) != None:
            word = int.from_bytes(data, "big")
            if word == BITSTREAM_START:
                print('Start of bitstream')
                break
    
        # Read bitstream content
        while 1:
        
            # Read header
            data = f.read(4)
            if data == None:
                break
            header = int.from_bytes(data, "big")
            
            #print(f'--- header: 0x{header:08x}')
            
            column_select = (header >> 27) & 0x1F # bits 31:27
            sync_bit = (header >> DESYNC_FLAG) & 0x1 # bit 20
            frame_strobe = header & 0xFFFFF # bits 19:0
            
            #print(f"column_select: {column_select}")
            #print(f"sync_bit: {sync_bit}")
            #print(f"frame_strobe: {frame_strobe}")

            # Desync
            if sync_bit:
                print("Detected desync flag!")
                break
            
            # Read row data
            all_row_data = 0
            for i in range(num_rows):
                row_data = int.from_bytes(f.read(4), "big")
                all_row_data = all_row_data << FRAME_BITS_PER_ROW | row_data

            #print(f'0x{all_row_data:08x}')

            # Set frame data
            dut.FrameData.value = all_row_data
            
            # Assert frame strobe
            dut.FrameStrobe.value = frame_strobe<<(MAX_FRAMES_PER_COL*column_select)
            await Timer(delay, unit="ns")
            
            # Deassert frame strobe
            dut.FrameStrobe.value = 0
            await Timer(delay, unit="ns")
        
        print(f'Bitstream upload completed')
        
        # Stop the bitstream
        dut.FrameData.value = 0
        dut.FrameStrobe.value = 0
        await Timer(delay, unit="ns")

class PCF:
    "A class to read a PCF file and access the signals within cocotb."

    def __init__(self, dut, file):
        self.signals = {}
        self.top = dut._name
        print(f"Reading PCF file: {file}")
        with open(file, "r") as pcf_file:
            while line := pcf_file.readline():
                if match := re.match(r"\s*set_io\s+(?P<signal>\w+)(\[(?P<index>\d+)?\])?\s+X(?P<tilex>\d+)Y(?P<tiley>\d+)\/(?P<bel>\w+)", line):
                    signal = match.group("signal")
                    index = match.group("index")
                    tile_x = match.group("tilex")
                    tile_y = match.group("tiley")
                    bel = match.group("bel")

                    if index is None:
                        index = 0
                    else:
                        index = int(index)

                    # Find the signal in dut
                    dut_signal_in = self.find_signal(dut, tile_x, tile_y, bel, use="IN")
                    dut_signal_out = self.find_signal(dut, tile_x, tile_y, bel, use="OUT")
                    dut_signal_en = self.find_signal(dut, tile_x, tile_y, bel, use="EN")
                    
                    assert dut_signal_in is not None, f"Couldn't find IN port for: {line}"
                    assert dut_signal_out is not None, f"Couldn't find OUT port for: {line}"
                    assert dut_signal_en is not None, f"Couldn't find EN port for: {line}"
                    
                    # Add an index to a signal
                    if signal in self.signals:
                        self.signals[signal][index] = {
                            "IN":   dut_signal_in,
                            "OUT":  dut_signal_out,
                            "EN":   dut_signal_en,
                        }

                        # Sort by index
                        self.signals[signal] = dict(sorted(self.signals[signal].items()))
                    # Add a new signal
                    else:
                        self.signals[signal] = {
                             index: {
                                "IN":   dut_signal_in,
                                "OUT":  dut_signal_out,
                                "EN":   dut_signal_en,
                            }
                        }

    def write_gtkw(self, path, filter=None):
        "Write a gtkwave save file in order to view the selected signals"
        with open(path, "w") as outfile:
            outfile.write(f"@28\n")
            for signal_name, signal in self.signals.items():
                if filter is not None and signal_name in filter:
                    if len(signal) == 1:
                        outfile.write(f"#{{{signal_name}_IN}} {self.top}.{signal[0]['IN']._name}\n")
                        outfile.write(f"#{{{signal_name}_OUT}} {self.top}.{signal[0]['OUT']._name}\n")
                        outfile.write(f"#{{{signal_name}_EN}} {self.top}.{signal[0]['EN']._name}\n")
                        outfile.write(f"@200\n")
                        outfile.write(f"-\n")
                        outfile.write(f"@28\n")
                    else:
                        bits = len(signal)
                        signals_in = [ self.top + "." + use["IN"]._name for index, use in reversed(signal.items()) ]
                        signals_out = [ self.top + "." + use["OUT"]._name for index, use in reversed(signal.items()) ]
                        signals_en = [ self.top + "." + use["EN"]._name for index, use in reversed(signal.items()) ]
                    
                        for use, signals in [("IN", signals_in), ("OUT", signals_out), ("EN", signals_en)]:
                            outfile.write(f"@c00022\n")
                            outfile.write(f"#{{{signal_name}_{use}[{bits-1}:0]}} {' '.join(signals)}\n")
                            outfile.write(f"@28\n")
                            for signal in signals:
                                outfile.write(f"{signal}\n")
                            outfile.write(f"@1401200\n")
                            outfile.write(f"-group_end\n")
                        outfile.write(f"@200\n")
                        outfile.write(f"-\n")
                    

    def find_signal(self, dut, tile_x, tile_y, bel, use):
        "Find a signal handle using cocotb"
        for element in dut:
            if match := re.match(r"Tile_X(?P<tilex>\d+)Y(?P<tiley>\d+)_(?P<bel>\w)_(?P<use>\w+)_top", element._name):
                match_x = match.group("tilex")
                match_y = match.group("tiley")
                match_bel = match.group("bel")
                match_use = match.group("use") # "OUT", "IN", "EN"
                
                if tile_x == match_x and tile_y == match_y and use == match_use and bel == match_bel:
                    #print(f"Found! {match.group(0)}")
                    return element
        return None

    def get(self, signal, index=None):
        "Get the value of a signal"
        #print(f"get {signal} {index}")
    
        # Get the full signal
        if index is None:
            return LogicArray("".join(str(bit["IN"].value) for bit in reversed(self.signals[signal].values())))
        # Get a single bit
        else:
            return Logic(self.signals[signal][index]["IN"].value)
    
    def set(self, signal, value, index=None):
        "Set the value of a signal"
        #print(f"set {signal} {value} {index}")
        
        # Get the full signal
        if index is None:
            for index, bit in enumerate(reversed(value)):
                self.signals[signal][index]["OUT"].value = bit
        else:
            self.signals[signal][index]["OUT"].value = value

    def get_raw(self, signal, use, index=0):
        "Get the raw cocotb signal. Can be used for triggers."
        return self.signals[signal][index][use]

// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

`timescale 1 ns / 1 ps
`default_nettype none

reg [1023:0] firmware_file;
module FMD_QNC_greyhound_ihp_dbg_tb;

    initial begin
        `ifdef DUMP_WAVEFORMS
            $dumpfile("FMD_QNC_greyhound_ihp_dbg_tb.fst");
            $dumpvars(0, FMD_QNC_greyhound_ihp_dbg_tb);
        `endif
    end

    // Pads
    wire          io_clock_PAD;
    wire          io_reset_PAD;

    wire          io_flash_clk_PAD;
    wire          io_flash_cs_n_PAD;
    wire [3:0]    io_flash_io_PAD;

    wire          io_psram_clk_PAD;
    wire          io_psram_cs_n_PAD;
    wire [3:0]    io_psram_io_PAD;

    wire          io_ser_rx_PAD;
    wire          io_ser_tx_PAD;
    
    wire          io_fpga_sclk_PAD;
    wire          io_fpga_cs_n_PAD;
    wire          io_fpga_mosi_PAD;
    wire          io_fpga_miso_PAD;
    
    wire          io_fpga_mode_PAD;
    wire          io_fetch_enable_PAD;
    wire          io_config_busy_PAD;
    wire          io_core_sleep_PAD;

    wire [31:0]   io_gpio_PAD;

    // QSPI Flash - Firmware
    spiflash i_spiflash (
	    .csb (io_flash_cs_n_PAD),
	    .clk (io_flash_clk_PAD),
	    .io0 (io_flash_io_PAD[0]), // MOSI
	    .io1 (io_flash_io_PAD[1]), // MISO
	    .io2 (io_flash_io_PAD[2]),
	    .io3 (io_flash_io_PAD[3])
    );
    
    // greyhound instance
    FMD_QNC_greyhound_ihp FMD_QNC_greyhound_ihp (
        .io_clock_PAD,
        .io_reset_PAD,

        .io_flash_clk_PAD,
        .io_flash_cs_n_PAD,
        .io_flash_io_PAD,

        .io_psram_clk_PAD,
        .io_psram_cs_n_PAD,
        .io_psram_io_PAD,

        .io_ser_rx_PAD,
        .io_ser_tx_PAD,
        
        .io_fpga_sclk_PAD,
        .io_fpga_cs_n_PAD,
        .io_fpga_mosi_PAD,
        .io_fpga_miso_PAD,
        
        .io_fpga_mode_PAD,
        .io_fetch_enable_PAD,
        .io_config_busy_PAD,
        .io_core_sleep_PAD,

        .io_gpio_PAD
    );

    // JTAG OpenOCD simulation shim
    wire reset_SimJTAG;

    SimJTAG #(
        .TICK_DELAY (1),
        .PORT(9999)
    ) i_sim_jtag (
        .clock                ( io_clock_PAD         ),
        .reset                ( ~reset_SimJTAG       ),
        .enable               ( 1'b1                 ),
        .init_done            ( reset_SimJTAG        ),
        .jtag_TCK             ( io_fpga_sclk_PAD     ),
        .jtag_TMS             ( io_fpga_cs_n_PAD     ),
        .jtag_TDI             ( io_fpga_mosi_PAD     ),
        .jtag_TRSTn           ( io_fpga_mode_PAD     ),
        .jtag_TDO_data        ( io_fpga_miso_PAD     ),
        .jtag_TDO_driven      ( 1'b1                 ),
        .exit                 (  )
    );

endmodule

module clk_buf(input A, output X);
assign X = A;
endmodule

module break_comb_loop(input A, output X);
assign #0.1 X = A;
endmodule

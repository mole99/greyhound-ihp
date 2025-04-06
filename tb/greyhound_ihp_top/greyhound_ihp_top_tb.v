// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1 ns / 1 ps
`default_nettype none

reg [1023:0] firmware_file;
module greyhound_ihp_top_tb;

    initial begin
        `ifdef DUMP_WAVEFORMS
            $dumpfile("greyhound_ihp_top_tb.fst");
            $dumpvars(0, greyhound_ihp_top_tb);
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
    
    `ifdef BITSTREAM_FLASH
    
    // SPI Flash - Bitstream
    spiflash_powered i_spiflash_powered (
	    .csb (io_fpga_cs_n_PAD),
	    .clk (io_fpga_sclk_PAD),
	    .io0 (io_fpga_mosi_PAD), // MOSI
	    .io1 (io_fpga_miso_PAD), // MISO
	    .io2 (  ),
	    .io3 (  )
    );
    
    // Pull down z to 0
    //assign (pull1, pull0) io_fpga_miso_PAD = 1'b0;
    
    `else

    assign io_fpga_cs_n_PAD = 1'b1;
    assign io_fpga_sclk_PAD = 1'b0;
    assign io_fpga_mosi_PAD = 1'b0;

    `endif

    // greyhound instance
    greyhound_ihp_top greyhound_ihp_top (
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

endmodule

module clk_buf(input A, output X);
assign X = A;
endmodule

module break_comb_loop(input A, output X);
assign #0.1 X = A;
endmodule

module bondpad_70x70 (input pad);
endmodule

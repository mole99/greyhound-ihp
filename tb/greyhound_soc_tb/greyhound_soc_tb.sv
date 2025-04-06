// SPDX-FileCopyrightText: © 2024 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module greyhound_soc_tb;

    initial begin
        $dumpfile("greyhound_soc_tb.fst");
        $dumpvars(0, greyhound_soc_tb);
    end

    // Top level signals
    
    // Clock and reset
    logic clk_i;
    logic rst_ni;

    // Basic interrupt architecture
    logic [31:0] irq_i;

    // Debug interface
    logic        debug_req_i;
    logic        debug_havereset_o;
    logic        debug_running_o;
    logic        debug_halted_o;
    logic        debug_pc_valid_o;
    logic [31:0] debug_pc_o;

    // CPU control signals
    logic fetch_enable_i;
    logic core_sleep_o;

    `ifdef USE_POWER_PINS
    logic VDPWR;
    logic VGND;
    `endif

    // QSPI - Flash
    logic            flash_sck;
    logic            flash_ce_n;
    logic [3:0]      flash_din;
    logic [3:0]      flash_dout;
    logic [3:0]      flash_douten;

    wire [3:0] flash_io;
    
    assign flash_din = flash_io;
    
    assign flash_io[0] = flash_douten[0] ? flash_dout[0] : 1'bz;
    assign flash_io[1] = flash_douten[1] ? flash_dout[1] : 1'bz;
    assign flash_io[2] = flash_douten[2] ? flash_dout[2] : 1'bz;
    assign flash_io[3] = flash_douten[3] ? flash_dout[3] : 1'bz;

    // QSPI - PSRAM
    logic            psram_sck;
    logic            psram_ce_n;
    logic [3:0]      psram_din;
    logic [3:0]      psram_dout;
    logic [3:0]      psram_douten;

    assign psram_din = 4'b0;
    
    // UART0
    logic uart0_rx;
    logic uart0_tx;
    
    // SRAM
    localparam SramBankAddrWidth = 11;
    logic [31:0]     bank_rdata_i;
    wire [SramBankAddrWidth-1:0]     bank_word_addr_o;
    wire [3:0]      bank_be_o;
    wire [31:0]     bank_wdata_o;
    wire            bank_req_o;
    wire            bank_we_o;

    greyhound_soc i_greyhound_soc
    (
        `ifdef USE_POWER_PINS
        .VDPWR,
        .VGND,
        `endif

        // Clock and reset
        .clk_i,
        .rst_ni,

        // Interrupt requests from fabric
        .fabric_irq_i       ( 4'b0 ),
        
        // Custom instruction interface to fabric
        .fabric_rs1_o       (),
        .fabric_rs2_o       (),
        .fabric_result_i    (32'hDEADBEEF),
        
        // SRAM
        .bank_rdata_i,
        .bank_word_addr_o,
        .bank_be_o,
        .bank_wdata_o,
        .bank_req_o,
        .bank_we_o,

        // QSPI - Flash
        .flash_sck,
        .flash_ce_n,
        .flash_din,
        .flash_dout,
        .flash_douten,

        // QSPI - PSRAM
        .psram_sck,
        .psram_ce_n,
        .psram_din,
        .psram_dout,
        .psram_douten,
        
        // UART0
        .uart0_rx,
        .uart0_tx,

        // CPU control signals
        .fetch_enable_i,
        .core_sleep_o
    );
    
    // 8kByte memory
    logic [31:0] sram [2**SramBankAddrWidth];
    
    always @(posedge clk_i) begin
        if (bank_req_o) begin
            if (bank_we_o) begin
                if (bank_be_o[0]) sram[bank_word_addr_o][ 7: 0] <= bank_wdata_o[7 : 0];
                if (bank_be_o[1]) sram[bank_word_addr_o][15: 8] <= bank_wdata_o[15: 8];
                if (bank_be_o[2]) sram[bank_word_addr_o][23:16] <= bank_wdata_o[23:16];
                if (bank_be_o[3]) sram[bank_word_addr_o][31:24] <= bank_wdata_o[31:24];
            end else begin
                bank_rdata_i <= sram[bank_word_addr_o];
            end
        end
    end

    // QSPI Flash
    spiflash i_spiflash (
	    .csb (flash_ce_n),
	    .clk (flash_sck),
	    .io0 (flash_io[0]), // MOSI
	    .io1 (flash_io[1]), // MISO
	    .io2 (flash_io[2]),
	    .io3 (flash_io[3])
    );

endmodule

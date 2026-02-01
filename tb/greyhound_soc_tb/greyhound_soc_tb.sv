// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

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

    // Our custom instruction interface    
    logic        issue_ready_o;
    logic        issue_accept_o;
    logic        issue_valid_i;
    logic [31:0] issue_instr_i;
    logic [31:0] issue_op0_i;
    logic [31:0] issue_op1_i;
    logic [ 3:0] issue_id_i;
    
    logic        result_valid_o;
    logic [ 3:0] result_id_o;
    logic [ 4:0] result_rd_o;
    logic [31:0] result_o;

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
        
        // Fabric config is currently
        // configuring the fabric
        .fabric_config_busy_i   (1'b0),
        
        // Fabric has been configured
        .fabric_configured_i   (1'b1),
        
        // Fabric bitstream data
        .bitstream_valid_o  (),
        .bitstream_data_o   (),
        
        // Trigger fabric reconfiguration
        .warmboot_boot_o    (),
        .warmboot_slot_o    (),

        // Custom instruction interface to fabric
        .fabric_issue_ready_i   (issue_ready_o),
        .fabric_issue_accept_i  (issue_accept_o),
        .fabric_issue_valid_o   (issue_valid_i),
        .fabric_issue_instr_o   (issue_instr_i),
        .fabric_issue_op0_o     (issue_op0_i),
        .fabric_issue_op1_o     (issue_op1_i),
        .fabric_issue_id_o      (issue_id_i),
            
        .fabric_result_valid_i  (result_valid_o),
        .fabric_result_id_i     (result_id_o),
        .fabric_result_rd_i     (result_rd_o),
        .fabric_result_i        (result_o),

        // Bus interface to fabric
        .fabric_gnt_i           (1'b0),
        .fabric_req_o           (),
        .fabric_rvalid_i        (1'b0),
        .fabric_we_o            (),
        .fabric_be_o            (),
        .fabric_addr_o          (),
        .fabric_wdata_o         (),
        .fabric_rdata_i         (32'hDEADBEEF),
        
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
        .core_sleep_o,

        // JTAG TODO
        .jtag_tck_i     (  ),
        .jtag_tdi_i     (  ),
        .jtag_tdo_o     (  ),
        .jtag_tms_i     (  ),
        .jtag_trst_ni   ( rst_ni )
    );

    // R-type instruction decoding
    logic [6:0] opcode;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode   = issue_instr_i[6:0];
    assign rs1      = issue_instr_i[19:15];
    assign rs2      = issue_instr_i[24:20];
    assign rd       = issue_instr_i[11:7];
    assign funct3   = issue_instr_i[14:12];
    assign funct7   = issue_instr_i[31:25];

    // 0x0B, 0x2B, 0x5B and 0x7B
    // are free for custom use
    localparam OPCODE_XIF = 7'h5B;

    // Use GCC .insn pseudo directive:
    // R type: .insn r opcode7, func3, func7, rd, rs1, rs2

    assign issue_accept_o = opcode == OPCODE_XIF && issue_valid_i;
    
    assign issue_ready_o = 1'b1;
    
    logic [31:0] op0_d;
    logic [31:0] op1_d;
    logic [3:0]  id_d;
    logic [3:0]  rd_d;
    logic issue_valid_d;
    
    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
            issue_valid_d   <= 1'b0;
            result_valid_o  <= 1'b0;
        end else begin
            issue_valid_d <= issue_valid_i;
        
            if (issue_valid_i) begin
                op0_d <= issue_op0_i;
                op1_d <= issue_op1_i;
                id_d  <= issue_id_i;
                rd_d  <= rd;  
            end
            
            result_valid_o <= 1'b0;
            if (issue_valid_d) begin
                result_valid_o  <= 1'b1;
                result_id_o     <= id_d;
                result_rd_o     <= rd_d;
                result_o        <= 32'hDEADBEEF;  
            end
        end
    end
    
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

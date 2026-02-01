// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

`default_nettype none

module greyhound_ihp (
`ifdef USE_POWER_PINS
    inout VPWR,    // Common digital supply
    inout VGND,    // Common digital ground
`endif
    input  logic          clk_i,
    input  logic          rst_ni,
    
    // Fabric I/O
    input  logic [31:0] fabric_gpio_i,
    output logic [31:0] fabric_gpio_o,
    output logic [31:0] fabric_gpio_oe_o,
    
    // FPGA config
    input  logic fpga_sclk_i,
    output logic fpga_sclk_o,
    output logic fpga_sclk_oe_o,
    
    input  logic fpga_cs_n_i,
    output logic fpga_cs_n_o,
    output logic fpga_cs_n_oe_o,
    
    input  logic fpga_mosi_i,
    output logic fpga_mosi_o,
    output logic fpga_mosi_oe_o,
    
    input  logic fpga_miso_i,
    output logic fpga_miso_o,
    output logic fpga_miso_oe_o,
    
    // FPGA config mode
    // if mode == 0: SPI controller
    // if mode == 1: SPI receiver
    input  logic fpga_mode_i,
    output logic config_busy_o,
    
    // SoC
    output logic flash_clk_o,
    output logic flash_cs_no,
    input  logic [3:0] flash_io_i,
    output logic [3:0] flash_io_o,
    output logic [3:0] flash_io_oe_no,
    
    output logic psram_clk_o,
    output logic psram_cs_no,
    input  logic [3:0] psram_io_i,
    output logic [3:0] psram_io_o,
    output logic [3:0] psram_io_oe_no,

    input  logic ser_rx_i,
    output logic ser_tx_o,
    
    input  logic fetch_enable_i,
    output logic core_sleep_o
);
    
    // Fabric parameters
    parameter FrameBitsPerRow = 32;
    parameter MaxFramesPerCol = 20;

    parameter NumColumns = 12;
    parameter NumRows = 18;

    parameter FABRIC_NUM_IO_WEST = 32;
    
    // Fabric config is currently
    // configuring the fabric
    wire            fabric_config_busy;
    
    // Fabric is configured
    wire            fabric_config_configured;
    
    // Fabric SPI controller is busy
    logic fabric_spi_controller_busy;
    
    // Bitstream
    wire            bitstream_valid_cpu;
    wire [31:0]     bitstream_data_cpu;
    
    // To the fabric
    wire [(FrameBitsPerRow*NumRows)-1:0]    FrameData;
    wire [(MaxFramesPerCol*NumColumns)-1:0] FrameStrobe;

    // Reset with asynchronous assertion and synchronous relase
    logic [1:0] rst_nd;
    logic rst_n_sync;
    
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            rst_nd <= '0;
        end else begin
            rst_nd[0] <= 1'b1;
            rst_nd[1] <= rst_nd[0];
        end
    end
    
    assign rst_n_sync = rst_nd[1];

    // Sync fpga_mode_i
    logic [1:0] fpga_mode_d;
    logic fpga_mode_sync;
    always_ff @(posedge clk_i) begin
        fpga_mode_d <= {fpga_mode_d[0], fpga_mode_i};
    end
    assign fpga_mode_sync = fpga_mode_d[1];
    
    // Config busy
    assign config_busy_o = fabric_config_busy;
    
    logic [31:0] spi_bitstream_data, spi_controller_bitstream_data_o, spi_receiver_bitstream_data_o;
    logic        spi_bitstream_valid, spi_controller_bitstream_valid_o, spi_receiver_bitstream_valid_o;
    
    // JTAG receiver
    logic [31:0] jtag_bitstream_data;
    logic        jtag_bitstream_valid;

    // JTAG boundary scan
    logic jtag_dm_clear, jtag_tck_n;
    logic jtag_mode2, jtag_mode5, jtag_mode6;
    logic jtag_boundary_scan_tdi, jtag_boundary_scan_tdo;
    logic jtag_capture_bsr_select, jtag_shift_bsr_select, jtag_update_bsr_select, jtag_shift_dr;
    logic jtag_tck, jtag_tdi, jtag_tdo, jtag_tms;

    // SPI receiver
    logic spi_receiver_sclk_i;
    logic spi_receiver_cs_ni;
    logic spi_receiver_mosi_i;
    logic spi_receiver_miso_o;
    
    // SPI controller
    logic spi_controller_sclk_o;
    logic spi_controller_cs_no;
    logic spi_controller_mosi_o;
    logic spi_controller_miso_i;
    
    logic spi_controller_start_i;
    logic [3:0] spi_controller_slot_i;
    
    // I/Os West
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_in_i;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_out_o;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_oe_o;

    // Assign fabric IOs
    // TODO change fabric clk to tclk when running INTEST
    // TODO test if working
    // TODO glitch free rst, rstgen.v?
    wire boundary_scan_td [FABRIC_NUM_IO_WEST-2:0];
    generate
        for (genvar i = 0; i<FABRIC_NUM_IO_WEST; i++) begin
            if (i==0) begin
                fpga_boundary_cell fpga_boundary_cell (
                    .tclk_i  ( jtag_tck       ),
                    .tclk_ni ( jtag_tck_n     ),
                    .trst_ni ( ~jtag_dm_clear ),
                    // Gated clk signals
                    .capture_bsr_select_i ( jtag_capture_bsr_select ),
                    .shift_bsr_select_i   ( jtag_shift_bsr_select   ),
                    .update_bsr_select_i  ( jtag_update_bsr_select  ),
                    .shift_dr_i           ( jtag_shift_dr           ),
                    // System logic connection
                    .output_enable_i ( fabric_io_west_oe_o[i]  ),
                    .output_data_i   ( fabric_io_west_out_o[i] ),
                    .input_data_o    ( fabric_io_west_in_i[i]  ),
                    // Mode configuration
                    .mode2_i ( jtag_mode2 ),
                    .mode5_i ( jtag_mode5 ),
                    .mode6_i ( jtag_mode6 ),
                    // Daisy chain connection
                    .td_i ( jtag_boundary_scan_tdo ),
                    .td_o ( boundary_scan_td[i]    ),
                    // System pin connection
                    .pin_i        ( fabric_gpio_i[i]    ),
                    .pin_o        ( fabric_gpio_o[i]    ),
                    .enable_pin_o ( fabric_gpio_oe_o[i] )
                );
            end
            else if (i==(FABRIC_NUM_IO_WEST-1)) begin
                fpga_boundary_cell fpga_boundary_cell (
                    .tclk_i  ( jtag_tck       ),
                    .tclk_ni ( jtag_tck_n     ),
                    .trst_ni ( ~jtag_dm_clear ),
                    // Gated clk signals
                    .capture_bsr_select_i ( jtag_capture_bsr_select ),
                    .shift_bsr_select_i   ( jtag_shift_bsr_select   ),
                    .update_bsr_select_i  ( jtag_update_bsr_select  ),
                    .shift_dr_i           ( jtag_shift_dr           ),
                    // System logic connection
                    .output_enable_i ( fabric_io_west_oe_o[i]  ),
                    .output_data_i   ( fabric_io_west_out_o[i] ),
                    .input_data_o    ( fabric_io_west_in_i[i]  ),
                    // Mode configuration
                    .mode2_i ( jtag_mode2 ),
                    .mode5_i ( jtag_mode5 ),
                    .mode6_i ( jtag_mode6 ),
                    // Daisy chain connection
                    .td_i ( boundary_scan_td[i-1]  ),
                    .td_o ( jtag_boundary_scan_tdi ),
                    // System pin connection
                    .pin_i        ( fabric_gpio_i[i]    ),
                    .pin_o        ( fabric_gpio_o[i]    ),
                    .enable_pin_o ( fabric_gpio_oe_o[i] )
                );
            end
            else begin
                fpga_boundary_cell fpga_boundary_cell (
                    .tclk_i  ( jtag_tck       ),
                    .tclk_ni ( jtag_tck_n     ),
                    .trst_ni ( ~jtag_dm_clear ),
                    // Gated clk signals
                    .capture_bsr_select_i ( jtag_capture_bsr_select ),
                    .shift_bsr_select_i   ( jtag_shift_bsr_select   ),
                    .update_bsr_select_i  ( jtag_update_bsr_select  ),
                    .shift_dr_i           ( jtag_shift_dr           ),
                    // System logic connection
                    .output_enable_i ( fabric_io_west_oe_o[i]  ),
                    .output_data_i   ( fabric_io_west_out_o[i] ),
                    .input_data_o    ( fabric_io_west_in_i[i]  ),
                    // Mode configuration
                    .mode2_i ( jtag_mode2 ),
                    .mode5_i ( jtag_mode5 ),
                    .mode6_i ( jtag_mode6 ),
                    // Daisy chain connection
                    .td_i ( boundary_scan_td[i-1] ),
                    .td_o ( boundary_scan_td[i]   ),
                    // System pin connection
                    .pin_i        ( fabric_gpio_i[i]    ),
                    .pin_o        ( fabric_gpio_o[i]    ),
                    .enable_pin_o ( fabric_gpio_oe_o[i] )
                );
            end
        end
    endgenerate

    // WARMBOOT
    wire        fabric_warmboot_boot_o;
    wire  [3:0] fabric_warmboot_slot_o;
    wire        fabric_warmboot_reset_i;

    // CPU_IRQ
    wire  [3:0] fabric_irq_o;
    
    // Custom instruction interface to fabric
    logic        fabric_issue_ready;
    logic        fabric_issue_accept;
    logic        fabric_issue_valid;
    logic [31:0] fabric_issue_instr;
    logic [31:0] fabric_issue_op0;
    logic [31:0] fabric_issue_op1;
    logic [3 :0] fabric_issue_id;
    
    logic        fabric_result_valid;
    logic [3 :0] fabric_result_id;
    logic [4 :0] fabric_result_rd;
    logic [31:0] fabric_result;
    
    // Bus interface to fabric
    wire            fabric_gnt;
    wire            fabric_req;
    wire            fabric_rvalid;
    wire            fabric_we;
    wire [ 3:0]     fabric_be;
    wire [23:0]     fabric_addr;
    wire [31:0]     fabric_wdata;
    wire [31:0]     fabric_rdata;
    
    // CPU trigger reconfiguration
    wire            cpu_warmboot_boot_o;
    wire [3:0]      cpu_warmboot_slot_o;
    
    // At startup, trigger configuration
    // when fpga_mode_sync == 1'b0
    logic startup_trigger;
    always_ff @(posedge clk_i, negedge rst_n_sync) begin
        if (!rst_n_sync) begin
            startup_trigger <= 1'b1;
        end else begin
            startup_trigger <= 1'b0;
        end
    end
    
    // Due to lack of pins fpga_mode_i is double used
    // Rename for clarity
    logic jtag_trst_n_sync, en_jtag_receiver, jtag_trst_n_module;
    assign jtag_trst_n_sync = fpga_mode_sync;
 
    always_comb begin
        jtag_trst_n_module = 1'b1;

        if (en_jtag_receiver | (!jtag_trst_n_sync & !rst_n_sync)) begin
            jtag_trst_n_module = jtag_trst_n_sync;
        end
    end

    always_comb begin
        jtag_tck         = 1'b0;
        jtag_tms         = 1'b0;
        jtag_tdi         = 1'b0;
        fpga_miso_o      = 1'b0;

        // On reset, set SPI to tri-state
        if (!rst_n_sync) begin
            // Default output
            fpga_sclk_o = 1'b0;
            fpga_cs_n_o = 1'b0;
            fpga_mosi_o = 1'b0;
            fpga_miso_o = 1'b0;
        
            // Tri-state
            fpga_sclk_oe_o = 1'b0;
            fpga_cs_n_oe_o = 1'b0;
            fpga_mosi_oe_o = 1'b0;
            fpga_miso_oe_o = 1'b0;
            
            // Receiver not selected
            spi_receiver_sclk_i = 1'b0;
            spi_receiver_cs_ni  = 1'b1;
            spi_receiver_mosi_i = 1'b0;
            
            // Controller not selected
            spi_controller_miso_i = 1'b0;
            
            // No bitstream
            spi_bitstream_data  = '0;
            spi_bitstream_valid = '0;
            
            // Slot and trigger
            spi_controller_slot_i   = '0;
            spi_controller_start_i  = '0;

            if (jtag_trst_n_sync) begin
                // srst pulled, trst not -> do special init (configure for jtag input instead of spi)
                // Run init sequence through jtag interface
                jtag_tck = fpga_sclk_i;
                jtag_tms = fpga_cs_n_i;
                jtag_tdi = fpga_mosi_i;
                // TODO test if one can disable this output until fully configured
                // Enable tdo output in this case
                fpga_miso_oe_o = 1'b1;
                fpga_miso_o = jtag_tdo;
            end
        end else begin
            // Default output
            fpga_sclk_o = 1'b0;
            fpga_cs_n_o = 1'b0;
            fpga_mosi_o = 1'b0;
            fpga_miso_o = 1'b0;
            
            // Receiver not selected
            spi_receiver_sclk_i = 1'b0;
            spi_receiver_cs_ni  = 1'b1;
            spi_receiver_mosi_i = 1'b0;
            
            // Controller not selected
            spi_controller_miso_i = 1'b0;

            if (fpga_mode_sync == 1'b0) begin
                // SPI Controller
                fpga_sclk_oe_o = 1'b1;
                fpga_cs_n_oe_o = 1'b1;
                fpga_mosi_oe_o = 1'b1;
                fpga_miso_oe_o = 1'b0;
                
                fpga_sclk_o = spi_controller_sclk_o;
                fpga_cs_n_o = spi_controller_cs_no;
                fpga_mosi_o = spi_controller_mosi_o;
                spi_controller_miso_i = fpga_miso_i;
                
                // Re-route bitstream
                spi_bitstream_data  = spi_controller_bitstream_data_o;
                spi_bitstream_valid = spi_controller_bitstream_valid_o;
                
                // Slot and trigger
                spi_controller_start_i  = startup_trigger || ((fabric_warmboot_boot_o || cpu_warmboot_boot_o) && !(fabric_config_busy || fabric_spi_controller_busy));
                spi_controller_slot_i   = startup_trigger ? '0 : cpu_warmboot_boot_o ? cpu_warmboot_slot_o : fabric_warmboot_slot_o;
                
            end else begin
                // SPI receiver
                fpga_sclk_oe_o = 1'b0;
                fpga_cs_n_oe_o = 1'b0;
                fpga_mosi_oe_o = 1'b0;
                fpga_miso_oe_o = 1'b1;
                
                spi_receiver_sclk_i = fpga_sclk_i;
                spi_receiver_cs_ni  = fpga_cs_n_i;
                spi_receiver_mosi_i = fpga_mosi_i;
                fpga_miso_o = spi_receiver_miso_o;
                
                // Re-route bitstream
                spi_bitstream_data  = spi_receiver_bitstream_data_o;
                spi_bitstream_valid = spi_receiver_bitstream_valid_o;
                
                // Slot and trigger
                spi_controller_start_i  = '0;
                spi_controller_slot_i   = '0;
            end
        end

        if (en_jtag_receiver) begin
            // JTAG receiver is enabled
            fpga_sclk_oe_o = 1'b0;
            fpga_cs_n_oe_o = 1'b0;
            fpga_mosi_oe_o = 1'b0;
            fpga_miso_oe_o = 1'b1;

            // Receiver not selected
            spi_receiver_sclk_i = 1'b0;
            spi_receiver_cs_ni  = 1'b1;
            spi_receiver_mosi_i = 1'b0;
            
            // Controller not selected
            spi_controller_miso_i = 1'b0;

            // JTAG receiver
            jtag_tck = fpga_sclk_i;
            jtag_tms  = fpga_cs_n_i;
            jtag_tdi = fpga_mosi_i;
            fpga_miso_o = jtag_tdo;

            // No spi bitstream
            spi_bitstream_data  = '0;
            spi_bitstream_valid = '0;
            
            // Slot and trigger
            spi_controller_slot_i   = '0;
            spi_controller_start_i  = '0;
        end
    end
    
    fabric_spi_receiver fabric_spi_receiver (
        .clk_i  (clk_i),
        .rst_ni (rst_n_sync),
        
        // Bitstream data
        .bitstream_data_o   (spi_receiver_bitstream_data_o),
        .bitstream_valid_o  (spi_receiver_bitstream_valid_o),
        
        // Enable the SPI receiver
        .enable_i   (fpga_mode_sync == 1'b1),
        
        // SPI
        .sclk_i     (spi_receiver_sclk_i),
        .cs_ni      (spi_receiver_cs_ni),
        .mosi_i     (spi_receiver_mosi_i),
        .miso_o     (spi_receiver_miso_o)
    );

    // TODO allow tap isc case change when loading rom over spi
    logic fpga_jtag_tdi, clk_fabric;
    fpga_dm fpga_dm (
        .clk_i                  ( clk_i                   ),
        .rst_ni                 ( rst_ni                  ),
        .clk_fabric_o           ( clk_fabric              ),
        .tck_i                  ( jtag_tck                ),
        .tms_i                  ( jtag_tms                ),
        .trst_ni                ( jtag_trst_n_module      ),
        .td_i                   ( fpga_jtag_tdi           ),
        .td_o                   ( jtag_tdo                ),
        .tdo_oe_o               (  ),
        .en_jtag_receiver_o     ( en_jtag_receiver        ),
        .jtag_bitstream_o       ( jtag_bitstream_data     ),
        .jtag_bitstream_valid_o ( jtag_bitstream_valid    ),
        .dm_clear_o             ( jtag_dm_clear           ),
        .shift_dr_o             ( jtag_shift_dr           ),
        .tck_no                 ( jtag_tck_n              ),
        .mode2_o                ( jtag_mode2              ),
        .mode5_o                ( jtag_mode5              ),
        .mode6_o                ( jtag_mode6              ),
        .boundary_scan_o        ( jtag_boundary_scan_tdo  ),
        .boundary_scan_i        ( jtag_boundary_scan_tdi  ),
        .capture_bsr_select_o   ( jtag_capture_bsr_select ),
        .shift_bsr_select_o     ( jtag_shift_bsr_select   ),
        .update_bsr_select_o    ( jtag_update_bsr_select  )
    );

    // TODO adjust BITSTREAM_LENGTH_WORDS
    fabric_spi_controller #(
        .BITSTREAM_LENGTH_WORDS (32'h11D6),
        .SLOT_OFFSET_WORDS      (32'h2000),
        .NUM_SLOTS              (16)
    ) fabric_spi_controller (
        .clk_i  (clk_i),
        .rst_ni (rst_n_sync),
        
        // Start reading data at selected slot
        .start_i    (spi_controller_start_i),
        .slot_i     (spi_controller_slot_i),
        
        // Bitstream data
        .bitstream_data_o    (spi_controller_bitstream_data_o),
        .bitstream_valid_o   (spi_controller_bitstream_valid_o),
        
        // Reading in progress
        .busy_o     (fabric_spi_controller_busy),
        
        // SPI
        .sclk_o     (spi_controller_sclk_o),
        .cs_no      (spi_controller_cs_no),
        .mosi_o     (spi_controller_mosi_o),
        .miso_i     (spi_controller_miso_i)
    );
    
    // Mux bitstreams: SPI (controller/receiver) <-> CPU
    
    logic [31:0] bitstream_data;
    logic        bitstream_valid;
    
    always_comb begin
        if (spi_bitstream_valid) begin
            bitstream_data = spi_bitstream_data;
        end else if (jtag_bitstream_valid) begin
            bitstream_data = jtag_bitstream_data;
        end else begin
            bitstream_data = bitstream_data_cpu;
        end
    end
    
    assign bitstream_valid = bitstream_valid_cpu || spi_bitstream_valid || jtag_bitstream_valid;

    fabric_config #(
        	.FrameBitsPerRow    (FrameBitsPerRow),
	    .MaxFramesPerCol    (MaxFramesPerCol),
	    
	    .NumColumns         (NumColumns),
	    .NumRows            (NumRows)
    ) fabric_config (
        .clk_i              (clk_i),
        .rst_ni             (rst_n_sync),
        
        // Bitstream
        .bitstream_valid_i  (bitstream_valid),
        .bitstream_data_i   (bitstream_data),
        
        // Configuration in progress
        .busy_o             (fabric_config_busy),
        
        // Fabric is configured
        .configured_o       (fabric_config_configured),
        
        // To the fabric
        .FrameData_o        (FrameData),
        .FrameStrobe_o      (FrameStrobe)
    );

    assign fabric_warmboot_reset_i = fabric_config_busy;

    (* keep *) fabric_wrapper fabric_wrapper (
        .clk_i          (clk_fabric),
        
        // Configuration
        .FrameData_i    (FrameData),
        .FrameStrobe_i  (FrameStrobe),
        
        // Fabric is configured
        .configured_i   (fabric_config_configured),
        
        // I/Os West
        .fabric_io_west_in_i,
        .fabric_io_west_out_o,
        .fabric_io_west_oe_o,

        // WARMBOOT
        .fabric_warmboot_boot_o,
        .fabric_warmboot_slot_o,
        .fabric_warmboot_reset_i,

        // CPU_IRQ
        .fabric_irq_o,
        
        // CUSTOM_INSTRUCTION
        .fabric_issue_ready_o   (fabric_issue_ready),
        .fabric_issue_accept_o  (fabric_issue_accept),
        .fabric_issue_valid_i   (fabric_issue_valid),
        .fabric_issue_instr_i   (fabric_issue_instr),
        .fabric_issue_op0_i     (fabric_issue_op0),
        .fabric_issue_op1_i     (fabric_issue_op1),
        .fabric_issue_id_i      (fabric_issue_id),
            
        .fabric_result_valid_o  (fabric_result_valid),
        .fabric_result_id_o     (fabric_result_id),
        .fabric_result_rd_o     (fabric_result_rd),
        .fabric_result_o        (fabric_result),
        
        // OBI_PERIPHERAL
        .fabric_obi_req_i       (fabric_req),
        .fabric_obi_we_i        (fabric_we),
        .fabric_obi_be_i        (fabric_be),
        .fabric_obi_addr_i      (fabric_addr),
        .fabric_obi_wdata_i     (fabric_wdata),
        .fabric_obi_gnt_o       (fabric_gnt),
        .fabric_obi_rvalid_o    (fabric_rvalid),
        .fabric_obi_rdata_o     (fabric_rdata)
    );

    // SoC
    
    // Invert oe polarity
    wire [3:0] flash_io_oe, psram_io_oe;

    assign flash_io_oe_no = ~flash_io_oe;
    assign psram_io_oe_no = ~psram_io_oe;
    
    // SRAM
    logic [31:0]     bank_rdata;
    logic [10:0]     bank_word_addr;
    logic [3:0]      bank_be;
    logic [31:0]     bank_wdata;
    logic            bank_req;
    logic            bank_we;
    
    // Sync fetch_enable_i
    logic [1:0] fetch_enable_d;
    logic fetch_enable_sync;
    always_ff @(posedge clk_i) begin
        fetch_enable_d <= {fetch_enable_d[0], fetch_enable_i};
    end
    assign fetch_enable_sync = fetch_enable_d[1];

    greyhound_soc i_greyhound_soc
    (
        `ifdef USE_POWER_PINS
        .VPWR   (VPWR),
        .VGND   (VGND),
        `endif

        // Clock and reset
        .clk_i          ( clk_i  ),
        .rst_ni         ( rst_n_sync ),

        // Interrupt requests from fabric
        .fabric_irq_i   ( fabric_irq_o ),
        
        // Fabric config is currently
        // configuring the fabric
        .fabric_config_busy_i   (fabric_config_busy || fabric_spi_controller_busy),
        
        // Fabric has been configured
        .fabric_configured_i   (fabric_config_configured),
        
        // Fabric bitstream data
        .bitstream_valid_o  (bitstream_valid_cpu),
        .bitstream_data_o   (bitstream_data_cpu),
        
        // Trigger fabric reconfiguration
        .warmboot_boot_o    (cpu_warmboot_boot_o),
        .warmboot_slot_o    (cpu_warmboot_slot_o),
        
        // Custom instruction interface to fabric
        .fabric_issue_ready_i   (fabric_issue_ready),
        .fabric_issue_accept_i  (fabric_issue_accept),
        .fabric_issue_valid_o   (fabric_issue_valid),
        .fabric_issue_instr_o   (fabric_issue_instr),
        .fabric_issue_op0_o     (fabric_issue_op0),
        .fabric_issue_op1_o     (fabric_issue_op1),
        .fabric_issue_id_o      (fabric_issue_id),
            
        .fabric_result_valid_i  (fabric_result_valid),
        .fabric_result_id_i     (fabric_result_id),
        .fabric_result_rd_i     (fabric_result_rd),
        .fabric_result_i        (fabric_result),

        // Bus interface to fabric
        .fabric_gnt_i           (fabric_gnt),
        .fabric_req_o           (fabric_req),
        .fabric_rvalid_i        (fabric_rvalid),
        .fabric_we_o            (fabric_we),
        .fabric_be_o            (fabric_be),
        .fabric_addr_o          (fabric_addr),
        .fabric_wdata_o         (fabric_wdata),
        .fabric_rdata_i         (fabric_rdata),

        // SRAM
        .bank_rdata_i             (bank_rdata),
        .bank_word_addr_o         (bank_word_addr),
        .bank_be_o                (bank_be),
        .bank_wdata_o             (bank_wdata),
        .bank_req_o               (bank_req),
        .bank_we_o                (bank_we),

        // QSPI - Flash
        .flash_sck      ( flash_clk_o ),
        .flash_ce_n     ( flash_cs_no ),
        .flash_din      ( flash_io_i  ),
        .flash_dout     ( flash_io_o  ),
        .flash_douten   ( flash_io_oe ),

        // QSPI - PSRAM
        .psram_sck      ( psram_clk_o ),
        .psram_ce_n     ( psram_cs_no ),
        .psram_din      ( psram_io_i  ),
        .psram_dout     ( psram_io_o  ),
        .psram_douten   ( psram_io_oe ),

        // UART0
        .uart0_rx       ( ser_rx_i ),
        .uart0_tx       ( ser_tx_o ),

        // CPU control signals
        .fetch_enable_i ( fetch_enable_sync ),
        .core_sleep_o   ( core_sleep_o   ),

        // JTAG
        .jtag_tck_i     ( jtag_tck           ),
        .jtag_tdi_i     ( jtag_tdi           ),
        .jtag_tdo_o     ( fpga_jtag_tdi      ),
        .jtag_tms_i     ( jtag_tms           ),
        .jtag_trst_ni   ( jtag_trst_n_module )
    );
    
    // Connect SRAM to the SoC
    
    logic [31:0] bank_rdata_sram_0;
    logic [31:0] bank_rdata_sram_1;

    logic sram_enable;
    assign sram_enable = bank_word_addr[10];
    
    logic sram_enable_d;
    
    always_ff @(posedge clk_i, negedge rst_n_sync) begin
        if (!rst_n_sync) begin
            sram_enable_d <= '0;
        end else begin
            sram_enable_d <= sram_enable;
        end
    end
    
    always_comb begin
        case (sram_enable_d)
            1'd0: bank_rdata = bank_rdata_sram_0;
            1'd1: bank_rdata = bank_rdata_sram_1;
        endcase
    end

    RM_IHPSG13_1P_1024x32_c2_bm_bist i_soc_sram0 (
        .A_CLK      (clk_i),
        .A_MEN      (bank_req && sram_enable == 1'd0),
        .A_WEN      (bank_we),
        .A_REN      (!bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata),
        .A_DLY      (1'b1), // tie high!
        .A_DOUT     (bank_rdata_sram_0),
        .A_BM       ({{8{bank_be[3]}}, {8{bank_be[2]}}, {8{bank_be[1]}}, {8{bank_be[0]}}}),

        .A_BIST_EN      ('0),
        .A_BIST_CLK     ('0),
        .A_BIST_MEN     ('0),
        .A_BIST_WEN     ('0),
        .A_BIST_REN     ('0),
        .A_BIST_ADDR    ('0),
        .A_BIST_DIN     ('0),
        .A_BIST_BM      ('0)
    );
    RM_IHPSG13_1P_1024x32_c2_bm_bist i_soc_sram1 (
        .A_CLK      (clk_i),
        .A_MEN      (bank_req && sram_enable == 1'd1),
        .A_WEN      (bank_we),
        .A_REN      (!bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata),
        .A_DLY      (1'b1), // tie high!
        .A_DOUT     (bank_rdata_sram_1),
        .A_BM       ({{8{bank_be[3]}}, {8{bank_be[2]}}, {8{bank_be[1]}}, {8{bank_be[0]}}}),

        .A_BIST_EN      ('0),
        .A_BIST_CLK     ('0),
        .A_BIST_MEN     ('0),
        .A_BIST_WEN     ('0),
        .A_BIST_REN     ('0),
        .A_BIST_ADDR    ('0),
        .A_BIST_DIN     ('0),
        .A_BIST_BM      ('0)
    );

endmodule

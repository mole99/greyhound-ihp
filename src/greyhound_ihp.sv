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

    // Gated clk used for JTAG single stepping
    wire clk;

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

    // WARMBOOT
    wire        fabric_warmboot_boot_o;
    wire  [3:0] fabric_warmboot_slot_o;
    wire        fabric_warmboot_reset_i;

    // CPU_IRQ
    wire  [3:0] fabric_irq_soc;
    wire  [3:0] fabric_irq_dm;
    
    // Custom instruction interface to fabric
    logic        fabric_issue_ready_soc;
    logic        fabric_issue_accept_soc;
    logic        fabric_issue_valid_soc;
    logic [31:0] fabric_issue_instr_soc;
    logic [31:0] fabric_issue_op0_soc;
    logic [31:0] fabric_issue_op1_soc;
    logic [3 :0] fabric_issue_id_soc;
    logic        fabric_issue_ready_dm;
    logic        fabric_issue_accept_dm;
    logic        fabric_issue_valid_dm;
    logic [31:0] fabric_issue_instr_dm;
    logic [31:0] fabric_issue_op0_dm;
    logic [31:0] fabric_issue_op1_dm;
    logic [3 :0] fabric_issue_id_dm;

    logic        fabric_result_valid_soc;
    logic [3 :0] fabric_result_id_soc;
    logic [4 :0] fabric_result_rd_soc;
    logic [31:0] fabric_result_soc;
    logic        fabric_result_valid_dm;
    logic [3 :0] fabric_result_id_dm;
    logic [4 :0] fabric_result_rd_dm;
    logic [31:0] fabric_result_dm;

    // Bus interface to fabric
    wire            fabric_gnt_soc;
    wire            fabric_req_soc;
    wire            fabric_rvalid_soc;
    wire            fabric_we_soc;
    wire [ 3:0]     fabric_be_soc;
    wire [23:0]     fabric_addr_soc;
    wire [31:0]     fabric_wdata_soc;
    wire [31:0]     fabric_rdata_soc;
    wire            fabric_gnt_dm;
    wire            fabric_req_dm;
    wire            fabric_rvalid_dm;
    wire            fabric_we_dm;
    wire [ 3:0]     fabric_be_dm;
    wire [23:0]     fabric_addr_dm;
    wire [31:0]     fabric_wdata_dm;
    wire [31:0]     fabric_rdata_dm;
    
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
    logic jtag_trst_ni_sync, en_jtag_receiver, jtag_trst_n_module_sync, jtag_trst_n_module_sync_d;
    assign jtag_trst_ni_sync = fpga_mode_sync;
 
    // Create a rst_n signal for the jtag test logic, when jtag receiver is enabled
    assign jtag_trst_n_module_sync_d = (en_jtag_receiver | !rst_n_sync) ? jtag_trst_ni_sync : 1'b1;
    always_ff @(posedge clk_i) begin
        jtag_trst_n_module_sync <= jtag_trst_n_module_sync_d;
    end

    assign jtag_tck = fpga_sclk_i;

    always_comb begin
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

            if (jtag_trst_ni_sync) begin
                // srst pulled, trst not -> do special init (configure for jtag input instead of spi)
                // Run init sequence through jtag interface
                jtag_tms = fpga_cs_n_i;
                jtag_tdi = fpga_mosi_i;
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
            jtag_tms = fpga_cs_n_i;
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
        .clk_i  (clk),
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

    logic [31:0] bitstream_data;
    logic        bitstream_valid;
    wire fpga_jtag_tdi;
    fpga_dm #(
        .FABRIC_NUM_IO_WEST ( FABRIC_NUM_IO_WEST )
    ) fpga_dm (
        .clk_i                  ( clk_i                   ),
        .rst_ni                 ( rst_ni                  ),
        .clk_o                  ( clk                     ),
        .tck_i                  ( jtag_tck                ),
        .tms_i                  ( jtag_tms                ),
        .trst_ni                ( jtag_trst_n_module_sync ),
        .td_i                   ( fpga_jtag_tdi           ),
        .td_o                   ( jtag_tdo                ),
        // EJTAG
        .en_jtag_receiver_o     ( en_jtag_receiver        ),
        // ISC Program
        .jtag_bitstream_o       ( jtag_bitstream_data     ),
        .jtag_bitstream_valid_o ( jtag_bitstream_valid    ),
        .fabric_busy_i          ( fabric_config_busy      ),
        .fabric_configured_i    ( fabric_config_configured ),
        .fabric_bitstream_valid_i ( bitstream_valid         ),
        .fabric_bitstream_data_i  ( bitstream_data          ),
        // Boundary scan register (intercept all relevant fabric connections)
        // GPIOs
        // to boundary
        .fabric_pin_i           ( fabric_gpio_i           ),
        .fabric_pin_o           ( fabric_gpio_o           ),
        .fabric_enable_pin_o    ( fabric_gpio_oe_o        ),
        // from fabric
        .fabric_output_enable_i ( fabric_io_west_oe_o     ),
        .fabric_output_data_i   ( fabric_io_west_out_o    ),
        .fabric_input_data_o    ( fabric_io_west_in_i     ),
        // CPU_IRQ
        // to cpu
        .fabric_irq_o           ( fabric_irq_soc ),
        // from fabric
        .fabric_irq_i           ( fabric_irq_dm ),
        // CUSTOM_INSTRUCTION
        // to cpu
        .fabric_issue_ready_o   ( fabric_issue_ready_soc  ),
        .fabric_issue_accept_o  ( fabric_issue_accept_soc ),
        .fabric_issue_valid_i   ( fabric_issue_valid_soc  ),
        .fabric_issue_instr_i   ( fabric_issue_instr_soc  ),
        .fabric_issue_op0_i     ( fabric_issue_op0_soc    ),
        .fabric_issue_op1_i     ( fabric_issue_op1_soc    ),
        .fabric_issue_id_i      ( fabric_issue_id_soc     ),
        .fabric_result_valid_o  ( fabric_result_valid_soc ),
        .fabric_result_id_o     ( fabric_result_id_soc    ),
        .fabric_result_rd_o     ( fabric_result_rd_soc    ),
        .fabric_result_o        ( fabric_result_soc       ),
        // from fabric
        .fabric_issue_ready_i   ( fabric_issue_ready_dm   ),
        .fabric_issue_accept_i  ( fabric_issue_accept_dm  ),
        .fabric_issue_valid_o   ( fabric_issue_valid_dm   ),
        .fabric_issue_instr_o   ( fabric_issue_instr_dm   ),
        .fabric_issue_op0_o     ( fabric_issue_op0_dm     ),
        .fabric_issue_op1_o     ( fabric_issue_op1_dm     ),
        .fabric_issue_id_o      ( fabric_issue_id_dm      ),
        .fabric_result_valid_i  ( fabric_result_valid_dm  ),
        .fabric_result_id_i     ( fabric_result_id_dm     ),
        .fabric_result_rd_i     ( fabric_result_rd_dm     ),
        .fabric_result_i        ( fabric_result_dm        ),
        // OBI_PERIPHERAL
        // to cpu
        .fabric_obi_req_i       ( fabric_req_soc          ),
        .fabric_obi_we_i        ( fabric_we_soc           ),
        .fabric_obi_be_i        ( fabric_be_soc           ),
        .fabric_obi_addr_i      ( fabric_addr_soc         ),
        .fabric_obi_wdata_i     ( fabric_wdata_soc        ),
        .fabric_obi_gnt_o       ( fabric_gnt_soc          ),
        .fabric_obi_rvalid_o    ( fabric_rvalid_soc       ),
        .fabric_obi_rdata_o     ( fabric_rdata_soc        ),
        // from fabric
        .fabric_obi_req_o       ( fabric_req_dm           ),
        .fabric_obi_we_o        ( fabric_we_dm            ),
        .fabric_obi_be_o        ( fabric_be_dm            ),
        .fabric_obi_addr_o      ( fabric_addr_dm          ),
        .fabric_obi_wdata_o     ( fabric_wdata_dm         ),
        .fabric_obi_gnt_i       ( fabric_gnt_dm           ),
        .fabric_obi_rvalid_i    ( fabric_rvalid_dm        ),
        .fabric_obi_rdata_i     ( fabric_rdata_dm         )
    );

    // TODO adjust BITSTREAM_LENGTH_WORDS
    fabric_spi_controller #(
        .BITSTREAM_LENGTH_WORDS (32'h11D6),
        .SLOT_OFFSET_WORDS      (32'h2000),
        .NUM_SLOTS              (16)
    ) fabric_spi_controller (
        .clk_i  (clk),
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
        .clk_i              (clk),
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
        .clk_i          (clk),
        
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
        .fabric_irq_o           (fabric_irq_dm),
        
        // CUSTOM_INSTRUCTION
        .fabric_issue_ready_o   (fabric_issue_ready_dm),
        .fabric_issue_accept_o  (fabric_issue_accept_dm),
        .fabric_issue_valid_i   (fabric_issue_valid_dm),
        .fabric_issue_instr_i   (fabric_issue_instr_dm),
        .fabric_issue_op0_i     (fabric_issue_op0_dm),
        .fabric_issue_op1_i     (fabric_issue_op1_dm),
        .fabric_issue_id_i      (fabric_issue_id_dm),
            
        .fabric_result_valid_o  (fabric_result_valid_dm),
        .fabric_result_id_o     (fabric_result_id_dm),
        .fabric_result_rd_o     (fabric_result_rd_dm),
        .fabric_result_o        (fabric_result_dm),
        
        // OBI_PERIPHERAL
        .fabric_obi_req_i       (fabric_req_dm),
        .fabric_obi_we_i        (fabric_we_dm),
        .fabric_obi_be_i        (fabric_be_dm),
        .fabric_obi_addr_i      (fabric_addr_dm),
        .fabric_obi_wdata_i     (fabric_wdata_dm),
        .fabric_obi_gnt_o       (fabric_gnt_dm),
        .fabric_obi_rvalid_o    (fabric_rvalid_dm),
        .fabric_obi_rdata_o     (fabric_rdata_dm)
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
        .clk_i          ( clk  ),
        .rst_ni         ( rst_n_sync ),

        // Interrupt requests from fabric
        .fabric_irq_i   ( fabric_irq_soc ),
        
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
        .fabric_issue_ready_i   (fabric_issue_ready_soc),
        .fabric_issue_accept_i  (fabric_issue_accept_soc),
        .fabric_issue_valid_o   (fabric_issue_valid_soc),
        .fabric_issue_instr_o   (fabric_issue_instr_soc),
        .fabric_issue_op0_o     (fabric_issue_op0_soc),
        .fabric_issue_op1_o     (fabric_issue_op1_soc),
        .fabric_issue_id_o      (fabric_issue_id_soc),
            
        .fabric_result_valid_i  (fabric_result_valid_soc),
        .fabric_result_id_i     (fabric_result_id_soc),
        .fabric_result_rd_i     (fabric_result_rd_soc),
        .fabric_result_i        (fabric_result_soc),

        // Bus interface to fabric
        .fabric_gnt_i           (fabric_gnt_soc),
        .fabric_req_o           (fabric_req_soc),
        .fabric_rvalid_i        (fabric_rvalid_soc),
        .fabric_we_o            (fabric_we_soc),
        .fabric_be_o            (fabric_be_soc),
        .fabric_addr_o          (fabric_addr_soc),
        .fabric_wdata_o         (fabric_wdata_soc),
        .fabric_rdata_i         (fabric_rdata_soc),

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
        .jtag_trst_ni   ( jtag_trst_n_module_sync )
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
        .A_CLK      (clk),
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
        .A_CLK      (clk),
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

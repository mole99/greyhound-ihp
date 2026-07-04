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
    
    // Config busy
    assign config_busy_o = fabric_config_busy;
    
    logic [31:0] spi_bitstream_data, spi_controller_bitstream_data, spi_receiver_bitstream_data;
    logic        spi_bitstream_valid, spi_controller_bitstream_valid, spi_receiver_bitstream_valid;
    
    // JTAG receiver
    logic [31:0] jtag_bitstream_data;
    logic        jtag_bitstream_valid;

    // JTAG boundary scan
    logic jtag_tdi, jtag_tdo, jtag_tms;
    logic en_jtag_receiver, jtag_trst_n_sync;

    // SPI receiver
    logic spi_receiver_cs_n;
    logic spi_receiver_mosi;
    logic spi_receiver_miso;
    logic spi_receiver_enable;
    
    logic c_clk_rising, c_clk_falling;

    // SPI controller
    logic spi_controller_sclk;
    logic spi_controller_cs_n;
    logic spi_controller_mosi;
    logic spi_controller_miso;
    
    logic spi_controller_start;
    logic [3:0] spi_controller_slot;
    
    // I/Os West
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_in_i;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_out_o;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_oe_o;

    // WARMBOOT
    wire        fabric_warmboot_boot;
    wire  [3:0] fabric_warmboot_slot;
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
    wire            cpu_warmboot_boot;
    wire [3:0]      cpu_warmboot_slot;

    logic fabric_busy;

    assign fabric_busy = fabric_config_busy || fabric_spi_controller_busy;

    controller_io_interface controller_io_interface (
        // IOs
        .clk_i          ( clk_i          ),
        .rst_n_sync_i   ( rst_n_sync     ),
        .mode_i         ( fpga_mode_i    ), // fpga_mode
        .c_clk_i        ( fpga_sclk_i    ), // sclk/jtck
        .select_i       ( fpga_cs_n_i    ), // cs_n/tms
        .pico_i         ( fpga_mosi_i    ), // mosi/tdi
        .poci_i         ( fpga_miso_i    ), // miso/tdo
        .select_o       ( fpga_cs_n_o    ), // cs_n/tms
        .pico_o         ( fpga_mosi_o    ), // mosi/tdi
        .poci_o         ( fpga_miso_o    ), // miso/tdo
        .c_clk_o        ( fpga_sclk_o    ), // sclk/jtck
        .c_clk_oe_o     ( fpga_sclk_oe_o ), // sclk/jtck
        .select_oe_o    ( fpga_cs_n_oe_o ), // cs_n/tms
        .pico_oe_o      ( fpga_mosi_oe_o ), // mosi/tdi
        .poci_oe_o      ( fpga_miso_oe_o ), // miso/tdo

        // SPI controller
        .spi_controller_cs_ni               ( spi_controller_cs_n            ),
        .spi_controller_mosi_i              ( spi_controller_mosi            ),
        .spi_controller_miso_o              ( spi_controller_miso            ),
        .spi_controller_sclk_i              ( spi_controller_sclk            ),
        .spi_controller_slot_o              ( spi_controller_slot            ),
        .spi_controller_start_o             ( spi_controller_start           ),
        .spi_controller_bitstream_data_i    ( spi_controller_bitstream_data  ),
        .spi_controller_bitstream_valid_i   ( spi_controller_bitstream_valid ),
        .fabric_warmboot_boot_i             ( fabric_warmboot_boot           ),
        .fabric_warmboot_slot_i             ( fabric_warmboot_slot           ),
        .cpu_warmboot_boot_i                ( cpu_warmboot_boot              ),
        .cpu_warmboot_slot_i                ( cpu_warmboot_slot              ),
        .fabric_busy_i                      ( fabric_busy                    ),

        // SPI receiver
        .spi_receiver_cs_no             ( spi_receiver_cs_n            ),
        .spi_receiver_mosi_o            ( spi_receiver_mosi            ),
        .spi_receiver_miso_i            ( spi_receiver_miso            ),
        .spi_receiver_enable_o          ( spi_receiver_enable          ),
        .spi_receiver_bitstream_data_i  ( spi_receiver_bitstream_data  ),
        .spi_receiver_bitstream_valid_i ( spi_receiver_bitstream_valid ),

        .spi_bitstream_data_o           ( spi_bitstream_data  ),
        .spi_bitstream_valid_o          ( spi_bitstream_valid ),

        // JTAG
        .en_jtag_receiver_i ( en_jtag_receiver ),
        .jtag_tdo_i         ( jtag_tdo         ),
        .jtag_tms_o         ( jtag_tms         ),
        .jtag_tdi_o         ( jtag_tdi         ),
        .jtag_trst_n_sync_o ( jtag_trst_n_sync ),

        .c_clk_rising_o     ( c_clk_rising  ),
        .c_clk_falling_o    ( c_clk_falling )
    );

    fabric_spi_receiver fabric_spi_receiver (
        .clk_i  (clk),
        .rst_ni (rst_n_sync),
        
        // Bitstream data
        .bitstream_data_o   (spi_receiver_bitstream_data),
        .bitstream_valid_o  (spi_receiver_bitstream_valid),
        
        // Enable the SPI receiver
        .enable_i   (spi_receiver_enable),
        
        // SPI
        .sclk_falling_i (c_clk_falling),
        .cs_ni          (spi_receiver_cs_n),
        .mosi_i         (spi_receiver_mosi),
        .miso_o         (spi_receiver_miso)
    );

    logic [31:0] bitstream_data;
    logic        bitstream_valid;
    wire fpga_jtag_tdi;
    logic [31:0] usercode;
    fpga_dm #(
        .FABRIC_NUM_IO_WEST ( FABRIC_NUM_IO_WEST )
    ) fpga_dm (
        .clk_i                  ( clk_i                   ),
        .rst_ni                 ( rst_n_sync              ),
        .clk_o                  ( clk                     ),
        .jclk_rising_i          ( c_clk_rising            ),
        .jclk_falling_i         ( c_clk_falling           ),
        .tms_i                  ( jtag_tms                ),
        .trst_n_sync_i          ( jtag_trst_n_sync        ),
        .td_i                   ( fpga_jtag_tdi           ),
        .td_o                   ( jtag_tdo                ),
        // EJTAG
        .en_jtag_receiver_o     ( en_jtag_receiver        ),
        // ISC Program
        .jtag_bitstream_o         ( jtag_bitstream_data      ),
        .jtag_bitstream_valid_o   ( jtag_bitstream_valid     ),
        .fabric_busy_i            ( fabric_config_busy       ),
        .fabric_configured_i      ( fabric_config_configured ),
        .fabric_bitstream_valid_i ( bitstream_valid          ),
        .fabric_bitstream_data_i  ( bitstream_data           ),
        // USERCODE
        .usercode_o             ( usercode                ),
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
        .start_i    (spi_controller_start),
        .slot_i     (spi_controller_slot),
        
        // Bitstream data
        .bitstream_data_o    (spi_controller_bitstream_data),
        .bitstream_valid_o   (spi_controller_bitstream_valid),
        
        // Reading in progress
        .busy_o     (fabric_spi_controller_busy),
        
        // SPI
        .sclk_o     (spi_controller_sclk),
        .cs_no      (spi_controller_cs_n),
        .mosi_o     (spi_controller_mosi),
        .miso_i     (spi_controller_miso)
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
        .fabric_warmboot_boot_o  (fabric_warmboot_boot),
        .fabric_warmboot_slot_o  (fabric_warmboot_slot),
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
        .fabric_config_busy_i   (fabric_busy),
        
        // Fabric has been configured
        .fabric_configured_i   (fabric_config_configured),
        
        // Fabric bitstream data
        .bitstream_valid_o  (bitstream_valid_cpu),
        .bitstream_data_o   (bitstream_data_cpu),
        
        // Trigger fabric reconfiguration
        .warmboot_boot_o    (cpu_warmboot_boot),
        .warmboot_slot_o    (cpu_warmboot_slot),
        
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
        .jclk_i             ( clk_i            ),
        .jclk_rising_i      ( c_clk_rising     ),
        .jclk_falling_i     ( c_clk_falling    ),
        .jtag_tdi_i         ( jtag_tdi         ),
        .jtag_tdo_o         ( fpga_jtag_tdi    ),
        .jtag_tms_i         ( jtag_tms         ),
        .jtag_trst_n_sync_i ( jtag_trst_n_sync ),
        .usercode_i         ( usercode         )
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

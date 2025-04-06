`default_nettype none

module greyhound_ihp (
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

    parameter NumColumns = 11;
    parameter NumRows = 16;

    parameter FABRIC_NUM_IO_WEST = 28;
    parameter FABRIC_NUM_IO_NORTH = 4;
    
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

    // I/O West config
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_config_bit0_o;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_config_bit1_o;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_config_bit2_o;
    wire [FABRIC_NUM_IO_WEST-1:0]      fabric_io_west_config_bit3_o;

    // I/Os North
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_in_i;
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_out_o;
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_oe_o;

    // I/O North config
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_config_bit0_o;
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_config_bit1_o;
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_config_bit2_o;
    wire [FABRIC_NUM_IO_NORTH-1:0]      fabric_io_north_config_bit3_o;

    // Assign fabric IOs
    assign fabric_io_west_in_i  = fabric_gpio_i[27:0];
    assign fabric_io_north_in_i = fabric_gpio_i[31:28];
    assign fabric_gpio_o        = {fabric_io_north_out_o, fabric_io_west_out_o};
    assign fabric_gpio_oe_o     = {fabric_io_north_oe_o, fabric_io_west_oe_o};

    // WARMBOOT
    wire        fabric_warmboot_boot_o;
    wire  [3:0] fabric_warmboot_slot_o;
    wire        fabric_warmboot_reset_i;

    // CPU_IRQ
    wire  [3:0] fabric_irq_o;
    
    // Choose functionality of fabric
    // 0 = custom instruction interface
    // 1 = bus interface
    wire            xif_or_periph;
    
    // Custom instruction interface to fabric
    wire [31:0]     fabric_rs1;
    wire [31:0]     fabric_rs2;
    wire [31:0]     fabric_result;
    
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
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            startup_trigger = 1'b1;
        end else begin
            startup_trigger = 1'b0;
        end
    end
    
    always_comb begin
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
    
    fabric_spi_receiver fabric_spi_receiver (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        
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

    fabric_spi_controller #(
        .BITSTREAM_LENGTH_WORDS (32'hEA2),
        .SLOT_OFFSET_WORDS      (32'h1000),
        .NUM_SLOTS              (16)
    ) fabric_spi_controller (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        
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
        end else begin
            bitstream_data = bitstream_data_cpu;
        end
    end
    
    assign bitstream_valid = bitstream_valid_cpu || spi_bitstream_valid;

    fabric_config #(
        	.FrameBitsPerRow    (FrameBitsPerRow),
	    .MaxFramesPerCol    (MaxFramesPerCol),
	    
	    .NumColumns         (NumColumns),
	    .NumRows            (NumRows)
    ) fabric_config (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),
        
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
        .clk_i,
        
        // Configuration
        .FrameData_i    (FrameData),
        .FrameStrobe_i  (FrameStrobe),
        
        // Fabric is configured
        .configured_i   (fabric_config_configured),
        
        // I/Os West
        .fabric_io_west_in_i,
        .fabric_io_west_out_o,
        .fabric_io_west_oe_o,

        // I/O West config
        .fabric_io_west_config_bit0_o,
        .fabric_io_west_config_bit1_o,
        .fabric_io_west_config_bit2_o,
        .fabric_io_west_config_bit3_o,
        
        // I/Os North
        .fabric_io_north_in_i,
        .fabric_io_north_out_o,
        .fabric_io_north_oe_o,

        // I/O North config
        .fabric_io_north_config_bit0_o,
        .fabric_io_north_config_bit1_o,
        .fabric_io_north_config_bit2_o,
        .fabric_io_north_config_bit3_o,

        // WARMBOOT
        .fabric_warmboot_boot_o,
        .fabric_warmboot_slot_o,
        .fabric_warmboot_reset_i,

        // CPU_IRQ
        .fabric_irq_o,

        // Choose functionality of fabric
        // 0 = custom instruction interface
        // 1 = bus interface
        .fabric_xif_or_periph_i (xif_or_periph),
        
        // Custom instruction interface
        .fabric_rs1_i       (fabric_rs1),
        .fabric_rs2_i       (fabric_rs2),
        .fabric_result_o    (fabric_result),
        
        // Bus interface
        .fabric_gnt_o       (fabric_gnt),
        .fabric_req_i       (fabric_req),
        .fabric_rvalid_o    (fabric_rvalid),
        .fabric_we_i        (fabric_we),
        .fabric_be_i        (fabric_be),
        .fabric_addr_i      (fabric_addr),
        .fabric_wdata_i     (fabric_wdata),
        .fabric_rdata_o     (fabric_rdata)
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
        // Clock and reset
        .clk_i          ( clk_i  ),
        .rst_ni         ( rst_ni ),

        // Interrupt requests from fabric
        .fabric_irq_i   ( fabric_irq_o ),
        
        // Fabric config is currently
        // configuring the fabric
        .fabric_config_busy_i   (fabric_config_busy || fabric_spi_controller_busy),
        
        // Fabric bitstream data
        .bitstream_valid_o  (bitstream_valid_cpu),
        .bitstream_data_o   (bitstream_data_cpu),
        
        // Trigger fabric reconfiguration
        .warmboot_boot_o    (cpu_warmboot_boot_o),
        .warmboot_slot_o    (cpu_warmboot_slot_o),
        
        // Choose functionality of fabric
        // 0 = custom instruction interface
        // 1 = bus interface 
        .xif_or_periph_o        (xif_or_periph),
        
        // Custom instruction interface to fabric
        .fabric_rs1_o           (fabric_rs1),
        .fabric_rs2_o           (fabric_rs2),
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
        .core_sleep_o   ( core_sleep_o   )
    );
    
    // Connect SRAM to the SoC
    // Combine two 16bit SRAMs into a 32bit SRAM
    
    logic [31:0] bank_rdata_sram_0;
    logic [31:0] bank_rdata_sram_1;

    logic sram_0_enable;
    logic sram_1_enable;

    assign sram_0_enable = bank_word_addr[10] == 1'b0;
    assign sram_1_enable = bank_word_addr[10] == 1'b1;
    
    logic sram_0_enable_d;
    
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            sram_0_enable_d <= 1'b0;
        end else begin
            sram_0_enable_d <= sram_0_enable;
        end
    end
    
    assign bank_rdata = sram_0_enable_d ? bank_rdata_sram_0 : bank_rdata_sram_1;

    RM_IHPSG13_1P_1024x16_c2_bm_bist i_soc_sram0_0 (
        .A_CLK      (clk_i),
        .A_MEN      (sram_0_enable && bank_req),
        .A_WEN      (sram_0_enable && bank_we),
        .A_REN      (sram_0_enable && !bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata[15:0]),
        .A_DLY      (1'b1),
        .A_DOUT     (bank_rdata_sram_0[15:0]),
        .A_BM       ({{8{bank_be[1]}}, {8{bank_be[0]}}}),

        .A_BIST_EN      ('0),
        .A_BIST_CLK     ('0),
        .A_BIST_MEN     ('0),
        .A_BIST_WEN     ('0),
        .A_BIST_REN     ('0),
        .A_BIST_ADDR    ('0),
        .A_BIST_DIN     ('0),
        .A_BIST_BM      ('0)
    );

    RM_IHPSG13_1P_1024x16_c2_bm_bist i_soc_sram0_1 (
        .A_CLK      (clk_i),
        .A_MEN      (sram_0_enable && bank_req),
        .A_WEN      (sram_0_enable && bank_we),
        .A_REN      (sram_0_enable && !bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata[31:16]),
        .A_DLY      (1'b1),
        .A_DOUT     (bank_rdata_sram_0[31:16]),
        .A_BM       ({{8{bank_be[3]}}, {8{bank_be[2]}}}),

        .A_BIST_EN      ('0),
        .A_BIST_CLK     ('0),
        .A_BIST_MEN     ('0),
        .A_BIST_WEN     ('0),
        .A_BIST_REN     ('0),
        .A_BIST_ADDR    ('0),
        .A_BIST_DIN     ('0),
        .A_BIST_BM      ('0)
    );

    RM_IHPSG13_1P_1024x16_c2_bm_bist i_soc_sram1_0 (
        .A_CLK      (clk_i),
        .A_MEN      (sram_1_enable && bank_req),
        .A_WEN      (sram_1_enable && bank_we),
        .A_REN      (sram_1_enable && !bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata[15:0]),
        .A_DLY      (1'b1),
        .A_DOUT     (bank_rdata_sram_1[15:0]),
        .A_BM       ({{8{bank_be[1]}}, {8{bank_be[0]}}}),

        .A_BIST_EN      ('0),
        .A_BIST_CLK     ('0),
        .A_BIST_MEN     ('0),
        .A_BIST_WEN     ('0),
        .A_BIST_REN     ('0),
        .A_BIST_ADDR    ('0),
        .A_BIST_DIN     ('0),
        .A_BIST_BM      ('0)
    );

    RM_IHPSG13_1P_1024x16_c2_bm_bist i_soc_sram1_1 (
        .A_CLK      (clk_i),
        .A_MEN      (sram_1_enable && bank_req),
        .A_WEN      (sram_1_enable && bank_we),
        .A_REN      (sram_1_enable && !bank_we),
        .A_ADDR     (bank_word_addr[9:0]),
        .A_DIN      (bank_wdata[31:16]),
        .A_DLY      (1'b1),
        .A_DOUT     (bank_rdata_sram_1[31:16]),
        .A_BM       ({{8{bank_be[3]}}, {8{bank_be[2]}}}),

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

`default_nettype none

module greyhound_ihp_top #(
    parameter NUM_GPIOS = 32
)(
    inout  wire          io_clock_PAD,
    inout  wire          io_reset_PAD,

    inout  wire          io_flash_clk_PAD,
    inout  wire          io_flash_cs_n_PAD,
    inout  wire [3:0]    io_flash_io_PAD,

    inout  wire          io_psram_clk_PAD,
    inout  wire          io_psram_cs_n_PAD,
    inout  wire [3:0]    io_psram_io_PAD,

    inout  wire          io_ser_rx_PAD,
    inout  wire          io_ser_tx_PAD,

    inout  wire          io_fpga_sclk_PAD,
    inout  wire          io_fpga_cs_n_PAD,
    inout  wire          io_fpga_mosi_PAD,
    inout  wire          io_fpga_miso_PAD,

    inout  wire          io_fpga_mode_PAD,
    inout  wire          io_fetch_enable_PAD,
    inout  wire          io_config_busy_PAD,
    inout  wire          io_core_sleep_PAD,

    inout  wire [NUM_GPIOS-1:0]   io_gpio_PAD
    
    /*inout VDD_PAD,
    inout VSS_PAD,
    inout IOVDD_PAD,
    inout IOVSS_PAD,*/
);

    wire io_clock_p2c;
    wire io_reset_p2c;

    wire io_flash_clk_c2p;
    wire io_flash_cs_n_c2p;
    wire [3:0] io_flash_io_c2p;    // Core to Pad
    wire [3:0] io_flash_io_c2p_en; // Core to Pad enable
    wire [3:0] io_flash_io_p2c;    // Pad to Core

    wire io_psram_clk_c2p;
    wire io_psram_cs_n_c2p;
    wire [3:0] io_psram_io_c2p;    // Core to Pad
    wire [3:0] io_psram_io_c2p_en; // Core to Pad enable
    wire [3:0] io_psram_io_p2c;    // Pad to Core

    wire io_ser_rx_p2c;
    wire io_ser_tx_c2p;
    
    wire io_fpga_sclk_c2p;    // Core to Pad
    wire io_fpga_sclk_c2p_en; // Core to Pad enable
    wire io_fpga_sclk_p2c;    // Pad to Core
    
    wire io_fpga_cs_n_c2p;    // Core to Pad
    wire io_fpga_cs_n_c2p_en; // Core to Pad enable
    wire io_fpga_cs_n_p2c;    // Pad to Core
    
    wire io_fpga_mosi_c2p;    // Core to Pad
    wire io_fpga_mosi_c2p_en; // Core to Pad enable
    wire io_fpga_mosi_p2c;    // Pad to Core
    
    wire io_fpga_miso_c2p;    // Core to Pad
    wire io_fpga_miso_c2p_en; // Core to Pad enable
    wire io_fpga_miso_p2c;    // Pad to Core

    wire [NUM_GPIOS-1:0] io_gpio_c2p;    // Core to Pad
    wire [NUM_GPIOS-1:0] io_gpio_c2p_en; // Core to Pad enable
    wire [NUM_GPIOS-1:0] io_gpio_p2c;    // Pad to Core

    wire io_fpga_mode_p2c;
    wire io_fetch_enable_p2c;
    
    wire io_config_busy_c2p;
    wire io_core_sleep_c2p;

    //wire VDD, VSS, IOVDD, IOVSS;

    /*(* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_east (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (VDD_PAD)
    );

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_east (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (VSS_PAD)
    );

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_east (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (IOVSS_PAD)
    );

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_east (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (IOVDD_PAD)
    );

    (* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_west (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (VDD_PAD)
    );

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_west (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (VSS_PAD)
    );

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_west (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (IOVSS_PAD)
    );

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_west (
        `ifdef USE_POWER_PINS
        .vss    (VSS),
        .vdd    (VDD),
        .iovss  (IOVSS),
        .iovdd  (IOVDD),
        `endif
        .pad (IOVDD_PAD)
    );*/
    
    (* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_east ();

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_east ();

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_east ();

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_east ();

    (* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_west ();

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_west ();

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_west ();

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_west ();

    sg13g2_IOPadIn sg13g2_IOPad_io_clock (
        .p2c (io_clock_p2c), //o
        .pad (io_clock_PAD)  //~
    );
    sg13g2_IOPadIn sg13g2_IOPad_io_reset (
        .p2c (io_reset_p2c), //o
        .pad (io_reset_PAD)  //~
    );
    
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_flash_clk (
        .c2p (io_flash_clk_c2p), //o
        .pad (io_flash_clk_PAD)  //~
    );
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_flash_cs_n (
        .c2p (io_flash_cs_n_c2p), //o
        .pad (io_flash_cs_n_PAD)  //~
    );
    generate
        for (genvar i=0; i<4; i++) begin : sg13g2_IOPad_flash
          sg13g2_IOPadInOut30mA sg13g2_IOPad_io_flash_io (
            .c2p    (io_flash_io_c2p[i]   ), //i
            .c2p_en (io_flash_io_c2p_en[i]), //i
            .p2c    (io_flash_io_p2c[i]   ), //o
            .pad    (io_flash_io_PAD[i]   )  //~
          );
        end
    endgenerate
    
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_psram_clk (
        .c2p (io_psram_clk_c2p), //o
        .pad (io_psram_clk_PAD)  //~
    );
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_psram_cs_n (
        .c2p (io_psram_cs_n_c2p), //o
        .pad (io_psram_cs_n_PAD)  //~
    );
    generate
        for (genvar i=0; i<4; i++) begin : sg13g2_IOPad_psram
          sg13g2_IOPadInOut30mA sg13g2_IOPad_io_psram_io (
            .c2p    (io_psram_io_c2p[i]   ), //i
            .c2p_en (io_psram_io_c2p_en[i]), //i
            .p2c    (io_psram_io_p2c[i]   ), //o
            .pad    (io_psram_io_PAD[i]   )  //~
          );
        end
    endgenerate

    sg13g2_IOPadIn sg13g2_IOPad_io_ser_rx (
        .p2c (io_ser_rx_p2c), //o
        .pad (io_ser_rx_PAD)  //~
    );
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_ser_tx (
        .c2p (io_ser_tx_c2p), //o
        .pad (io_ser_tx_PAD)  //~
    );

    sg13g2_IOPadInOut30mA sg13g2_IOPad_io_fpga_sclk (
        .c2p    (io_fpga_sclk_c2p   ), //i
        .c2p_en (io_fpga_sclk_c2p_en), //i
        .p2c    (io_fpga_sclk_p2c   ), //o
        .pad    (io_fpga_sclk_PAD   )  //~
    );
    sg13g2_IOPadInOut30mA sg13g2_IOPad_io_fpga_cs_n (
        .c2p    (io_fpga_cs_n_c2p   ), //i
        .c2p_en (io_fpga_cs_n_c2p_en), //i
        .p2c    (io_fpga_cs_n_p2c   ), //o
        .pad    (io_fpga_cs_n_PAD   )  //~
    );
    sg13g2_IOPadInOut30mA sg13g2_IOPad_io_fpga_mosi (
        .c2p    (io_fpga_mosi_c2p   ), //i
        .c2p_en (io_fpga_mosi_c2p_en), //i
        .p2c    (io_fpga_mosi_p2c   ), //o
        .pad    (io_fpga_mosi_PAD   )  //~
    );
    sg13g2_IOPadInOut30mA sg13g2_IOPad_io_fpga_miso (
        .c2p    (io_fpga_miso_c2p   ), //i
        .c2p_en (io_fpga_miso_c2p_en), //i
        .p2c    (io_fpga_miso_p2c   ), //o
        .pad    (io_fpga_miso_PAD   )  //~
    );

    sg13g2_IOPadIn sg13g2_IOPad_io_fpga_mode (
        .p2c (io_fpga_mode_p2c), //o
        .pad (io_fpga_mode_PAD)  //~
    );
    sg13g2_IOPadIn sg13g2_IOPad_io_fetch_enable (
        .p2c (io_fetch_enable_p2c), //o
        .pad (io_fetch_enable_PAD)  //~
    );
    
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_config_busy (
        .c2p (io_config_busy_c2p), //o
        .pad (io_config_busy_PAD)  //~
    );
    sg13g2_IOPadOut30mA sg13g2_IOPad_io_core_sleep (
        .c2p (io_core_sleep_c2p), //o
        .pad (io_core_sleep_PAD)  //~
    );

    generate
    
        for (genvar i=0; i<NUM_GPIOS; i++) begin : sg13g2_IOPad
          sg13g2_IOPadInOut30mA sg13g2_IOPad_io_gpio (
            .c2p    (io_gpio_c2p[i]   ), //i
            .c2p_en (io_gpio_c2p_en[i]), //i
            .p2c    (io_gpio_p2c[i]   ), //o
            .pad    (io_gpio_PAD[i]   )  //~
          );
        end
    
    endgenerate
    
    wire [3:0] psram_io_oe_n;
    wire [3:0] flash_io_oe_n;

    greyhound_ihp i_greyhound_ihp (
        .clk_i  (io_clock_p2c),
        .rst_ni (io_reset_p2c),

        // Fabric I/O
        .fabric_gpio_i      (io_gpio_p2c[31:0]),
        .fabric_gpio_o      (io_gpio_c2p[31:0]),
        .fabric_gpio_oe_o   (io_gpio_c2p_en[31:0]),

        // FPGA config
        .fpga_sclk_i        (io_fpga_sclk_p2c),
        .fpga_sclk_o        (io_fpga_sclk_c2p),
        .fpga_sclk_oe_o     (io_fpga_sclk_c2p_en),
        
        .fpga_cs_n_i        (io_fpga_cs_n_p2c),
        .fpga_cs_n_o        (io_fpga_cs_n_c2p),
        .fpga_cs_n_oe_o     (io_fpga_cs_n_c2p_en),
        
        .fpga_mosi_i        (io_fpga_mosi_p2c),
        .fpga_mosi_o        (io_fpga_mosi_c2p),
        .fpga_mosi_oe_o     (io_fpga_mosi_c2p_en),
        
        .fpga_miso_i        (io_fpga_miso_p2c),
        .fpga_miso_o        (io_fpga_miso_c2p),
        .fpga_miso_oe_o     (io_fpga_miso_c2p_en),
        
        // FPGA config mode
        // if mode == 0: SPI controller
        // if mode == 1: SPI receiver
        .fpga_mode_i    (io_fpga_mode_p2c),
        .config_busy_o  (io_config_busy_c2p),

        // SoC
        .flash_clk_o    (io_flash_clk_c2p),
        .flash_cs_no    (io_flash_cs_n_c2p),
        .flash_io_i     (io_flash_io_p2c),
        .flash_io_o     (io_flash_io_c2p),
        .flash_io_oe_no (flash_io_oe_n),

        .psram_clk_o    (io_psram_clk_c2p),
        .psram_cs_no    (io_psram_cs_n_c2p),
        .psram_io_i     (io_psram_io_p2c),
        .psram_io_o     (io_psram_io_c2p),
        .psram_io_oe_no (psram_io_oe_n),

        .ser_rx_i       (io_ser_rx_p2c),
        .ser_tx_o       (io_ser_tx_c2p),
        
        .fetch_enable_i (io_fetch_enable_p2c),
        .core_sleep_o   (io_core_sleep_c2p)
    );

    assign io_flash_io_c2p_en = ~flash_io_oe_n;
    assign io_psram_io_c2p_en = ~psram_io_oe_n;
    
    //(* keep *) greyhound_logo i_greyhound_logo ();

endmodule

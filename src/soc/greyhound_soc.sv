`default_nettype none

module greyhound_soc import cv32e40x_pkg::*, soc_pkg::*;
(
`ifdef USE_POWER_PINS
    inout VPWR,    // Common 1.8V supply
    inout VGND,    // Common digital ground
`endif

    // Clock and reset
    input  logic            clk_i,
    input  logic            rst_ni,

    // Interrupt requests from fabric
    input  logic [3:0]      fabric_irq_i,
    
    // Fabric config is currently
    // configuring the fabric
    input  logic            fabric_config_busy_i,
    
    // Fabric bitstream data
    output logic            bitstream_valid_o,
    output logic [31:0]     bitstream_data_o,
    
    // Trigger fabric reconfiguration
    output logic            warmboot_boot_o,
    output logic [3:0]      warmboot_slot_o,
    
    // Choose functionality of fabric
    // 0 = custom instruction interface
    // 1 = bus interface 
    output logic            xif_or_periph_o,
    
    // Custom instruction interface to fabric
    output logic [31:0]     fabric_rs1_o,
    output logic [31:0]     fabric_rs2_o,
    input  logic [31:0]     fabric_result_i,
    
    // Bus interface to fabric
    input  logic            fabric_gnt_i,
    output logic            fabric_req_o,
    input  logic            fabric_rvalid_i,
    output logic            fabric_we_o,
    output logic [ 3:0]     fabric_be_o,
    output logic [23:0]     fabric_addr_o,
    output logic [31:0]     fabric_wdata_o,
    input  logic [31:0]     fabric_rdata_i,
  
    // SRAM
    input  logic [31:0]     bank_rdata_i,
    output logic [10:0]     bank_word_addr_o,
    output logic [3:0]      bank_be_o,
    output logic [31:0]     bank_wdata_o,
    output logic            bank_req_o,
    output logic            bank_we_o,
  
    // QSPI - Flash
    output  logic           flash_sck,
    output  logic           flash_ce_n,
    input   logic [3:0]     flash_din,
    output  logic [3:0]     flash_dout,
    output  logic [3:0]     flash_douten,

    // QSPI - PSRAM
    output  logic           psram_sck,
    output  logic           psram_ce_n,
    input   logic [3:0]     psram_din,
    output  logic [3:0]     psram_dout,
    output  logic [3:0]     psram_douten,
    
    // UART0
    	input	logic           uart0_rx,
	output	logic           uart0_tx,

    // CPU control signals
    input  logic            fetch_enable_i,
    output logic            core_sleep_o
);

    // Custom instruction interface
    cv32e40x_if_xif ext_if();

    /*dummy_extension dummy_extension
    (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),

        .xif_compressed     (ext_if.coproc_compressed),
        .xif_issue          (ext_if.coproc_issue),
        .xif_commit         (ext_if.coproc_commit),
        .xif_mem            (ext_if.coproc_mem),
        .xif_mem_result     (ext_if.coproc_mem_result),
        .xif_result         (ext_if.coproc_result)
    );*/
    
    fabric_extension fabric_extension
    (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),

        .xif_compressed     (ext_if.coproc_compressed),
        .xif_issue          (ext_if.coproc_issue),
        .xif_commit         (ext_if.coproc_commit),
        .xif_mem            (ext_if.coproc_mem),
        .xif_mem_result     (ext_if.coproc_mem_result),
        .xif_result         (ext_if.coproc_result),
        
        .fabric_rs1_o,
        .fabric_rs2_o,
        .fabric_result_i,
    );

    logic [63:0] time_counter;
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            time_counter <= '0;
        end else begin
            time_counter <= time_counter + 1;
        end
    end

    // ----------------------------
    // Manager buses into MUX
    // ----------------------------

    // Core instr bus
    sbr_obi_req_t core_instr_obi_req;
    sbr_obi_rsp_t core_instr_obi_rsp;
    assign core_instr_obi_req.a.aid = '0;
    assign core_instr_obi_req.a.we = '0;
    assign core_instr_obi_req.a.be = '1;
    assign core_instr_obi_req.a.wdata = '0;
    assign core_instr_obi_req.a.a_optional = '0;

    // Core data bus
    sbr_obi_req_t core_data_obi_req;
    sbr_obi_rsp_t core_data_obi_rsp;
    assign core_data_obi_req.a.aid = '0;
    assign core_data_obi_req.a.a_optional = '0;

    // ---------------------
    // Mux to Demux bus
    // ---------------------

    sbr_obi_req_t mux_demux_obi_req;
    sbr_obi_rsp_t mux_demux_obi_rsp;

    // -----------------
    // Manager buses
    // -----------------

    sbr_obi_req_t [NumManagers-1:0] mgrs_mux_obi_req;
    sbr_obi_rsp_t [NumManagers-1:0] mgrs_mux_obi_rsp;
    
    assign mgrs_mux_obi_req[ManagInstr] = core_instr_obi_req;
    assign core_instr_obi_rsp = mgrs_mux_obi_rsp[ManagInstr];

    assign mgrs_mux_obi_req[ManagData] = core_data_obi_req;
    assign core_data_obi_rsp = mgrs_mux_obi_rsp[ManagData];

    // -----------------
    // Peripheral buses
    // -----------------

    // array of subordinate buses from peripheral demultiplexer
    sbr_obi_req_t [NumPeriphs-1:0] all_periph_obi_req;
    sbr_obi_rsp_t [NumPeriphs-1:0] all_periph_obi_rsp;

    // Error bus
    sbr_obi_req_t error_obi_req;
    sbr_obi_rsp_t error_obi_rsp;

    // Flash bus
    sbr_obi_req_t flash_obi_req;
    sbr_obi_rsp_t flash_obi_rsp;
    
    // Sram bus
    sbr_obi_req_t sram_obi_req;
    sbr_obi_rsp_t sram_obi_rsp;
    
    // Psram bus
    sbr_obi_req_t psram_obi_req;
    sbr_obi_rsp_t psram_obi_rsp;

    // Uart0 bus
    sbr_obi_req_t uart0_obi_req;
    sbr_obi_rsp_t uart0_obi_rsp;
    
    // FabricConfig bus
    sbr_obi_req_t fabric_config_obi_req;
    sbr_obi_rsp_t fabric_config_obi_rsp;
    
    // Fabric bus
    sbr_obi_req_t fabric_obi_req;
    sbr_obi_rsp_t fabric_obi_rsp;

    // Fanout to individual peripherals
    assign error_obi_req                          = all_periph_obi_req[PeriphError];
    assign all_periph_obi_rsp[PeriphError]        = error_obi_rsp;

    assign flash_obi_req                          = all_periph_obi_req[PeriphFlash];
    assign all_periph_obi_rsp[PeriphFlash]        = flash_obi_rsp;
    
    assign sram_obi_req                           = all_periph_obi_req[PeriphSram];
    assign all_periph_obi_rsp[PeriphSram]         = sram_obi_rsp;
    
    assign psram_obi_req                          = all_periph_obi_req[PeriphPsram];
    assign all_periph_obi_rsp[PeriphPsram]        = psram_obi_rsp;

    assign uart0_obi_req                          = all_periph_obi_req[PeriphUart0];
    assign all_periph_obi_rsp[PeriphUart0]        = uart0_obi_rsp;

    assign fabric_config_obi_req                  = all_periph_obi_req[PeriphFabricConfig];
    assign all_periph_obi_rsp[PeriphFabricConfig] = fabric_config_obi_rsp;

    assign fabric_obi_req                         = all_periph_obi_req[PeriphFabric];
    assign all_periph_obi_rsp[PeriphFabric]       = fabric_obi_rsp;

    // Instruction memory interface
    logic                          instr_req_o;
    logic                          instr_gnt_i;
    logic                          instr_rvalid_i;
    logic [31:0]                   instr_addr_o;
    logic [31:0]                   instr_rdata_i;
    logic                          instr_err_i;

    // Data memory interface
    logic                          data_req_o;
    logic                          data_gnt_i;
    logic                          data_rvalid_i;
    logic [31:0]                   data_addr_o;
    logic [3:0]                    data_be_o;
    logic                          data_we_o;
    logic [31:0]                   data_wdata_o;
    logic [31:0]                   data_rdata_i;
    logic                          data_err_i;

    // Instruction memory interface
    assign instr_req_o        = core_instr_obi_req.req;
    assign instr_gnt_i        = core_instr_obi_rsp.gnt;
    assign instr_rvalid_i     = core_instr_obi_rsp.rvalid;
    assign instr_addr_o       = core_instr_obi_req.a.addr;
    assign instr_rdata_i      = core_instr_obi_rsp.r.rdata;
    assign instr_err_i        = core_instr_obi_rsp.r.err;

    // Data memory interface
    assign data_req_o         = core_data_obi_req.req;
    assign data_gnt_i         = core_data_obi_rsp.gnt;
    assign data_rvalid_i      = core_data_obi_rsp.rvalid;
    assign data_addr_o        = core_data_obi_req.a.addr;
    assign data_be_o          = core_data_obi_req.a.be;
    assign data_we_o          = core_data_obi_req.a.we;
    assign data_wdata_o       = core_data_obi_req.a.wdata;
    assign data_rdata_i       = core_data_obi_rsp.r.rdata;
    assign data_err_i         = core_data_obi_rsp.r.err;

    // Interrupt sources
    logic [31:0] irq;
    logic uart0_irq;
    assign irq = {11'b0, uart0_irq, fabric_irq_i, 16'b0};

    cv32e40x_core
    #(
      .RV32                  ( RV32I                 ),
      .A_EXT                 ( A                     ),
      .B_EXT                 ( ZBA_ZBB_ZBC_ZBS       ),
      .M_EXT                 ( M                     ),
      .DEBUG                 ( 0                     ),
      .DM_REGION_START       ( '0                    ),
      .DM_REGION_END         ( '0                    ),
      .DBG_NUM_TRIGGERS      ( 0                     ),
      .PMA_NUM_REGIONS       ( NumPMARules           ),
      .PMA_CFG               ( pma_cfg               ),
      .X_EXT                 ( 1                     ),
      .CLIC                  ( 0                     ), // CLINT
    ) cv32e40x_core (
      // Clock and reset
      .clk_i                 ( clk_i                 ),
      .rst_ni                ( rst_ni                ),
      .scan_cg_en_i          ( 1'b0                  ),

      // Static configuration
      .boot_addr_i           ( BootAddr              ),
      .dm_exception_addr_i   ( '0                    ),
      .dm_halt_addr_i        ( '0                    ),
      .mhartid_i             ( HartId                ),
      .mimpid_patch_i        ( 4'b0                  ),
      .mtvec_addr_i          ( MtvecAddr             ),

      // Instruction memory interface
     .instr_req_o            ( core_instr_obi_req.req     ),
     .instr_gnt_i            ( core_instr_obi_rsp.gnt     ),
     .instr_rvalid_i         ( core_instr_obi_rsp.rvalid  ),
     .instr_addr_o           ( core_instr_obi_req.a.addr  ),
     .instr_memtype_o        (                            ),
     .instr_prot_o           (                            ),
     .instr_dbg_o            (                            ),
     .instr_rdata_i          ( core_instr_obi_rsp.r.rdata ),
     .instr_err_i            ( core_instr_obi_rsp.r.err   ),

      // Data memory interface
     .data_req_o             ( core_data_obi_req.req     ),
     .data_gnt_i             ( core_data_obi_rsp.gnt     ),
     .data_rvalid_i          ( core_data_obi_rsp.rvalid  ),
     .data_addr_o            ( core_data_obi_req.a.addr  ),
     .data_be_o              ( core_data_obi_req.a.be    ),
     .data_we_o              ( core_data_obi_req.a.we    ),
     .data_wdata_o           ( core_data_obi_req.a.wdata ),
     .data_memtype_o         (                           ),
     .data_prot_o            (                           ),
     .data_dbg_o             (                           ),
     .data_atop_o            (                           ),
     .data_rdata_i           ( core_data_obi_rsp.r.rdata ),
     .data_err_i             ( core_data_obi_rsp.r.err   ),
     .data_exokay_i          ( 1'b1                      ),

      // Cycle count
      .mcycle_o              (                       ),

      // Time input
      .time_i                ( time_counter          ),

      // eXtension interface
      .xif_compressed_if     ( ext_if                ),
      .xif_issue_if          ( ext_if                ),
      .xif_commit_if         ( ext_if                ),
      .xif_mem_if            ( ext_if                ),
      .xif_mem_result_if     ( ext_if                ),
      .xif_result_if         ( ext_if                ),

      // Basic interrupt architecture
      .irq_i                 ( irq                   ),

      // Event wakeup signals
      .wu_wfe_i              ( 1'b0                  ),

      // CLIC interrupt architecture
      .clic_irq_i            ( 1'b0                  ),
      .clic_irq_id_i         ( '0                    ),
      .clic_irq_level_i      ( 8'h0                  ),
      .clic_irq_priv_i       ( 2'h0                  ),
      .clic_irq_shv_i        ( 1'b0                  ),

      // Fence.i flush handshake
      .fencei_flush_req_o    (                       ),
      .fencei_flush_ack_i    ( 1'b1                  ),

      // Debug interface
      .debug_req_i           ( 1'b0                  ),
      .debug_havereset_o     (                       ),
      .debug_running_o       (                       ),
      .debug_halted_o        (                       ),
      .debug_pc_valid_o      (                       ),
      .debug_pc_o            (                       ),

      // CPU control signals
      .fetch_enable_i        ( fetch_enable_i        ),
      .core_sleep_o          ( core_sleep_o          )
    );

    // Multiplexer - Core Data / Instr
    
  obi_mux #(
    .SbrPortObiCfg      ( SbrObiCfg     ),
    
    .sbr_port_obi_req_t   ( sbr_obi_req_t ),
    .sbr_port_a_chan_t    ( sbr_obi_a_chan_t ),
    .sbr_port_obi_rsp_t   ( sbr_obi_rsp_t ),
    .sbr_port_r_chan_t    ( sbr_obi_r_chan_t ),
    
    .NumSbrPorts ( NumManagers   ),
    .NumMaxTrans ( 1             ) // TODO was 2
  ) i_obi_mux (
    .clk_i      ( clk_i  ),
    .rst_ni     ( rst_ni ),
    .testmode_i ( 1'b0   ),

    .sbr_ports_req_i   ( mgrs_mux_obi_req  ),
    .sbr_ports_rsp_o   ( mgrs_mux_obi_rsp  ),

    .mgr_port_req_o    ( mux_demux_obi_req ),
    .mgr_port_rsp_i    ( mux_demux_obi_rsp )
  );

  // -----------------
  // Peripherals
  // -----------------

  // demultiplex to peripherals according to address map
  logic [cf_math_pkg::idx_width(NumPeriphs)-1:0] periph_idx;

  // iverilog doesn't like addr_decode:
  // error: A reference to a net or variable (`i') is not allowed in a constant expression.
  /*addr_decode #(
    .NoIndices ( NumPeriphs                     ),
    .NoRules   ( NumPeriphRules                 ),
    .addr_t    ( logic[SbrObiCfg.DataWidth-1:0] ),
    .rule_t    ( addr_map_rule_t                ),
    .Napot     ( 1'b0                           )
  ) i_addr_decode_periphs (
    .addr_i           ( mux_demux_obi_req.a.addr  ),
    .addr_map_i       ( periph_addr_map             ),
    .idx_o            ( periph_idx                  ),
    .dec_valid_o      (),
    .dec_error_o      (),
    .en_default_idx_i ( 1'b1 ),
    .default_idx_i    ( '0 )
  );*/
  
  // simple but effective
  always_comb begin
    // default
    periph_idx = 0;
    
    // last rule wins
    for (int i=0; i<NumPeriphRules; i++) begin
        if ((mux_demux_obi_req.a.addr >= periph_addr_map[i].start_addr) &&
        ((mux_demux_obi_req.a.addr < periph_addr_map[i].end_addr) || (periph_addr_map[i].end_addr == '0))) periph_idx = periph_addr_map[i].idx;
    end
  end
  
  logic [31:0] mux_demux_obi_req_a_addr;
  assign mux_demux_obi_req_a_addr = mux_demux_obi_req.a.addr;

  obi_demux #(
    .ObiCfg      ( SbrObiCfg     ),
    .obi_req_t   ( sbr_obi_req_t ),
    .obi_rsp_t   ( sbr_obi_rsp_t ),
    .NumMgrPorts ( NumPeriphs    ),
    .NumMaxTrans ( 1             ) // TODO was 2
  ) i_obi_demux (
    .clk_i  ( clk_i  ),
    .rst_ni ( rst_ni ),

    .sbr_port_select_i ( periph_idx         ),
    .sbr_port_req_i    ( mux_demux_obi_req  ),
    .sbr_port_rsp_o    ( mux_demux_obi_rsp  ),

    .mgr_ports_req_o   ( all_periph_obi_req ),
    .mgr_ports_rsp_i   ( all_periph_obi_rsp )
  );

  // Peripheral space error subordinate
  obi_err_sbr #(
    .ObiCfg      ( SbrObiCfg     ),
    .obi_req_t   ( sbr_obi_req_t ),
    .obi_rsp_t   ( sbr_obi_rsp_t ),
    .NumMaxTrans ( 1             ), // TODO 2 as above?
    .RspData     ( 32'hBADCAB1E  )
  ) i_periph_err (
    .clk_i      ( clk_i ),
    .rst_ni     ( rst_ni ),
    .testmode_i ( 1'b0 ),
    .obi_req_i  ( error_obi_req ),
    .obi_rsp_o  ( error_obi_rsp )
  );

    // QSPI XIP
    
    `ifdef PnR

    logic                flash_HSEL;
    logic [31:0]         flash_HADDR;
    logic [1:0]          flash_HTRANS;
    logic                flash_HWRITE;
    logic                flash_HREADY;
    logic                flash_HREADYOUT;
    logic [31:0]         flash_HRDATA;
    
    obi2ahbm_adapter i_obi2ahbm_adapter_flash (
       // Clock and reset
       .hclk_i      ( clk_i ),                // (I) AHB clock
       .hresetn_i   ( rst_ni ),               // (I) AHB reset, active LOW
       
       // AHB master interface
       .haddr_o       ( flash_HADDR ),        // (O) 32-bit AHB system address bus
       .hburst_o      (  ),                   // (O) Burst type 
       .hmastlock_o   (  ),                   // (O) Sequence lock
       .hprot_o       (  ),                   // (O) Protection control
       .hsize_o       (  ),                   // (O) Transfer size
       .htrans_o      ( flash_HTRANS ),       // (O) Transfer type
       .hwdata_o      (  ),                   // (O) 32-bit AHB write data bus
       .hwrite_o      ( flash_HWRITE ),       // (O) Transfer direction
       .hrdata_i      ( flash_HRDATA ),       // (I) 32-bit AHB read data bus
       .hready_i      ( flash_HREADYOUT ),    // (I) Status of transfer
       .hresp_i       ( 1'b0 ), // No error   // (I) Transfer response
       
       // Data interface from core
       .data_req_i    ( flash_obi_req.req ),     // (I) Request ready
       .data_gnt_o    ( flash_obi_rsp.gnt ),     // (O) The other side accepted the request
       .data_rvalid_o ( flash_obi_rsp.rvalid ),  // (O) Read data valid when high
       .data_we_i     ( flash_obi_req.a.we ),    // (I) Write enable (active HIGH)
       .data_be_i     ( flash_obi_req.a.be ),    // (I) Byte enable
       .data_addr_i   ( flash_obi_req.a.addr ),  // (I) Address
       .data_wdata_i  ( flash_obi_req.a.wdata ), // (I) Write data
       .data_rdata_o  ( flash_obi_rsp.r.rdata ), // (O) Read data
       .data_err_o    ( flash_obi_rsp.r.err ),   // (O) Error
       .pending_dbus_xfer_i   ( 1'b0 ), // TODO (I) Asserted if data bus is busy from other transactions

       // Miscellaneous
       .priv_mode_i   ( 1'b1 )       // (I) Privilege mode (from core. 1=machine mode, 0=user mode)
    );
    
    assign flash_HSEL = periph_idx == PeriphFlash; // TODO
    assign flash_HREADY = flash_HREADYOUT; //flash_obi_req.req; // TODO

    assign flash_obi_rsp.r.rid = flash_obi_req.a.aid; // TODO passthrough?
    assign flash_obi_rsp.r.r_optional = 1'b0;
    
    EF_QSPI_XIP_CTRL_AHBL 
    #(
        .NUM_LINES      ( 8 ), 
        .LINE_SIZE      ( 32 ), 
        .RESET_CYCLES   ( 999 ) 
    )
    i_EF_QSPI_XIP_CTRL_AHBL
    (
        // AHB-Lite Slave Interface
        .HCLK        ( clk_i  ),
        .HRESETn     ( rst_ni ),

        .HSEL        ( flash_HSEL      ),
        .HADDR       ( flash_HADDR     ),
        .HTRANS      ( flash_HTRANS    ),
        .HWRITE      ( flash_HWRITE    ),
        .HREADY      ( flash_HREADY    ),
        .HREADYOUT   ( flash_HREADYOUT ),
        .HRDATA      ( flash_HRDATA    ),

        // External Interface to Quad I/O
        .sck     ( flash_sck    ),
        .ce_n    ( flash_ce_n   ),
        .din     ( flash_din    ),
        .dout    ( flash_dout   ),
        .douten  ( flash_douten )
    );
    
    `else
    
    // Use a ROM for FPGA
    
    localparam RomAddrWidth = 12; // in words, in total 16kByte memory

    logic rom_req, rom_we, rom_gnt, rom_single_err;
    logic [SbrObiCfg.AddrWidth-1:0] rom_byte_addr;
    logic [RomAddrWidth-1:0] rom_word_addr;
    logic [SbrObiCfg.DataWidth-1:0] rom_wdata, rom_rdata;
    logic [SbrObiCfg.DataWidth/8-1:0] rom_be;

    obi_sram_shim #(
      .ObiCfg    ( SbrObiCfg     ),
      .obi_req_t ( sbr_obi_req_t ),
      .obi_rsp_t ( sbr_obi_rsp_t )
    ) i_rom_shim (
      .clk_i,
      .rst_ni,

      .obi_req_i ( flash_obi_req ),
      .obi_rsp_o ( flash_obi_rsp ),

      .req_o   ( rom_req       ),
      .we_o    ( rom_we        ),
      .addr_o  ( rom_byte_addr ),
      .wdata_o ( rom_wdata     ),
      .be_o    ( rom_be        ),

      .gnt_i   ( rom_gnt   ),
      .rdata_i ( rom_rdata )
    );

    assign rom_word_addr = rom_byte_addr[SbrObiCfg.AddrWidth-1:2];

    // 4kByte memory
    logic [31:0] rom [2**RomAddrWidth];
    
    	initial begin
		$readmemh("firmware/hello_world/hello_world.hex", rom);
	end
    
    always @(posedge clk_i) begin
        if (rom_req) begin
            if (!rom_we) begin
                rom_rdata <= rom[rom_word_addr];
            end
        end
    end

    assign rom_gnt = 1'b1;
    
    `endif
    
    // SRAM

    logic bank_gnt;
    logic [SbrObiCfg.AddrWidth-1:0] bank_byte_addr;

    obi_sram_shim #(
      .ObiCfg    ( SbrObiCfg     ),
      .obi_req_t ( sbr_obi_req_t ),
      .obi_rsp_t ( sbr_obi_rsp_t )
    ) i_sram_shim (
      .clk_i,
      .rst_ni,

      .obi_req_i ( sram_obi_req ),
      .obi_rsp_o ( sram_obi_rsp ),

      .req_o   ( bank_req_o       ),
      .we_o    ( bank_we_o        ),
      .addr_o  ( bank_byte_addr ),
      .wdata_o ( bank_wdata_o     ),
      .be_o    ( bank_be_o        ),

      .gnt_i   ( bank_gnt     ),
      .rdata_i ( bank_rdata_i )
    );

    assign bank_word_addr_o = bank_byte_addr[SbrObiCfg.AddrWidth-1:2];
    assign bank_gnt = 1'b1;
    
    // PSRAM
    
    logic                psram_HSEL;
    logic [31:0]         psram_HADDR;
    logic [1:0]          psram_HTRANS;
    logic [2:0]          psram_HSIZE;
    logic [31:0]         psram_HWDATA;
    logic                psram_HWRITE;
    logic                psram_HREADY;
    logic                psram_HREADYOUT;
    logic [31:0]         psram_HRDATA;
    
    obi2ahbm_adapter i_obi2ahbm_adapter_psram (
       // Clock and reset
       .hclk_i      ( clk_i ),                // (I) AHB clock
       .hresetn_i   ( rst_ni ),               // (I) AHB reset, active LOW
       
       // AHB master interface
       .haddr_o       ( psram_HADDR ),        // (O) 32-bit AHB system address bus
       .hburst_o      (  ),                   // (O) Burst type 
       .hmastlock_o   (  ),                   // (O) Sequence lock
       .hprot_o       (  ),                   // (O) Protection control
       .hsize_o       ( psram_HSIZE ),        // (O) Transfer size
       .htrans_o      ( psram_HTRANS ),       // (O) Transfer type
       .hwdata_o      ( psram_HWDATA ),       // (O) 32-bit AHB write data bus
       .hwrite_o      ( psram_HWRITE ),       // (O) Transfer direction
       .hrdata_i      ( psram_HRDATA ),       // (I) 32-bit AHB read data bus
       .hready_i      ( psram_HREADYOUT ),    // (I) Status of transfer
       .hresp_i       ( 1'b0 ), // No error   // (I) Transfer response
       
       // Data interface from core
       .data_req_i    ( psram_obi_req.req ),     // (I) Request ready
       .data_gnt_o    ( psram_obi_rsp.gnt ),     // (O) The other side accepted the request
       .data_rvalid_o ( psram_obi_rsp.rvalid ),  // (O) Read data valid when high
       .data_we_i     ( psram_obi_req.a.we ),    // (I) Write enable (active HIGH)
       .data_be_i     ( psram_obi_req.a.be ),    // (I) Byte enable
       .data_addr_i   ( psram_obi_req.a.addr ),  // (I) Address
       .data_wdata_i  ( psram_obi_req.a.wdata ), // (I) Write data
       .data_rdata_o  ( psram_obi_rsp.r.rdata ), // (O) Read data
       .data_err_o    ( psram_obi_rsp.r.err ),   // (O) Error
       .pending_dbus_xfer_i   ( 1'b0 ), // TODO (I) Asserted if data bus is busy from other transactions

       // Miscellaneous
       .priv_mode_i   ( 1'b1 )       // (I) Privilege mode (from core. 1=machine mode, 0=user mode)
    );
    
    assign psram_HSEL = periph_idx == PeriphPsram; // TODO
    
    /*always_ff @(posedge clk_i) begin
        psram_HREADY <= psram_HREADYOUT; //psram_obi_req.req; // TODO
    end*/
    assign psram_HREADY = psram_HREADYOUT;

    assign psram_obi_rsp.r.rid = psram_obi_req.a.aid; // TODO passthrough?
    assign psram_obi_rsp.r.r_optional = 1'b0;
    
    // Using EBH Command
    EF_PSRAM_CTRL_AHBL i_EF_PSRAM_CTRL_AHBL
    (
        // AHB-Lite Slave Interface
        .HCLK        ( clk_i  ),
        .HRESETn     ( rst_ni ),

        .HSEL        ( psram_HSEL      ),
        .HADDR       ( psram_HADDR     ),
        .HWDATA      ( psram_HWDATA    ),
        .HTRANS      ( psram_HTRANS    ),
        .HSIZE       ( psram_HSIZE     ),
        .HWRITE      ( psram_HWRITE    ),
        .HREADY      ( psram_HREADY    ),
        .HREADYOUT   ( psram_HREADYOUT ),
        .HRDATA      ( psram_HRDATA    ),

        // External Interface to Quad I/O
        .sck     ( psram_sck    ),
        .ce_n    ( psram_ce_n   ),
        .din     ( psram_din    ),
        .dout    ( psram_dout   ),
        .douten  ( psram_douten )
    );

    // UART0
    
    logic                uart0_HSEL;
    logic [31:0]         uart0_HADDR;
    logic [1:0]          uart0_HTRANS;
    logic [2:0]          uart0_HSIZE;
    logic [31:0]         uart0_HWDATA;
    logic                uart0_HWRITE;
    logic                uart0_HREADY;
    logic                uart0_HREADYOUT;
    logic [31:0]         uart0_HRDATA;
    
    obi2ahbm_adapter i_obi2ahbm_adapter_uart0 (
       // Clock and reset
       .hclk_i      ( clk_i ),                // (I) AHB clock
       .hresetn_i   ( rst_ni ),               // (I) AHB reset, active LOW
       
       // AHB master interface
       .haddr_o       ( uart0_HADDR ),        // (O) 32-bit AHB system address bus
       .hburst_o      (  ),                   // (O) Burst type 
       .hmastlock_o   (  ),                   // (O) Sequence lock
       .hprot_o       (  ),                   // (O) Protection control
       .hsize_o       ( uart0_HSIZE ),        // (O) Transfer size
       .htrans_o      ( uart0_HTRANS ),       // (O) Transfer type
       .hwdata_o      ( uart0_HWDATA ),       // (O) 32-bit AHB write data bus
       .hwrite_o      ( uart0_HWRITE ),       // (O) Transfer direction
       .hrdata_i      ( uart0_HRDATA ),       // (I) 32-bit AHB read data bus
       .hready_i      ( uart0_HREADYOUT ),    // (I) Status of transfer
       .hresp_i       ( 1'b0 ), // No error   // (I) Transfer response
       
       // Data interface from core
       .data_req_i    ( uart0_obi_req.req ),     // (I) Request ready
       .data_gnt_o    ( uart0_obi_rsp.gnt ),     // (O) The other side accepted the request
       .data_rvalid_o ( uart0_obi_rsp.rvalid ),  // (O) Read data valid when high
       .data_we_i     ( uart0_obi_req.a.we ),    // (I) Write enable (active HIGH)
       .data_be_i     ( uart0_obi_req.a.be ),    // (I) Byte enable
       .data_addr_i   ( uart0_obi_req.a.addr ),  // (I) Address
       .data_wdata_i  ( uart0_obi_req.a.wdata ), // (I) Write data
       .data_rdata_o  ( uart0_obi_rsp.r.rdata ), // (O) Read data
       .data_err_o    ( uart0_obi_rsp.r.err ),   // (O) Error
       .pending_dbus_xfer_i   ( 1'b0 ), // TODO (I) Asserted if data bus is busy from other transactions

       // Miscellaneous
       .priv_mode_i   ( 1'b1 )       // (I) Privilege mode (from core. 1=machine mode, 0=user mode)
    );
    
    assign uart0_HSEL = periph_idx == PeriphUart0; // TODO write signal on UART is two cycles, depends on HSEL, HREADY
    assign uart0_HREADY = uart0_HREADYOUT;//uart0_obi_req.req; // TODO

    assign uart0_obi_rsp.r.rid = uart0_obi_req.a.aid; // TODO passthrough?
    assign uart0_obi_rsp.r.r_optional = 1'b0;

    EF_UART_AHBL i_EF_UART_AHBL (

        // AHB-Lite Slave Interface
        .HCLK        ( clk_i  ),
        .HRESETn     ( rst_ni ),

        .HSEL        ( uart0_HSEL      ),
        .HADDR       ( uart0_HADDR     ),
        .HWDATA      ( uart0_HWDATA    ),
        .HTRANS      ( uart0_HTRANS    ),
        .HWRITE      ( uart0_HWRITE    ),
        .HREADY      ( uart0_HREADY    ),
        .HREADYOUT   ( uart0_HREADYOUT ),
        .HRDATA      ( uart0_HRDATA    ),

        .IRQ         ( uart0_irq ), 

        .rx          ( uart0_rx ),
        .tx          ( uart0_tx )
    );

    // FabricConfig Peripheral
    localparam REG_XIF_OR_PERIPH        = 4'd0;
    localparam REG_FABRIC_CONFIG_BUSY   = 4'd4;
    localparam REG_BITSTREAM            = 4'd8;
    localparam REG_TRIGGER_SLOT         = 4'd12;
    
    logic [  32-1:0] debug_fabric_config_req;
    logic [  32-1:0] debug_fabric_config_addr;
    logic            debug_fabric_config_we;
    logic [32/8-1:0] debug_fabric_config_be;
    logic [  32-1:0] debug_fabric_config_wdata;
    logic [   1-1:0] debug_fabric_config_aid;
    logic            debug_fabric_config_a_optional;

    assign debug_fabric_config_req        = fabric_config_obi_req.req;
    assign debug_fabric_config_addr       = fabric_config_obi_req.a.addr;
    assign debug_fabric_config_we         = fabric_config_obi_req.a.we;
    assign debug_fabric_config_be         = fabric_config_obi_req.a.be;
    assign debug_fabric_config_wdata      = fabric_config_obi_req.a.wdata;
    assign debug_fabric_config_aid        = fabric_config_obi_req.a.aid;
    assign debug_fabric_config_a_optional = fabric_config_obi_req.a.a_optional;
    
    logic          debug_fabric_config_gnt;
    logic          debug_fabric_config_rvalid;
    logic [32-1:0] debug_fabric_config_rdata;
    logic [ 1-1:0] debug_fabric_config_rid;
    logic          debug_fabric_config_err;
    logic          debug_fabric_config_r_optional;

    assign debug_fabric_config_gnt        = fabric_config_obi_rsp.gnt;
    assign debug_fabric_config_rvalid     = fabric_config_obi_rsp.rvalid;
    assign debug_fabric_config_rdata      = fabric_config_obi_rsp.r.rdata;
    assign debug_fabric_config_rid        = fabric_config_obi_rsp.r.rid;
    assign debug_fabric_config_err        = fabric_config_obi_rsp.r.err;
    assign debug_fabric_config_r_optional = fabric_config_obi_rsp.r.r_optional;
    
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            xif_or_periph_o     <= 1'b0;
            bitstream_valid_o   <= 1'b0;
            bitstream_data_o    <= '0;
            warmboot_boot_o   <= 1'b0;
            warmboot_slot_o   <= '0;
        end else begin
            fabric_config_obi_rsp.rvalid <= 1'b0;
            
            bitstream_valid_o <= 1'b0;
            warmboot_boot_o <= 1'b0;
            
            if (fabric_config_obi_req.req) begin
            
                fabric_config_obi_rsp.rvalid <= 1'b1;
                
                // Write
                if (fabric_config_obi_req.a.we) begin
                    
                    if (fabric_config_obi_req.a.addr[3:0] == REG_XIF_OR_PERIPH) begin
                        if (fabric_config_obi_req.a.be[0]) xif_or_periph_o <= fabric_config_obi_req.a.wdata[0];
                    end
                    
                    if (fabric_config_obi_req.a.addr[3:0] == REG_BITSTREAM) begin
                        if (fabric_config_obi_req.a.be[0]) bitstream_data_o[ 7: 0] <= fabric_config_obi_req.a.wdata[7 : 0];
                        if (fabric_config_obi_req.a.be[1]) bitstream_data_o[15: 8] <= fabric_config_obi_req.a.wdata[15: 8];
                        if (fabric_config_obi_req.a.be[2]) bitstream_data_o[23:16] <= fabric_config_obi_req.a.wdata[23:16];
                        if (fabric_config_obi_req.a.be[3]) bitstream_data_o[31:24] <= fabric_config_obi_req.a.wdata[31:24];

                        bitstream_valid_o <= 1'b1;
                    end
                    
                    if (fabric_config_obi_req.a.addr[3:0] == REG_TRIGGER_SLOT) begin
                        if (fabric_config_obi_req.a.be[0]) warmboot_slot_o <= fabric_config_obi_req.a.wdata[3 : 0];

                        warmboot_boot_o <= 1'b1;
                    end
                // Read
                end else begin
                    fabric_config_obi_rsp.r.rdata <= '0;
                    if (fabric_config_obi_req.a.addr[3:0] == REG_FABRIC_CONFIG_BUSY) begin
                        fabric_config_obi_rsp.r.rdata <= {31'd0, fabric_config_busy_i};
                    end
                end
            end
        end
    end
    
    assign fabric_config_obi_rsp.gnt = 1'b1;
    
    assign fabric_config_obi_rsp.r.err = 1'b0;
    assign fabric_config_obi_rsp.r.rid = fabric_config_obi_req.a.aid;
    assign fabric_config_obi_rsp.r.r_optional = 1'b0;
    
    // Fabric Peripheral
    
    assign fabric_obi_rsp.gnt            = fabric_gnt_i;
    assign fabric_req_o                  = fabric_obi_req.req;
    assign fabric_obi_rsp.rvalid         = fabric_rvalid_i;
    assign fabric_we_o                   = fabric_obi_req.a.we;
    assign fabric_be_o                   = fabric_obi_req.a.be;
    assign fabric_addr_o                 = fabric_obi_req.a.addr[23:0];
    assign fabric_wdata_o                = fabric_obi_req.a.wdata;
    assign fabric_obi_rsp.r.rdata        = fabric_rdata_i;

    assign fabric_obi_rsp.r.err = 1'b0;
    assign fabric_obi_rsp.r.rid = fabric_obi_req.a.aid;
    assign fabric_obi_rsp.r.r_optional = 1'b0;
    
    logic [  32-1:0] debug_fabric_req;
    logic [  32-1:0] debug_fabric_addr;
    logic            debug_fabric_we;
    logic [32/8-1:0] debug_fabric_be;
    logic [  32-1:0] debug_fabric_wdata;
    logic [   1-1:0] debug_fabric_aid;
    logic            debug_fabric_a_optional;

    assign debug_fabric_req        = fabric_obi_req.req;
    assign debug_fabric_addr       = fabric_obi_req.a.addr;
    assign debug_fabric_we         = fabric_obi_req.a.we;
    assign debug_fabric_be         = fabric_obi_req.a.be;
    assign debug_fabric_wdata      = fabric_obi_req.a.wdata;
    assign debug_fabric_aid        = fabric_obi_req.a.aid;
    assign debug_fabric_a_optional = fabric_obi_req.a.a_optional;
    
    logic          debug_fabric_gnt;
    logic          debug_fabric_rvalid;
    logic [32-1:0] debug_fabric_rdata;
    logic [ 1-1:0] debug_fabric_rid;
    logic          debug_fabric_err;
    logic          debug_fabric_r_optional;

    assign debug_fabric_gnt        = fabric_obi_rsp.gnt;
    assign debug_fabric_rvalid     = fabric_obi_rsp.rvalid;
    assign debug_fabric_rdata      = fabric_obi_rsp.r.rdata;
    assign debug_fabric_rid        = fabric_obi_rsp.r.rid;
    assign debug_fabric_err        = fabric_obi_rsp.r.err;
    assign debug_fabric_r_optional = fabric_obi_rsp.r.r_optional;

endmodule

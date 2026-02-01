package soc_pkg;

    localparam int unsigned HartId = 32'd0;

    localparam int unsigned BootAddr = 32'h0000_0080;

    // Machine Trap-Vector Base Address, 128-byte aligned
    localparam int unsigned MtvecAddr = 32'h0000_0000;

    ///////////////////////
    // Managers         ///
    ///////////////////////

    localparam int unsigned NumManagers = 3; // Instr, data, debug

    // Enum for bus indices
    typedef enum int {
        ManagInstr     = 0,
        ManagData      = 1,
        ManagDbg       = 2
    } manage_outputs_e;

    ///////////////////////
    // Address Maps     ///
    ///////////////////////

    // Address map data type
    typedef struct packed {
        logic [31:0] idx;
        logic [31:0] start_addr;
        logic [31:0] end_addr;
    } addr_map_rule_t;

    /////////////////////////////
    // Peripheral address map ///
    /////////////////////////////

    localparam bit [31:0] FlashAddrOffset           = 32'h0000_0000;
    localparam bit [31:0] FlashAddrRange            = 32'h0100_0000; // 24bit

    localparam bit [31:0] SramAddrOffset            = 32'h1000_0000;
    localparam bit [31:0] SramAddrRange             = 32'h0000_2000; // 8kB

    localparam bit [31:0] PsramAddrOffset           = 32'h2000_0000;
    localparam bit [31:0] PsramAddrRange            = 32'h0100_0000; // 24bit

    localparam bit [31:0] Uart0AddrOffset           = 32'h3000_0000;
    localparam bit [31:0] Uart0AddrRange            = 32'h0001_0000;
    
    localparam bit [31:0] FabricConfigAddrOffset    = 32'h4000_0000;
    localparam bit [31:0] FabricConfigAddrRange     = 32'h0000_0100;
    
    localparam bit [31:0] FabricAddrOffset          = 32'h5000_0000;
    localparam bit [31:0] FabricAddrRange           = 32'h0100_0000; // 24bit

    localparam bit [31:0] DbgAddrOffset             = 32'h6000_0000;
    localparam bit [31:0] DbgAddrRange              = 32'h0000_1000; // ROM starts at 0x800 and is 160 byte


    localparam int unsigned NumPeriphRules  = 7;
    localparam int unsigned NumPeriphs      = NumPeriphRules + 1; // additional OBI error

    // Enum for bus indices
    typedef enum int {
        PeriphError         = 0,
        PeriphFlash         = 1,
        PeriphSram          = 2,
        PeriphPsram         = 3,
        PeriphUart0         = 4,
        PeriphFabricConfig  = 5,
        PeriphFabric        = 6,
        PeriphDbg           = 7
    } periph_outputs_e;

    localparam addr_map_rule_t [NumPeriphRules-1:0] periph_addr_map = '{                                  // 0: OBI Error (default)
        '{ idx: PeriphDbg,    start_addr: DbgAddrOffset,    end_addr: DbgAddrOffset  + DbgAddrRange},     // 1: Dbg
        '{ idx: PeriphFlash,  start_addr: FlashAddrOffset,  end_addr: FlashAddrOffset + FlashAddrRange }, // 2: Flash
        '{ idx: PeriphSram,   start_addr: SramAddrOffset,   end_addr: SramAddrOffset  + SramAddrRange  }, // 3: Sram
        '{ idx: PeriphPsram,  start_addr: PsramAddrOffset,  end_addr: PsramAddrOffset + PsramAddrRange }, // 4: Psram
        '{ idx: PeriphUart0,  start_addr: Uart0AddrOffset,  end_addr: Uart0AddrOffset + Uart0AddrRange }, // 5: Uart0
        '{ idx: PeriphFabricConfig,  start_addr: FabricConfigAddrOffset,  end_addr: FabricConfigAddrOffset + FabricConfigAddrRange}, // 6: FabricConfig
        '{ idx: PeriphFabric, start_addr: FabricAddrOffset, end_addr: FabricAddrOffset + FabricAddrRange}// 7: Fabric
        
    };

    // PMA configuration
    localparam int unsigned NumPMARules = NumPeriphRules;

    // Lowest index has priority
    // No match: main=0, bufferable=0, cacheable=0, atomic=0
    localparam cv32e40x_pkg::pma_cfg_t pma_cfg [NumPMARules] = '{
        '{word_addr_low: FlashAddrOffset>>2, word_addr_high: (FlashAddrOffset + FlashAddrRange)>>2, main: 1'b1, bufferable: 1'b1, cacheable: 1'b1, atomic: 1'b1},
        '{word_addr_low: SramAddrOffset>>2,  word_addr_high: (SramAddrOffset + SramAddrRange)>>2,   main: 1'b1, bufferable: 1'b1, cacheable: 1'b1, atomic: 1'b1},
        '{word_addr_low: PsramAddrOffset>>2, word_addr_high: (PsramAddrOffset + PsramAddrRange)>>2, main: 1'b1, bufferable: 1'b1, cacheable: 1'b1, atomic: 1'b1},
        '{word_addr_low: Uart0AddrOffset>>2, word_addr_high: (Uart0AddrOffset + Uart0AddrRange)>>2, main: 1'b0, bufferable: 1'b0, cacheable: 1'b0, atomic: 1'b0},
        '{word_addr_low: FabricConfigAddrOffset>>2, word_addr_high: (FabricConfigAddrOffset + FabricConfigAddrRange)>>2, main: 1'b0, bufferable: 1'b0, cacheable: 1'b0, atomic: 1'b0},
        '{word_addr_low: FabricAddrOffset>>2, word_addr_high: (FabricAddrOffset + FabricAddrRange)>>2, main: 1'b1, bufferable: 1'b0, cacheable: 1'b0, atomic: 1'b0},
        '{word_addr_low: DbgAddrOffset>>2,   word_addr_high: (DbgAddrOffset + DbgAddrRange)>>2,     main: 1'b1, bufferable: 1'b0, cacheable: 1'b0, atomic: 1'b0}
    };

    // ---------------------------------------------

    /// OBI subordinate configuration (from the interconnect to a subordinate device)
    localparam obi_pkg::obi_cfg_t SbrObiCfg = '{
          UseRReady:   1'b0,
          CombGnt:     1'b0,
          AddrWidth:     32,
          DataWidth:     32,
          // One manager
          IdWidth:        1,
          Integrity:   1'b0,
          BeFull:      1'b1,
          OptionalCfg:  '0
      };


    /// OBI Xbar <-> Subordinate address channel
    typedef struct packed {
        logic [  SbrObiCfg.AddrWidth-1:0] addr;
        logic                             we;
        logic [SbrObiCfg.DataWidth/8-1:0] be;
        logic [  SbrObiCfg.DataWidth-1:0] wdata;
        logic [    SbrObiCfg.IdWidth-1:0] aid;
        logic                             a_optional; // dummy signal; not used
    } sbr_obi_a_chan_t;

    /// OBI Xbar <-> Subordinate request
    typedef struct packed {
        sbr_obi_a_chan_t a;
        logic            req;
    } sbr_obi_req_t;

    /// OBI Xbar <-> Subordinate response channel
    typedef struct packed {
        logic [SbrObiCfg.DataWidth-1:0] rdata;
        logic [  SbrObiCfg.IdWidth-1:0] rid;
        logic                           err;
        logic                           r_optional; // dummy signal; not used
    } sbr_obi_r_chan_t;

    /// OBI Xbar <-> Subordinate response
    typedef struct packed {
        sbr_obi_r_chan_t r;
        logic            gnt;
        logic            rvalid;
    } sbr_obi_rsp_t;

    /// JTAG <-> OBI hardware info 
    localparam dm::hartinfo_t HARTINFO = '{
        zero1: '0,
        nscratch: 2,
        zero0: '0,
        dataaccess: 1'b1,
        datasize: dm::DataCount,
        dataaddr: dm::DataAddr
    };

    // Default JTAG ID code type
    typedef struct packed {
        bit [ 3:0]  version;
        bit [15:0]  part_num;
        bit [10:0]  manufacturer;
        bit         _one;
    } jtag_idcode_t;

    // JTAG IDCODE TODO
    localparam bit [10:0] JtagGreyhoundManufacturer = 11'h0;
    localparam bit [15:0] JtagGreyhoundPartNumCore  = 16'h5256; // Core: RV (Risc-V)
    localparam bit [15:0] JtagGreyhoundPartNumFPGA  = 16'h4646; // Fpga: FF (Fabulous Fabric)
    localparam bit [ 3:0] JtagGreyhoundVersion      = 4'h0;
    localparam jtag_idcode_t GreyhoundJtagIdCodeCore = '{
        _one          : 1,
        manufacturer  : JtagGreyhoundManufacturer,
        part_num      : JtagGreyhoundPartNumCore,
        version       : JtagGreyhoundVersion
    };

    localparam jtag_idcode_t GreyhoundJtagIdCodeFPGA = '{
        _one          : 1,
        manufacturer  : JtagGreyhoundManufacturer,
        part_num      : JtagGreyhoundPartNumFPGA,
        version       : JtagGreyhoundVersion
    };

    // Supported boundary scan register length for the fabric fpga
    typedef enum logic [1:0] {
        None,       // No bsr is implemented run everything through the bypass register (0 bit)
        External,   // Only the bsr for the west IOs is implemented (64 bit)
        Internal,   // Only the bsr for the internal connections (cpu irq, cpu xif, cpu obi) are implemented (245 bit)
        All         // External and internal bsr are implemented (309 bit)
    } supported_bsr_e;

    localparam supported_bsr_e EnabledBSRLength = None;
endpackage

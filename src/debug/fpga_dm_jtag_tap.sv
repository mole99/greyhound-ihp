/* Copyright 2018 ETH Zurich and University of Bologna.
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the “License”); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * File:   fpga_dm_jtag_tap.sv
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   19.7.2018
 *
 * Modified by Stefan Huwar <stefan.huwar@gmail.com>
 *
 * Description: JTAG TAP for Fabulous Fabric compatible with IEEE 1149.1 and IEEE 1532 
 *
 */

module fpga_dm_jtag_tap import soc_pkg::*; #(
  parameter int unsigned IrLength = 5,
  // JTAG IDCODE Value
  parameter logic [31:0] IdcodeValue = 32'h00000001
  // xxxx             version
  // xxxxxxxxxxxxxxxx part number
  // xxxxxxxxxxx      manufacturer id
  // 1                required by standard
) (
  input  logic        clk_i,
  input  logic        jclk_rising_i,  // JTAG clk rising
  input  logic        jclk_falling_i, // JTAG clk falling
  input  logic        tms_i,    // JTAG test mode select pad
  input  logic        trst_n_sync_i,  // JTAG test reset pad
  input  logic        td_i,     // JTAG test data input pad
  output logic        td_o,     // JTAG test data output pad
  // Synchronous reset of the dmi module triggered by JTAG TAP
  output logic        dm_rst_o,
  // Control if jtag interface is enabled
  output logic        ejtag_o,
  output logic        ejtag_valid_o,
  input  logic        ejtag_i,
  // Usercode derived from FPGA program
  input  logic [31:0] usercode_i,
  // Fabric program bitstream register
  output logic        isc_pdata_valid_o,
  output logic [31:0] isc_pdata_o,
  input  logic        isc_ext_prog_i,
  input  logic        isc_ext_conf_i,
  // Boundary scan
  output logic        mode1_o,
  output logic        mode2_o,
  output logic        mode5_o,
  output logic        mode6_o,
  output logic        isc_highZ_o,
  output logic        boundary_scan_o,
  input  logic        boundary_scan_i,
  output logic        capture_bsr_select_o,
  output logic        shift_bsr_select_o,
  output logic        update_bsr_select_o,
  output logic        testmode_clk_pulse_o
);

  typedef enum logic [3:0] {
    TestLogicReset, RunTestIdle, SelectDrScan,
    CaptureDr, ShiftDr, Exit1Dr, PauseDr, Exit2Dr,
    UpdateDr, SelectIrScan, CaptureIr, ShiftIr,
    Exit1Ir, PauseIr, Exit2Ir, UpdateIr
  } tap_state_e;

  typedef enum logic [2:0] {
    Unprogrammed = 3'b000,
    IscAccessed  = 3'b1??,
    IscComplete  = 3'b0?1,
    Operational  = 3'b010
  } tap_isc_state_e;

  tap_state_e tap_state_q, tap_state_d;
  tap_isc_state_e tap_isc_state_q;
  logic update_dr_d, update_dr_q;
  logic update_dr, shift_dr, capture_dr;
  logic isc_enabled_q, isc_enabled_d;
  logic isc_done_q, isc_done_d;
  logic isc_disable_completing_q, isc_disable_completing_d;
  logic testmode;

  typedef enum logic [IrLength-1:0] {
    BYPASS0        = 'h0,
    IDCODE         = 'h1,
    USERCODE       = 'h2,
    SAMPLE_PRELOAD = 'h3,
    EXTEST         = 'h4,
    INTEST         = 'h5,
    EJTAG          = 'h10, // Enable JTAG pin functionality, set register to enable/disable jtag functionality
    ISC_ENABLE     = 'h14,
    ISC_DISABLE    = 'h15,
    ISC_PROGRAM    = 'h16,
    ISC_NOOP       = 'h17,
    BYPASS1        = 'h1f
  } ir_reg_e;

  // ----------------
  // IR logic
  // ----------------
  // shift register
  logic [IrLength-1:0]  jtag_ir_shift_d, jtag_ir_shift_q;
  // IR register -> this gets captured from shift register upon update_ir
  ir_reg_e jtag_ir_d, jtag_ir_q;
  logic capture_ir, shift_ir, update_ir, test_logic_reset;

  always_comb begin : p_jtag
    jtag_ir_shift_d = jtag_ir_shift_q;
    jtag_ir_d       = jtag_ir_q;

    // IR shift register
    if (shift_ir) begin
      jtag_ir_shift_d = {td_i, jtag_ir_shift_q[IrLength-1:1]};
    end

    // capture IR register
    if (capture_ir) begin
      jtag_ir_shift_d =  IrLength'(4'b0101);
    end

    // update IR register
    if (update_ir) begin
      jtag_ir_d = ir_reg_e'(jtag_ir_shift_q);
    end

    if (test_logic_reset) begin
      // Bring all TAP state to the initial value.
      jtag_ir_shift_d = '0;
      jtag_ir_d = IDCODE;
    end
  end

  always_ff @(posedge clk_i) begin : p_jtag_ir_reg
    if (!trst_n_sync_i) begin
      jtag_ir_shift_q <= '0;
      jtag_ir_q       <= IDCODE;
    end else if (jclk_rising_i) begin
      jtag_ir_shift_q <= jtag_ir_shift_d;
      jtag_ir_q       <= jtag_ir_d;
    end
  end

  // ----------------
  // TAP DR Regs
  // ----------------
  // - Bypass
  // - IDCODE
  // - USERCODE
  // - BOUNDARY SCAN
  // - EJTAG
  // - ISC_Default is implemented as the bypass reg as per IEEE1532
  // - ISC_PData
  logic [31:0] idcode_d, idcode_q;
  logic        idcode_select;
  logic        usercode_select;
  logic        boundary_scan_select;
  logic        bypass_select;
  logic        ejtag_select;
  logic [31:0] isc_pdata_d, isc_pdata_q;
  logic        isc_pdata_select;

  logic        isc_enable_select;
  logic        isc_disable_select;

  logic        bypass_d, bypass_q;  // this is a 1-bit register

  always_comb begin
    idcode_d          = idcode_q;
    bypass_d          = bypass_q;
    isc_pdata_d       = isc_pdata_q;
    isc_pdata_valid_o = 1'b0;
    ejtag_valid_o     = 1'b0;
    if (EnabledBSRLength != None) begin
      boundary_scan_o = boundary_scan_i;
    end
    else begin
      boundary_scan_o = 1'b0;
    end

    if (capture_dr) begin
      if (idcode_select)        idcode_d        = IdcodeValue;
      if (usercode_select)      idcode_d        = usercode_i;
      if (bypass_select)        bypass_d        = 1'b0;
      if (ejtag_select)         bypass_d        = ejtag_i;
      if (isc_pdata_select)     isc_pdata_d     = '0;
    end

    if (shift_dr) begin
      if (idcode_select)        idcode_d        = {td_i, 31'(idcode_q >> 1)};
      if (usercode_select)      idcode_d        = {td_i, 31'(idcode_q >> 1)};
      if (bypass_select)        bypass_d        = td_i;
      if (ejtag_select)         bypass_d        = td_i;
      if (isc_pdata_select)     isc_pdata_d     = {td_i, 31'(isc_pdata_q >> 1)};
      if (EnabledBSRLength == None) begin
        if (boundary_scan_select) bypass_d = td_i;
      end
      else begin
        if (boundary_scan_select) boundary_scan_o = td_i;
      end
    end

    if (update_dr) begin
      if (isc_pdata_select) isc_pdata_valid_o = isc_enabled_q; // Corresponds to sate IscAccessed
      if (ejtag_select)     ejtag_valid_o     = 1'b1;
    end

    if (test_logic_reset) begin
      // Bring all TAP state to the initial value.
      idcode_d        = IdcodeValue;
      bypass_d        = 1'b0;
      isc_pdata_d     = '0;
      if (EnabledBSRLength != None) begin
        boundary_scan_o = '0;
      end
    end
  end

  // ----------------
  // Data reg select
  // ----------------
  always_comb begin : p_data_reg_sel
    idcode_select        = 1'b0;
    usercode_select      = 1'b0;
    bypass_select        = 1'b0;
    ejtag_select         = 1'b0;
    isc_pdata_select     = 1'b0;
    boundary_scan_select = 1'b0;

    unique case (jtag_ir_q)
      BYPASS0:        bypass_select        = 1'b1;
      IDCODE:         idcode_select        = 1'b1;
      USERCODE:       usercode_select      = 1'b1;
      SAMPLE_PRELOAD: boundary_scan_select = 1'b1;
      EXTEST:         boundary_scan_select = 1'b1;
      INTEST:         boundary_scan_select = 1'b1;
      EJTAG:          ejtag_select         = 1'b1;
      ISC_ENABLE:     bypass_select        = 1'b1;
      ISC_DISABLE:    bypass_select        = 1'b1;
      ISC_PROGRAM:    isc_pdata_select     = 1'b1;
      ISC_NOOP:       bypass_select        = 1'b1;
      BYPASS1:        bypass_select        = 1'b1;
      default:        bypass_select        = 1'b1;
    endcase
  end

  // ----------------
  // Mode select for IEEE
  // ---------------
  logic testmode_clk_pulse_q, testmode_clk_pulse_d, testmode_clk_pulseo_d;
  logic isc_highZ_d, isc_highZ_q;
  logic capture_bsr_select_d, shift_bsr_select_d, update_bsr_select_d, testmode_d;

  if (EnabledBSRLength == None) begin
    assign capture_bsr_select_d  = '0;
    assign shift_bsr_select_d    = '0;
    assign update_bsr_select_d   = '0;
    assign testmode_d            = '0;
    assign testmode_clk_pulseo_d = '0;
    assign testmode_clk_pulse_d  = '0;
  end
  else begin
    assign capture_bsr_select_d  = boundary_scan_select & (tap_state_d == CaptureDr);
    assign shift_bsr_select_d    = boundary_scan_select & (tap_state_d == ShiftDr);
    assign update_bsr_select_d   = boundary_scan_select & (tap_state_d == UpdateDr);
    assign testmode_d            = (jtag_ir_d == EXTEST) | (jtag_ir_d == INTEST);
    assign testmode_clk_pulseo_d = ~testmode | (testmode_clk_pulse_d & ~testmode_clk_pulse_q);
    assign testmode_clk_pulse_d  = tap_state_d == RunTestIdle;
  end

  // Buffered output signals
  always_ff @(posedge clk_i) begin
    if (!trst_n_sync_i) begin
      capture_bsr_select_o <= 1'b0;
      shift_bsr_select_o   <= 1'b0;
      update_bsr_select_o  <= 1'b0;
    end
    else if (jclk_rising_i) begin
      if (EnabledBSRLength == None) begin
        capture_bsr_select_o <= 1'b0;
        shift_bsr_select_o   <= 1'b0;
        update_bsr_select_o  <= 1'b0;
      end
      else begin
        capture_bsr_select_o <= capture_bsr_select_d;
        shift_bsr_select_o   <= shift_bsr_select_d;
        update_bsr_select_o  <= update_bsr_select_d;
      end
    end
  end

  always_ff @(posedge clk_i) begin
    if (!trst_n_sync_i) begin
      testmode <= 1'b0;
      if (EnabledBSRLength == None) begin
        testmode_clk_pulse_o <= 1'b0;
      end 
      else begin
        testmode_clk_pulse_o <= 1'b1;
      end
      testmode_clk_pulse_q <= 1'b0;
    end
    else begin
      if (EnabledBSRLength == None) begin
        if (jclk_rising_i) testmode <= 1'b0;
        testmode_clk_pulse_o <= 1'b0;
        testmode_clk_pulse_q <= 1'b0;
      end
      else begin
        if (jclk_rising_i) testmode <= testmode_d;
        testmode_clk_pulse_o <= testmode_clk_pulseo_d;
        testmode_clk_pulse_q <= testmode_clk_pulse_d;
      end
    end 
  end

  // Determine ISC mode
  always_comb begin
    isc_enable_select    = 1'b0;
    isc_disable_select   = 1'b0;

    unique case (jtag_ir_q)
      ISC_ENABLE:  isc_enable_select  = 1'b1;
      ISC_DISABLE: isc_disable_select = 1'b1;
      default:;
    endcase
  end

  if (EnabledBSRLength != None) begin
    // Determine ISC highZ (Sets known IO state, when unprogrammed)
    assign isc_highZ_d = (tap_isc_state_q != Operational) & ~testmode & ejtag_i;
  end
  else begin
    assign isc_highZ_d = 1'b0;
  end

  always_ff @(posedge clk_i) begin
    if (!trst_n_sync_i) begin
      isc_highZ_q <= 1'b0;
    end
    else if (jclk_rising_i) begin
      if (EnabledBSRLength != None) begin
        isc_highZ_q <= isc_highZ_d;
      end
      else begin
        isc_highZ_q <= 1'b0;
      end
    end
  end

  // Determine logic mode (In boundary scan)
  // Value has to be present when the single step clk pulse rises, otherwise capture may be to early
  logic mode1_d, mode2_d, mode5_d, mode6_d;
  if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
    assign mode1_d = (jtag_ir_d == INTEST) | (jtag_ir_d == EXTEST);
  end
  else begin
    assign mode1_d = 1'b0;
  end

  if (EnabledBSRLength == None) begin
    assign mode2_d = 1'b0;
  end
  else begin
    assign mode2_d = (jtag_ir_d == INTEST);
  end

  if ((EnabledBSRLength == External) || (EnabledBSRLength == All)) begin
    assign mode5_d = (jtag_ir_d == EXTEST);
    assign mode6_d = (jtag_ir_d != INTEST);
  end
  else begin
    assign mode5_d = 1'b0;
    assign mode6_d = 1'b0;
  end

  // Buffer mode signals, fixes some slack timing
  always_ff @(posedge clk_i) begin
    if (!trst_n_sync_i) begin
      mode1_o <= 1'b0;
      mode2_o <= 1'b0;
      mode5_o <= 1'b0;
      if ((EnabledBSRLength == External) || (EnabledBSRLength == All)) begin
        mode6_o <= 1'b1;
      end
      else begin
        mode6_o <= 1'b0;
      end
    end
    else if (jclk_rising_i) begin
      mode1_o <= mode1_d;
      mode2_o <= mode2_d;
      mode5_o <= mode5_d;
      mode6_o <= mode6_d;
    end
  end

  // ----------------
  // Output select
  // ----------------
  logic tdo_mux;

  always_comb begin : p_out_sel
    // we are shifting out the IR register
    if (shift_ir) begin
      tdo_mux = jtag_ir_shift_q[0];
    // here we are shifting the DR register
    end else begin
      unique case (jtag_ir_q)
        IDCODE:         tdo_mux = idcode_q[0];   // Reading ID code
        USERCODE:       tdo_mux = idcode_q[0];   // Reading user code
        SAMPLE_PRELOAD: tdo_mux = (EnabledBSRLength == None) ? bypass_q : boundary_scan_i;
        EXTEST:         tdo_mux = (EnabledBSRLength == None) ? bypass_q : boundary_scan_i;
        INTEST:         tdo_mux = (EnabledBSRLength == None) ? bypass_q : boundary_scan_i;
        ISC_PROGRAM:    tdo_mux = isc_pdata_q[0];
        default:        tdo_mux = bypass_q;      // BYPASS instruction
      endcase
    end
  end

  // ----------------
  // DFT
  // ----------------
  // TDO changes state at negative edge of TCK
  always_ff @(posedge clk_i) begin : p_tdo_regs
    if (!trst_n_sync_i) begin
      td_o     <= 1'b0;
    end else if (jclk_falling_i) begin
      td_o     <= tdo_mux;
    end
  end

  // ----------------
  // ISC IR logic
  // ----------------
  always_ff @(posedge clk_i) begin : isc_state
    if (!trst_n_sync_i) begin
      isc_enabled_q            <= '0;
      isc_done_q               <= '0;
      isc_disable_completing_q <= '0;
    end else begin
      isc_enabled_q            <= isc_enabled_d;
      isc_done_q               <= isc_done_d;
      isc_disable_completing_q <= isc_disable_completing_d;
    end
  end

  // ----------------
  // TAP ISC FSM
  // ----------------
  assign tap_isc_state_q = tap_isc_state_e'({isc_enabled_q, isc_done_q, isc_disable_completing_q});

  always_comb begin : p_tap_isc_fsm
    isc_enabled_d            = isc_enabled_q;
    isc_done_d               = isc_done_q;
    isc_disable_completing_d = isc_disable_completing_q;

    if (jclk_falling_i) begin
      unique casez (tap_isc_state_q)
        Unprogrammed: begin
          if (isc_enable_select) begin
            isc_enabled_d = 1'b1;
          end
        end
        IscAccessed: begin
          if (test_logic_reset) begin
            isc_enabled_d = 1'b0;
          end

          if (isc_disable_select) begin
            isc_disable_completing_d = isc_enabled_q;
            isc_enabled_d            = 1'b0;
            isc_done_d               = 1'b1;
          end
        end
        IscComplete: begin
          if (!isc_disable_select) begin
            isc_disable_completing_d = 1'b0;
          end
        end
        Operational: begin
          if (isc_enable_select) begin
            isc_enabled_d = 1'b1;
            isc_done_d    = 1'b0;
          end
        end
        default: ;
      endcase
    end

    if (isc_ext_prog_i & (jtag_ir_q != ISC_PROGRAM)) begin // Fabric is beeing configured by cpu
      isc_enabled_d            = 1'b1;
      isc_done_d               = '0;
      isc_disable_completing_d = '0;
    end 
    
    if (isc_ext_conf_i & (jtag_ir_q != ISC_PROGRAM)) begin // Fabric was configured by cpu
      isc_enabled_d            = '0;
      isc_done_d               = 1'b1;
      isc_disable_completing_d = '0;
    end
  end

  // ----------------
  // TAP System FSM
  // ----------------
  // Determination of next state; purely combinatorial
  always_comb begin : p_tap_fsm
    test_logic_reset = 1'b0;

    capture_dr       = 1'b0;
    shift_dr         = 1'b0;
    update_dr_d      = 1'b0;

    capture_ir       = 1'b0;
    shift_ir         = 1'b0;
    update_ir        = 1'b0;

    unique case (tap_state_q)
      TestLogicReset: begin
        tap_state_d = (tms_i) ? TestLogicReset : RunTestIdle;
        test_logic_reset = 1'b1;
      end
      RunTestIdle: begin
        tap_state_d = (tms_i) ? SelectDrScan : RunTestIdle;
      end
      // DR Path
      SelectDrScan: begin
        tap_state_d = (tms_i) ? SelectIrScan : CaptureDr;
      end
      CaptureDr: begin
        capture_dr = 1'b1;
        tap_state_d = (tms_i) ? Exit1Dr : ShiftDr;
      end
      ShiftDr: begin
        shift_dr = 1'b1;
        tap_state_d = (tms_i) ? Exit1Dr : ShiftDr;
      end
      Exit1Dr: begin
        tap_state_d = (tms_i) ? UpdateDr : PauseDr;
      end
      PauseDr: begin
        tap_state_d = (tms_i) ? Exit2Dr : PauseDr;
      end
      Exit2Dr: begin
        tap_state_d = (tms_i) ? UpdateDr : ShiftDr;
      end
      UpdateDr: begin
        update_dr_d = 1'b1;
        tap_state_d = (tms_i) ? SelectDrScan : RunTestIdle;
      end
      // IR Path
      SelectIrScan: begin
        tap_state_d = (tms_i) ? TestLogicReset : CaptureIr;
      end
      // In this controller state, the shift register bank in the
      // Instruction Register parallel loads a pattern of fixed values on
      // the rising edge of TCK. The last two significant bits must always
      // be "01".
      CaptureIr: begin
        capture_ir = 1'b1;
        tap_state_d = (tms_i) ? Exit1Ir : ShiftIr;
      end
      // In this controller state, the instruction register gets connected
      // between TDI and TDO, and the captured pattern gets shifted on
      // each rising edge of TCK. The instruction available on the TDI
      // pin is also shifted in to the instruction register.
      ShiftIr: begin
        shift_ir = 1'b1;
        tap_state_d = (tms_i) ? Exit1Ir : ShiftIr;
      end
      Exit1Ir: begin
        tap_state_d = (tms_i) ? UpdateIr : PauseIr;
      end
      PauseIr: begin
        // pause_ir = 1'b1; // unused
        tap_state_d = (tms_i) ? Exit2Ir : PauseIr;
      end
      Exit2Ir: begin
        tap_state_d = (tms_i) ? UpdateIr : ShiftIr;
      end
      // In this controller state, the instruction in the instruction
      // shift register is latched to the latch bank of the Instruction
      // Register on every falling edge of TCK. This instruction becomes
      // the current instruction once it is latched.
      UpdateIr: begin
        update_ir = 1'b1;
        tap_state_d = (tms_i) ? SelectDrScan : RunTestIdle;
      end
      default: ; // can't actually happen since case is full
    endcase
  end

  assign update_dr = update_dr_d && !update_dr_q;

  always_ff @(posedge clk_i) begin : p_regs
    if (!trst_n_sync_i) begin
      tap_state_q <= TestLogicReset;
      idcode_q    <= IdcodeValue;
      bypass_q    <= 1'b0;
      isc_pdata_q <= '0;
      update_dr_q <= '0;
    end else begin
      update_dr_q <= update_dr_d; // Single out en pulse

      if (jclk_rising_i) begin
        tap_state_q <= tap_state_d;
        idcode_q    <= idcode_d;
        bypass_q    <= bypass_d;
        isc_pdata_q <= isc_pdata_d;
      end
    end
  end

  // Pass through JTAG signals to debug custom DR logic.
  // In case of a single TAP those are just feed-through.
  // Buffer out clear signal
  always_ff @(posedge clk_i) begin
    if (!trst_n_sync_i) begin
      dm_rst_o <= 1'b0;
    end
    else if (jclk_rising_i) begin
      dm_rst_o <= (tap_state_q == TestLogicReset);
    end
  end

  assign isc_highZ_o = isc_highZ_q;
  assign ejtag_o = bypass_q;
  assign isc_pdata_o = isc_pdata_q;

endmodule : fpga_dm_jtag_tap

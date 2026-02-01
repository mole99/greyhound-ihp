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

module fpga_dm_jtag_tap #(
  parameter int unsigned IrLength = 5,
  // JTAG IDCODE Value
  parameter logic [31:0] IdcodeValue = 32'h00000001
  // xxxx             version
  // xxxxxxxxxxxxxxxx part number
  // xxxxxxxxxxx      manufacturer id
  // 1                required by standard
) (
  input  logic        tck_i,    // JTAG test clock pad
  input  logic        tms_i,    // JTAG test mode select pad
  input  logic        trst_ni,  // JTAG test reset pad
  input  logic        td_i,     // JTAG test data input pad
  output logic        td_o,     // JTAG test data output pad
  output logic        tdo_oe_o, // Data out output enable
  output logic        tck_no,
  // Synchronous reset of the dmi module triggered by JTAG TAP
  output logic        dm_rst_o,
  output logic        update_o,
  output logic        capture_o,
  output logic        shift_o,
  output logic        tdi_o,
  // Control if jtag interface is enabled
  output logic        ejtag_o,
  output logic        ejtag_valid_o,
  input  logic        ejtag_i,
  // Usercode derived from FPGA program
  input  logic [31:0] usercode_i,
  // Fabric program bitstream register
  output logic        isc_pdata_valid_o,
  output logic [31:0] isc_pdata_o,
  // Boundary scan
  output logic        mode2_o,
  output logic        mode5_o,
  output logic        mode6_o,
  output logic        boundary_scan_o,
  input  logic        boundary_scan_i,
  output logic        capture_bsr_select_o,
  output logic        shift_bsr_select_o,
  output logic        update_bsr_select_o,
  output logic        testmode_o, 
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
  logic update_dr, shift_dr, capture_dr;
  logic isc_enabled_q, isc_enabled_d;
  logic isc_done_q, isc_done_d;
  logic isc_disable_completing_q, isc_disable_completing_d;

  typedef enum logic [IrLength-1:0] {
    BYPASS0        = 'h0,
    IDCODE         = 'h1,
    // TODO test them IEEE1149.1
    USERCODE       = 'h2,
    SAMPLE_PRELOAD = 'h3,
    EXTEST         = 'h4,
    INTEST         = 'h5,
    EJTAG          = 'h10, // Enable JTAG pin functionality, set register to enable/disable jtag functionality
    // TODO verify (need 1149.1) IEEE1532
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
  ir_reg_e              jtag_ir_d, jtag_ir_q;
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

  always_ff @(posedge tck_i, negedge trst_ni) begin : p_jtag_ir_reg
    if (!trst_ni) begin
      jtag_ir_shift_q <= '0;
      jtag_ir_q       <= IDCODE;
    end else begin
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
    boundary_scan_o   = boundary_scan_i;

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
      if (boundary_scan_select) boundary_scan_o = td_i;
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
      boundary_scan_o = '0;
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
  logic testmode_clk_pulse_d, testmode_clk_pulse_q;
  assign clk_bsr_select_o     = boundary_scan_select;
  assign capture_bsr_select_o = boundary_scan_select & capture_dr;
  assign shift_bsr_select_o   = boundary_scan_select & shift_dr;
  assign update_bsr_select_o  = boundary_scan_select & update_dr;
  assign testmode_clk_pulse_o = ~testmode_o | (testmode_clk_pulse_d & ~testmode_clk_pulse_q);

  // Determin clk pulse in test mode
  always_comb begin
    unique case (tap_state_q)
      RunTestIdle: testmode_clk_pulse_d = 1'b1;
      // Create a single pulse if idle state is skipped, must happen between update and capture are performed
      // Update happens on falling edge, capture happens 2 cyles later on rising edge at the minimum
      UpdateDr:    testmode_clk_pulse_d = tms_i;
      UpdateIr:    testmode_clk_pulse_d = tms_i;
      default:     testmode_clk_pulse_d = 1'b0;
    endcase
  end


  // Determin logic mode (In ISC and boundary scan)
  always_comb begin
    mode2_o              = '0;
    mode5_o              = '0;
    mode6_o              = '0;
    testmode_o           = (jtag_ir_d == EXTEST) | (jtag_ir_d == INTEST);
    isc_enable_select    = 1'b0;
    isc_disable_select   = 1'b0;

    unique case (jtag_ir_q)
      INTEST: begin
        mode2_o    = 1;
        testmode_o = 1'b1;
      end
      EXTEST: begin
        mode5_o    = 1;
        mode6_o    = 1;
        testmode_o = 1'b1;
      end
      ISC_ENABLE:  isc_enable_select  = 1'b1;
      ISC_DISABLE: isc_disable_select = 1'b1;
      default: mode6_o = 1;
    endcase
  end

  always_ff @(posedge tck_i, negedge trst_ni) begin
    if (!trst_ni) begin
      testmode_clk_pulse_q <= '0;
    end else begin
      testmode_clk_pulse_q <= testmode_clk_pulse_d;
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
        SAMPLE_PRELOAD: tdo_mux = boundary_scan_i;
        EXTEST:         tdo_mux = boundary_scan_i;
        INTEST:         tdo_mux = boundary_scan_i;
        ISC_PROGRAM:    tdo_mux = isc_pdata_q[0];
        default:        tdo_mux = bypass_q;      // BYPASS instruction
      endcase
    end
  end

  // ----------------
  // DFT
  // ----------------
  logic tck_n;
  tc_clk_inverter i_tck_inv (
    .clk_i ( tck_i ),
    .clk_o ( tck_n )
  );

  // TDO changes state at negative edge of TCK
  always_ff @(posedge tck_n, negedge trst_ni) begin : p_tdo_regs
    if (!trst_ni) begin
      td_o     <= 1'b0;
      tdo_oe_o <= 1'b0;
    end else begin
      td_o     <= tdo_mux;
      tdo_oe_o <= (shift_ir | shift_dr);
    end
  end

  // ----------------
  // ISC IR logic
  // ----------------
  always_ff @(posedge tck_n, negedge trst_ni) begin : isc_state
    if (!trst_ni) begin
      isc_enabled_q            <= '0;
      isc_done_q               <= '0;
      isc_disable_completing_q <= '0;
    end else begin
      isc_enabled_q            <= isc_enabled_d;
      isc_done_q               <= isc_done_d;
      isc_disable_completing_q <= isc_disable_completing_d;
    end
  end

  assign tap_isc_state_q = tap_isc_state_e'({isc_enabled_q, isc_done_q, isc_disable_completing_q});


  // ----------------
  // TAP ISC FSM
  // ----------------
  // TODO test mode, depending on IEEE1149
  // TODO io states as described in IEEE1532 section 4.2
  // TODO NOOP does something different from bypass relevant for io state
  always_comb begin : p_tap_isc_fsm
    isc_enabled_d            = isc_enabled_q;
    isc_done_d               = isc_done_q;
    isc_disable_completing_d = isc_disable_completing_q;
    
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

  // ----------------
  // TAP System FSM
  // ----------------
  // Determination of next state; purely combinatorial
  always_comb begin : p_tap_fsm
    test_logic_reset = 1'b0;

    capture_dr       = 1'b0;
    shift_dr         = 1'b0;
    update_dr        = 1'b0;

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
        update_dr = 1'b1;
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

  always_ff @(posedge tck_i or negedge trst_ni) begin : p_regs
    if (!trst_ni) begin
      tap_state_q <= TestLogicReset;
      idcode_q    <= IdcodeValue;
      bypass_q    <= 1'b0;
      isc_pdata_q <= '0;
    end else begin
      tap_state_q <= tap_state_d;
      idcode_q    <= idcode_d;
      bypass_q    <= bypass_d;
      isc_pdata_q <= isc_pdata_d;
    end
  end

  // Pass through JTAG signals to debug custom DR logic.
  // In case of a single TAP those are just feed-through.
  assign tck_no = tck_n;
  assign tdi_o = td_i;
  assign update_o = update_dr;
  assign shift_o = shift_dr;
  assign capture_o = capture_dr;
  assign dm_rst_o = test_logic_reset;

  assign ejtag_o = bypass_q;
  assign isc_pdata_o = isc_pdata_q;

endmodule : fpga_dm_jtag_tap

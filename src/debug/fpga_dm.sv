// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

module fpga_dm import soc_pkg::GreyhoundJtagIdCodeFPGA;(
    input  logic         clk_i,
    input  logic         rst_ni,
    // Muxed and gated clk to use as EX- and INTEST are supported
    output logic         clk_fabric_o,

    // JTAG
    input  logic         tck_i,
    input  logic         tms_i,
    input  logic         trst_ni,
    input  logic         td_i,
    output logic         td_o,
    output logic         tdo_oe_o,
    // Functions
    // EJTAG
    output logic         en_jtag_receiver_o,
    // ISC_PROGRAM
    output logic [31:0]  jtag_bitstream_o,
    output logic         jtag_bitstream_valid_o,
    // Boundary scan
    output logic         dm_clear_o,
    output logic         shift_dr_o,
    output logic         tck_no,
    output logic         mode2_o,
    output logic         mode5_o,
    output logic         mode6_o,
    output logic         boundary_scan_o,
    input  logic         boundary_scan_i,
    output logic         capture_bsr_select_o,
    output logic         shift_bsr_select_o,
    output logic         update_bsr_select_o
);
    localparam logic [31:0] BITFILE_START = 32'h00AAFF01;

    logic clk_fabric_m, testmode, fabric_clk_enable;
    // Mux FPGA and tclk to create a glitch free intest clk if desired
    tc_clk_mux2 i_dft_tck_mux (
        .clk0_i    ( clk_i        ),
        .clk1_i    ( tck_i        ),
        .clk_sel_i ( testmode     ),
        .clk_o     ( clk_fabric_m )
    );

    // Gate the input clock with the enable signal to create an intest clk
    tc_clk_gating i_clk_gate (
        .clk_i     ( clk_fabric_m      ),
        .en_i      ( fabric_clk_enable ),
        .clk_o     ( clk_fabric_o      )
    );

    // ejtag controls "enable jtag" alternate pinout function. It is only ever reset by trst. 
    logic ejtag_d, ejtag_q, ejtag, ejtag_valid;
    logic        isc_pdata_valid;
    logic [31:0] isc_pdata;
    logic [31:0] usercode_d, usercode_q;
    logic        usercode_valid_d, usercode_valid_q;

    // TODO: make this IEEE 1149.1 and IEEE 1532 compatible
    // TODO use raw_pld driver in openocd-> need to create raw bitfile with commands first....
    // TODO remove unused io's
    // TAP
    fpga_dm_jtag_tap #(
        .IdcodeValue ( GreyhoundJtagIdCodeFPGA )
    ) i_dm_jtag_tap (
        .tck_i,
        .tms_i,
        .trst_ni,
        .td_i,
        .td_o,
        .tdo_oe_o,
        .tck_no,
        .mode2_o,
        .mode5_o,
        .mode6_o,
        .boundary_scan_o,
        .boundary_scan_i,
        .capture_bsr_select_o,
        .shift_bsr_select_o,
        .update_bsr_select_o,
        .testmode_o           ( testmode          ),
        .testmode_clk_pulse_o ( fabric_clk_enable ),
        .dm_rst_o             ( dm_clear_o        ),
        .shift_o              ( shift_dr_o        ),
        // Control if jtag interface is enabled
        .ejtag_o        ( ejtag       ),
        .ejtag_valid_o  ( ejtag_valid ),
        .ejtag_i        ( ejtag_q     ),
        // Usercode
        .usercode_i     ( usercode_q  ),
        // Jtag programming data
        .isc_pdata_valid_o ( isc_pdata_valid ),
        .isc_pdata_o       ( isc_pdata       )
    );

    assign ejtag_d          = ejtag_valid ? ejtag : ejtag_q;
    assign usercode_valid_d = isc_pdata_valid & (isc_pdata == BITFILE_START);
    assign usercode_d       = usercode_valid_q ? isc_pdata : usercode_q;
    always_ff @(posedge tck_i or negedge trst_ni) begin
        if (!trst_ni) begin
            ejtag_q          <= 1'b0;
            usercode_q       <= '0;
            usercode_valid_q <= 1'b0;
        end else begin
            ejtag_q          <= ejtag_d;
            usercode_q       <= usercode_d;
            usercode_valid_q <= usercode_valid_d;
        end
    end

    // CDC
    // Sync en_jtag_receiver
    logic [1:0] en_jtag_receiver_d;
    always_ff @(posedge clk_i) begin
        en_jtag_receiver_d <= {en_jtag_receiver_d[0], ejtag_q};
    end
    assign en_jtag_receiver_o = en_jtag_receiver_d[1];

    // Sync fpga program
    cdc_2phase_clearable #(.T(logic [31:0])) i_cdc_req (
    .src_rst_ni  ( trst_ni                ),
    .src_clear_i ( dm_clear_o             ),
    .src_clk_i   ( tck_i                  ),
    .src_data_i  ( isc_pdata              ),
    .src_valid_i ( isc_pdata_valid        ),

    .dst_rst_ni  ( rst_ni                 ),
    .dst_clear_i ( 1'b0                   ),
    .dst_clk_i   ( clk_i                  ),
    .dst_data_o  ( jtag_bitstream_o       ),
    .dst_valid_o ( jtag_bitstream_valid_o ),
    .dst_ready_i ( 1'b1                   )
  );

endmodule
// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

module fpga_dm import soc_pkg::*; #(
    parameter FABRIC_NUM_IO_WEST = 32
)(
    input  logic        clk_i,
    input  logic        rst_ni,
    // Muxed and gated clk to use; As EX- and INTEST are supported
    output logic        clk_o,

    // JTAG tap
    input  logic        tck_i,
    input  logic        tms_i,
    input  logic        trst_ni,
    input  logic        td_i,
    output logic        td_o,

    // Functions
    // EJTAG
    output logic        en_jtag_receiver_o,

    // ISC_PROGRAM
    output logic [31:0] jtag_bitstream_o,
    output logic        jtag_bitstream_valid_o,
    input  logic        fabric_busy_i,
    input  logic        fabric_configured_i,
    input  logic        fabric_bitstream_valid_i,
    input  logic [31:0] fabric_bitstream_data_i,

    // Boundary scan registers
    // GPIOs
    // to boundary
    input  logic [FABRIC_NUM_IO_WEST-1:0] fabric_pin_i,
    output logic [FABRIC_NUM_IO_WEST-1:0] fabric_pin_o,
    output logic [FABRIC_NUM_IO_WEST-1:0] fabric_enable_pin_o,
    // from fpga
    input  logic [FABRIC_NUM_IO_WEST-1:0] fabric_output_enable_i,
    input  logic [FABRIC_NUM_IO_WEST-1:0] fabric_output_data_i,
    output logic [FABRIC_NUM_IO_WEST-1:0] fabric_input_data_o,
    // CPU_IRQ
    // to cpu
    output [3:0] fabric_irq_o,
    // from fpga
    input  [3:0] fabric_irq_i,
    // CUSTOM_INSTRUCTION
    // to cpu
    output logic        fabric_issue_ready_o,
    output logic        fabric_issue_accept_o,
    input  logic        fabric_issue_valid_i,
    input  logic [31:0] fabric_issue_instr_i,
    input  logic [31:0] fabric_issue_op0_i,
    input  logic [31:0] fabric_issue_op1_i,
    input  logic [3 :0] fabric_issue_id_i,
    output logic        fabric_result_valid_o,
    output logic [3 :0] fabric_result_id_o,
    output logic [4 :0] fabric_result_rd_o,
    output logic [31:0] fabric_result_o,
    // from fpga
    input  logic        fabric_issue_ready_i,
    input  logic        fabric_issue_accept_i,
    output logic        fabric_issue_valid_o,
    output logic [31:0] fabric_issue_instr_o,
    output logic [31:0] fabric_issue_op0_o,
    output logic [31:0] fabric_issue_op1_o,
    output logic [3 :0] fabric_issue_id_o,
    input  logic        fabric_result_valid_i,
    input  logic [3 :0] fabric_result_id_i,
    input  logic [4 :0] fabric_result_rd_i,
    input  logic [31:0] fabric_result_i,
    // OBI_PERIPHERAL
    // to cpu
    input  logic        fabric_obi_req_i,
    input  logic        fabric_obi_we_i,
    input  logic [3 :0] fabric_obi_be_i,
    input  logic [23:0] fabric_obi_addr_i,
    input  logic [31:0] fabric_obi_wdata_i,
    output logic        fabric_obi_gnt_o,
    output logic        fabric_obi_rvalid_o,
    output logic [31:0] fabric_obi_rdata_o,
    // from fpga
    output logic        fabric_obi_req_o,
    output logic        fabric_obi_we_o,
    output logic [3 :0] fabric_obi_be_o,
    output logic [23:0] fabric_obi_addr_o,
    output logic [31:0] fabric_obi_wdata_o,
    input  logic        fabric_obi_gnt_i,
    input  logic        fabric_obi_rvalid_i,
    input  logic [31:0] fabric_obi_rdata_i
);
    localparam logic [31:0] BITFILE_START = 32'h00AAFF01;

    logic clk_fabric_m, testmode, clk_enable;

    if (EnabledBSRLength == None) begin
        assign clk_o = clk_i;
    end
    else begin
        // Mux FPGA and tclk to create a glitch free intest clk if desired
        tc_clk_mux2 i_dft_tck_mux (
            .clk0_i    ( clk_i        ),
            .clk1_i    ( tck_i        ),
            .clk_sel_i ( testmode     ),
            .clk_o     ( clk_fabric_m )
        );

        // Gate the input clock with the enable signal to create an intest clk
        tc_clk_gating i_clk_gate (
            .clk_i     ( clk_fabric_m ),
            .en_i      ( clk_enable   ),
            .clk_o     ( clk_o        )
        );
    end

    // ejtag controls "enable jtag" alternate pinout function. It is only ever reset by trst. 
    logic ejtag_d, ejtag_q, ejtag_valid;
    // ISC Program
    logic        isc_pdata_valid, isc_ext_prog, isc_ext_conf;
    logic [31:0] isc_pdata;
    // USERCODE
    logic [31:0] jtag_usercode_q, usercode_q;
    logic        usercode_valid_d, usercode_valid_q;
    // Boundary scan registers
    logic tck_n, dm_clear;
    logic mode1, mode2, mode5, mode6;
    logic boundary_scan_tdi, boundary_scan_tdo;
    logic capture_bsr_select, shift_bsr_select, update_bsr_select;

    // TODO use raw_pld driver in openocd-> need to create raw bitfile with commands first....
    // ----------------
    // TAP
    // ----------------
    fpga_dm_jtag_tap #(
        .IdcodeValue ( GreyhoundJtagIdCodeFPGA )
    ) i_dm_jtag_tap (
        // JTAG tap 
        .tck_i,
        .tms_i,
        .trst_ni,
        .td_i,
        .td_o,
        // Boundary scan registers
        .tck_no               ( tck_n              ),
        .mode1_o              ( mode1              ),
        .mode2_o              ( mode2              ),
        .mode5_o              ( mode5              ),
        .mode6_o              ( mode6              ),
        .boundary_scan_o      ( boundary_scan_tdo  ),
        .boundary_scan_i      ( boundary_scan_tdi  ),
        .capture_bsr_select_o ( capture_bsr_select ),
        .shift_bsr_select_o   ( shift_bsr_select   ),
        .update_bsr_select_o  ( update_bsr_select  ),
        .testmode_o           ( testmode           ),
        .testmode_clk_pulse_o ( clk_enable         ),
        .dm_rst_o             ( dm_clear           ),
        // Control if jtag interface is enabled
        .ejtag_o        ( ejtag_d     ),
        .ejtag_valid_o  ( ejtag_valid ),
        .ejtag_i        ( ejtag_q     ),
        // Usercode
        .usercode_i     ( jtag_usercode_q  ),
        // Jtag programming data
        .isc_pdata_valid_o ( isc_pdata_valid ),
        .isc_pdata_o       ( isc_pdata       ),
        .isc_ext_prog_i    ( isc_ext_prog    ),
        .isc_ext_conf_i    ( isc_ext_conf    )
    );

    // ----------------
    // USERCODE
    // ----------------
    assign usercode_valid_d = fabric_bitstream_valid_i & (fabric_bitstream_data_i == BITFILE_START);
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            usercode_q       <= '0;
            usercode_valid_q <= 1'b0;
        end else begin
            if (usercode_valid_q & fabric_bitstream_valid_i) begin
                usercode_q <= fabric_bitstream_data_i;
            end

            if (fabric_bitstream_valid_i) begin
                usercode_valid_q <= 1'b0;
            end
            
            if (usercode_valid_d) begin
                usercode_valid_q <= 1'b1;
            end
        end
    end

    // Sync whole usercode into tclk domain, this will never be used faster than 10 tclk cycles 
    // after changing usercode_q (because of the IEEE1149.1 state machine and fabric programming taking many cycles)
    always_ff @(posedge tck_i) begin
        jtag_usercode_q <= usercode_q;
    end

    // ----------------
    // EJTAG
    // ----------------
    always_ff @(posedge tck_i or negedge trst_ni) begin
        if (!trst_ni) begin
            ejtag_q <= 1'b0;
        end else begin
            if (ejtag_valid) begin
                ejtag_q <= ejtag_d;
            end
        end
    end

    // Sync en_jtag_receiver
    logic [1:0] en_jtag_receiver_d;
    always_ff @(posedge clk_i) begin
        en_jtag_receiver_d <= {en_jtag_receiver_d[0], ejtag_q};
    end
    assign en_jtag_receiver_o = en_jtag_receiver_d[1];

    // ----------------
    // PROGRAM
    // ----------------
    cdc_2phase_clearable #(.T(logic [31:0])) i_cdc_jtag_out (
        .src_rst_ni  ( trst_ni                ),
        .src_clear_i ( dm_clear               ),
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

    // Sync fabric_configured_i and fabric_busy_i as single pulse
    logic [2:0] isc_ext_prog_d;
    logic [2:0] isc_ext_conf_d;
    always_ff @(posedge tck_i) begin
        isc_ext_prog_d <= {isc_ext_prog_d[1:0], fabric_busy_i};
        isc_ext_conf_d <= {isc_ext_conf_d[1:0], fabric_configured_i};
    end
    assign isc_ext_prog = ~isc_ext_prog_d[2] & isc_ext_prog_d[1];
    assign isc_ext_conf = ~isc_ext_conf_d[2] & isc_ext_conf_d[1];

    // ----------------
    // Boundary scan registers
    // ----------------
    // Layout: 64 bit west io (as io + control pair) (0...31), 4 bit cpu irq (0...3), 
    //         103 bit custom instruction (fabric_issue_valid_i, fabric_issue_instr_i, fabric_issue_op0_i, fabric_issue_op1_i, fabric_issue_id_i, 
    //                                     fabric_issue_ready_o, fabric_issue_accept_o, fabric_result_valid_o, fabric_result_id_o, fabric_result_rd_o, fabric_result_o),
    //         96 bit obi interface (fabric_obi_req_i, fabric_obi_we_i, fabric_obi_be_i, fabric_obi_addr_i, fabric_obi_wdata_i,
    //                               fabric_obi_gnt_o, fabric_obi_rvalid_o, fabric_obi_rdata_o)
    // West IO (64 bit)
    wire boundary_scan_io_west_td [FABRIC_NUM_IO_WEST:0];
    if ((EnabledBSRLength == External) || (EnabledBSRLength == All)) begin
        assign boundary_scan_io_west_td[0] = boundary_scan_tdo;
        for (genvar i = 0; i<FABRIC_NUM_IO_WEST; i++) begin : BSR_IO_WEST
            fpga_boundary_cell_inout fpga_boundary_cell_io_west (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .output_enable_i ( fabric_output_enable_i[i] ),
                .output_data_i   ( fabric_output_data_i[i]   ),
                .input_data_o    ( fabric_input_data_o[i]    ),
                // Mode configuration
                .mode2_i ( mode2 ),
                .mode5_i ( mode5 ),
                .mode6_i ( mode6 ),
                // Daisy chain connection
                .td_i ( boundary_scan_io_west_td[i]   ),
                .td_o ( boundary_scan_io_west_td[i+1] ),
                // System pin connection
                .pin_i        ( fabric_pin_i[i]        ),
                .pin_o        ( fabric_pin_o[i]        ),
                .enable_pin_o ( fabric_enable_pin_o[i] )
            );
        end
    end
    else begin
        assign fabric_enable_pin_o = fabric_output_enable_i;
        assign fabric_pin_o        = fabric_output_data_i;
        assign fabric_input_data_o = fabric_pin_i;
    end

    if (EnabledBSRLength == External) begin
        assign boundary_scan_tdi = boundary_scan_io_west_td[FABRIC_NUM_IO_WEST];
    end

    // CPU_IRQ (4 bit)
    wire boundary_scan_irq_td [4:0];
    if (EnabledBSRLength == Internal) begin
        assign boundary_scan_irq_td[0] = boundary_scan_tdo;
    end

    if (EnabledBSRLength == All) begin
        assign boundary_scan_irq_td[0] = boundary_scan_io_west_td[FABRIC_NUM_IO_WEST];
    end

    if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
        for (genvar i = 0; i<4; i++) begin : BSR_CPU_IRQ
            fpga_boundary_cell_output fpga_boundary_cell_out_irq (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .output_data_i ( fabric_irq_i[i] ),
                // Mode configuration
                .mode1_i ( mode1 ),
                // Daisy chain connection
                .td_i ( boundary_scan_irq_td[i]   ),
                .td_o ( boundary_scan_irq_td[i+1] ),
                // System pin connection
                .pin_o ( fabric_irq_o[i] )
            );
        end
    end
    else begin
        assign fabric_irq_o = fabric_irq_i;
    end
    
    // CUSTOM_INSTRUCTION (145 bit)
    wire boundary_scan_custom_instr_in_td [101:0];
    wire [101:0] boundary_scan_custom_instr_in_packed [1:0];
    if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
        // Pack and unpack instruction input
        assign boundary_scan_custom_instr_in_packed[0] = {fabric_issue_valid_i, fabric_issue_instr_i, fabric_issue_op0_i, fabric_issue_op1_i, fabric_issue_id_i};
        assign {fabric_issue_valid_o, fabric_issue_instr_o, fabric_issue_op0_o, fabric_issue_op1_o, fabric_issue_id_o} = boundary_scan_custom_instr_in_packed[1];
        assign boundary_scan_custom_instr_in_td[0] = boundary_scan_irq_td[4];
        for (genvar i = 0; i<101; i++) begin : BSR_CUSTOM_INSTRUCTION_INPUT
            fpga_boundary_cell_input fpga_boundary_cell_in_custom_instruction (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .input_data_o ( boundary_scan_custom_instr_in_packed[1][i] ),
                // Mode configuration
                .mode2_i ( mode2 ),
                // Daisy chain connection
                .td_i ( boundary_scan_custom_instr_in_td[i]   ),
                .td_o ( boundary_scan_custom_instr_in_td[i+1] ),
                // System pin connection
                .pin_i ( boundary_scan_custom_instr_in_packed[0][i] )
            );
        end
    end
    else begin
        assign fabric_issue_valid_o = fabric_issue_valid_i;
        assign fabric_issue_instr_o = fabric_issue_instr_i;
        assign fabric_issue_op0_o   = fabric_issue_op0_i;
        assign fabric_issue_op1_o   = fabric_issue_op1_i;
        assign fabric_issue_id_o    = fabric_issue_id_i;
    end

    wire boundary_scan_custom_instr_out_td [44:0];
    wire [44:0] boundary_scan_custom_instr_out_packed [1:0];
    if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
        // Pack and unpack instruction output
        assign boundary_scan_custom_instr_out_packed[0] = {fabric_issue_ready_i, fabric_issue_accept_i, fabric_result_valid_i, fabric_result_id_i, fabric_result_rd_i, fabric_result_i};
        assign {fabric_issue_ready_o, fabric_issue_accept_o, fabric_result_valid_o, fabric_result_id_o, fabric_result_rd_o, fabric_result_o} = boundary_scan_custom_instr_out_packed[1];
        assign boundary_scan_custom_instr_out_td[0] = boundary_scan_custom_instr_in_td[101];
        for (genvar i = 0; i<44; i++) begin : BSR_CUSTOM_INSTRUCTION_OUTPUT
            fpga_boundary_cell_output fpga_boundary_cell_out_custom_instruction (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .output_data_i ( boundary_scan_custom_instr_out_packed[0][i] ),
                // Mode configuration
                .mode1_i ( mode1 ),
                // Daisy chain connection
                .td_i ( boundary_scan_custom_instr_out_td[i]   ),
                .td_o ( boundary_scan_custom_instr_out_td[i+1] ),
                // System pin connection
                .pin_o ( boundary_scan_custom_instr_out_packed[1][i] )
            );
        end
    end
    else begin
        assign fabric_issue_ready_o  = fabric_issue_ready_i;
        assign fabric_issue_accept_o = fabric_issue_accept_i;
        assign fabric_result_valid_o = fabric_result_valid_i;
        assign fabric_result_id_o    = fabric_result_id_i;
        assign fabric_result_rd_o    = fabric_result_rd_i;
        assign fabric_result_o       = fabric_result_i;
    end

    // OBI_PERIPHERAL (96 bit)
    wire boundary_scan_obi_periph_in_td [62:0];
    wire [62:0] boundary_scan_obi_periph_in_packed [1:0];
    if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
        // Pack and unpack instruction input
        assign boundary_scan_obi_periph_in_packed[0] = {fabric_obi_req_i, fabric_obi_we_i, fabric_obi_be_i, fabric_obi_addr_i, fabric_obi_wdata_i};
        assign {fabric_obi_req_o, fabric_obi_we_o, fabric_obi_be_o, fabric_obi_addr_o, fabric_obi_wdata_o} = boundary_scan_obi_periph_in_packed[1];
        assign boundary_scan_obi_periph_in_td[0] = boundary_scan_custom_instr_out_td[44];
        for (genvar i = 0; i<62; i++) begin : BSR_OBI_PERIPHERAL_INPUT
            fpga_boundary_cell_input fpga_boundary_cell_in_custom_instruction (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .input_data_o ( boundary_scan_obi_periph_in_packed[1][i] ),
                // Mode configuration
                .mode2_i ( mode2 ),
                // Daisy chain connection
                .td_i ( boundary_scan_obi_periph_in_td[i]   ),
                .td_o ( boundary_scan_obi_periph_in_td[i+1] ),
                // System pin connection
                .pin_i ( boundary_scan_obi_periph_in_packed[0][i] )
            );
        end
    end
    else begin
        assign fabric_obi_req_o   = fabric_obi_req_i;
        assign fabric_obi_we_o    = fabric_obi_we_i;
        assign fabric_obi_be_o    = fabric_obi_be_i;
        assign fabric_obi_addr_o  = fabric_obi_addr_i;
        assign fabric_obi_wdata_o = fabric_obi_wdata_i;
    end

    wire boundary_scan_obi_periph_out_td [34:0];
    wire [34:0] boundary_scan_obi_periph_out_packed [1:0];
    if ((EnabledBSRLength == Internal) || (EnabledBSRLength == All)) begin
        // Pack and unpack instruction output
        assign boundary_scan_obi_periph_out_packed[0] = {fabric_obi_gnt_i, fabric_obi_rvalid_i, fabric_obi_rdata_i};
        assign {fabric_obi_gnt_o, fabric_obi_rvalid_o, fabric_obi_rdata_o} = boundary_scan_obi_periph_out_packed[1];
        assign boundary_scan_obi_periph_out_td[0] = boundary_scan_obi_periph_in_td[62];
        for (genvar i = 0; i<34; i++) begin : BSR_OBI_PERIPHERAL_OUTPUT
            fpga_boundary_cell_output fpga_boundary_cell_out_custom_instruction (
                .tclk_i   ( tck_i    ),
                .tclk_ni  ( tck_n    ),
                .trst_ni  ( trst_ni  ),
                .tclear_i ( dm_clear ),
                // Gated clk signals
                .capture_bsr_select_i ( capture_bsr_select ),
                .shift_bsr_select_i   ( shift_bsr_select   ),
                .update_bsr_select_i  ( update_bsr_select  ),
                // System logic connection
                .output_data_i ( boundary_scan_obi_periph_out_packed[0][i] ),
                // Mode configuration
                .mode1_i ( mode1 ),
                // Daisy chain connection
                .td_i ( boundary_scan_obi_periph_out_td[i]   ),
                .td_o ( boundary_scan_obi_periph_out_td[i+1] ),
                // System pin connection
                .pin_o ( boundary_scan_obi_periph_out_packed[1][i] )
            );
        end

        assign boundary_scan_tdi = boundary_scan_obi_periph_out_td[34];
    end
    else begin
        assign fabric_obi_gnt_o    = fabric_obi_gnt_i;
        assign fabric_obi_rvalid_o = fabric_obi_rvalid_i;
        assign fabric_obi_rdata_o  = fabric_obi_rdata_i;
    end

    if (EnabledBSRLength == None) begin
        assign boundary_scan_tdi = '0;
    end
endmodule
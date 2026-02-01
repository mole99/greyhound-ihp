module fpga_dm import soc_pkg::GreyhoundJtagIdCodeFPGA;(
    input  logic         clk_i,
    input  logic         rst_ni,

    // JTAG
    input  logic         tck_i,
    input  logic         tms_i,
    input  logic         trst_ni,
    input  logic         td_i,
    output logic         td_o,
    output logic         tdo_oe_o,
    // Functions
    output logic         en_jtag_receiver_o,
    output logic [31:0]  jtag_bitstream_o,
    output logic         jtag_bitstream_valid_o
);
    logic dm_clear;
    // ejtag controls "enable jtag" alternate pinout function. It is only ever reset by trst. 
    logic ejtag_d, ejtag_q, ejtag, ejtag_valid;
    logic        isc_pdata_valid;
    logic [31:0] isc_pdata;

    // TODO: make this IEEE 1149.1 and IEEE 1532 compatible
    // TODO program interface.... CDC
    // TODO ISC status code implementation as per IEEE1532 5.2 v)
    // TODO ISC_READ for programming verification?
    // TODO remove unused io's
    // TAP
    fpga_dm_jtag_tap #(
        .IdcodeValue ( GreyhoundJtagIdCodeFPGA )
    ) i_dmi_jtag_tap (
        .tck_i,
        .tms_i,
        .trst_ni,
        .td_i,
        .td_o,
        .tdo_oe_o,
        .testmode_i ( 0        ),
        .dm_rst_o   ( dm_clear ),
        
        // Control if jtag interface is enabled
        .ejtag_o        ( ejtag       ),
        .ejtag_valid_o  ( ejtag_valid ),
        .ejtag_i        ( ejtag_q     ),

        // Jtag programming data
        .isc_pdata_valid_o ( isc_pdata_valid ),
        .isc_pdata_o       ( isc_pdata       )
    );

    // BYPASS, SAMPLE, PRELOAD, EXTEST, IDCODE IEEE1532 requires IDCODE and USERCODE instr
    // RECOMMENDED
    // 1) IDCODE, 2) CLAMP and HIGHZ, 3) IC_RESET, 4) CLAMP_HOLD, CLAMP_RELEASE, and TMP_STATUS

    assign ejtag_d = ejtag_valid ? ejtag : ejtag_q;
    always_ff @(posedge tck_i or negedge trst_ni) begin
        if (!trst_ni) begin
            ejtag_q <= 1'b0;
        end else begin
            ejtag_q <= ejtag_d;
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

endmodule
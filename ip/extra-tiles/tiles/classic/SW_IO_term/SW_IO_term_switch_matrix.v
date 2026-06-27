 // NumberOfConfigBits: 19
module SW_IO_term_switch_matrix
    #(
        parameter NoConfigBits=19
    )
    (
        input  S_GBUF_FEED_END0,
        input  S_GBUF_FEED_END1,
        input  S_GBUF_FEED_END2,
        input  S_GBUF_FEED_END3,
        input  W_GBUF_FEED_END0,
        input  W_GBUF_FEED_END1,
        input  W_GBUF_FEED_END2,
        input  W_GBUF_FEED_END3,
        input  GBUF_A_OUT,
        input  GBUF_B_OUT,
        input  GBUF_C_OUT,
        input  GBUF_D_OUT,
        input  SYS_RESET_RESET,
        input  IOBUF_OUT,
        output  N_GBUF_BEG0,
        output  N_GBUF_BEG1,
        output  N_GBUF_BEG2,
        output  N_GBUF_BEG3,
        output  E_GBUF_BEG0,
        output  E_GBUF_BEG1,
        output  E_GBUF_BEG2,
        output  E_GBUF_BEG3,
        output  GBUF_A_IN,
        output  GBUF_B_IN,
        output  GBUF_C_IN,
        output  GBUF_D_IN,
        output  IOBUF_CLK,
        output  IOBUF_IN,
        output  IOBUF_EN,
 //global
        input  [NoConfigBits-1:0] ConfigBits,
        input  [NoConfigBits-1:0] ConfigBits_N
);
parameter GND0 = 1'b0;
parameter GND = 1'b0;
parameter VCC0 = 1'b1;
parameter VCC = 1'b1;
parameter VDD0 = 1'b1;
parameter VDD = 1'b1;

wire[10-1:0] GBUF_A_IN_input;
wire[10-1:0] GBUF_B_IN_input;
wire[10-1:0] GBUF_C_IN_input;
wire[10-1:0] GBUF_D_IN_input;
wire[2-1:0] IOBUF_CLK_input;
wire[2-1:0] IOBUF_IN_input;
wire[2-1:0] IOBUF_EN_input;
 //The configuration bits (if any) are just a long shift register
 //This shift register is padded to an even number of flops/latches
 //switch matrix multiplexer N_GBUF_BEG0 MUX-1
assign N_GBUF_BEG0 = GBUF_A_OUT;

 //switch matrix multiplexer N_GBUF_BEG1 MUX-1
assign N_GBUF_BEG1 = GBUF_B_OUT;

 //switch matrix multiplexer N_GBUF_BEG2 MUX-1
assign N_GBUF_BEG2 = GBUF_C_OUT;

 //switch matrix multiplexer N_GBUF_BEG3 MUX-1
assign N_GBUF_BEG3 = GBUF_D_OUT;

 //switch matrix multiplexer E_GBUF_BEG0 MUX-1
assign E_GBUF_BEG0 = GBUF_A_OUT;

 //switch matrix multiplexer E_GBUF_BEG1 MUX-1
assign E_GBUF_BEG1 = GBUF_B_OUT;

 //switch matrix multiplexer E_GBUF_BEG2 MUX-1
assign E_GBUF_BEG2 = GBUF_C_OUT;

 //switch matrix multiplexer E_GBUF_BEG3 MUX-1
assign E_GBUF_BEG3 = GBUF_D_OUT;

 //switch matrix multiplexer GBUF_A_IN MUX-10
assign GBUF_A_IN_input = {IOBUF_OUT,SYS_RESET_RESET,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
cus_mux161 inst_cus_mux161_GBUF_A_IN (
    .A0(GBUF_A_IN_input[0]),
    .A1(GBUF_A_IN_input[1]),
    .A2(GBUF_A_IN_input[2]),
    .A3(GBUF_A_IN_input[3]),
    .A4(GBUF_A_IN_input[4]),
    .A5(GBUF_A_IN_input[5]),
    .A6(GBUF_A_IN_input[6]),
    .A7(GBUF_A_IN_input[7]),
    .A8(GBUF_A_IN_input[8]),
    .A9(GBUF_A_IN_input[9]),
    .A10(GND0),
    .A11(GND0),
    .A12(GND0),
    .A13(GND0),
    .A14(GND0),
    .A15(GND0),
    .S0(ConfigBits[0+0]),
    .S0N(ConfigBits_N[0+0]),
    .S1(ConfigBits[0+1]),
    .S1N(ConfigBits_N[0+1]),
    .S2(ConfigBits[0+2]),
    .S2N(ConfigBits_N[0+2]),
    .S3(ConfigBits[0+3]),
    .S3N(ConfigBits_N[0+3]),
    .X(GBUF_A_IN)
);

 //switch matrix multiplexer GBUF_B_IN MUX-10
assign GBUF_B_IN_input = {IOBUF_OUT,SYS_RESET_RESET,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
cus_mux161 inst_cus_mux161_GBUF_B_IN (
    .A0(GBUF_B_IN_input[0]),
    .A1(GBUF_B_IN_input[1]),
    .A2(GBUF_B_IN_input[2]),
    .A3(GBUF_B_IN_input[3]),
    .A4(GBUF_B_IN_input[4]),
    .A5(GBUF_B_IN_input[5]),
    .A6(GBUF_B_IN_input[6]),
    .A7(GBUF_B_IN_input[7]),
    .A8(GBUF_B_IN_input[8]),
    .A9(GBUF_B_IN_input[9]),
    .A10(GND0),
    .A11(GND0),
    .A12(GND0),
    .A13(GND0),
    .A14(GND0),
    .A15(GND0),
    .S0(ConfigBits[4+0]),
    .S0N(ConfigBits_N[4+0]),
    .S1(ConfigBits[4+1]),
    .S1N(ConfigBits_N[4+1]),
    .S2(ConfigBits[4+2]),
    .S2N(ConfigBits_N[4+2]),
    .S3(ConfigBits[4+3]),
    .S3N(ConfigBits_N[4+3]),
    .X(GBUF_B_IN)
);

 //switch matrix multiplexer GBUF_C_IN MUX-10
assign GBUF_C_IN_input = {IOBUF_OUT,SYS_RESET_RESET,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
cus_mux161 inst_cus_mux161_GBUF_C_IN (
    .A0(GBUF_C_IN_input[0]),
    .A1(GBUF_C_IN_input[1]),
    .A2(GBUF_C_IN_input[2]),
    .A3(GBUF_C_IN_input[3]),
    .A4(GBUF_C_IN_input[4]),
    .A5(GBUF_C_IN_input[5]),
    .A6(GBUF_C_IN_input[6]),
    .A7(GBUF_C_IN_input[7]),
    .A8(GBUF_C_IN_input[8]),
    .A9(GBUF_C_IN_input[9]),
    .A10(GND0),
    .A11(GND0),
    .A12(GND0),
    .A13(GND0),
    .A14(GND0),
    .A15(GND0),
    .S0(ConfigBits[8+0]),
    .S0N(ConfigBits_N[8+0]),
    .S1(ConfigBits[8+1]),
    .S1N(ConfigBits_N[8+1]),
    .S2(ConfigBits[8+2]),
    .S2N(ConfigBits_N[8+2]),
    .S3(ConfigBits[8+3]),
    .S3N(ConfigBits_N[8+3]),
    .X(GBUF_C_IN)
);

 //switch matrix multiplexer GBUF_D_IN MUX-10
assign GBUF_D_IN_input = {IOBUF_OUT,SYS_RESET_RESET,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
cus_mux161 inst_cus_mux161_GBUF_D_IN (
    .A0(GBUF_D_IN_input[0]),
    .A1(GBUF_D_IN_input[1]),
    .A2(GBUF_D_IN_input[2]),
    .A3(GBUF_D_IN_input[3]),
    .A4(GBUF_D_IN_input[4]),
    .A5(GBUF_D_IN_input[5]),
    .A6(GBUF_D_IN_input[6]),
    .A7(GBUF_D_IN_input[7]),
    .A8(GBUF_D_IN_input[8]),
    .A9(GBUF_D_IN_input[9]),
    .A10(GND0),
    .A11(GND0),
    .A12(GND0),
    .A13(GND0),
    .A14(GND0),
    .A15(GND0),
    .S0(ConfigBits[12+0]),
    .S0N(ConfigBits_N[12+0]),
    .S1(ConfigBits[12+1]),
    .S1N(ConfigBits_N[12+1]),
    .S2(ConfigBits[12+2]),
    .S2N(ConfigBits_N[12+2]),
    .S3(ConfigBits[12+3]),
    .S3N(ConfigBits_N[12+3]),
    .X(GBUF_D_IN)
);

 //switch matrix multiplexer IOBUF_CLK MUX-2
assign IOBUF_CLK_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_IOBUF_CLK (
    .A0(IOBUF_CLK_input[0]),
    .A1(IOBUF_CLK_input[1]),
    .S(ConfigBits[16+0]),
    .X(IOBUF_CLK)
);

 //switch matrix multiplexer IOBUF_IN MUX-2
assign IOBUF_IN_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_IOBUF_IN (
    .A0(IOBUF_IN_input[0]),
    .A1(IOBUF_IN_input[1]),
    .S(ConfigBits[17+0]),
    .X(IOBUF_IN)
);

 //switch matrix multiplexer IOBUF_EN MUX-2
assign IOBUF_EN_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_IOBUF_EN (
    .A0(IOBUF_EN_input[0]),
    .A1(IOBUF_EN_input[1]),
    .S(ConfigBits[18+0]),
    .X(IOBUF_EN)
);

endmodule
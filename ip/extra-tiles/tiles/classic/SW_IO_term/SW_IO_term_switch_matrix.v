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
        input  A_OUT,
        input  GBUF_A_OUT,
        input  GBUF_B_OUT,
        input  GBUF_C_OUT,
        input  GBUF_D_OUT,
        input  SYS_RESET_RESET,
        output  N_GBUF_BEG0,
        output  N_GBUF_BEG1,
        output  N_GBUF_BEG2,
        output  N_GBUF_BEG3,
        output  E_GBUF_BEG0,
        output  E_GBUF_BEG1,
        output  E_GBUF_BEG2,
        output  E_GBUF_BEG3,
        output  A_CLK,
        output  A_IN,
        output  A_EN,
        output  GBUF_A_IN,
        output  GBUF_B_IN,
        output  GBUF_C_IN,
        output  GBUF_D_IN,
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

wire[2-1:0] A_CLK_input;
wire[2-1:0] A_IN_input;
wire[2-1:0] A_EN_input;
wire[10-1:0] GBUF_A_IN_input;
wire[10-1:0] GBUF_B_IN_input;
wire[10-1:0] GBUF_C_IN_input;
wire[10-1:0] GBUF_D_IN_input;
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

 //switch matrix multiplexer A_CLK MUX-2
assign A_CLK_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_A_CLK (
    .A0(A_CLK_input[0]),
    .A1(A_CLK_input[1]),
    .S(ConfigBits[0+0]),
    .X(A_CLK)
);

 //switch matrix multiplexer A_IN MUX-2
assign A_IN_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_A_IN (
    .A0(A_IN_input[0]),
    .A1(A_IN_input[1]),
    .S(ConfigBits[1+0]),
    .X(A_IN)
);

 //switch matrix multiplexer A_EN MUX-2
assign A_EN_input = {VCC0,GND0};
cus_mux21 inst_cus_mux21_A_EN (
    .A0(A_EN_input[0]),
    .A1(A_EN_input[1]),
    .S(ConfigBits[2+0]),
    .X(A_EN)
);

 //switch matrix multiplexer GBUF_A_IN MUX-10
assign GBUF_A_IN_input = {SYS_RESET_RESET,A_OUT,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
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
    .S0(ConfigBits[3+0]),
    .S0N(ConfigBits_N[3+0]),
    .S1(ConfigBits[3+1]),
    .S1N(ConfigBits_N[3+1]),
    .S2(ConfigBits[3+2]),
    .S2N(ConfigBits_N[3+2]),
    .S3(ConfigBits[3+3]),
    .S3N(ConfigBits_N[3+3]),
    .X(GBUF_A_IN)
);

 //switch matrix multiplexer GBUF_B_IN MUX-10
assign GBUF_B_IN_input = {SYS_RESET_RESET,A_OUT,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
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
    .S0(ConfigBits[7+0]),
    .S0N(ConfigBits_N[7+0]),
    .S1(ConfigBits[7+1]),
    .S1N(ConfigBits_N[7+1]),
    .S2(ConfigBits[7+2]),
    .S2N(ConfigBits_N[7+2]),
    .S3(ConfigBits[7+3]),
    .S3N(ConfigBits_N[7+3]),
    .X(GBUF_B_IN)
);

 //switch matrix multiplexer GBUF_C_IN MUX-10
assign GBUF_C_IN_input = {SYS_RESET_RESET,A_OUT,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
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
    .S0(ConfigBits[11+0]),
    .S0N(ConfigBits_N[11+0]),
    .S1(ConfigBits[11+1]),
    .S1N(ConfigBits_N[11+1]),
    .S2(ConfigBits[11+2]),
    .S2N(ConfigBits_N[11+2]),
    .S3(ConfigBits[11+3]),
    .S3N(ConfigBits_N[11+3]),
    .X(GBUF_C_IN)
);

 //switch matrix multiplexer GBUF_D_IN MUX-10
assign GBUF_D_IN_input = {SYS_RESET_RESET,A_OUT,W_GBUF_FEED_END3,W_GBUF_FEED_END2,W_GBUF_FEED_END1,W_GBUF_FEED_END0,S_GBUF_FEED_END3,S_GBUF_FEED_END2,S_GBUF_FEED_END1,S_GBUF_FEED_END0};
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
    .S0(ConfigBits[15+0]),
    .S0N(ConfigBits_N[15+0]),
    .S1(ConfigBits[15+1]),
    .S1N(ConfigBits_N[15+1]),
    .S2(ConfigBits[15+2]),
    .S2N(ConfigBits_N[15+2]),
    .S3(ConfigBits[15+3]),
    .S3N(ConfigBits_N[15+3]),
    .X(GBUF_D_IN)
);

endmodule
 // NumberOfConfigBits: 75
module S_XIF_middle_switch_matrix
    #(
        parameter NoConfigBits=75
    )
    (
        input  W_GBUF_FEED_END0,
        input  W_GBUF_FEED_END1,
        input  W_GBUF_FEED_END2,
        input  W_GBUF_FEED_END3,
        input  E_GBUF_END0,
        input  E_GBUF_END1,
        input  E_GBUF_END2,
        input  E_GBUF_END3,
        input  S1END0,
        input  S1END1,
        input  S1END2,
        input  S1END3,
        input  S2MID0,
        input  S2MID1,
        input  S2MID2,
        input  S2MID3,
        input  S2MID4,
        input  S2MID5,
        input  S2MID6,
        input  S2MID7,
        input  S2END0,
        input  S2END1,
        input  S2END2,
        input  S2END3,
        input  S2END4,
        input  S2END5,
        input  S2END6,
        input  S2END7,
        input  S4END0,
        input  S4END1,
        input  S4END2,
        input  S4END3,
        input  S4END4,
        input  S4END5,
        input  S4END6,
        input  S4END7,
        input  S4END8,
        input  S4END9,
        input  S4END10,
        input  S4END11,
        input  S4END12,
        input  S4END13,
        input  S4END14,
        input  S4END15,
        input  SS4END0,
        input  SS4END1,
        input  SS4END2,
        input  SS4END3,
        input  SS4END4,
        input  SS4END5,
        input  SS4END6,
        input  SS4END7,
        input  SS4END8,
        input  SS4END9,
        input  SS4END10,
        input  SS4END11,
        input  SS4END12,
        input  SS4END13,
        input  SS4END14,
        input  SS4END15,
        input  left2middle_RESULT0,
        input  left2middle_RESULT1,
        input  left2middle_RESULT2,
        input  left2middle_RESULT3,
        input  left2middle_RESULT4,
        input  left2middle_RESULT5,
        input  left2middle_RESULT6,
        input  left2middle_RESULT7,
        input  left2middle_RESULT8,
        input  left2middle_RESULT9,
        input  left2middle_RESULT10,
        input  left2middle_RESULT11,
        input  left2middle_RESULT12,
        input  left2middle_RESULT13,
        input  left2middle_RESULT14,
        input  left2middle_RESULT15,
        input  right2middle_RESULT0,
        input  right2middle_RESULT1,
        input  right2middle_RESULT2,
        input  right2middle_RESULT3,
        input  right2middle_RESULT4,
        input  right2middle_RESULT5,
        input  right2middle_RESULT6,
        input  right2middle_RESULT7,
        input  right2middle_RESULT8,
        input  right2middle_RESULT9,
        input  right2middle_RESULT10,
        input  right2middle_RESULT11,
        input  right2middle_RESULT12,
        input  right2middle_RESULT13,
        input  right2middle_RESULT14,
        input  right2middle_RESULT15,
        input  ISSUE_VALID,
        input  ISSUE_INSTR0,
        input  ISSUE_INSTR1,
        input  ISSUE_INSTR2,
        input  ISSUE_INSTR3,
        input  ISSUE_INSTR4,
        input  ISSUE_INSTR5,
        input  ISSUE_INSTR6,
        input  ISSUE_INSTR7,
        input  ISSUE_INSTR8,
        input  ISSUE_INSTR9,
        input  ISSUE_INSTR10,
        input  ISSUE_INSTR11,
        input  ISSUE_INSTR12,
        input  ISSUE_INSTR13,
        input  ISSUE_INSTR14,
        input  ISSUE_INSTR15,
        input  ISSUE_INSTR16,
        input  ISSUE_INSTR17,
        input  ISSUE_INSTR18,
        input  ISSUE_INSTR19,
        input  ISSUE_INSTR20,
        input  ISSUE_INSTR21,
        input  ISSUE_INSTR22,
        input  ISSUE_INSTR23,
        input  ISSUE_INSTR24,
        input  ISSUE_INSTR25,
        input  ISSUE_INSTR26,
        input  ISSUE_INSTR27,
        input  ISSUE_INSTR28,
        input  ISSUE_INSTR29,
        input  ISSUE_INSTR30,
        input  ISSUE_INSTR31,
        input  ISSUE_OPA0,
        input  ISSUE_OPA1,
        input  ISSUE_OPA2,
        input  ISSUE_OPA3,
        input  ISSUE_OPA4,
        input  ISSUE_OPA5,
        input  ISSUE_OPA6,
        input  ISSUE_OPA7,
        input  ISSUE_OPA8,
        input  ISSUE_OPA9,
        input  ISSUE_OPA10,
        input  ISSUE_OPA11,
        input  ISSUE_OPA12,
        input  ISSUE_OPA13,
        input  ISSUE_OPA14,
        input  ISSUE_OPA15,
        input  ISSUE_OPA16,
        input  ISSUE_OPA17,
        input  ISSUE_OPA18,
        input  ISSUE_OPA19,
        input  ISSUE_OPA20,
        input  ISSUE_OPA21,
        input  ISSUE_OPA22,
        input  ISSUE_OPA23,
        input  ISSUE_OPA24,
        input  ISSUE_OPA25,
        input  ISSUE_OPA26,
        input  ISSUE_OPA27,
        input  ISSUE_OPA28,
        input  ISSUE_OPA29,
        input  ISSUE_OPA30,
        input  ISSUE_OPA31,
        input  ISSUE_OPB0,
        input  ISSUE_OPB1,
        input  ISSUE_OPB2,
        input  ISSUE_OPB3,
        input  ISSUE_OPB4,
        input  ISSUE_OPB5,
        input  ISSUE_OPB6,
        input  ISSUE_OPB7,
        input  ISSUE_OPB8,
        input  ISSUE_OPB9,
        input  ISSUE_OPB10,
        input  ISSUE_OPB11,
        input  ISSUE_OPB12,
        input  ISSUE_OPB13,
        input  ISSUE_OPB14,
        input  ISSUE_OPB15,
        input  ISSUE_OPB16,
        input  ISSUE_OPB17,
        input  ISSUE_OPB18,
        input  ISSUE_OPB19,
        input  ISSUE_OPB20,
        input  ISSUE_OPB21,
        input  ISSUE_OPB22,
        input  ISSUE_OPB23,
        input  ISSUE_OPB24,
        input  ISSUE_OPB25,
        input  ISSUE_OPB26,
        input  ISSUE_OPB27,
        input  ISSUE_OPB28,
        input  ISSUE_OPB29,
        input  ISSUE_OPB30,
        input  ISSUE_OPB31,
        input  ISSUE_ID0,
        input  ISSUE_ID1,
        input  ISSUE_ID2,
        input  ISSUE_ID3,
        output  W_GBUF_FEED_BEG0,
        output  W_GBUF_FEED_BEG1,
        output  W_GBUF_FEED_BEG2,
        output  W_GBUF_FEED_BEG3,
        output  N_GBUF_BEG0,
        output  N_GBUF_BEG1,
        output  N_GBUF_BEG2,
        output  N_GBUF_BEG3,
        output  E_GBUF_BEG0,
        output  E_GBUF_BEG1,
        output  E_GBUF_BEG2,
        output  E_GBUF_BEG3,
        output  N1BEG0,
        output  N1BEG1,
        output  N1BEG2,
        output  N1BEG3,
        output  N2BEG0,
        output  N2BEG1,
        output  N2BEG2,
        output  N2BEG3,
        output  N2BEG4,
        output  N2BEG5,
        output  N2BEG6,
        output  N2BEG7,
        output  N2BEGb0,
        output  N2BEGb1,
        output  N2BEGb2,
        output  N2BEGb3,
        output  N2BEGb4,
        output  N2BEGb5,
        output  N2BEGb6,
        output  N2BEGb7,
        output  N4BEG0,
        output  N4BEG1,
        output  N4BEG2,
        output  N4BEG3,
        output  N4BEG4,
        output  N4BEG5,
        output  N4BEG6,
        output  N4BEG7,
        output  N4BEG8,
        output  N4BEG9,
        output  N4BEG10,
        output  N4BEG11,
        output  N4BEG12,
        output  N4BEG13,
        output  N4BEG14,
        output  N4BEG15,
        output  NN4BEG0,
        output  NN4BEG1,
        output  NN4BEG2,
        output  NN4BEG3,
        output  NN4BEG4,
        output  NN4BEG5,
        output  NN4BEG6,
        output  NN4BEG7,
        output  NN4BEG8,
        output  NN4BEG9,
        output  NN4BEG10,
        output  NN4BEG11,
        output  NN4BEG12,
        output  NN4BEG13,
        output  NN4BEG14,
        output  NN4BEG15,
        output  Co0,
        output  middle2left_ISSUE_OPA0,
        output  middle2left_ISSUE_OPA1,
        output  middle2left_ISSUE_OPA2,
        output  middle2left_ISSUE_OPA3,
        output  middle2left_ISSUE_OPA4,
        output  middle2left_ISSUE_OPA5,
        output  middle2left_ISSUE_OPA6,
        output  middle2left_ISSUE_OPA7,
        output  middle2left_ISSUE_OPA8,
        output  middle2left_ISSUE_OPA9,
        output  middle2left_ISSUE_OPA10,
        output  middle2left_ISSUE_OPA11,
        output  middle2left_ISSUE_OPA12,
        output  middle2left_ISSUE_OPA13,
        output  middle2left_ISSUE_OPA14,
        output  middle2left_ISSUE_OPA15,
        output  middle2left_ISSUE_OPA16,
        output  middle2left_ISSUE_OPA17,
        output  middle2left_ISSUE_OPA18,
        output  middle2left_ISSUE_OPA19,
        output  middle2left_ISSUE_OPA20,
        output  middle2left_ISSUE_OPA21,
        output  middle2left_ISSUE_OPA22,
        output  middle2left_ISSUE_OPA23,
        output  middle2left_ISSUE_OPA24,
        output  middle2left_ISSUE_OPA25,
        output  middle2left_ISSUE_OPA26,
        output  middle2left_ISSUE_OPA27,
        output  middle2left_ISSUE_OPA28,
        output  middle2left_ISSUE_OPA29,
        output  middle2left_ISSUE_OPA30,
        output  middle2left_ISSUE_OPA31,
        output  middle2right_ISSUE_OPB0,
        output  middle2right_ISSUE_OPB1,
        output  middle2right_ISSUE_OPB2,
        output  middle2right_ISSUE_OPB3,
        output  middle2right_ISSUE_OPB4,
        output  middle2right_ISSUE_OPB5,
        output  middle2right_ISSUE_OPB6,
        output  middle2right_ISSUE_OPB7,
        output  middle2right_ISSUE_OPB8,
        output  middle2right_ISSUE_OPB9,
        output  middle2right_ISSUE_OPB10,
        output  middle2right_ISSUE_OPB11,
        output  middle2right_ISSUE_OPB12,
        output  middle2right_ISSUE_OPB13,
        output  middle2right_ISSUE_OPB14,
        output  middle2right_ISSUE_OPB15,
        output  middle2right_ISSUE_OPB16,
        output  middle2right_ISSUE_OPB17,
        output  middle2right_ISSUE_OPB18,
        output  middle2right_ISSUE_OPB19,
        output  middle2right_ISSUE_OPB20,
        output  middle2right_ISSUE_OPB21,
        output  middle2right_ISSUE_OPB22,
        output  middle2right_ISSUE_OPB23,
        output  middle2right_ISSUE_OPB24,
        output  middle2right_ISSUE_OPB25,
        output  middle2right_ISSUE_OPB26,
        output  middle2right_ISSUE_OPB27,
        output  middle2right_ISSUE_OPB28,
        output  middle2right_ISSUE_OPB29,
        output  middle2right_ISSUE_OPB30,
        output  middle2right_ISSUE_OPB31,
        output  ISSUE_READY,
        output  ISSUE_ACCEPT,
        output  RESULT_VALID,
        output  RESULT_ID0,
        output  RESULT_ID1,
        output  RESULT_ID2,
        output  RESULT_ID3,
        output  RESULT_RD0,
        output  RESULT_RD1,
        output  RESULT_RD2,
        output  RESULT_RD3,
        output  RESULT_RD4,
        output  RESULT0,
        output  RESULT1,
        output  RESULT2,
        output  RESULT3,
        output  RESULT4,
        output  RESULT5,
        output  RESULT6,
        output  RESULT7,
        output  RESULT8,
        output  RESULT9,
        output  RESULT10,
        output  RESULT11,
        output  RESULT12,
        output  RESULT13,
        output  RESULT14,
        output  RESULT15,
        output  RESULT16,
        output  RESULT17,
        output  RESULT18,
        output  RESULT19,
        output  RESULT20,
        output  RESULT21,
        output  RESULT22,
        output  RESULT23,
        output  RESULT24,
        output  RESULT25,
        output  RESULT26,
        output  RESULT27,
        output  RESULT28,
        output  RESULT29,
        output  RESULT30,
        output  RESULT31,
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

wire[4-1:0] W_GBUF_FEED_BEG0_input;
wire[4-1:0] W_GBUF_FEED_BEG1_input;
wire[4-1:0] W_GBUF_FEED_BEG2_input;
wire[4-1:0] W_GBUF_FEED_BEG3_input;
wire[2-1:0] N1BEG0_input;
wire[2-1:0] N1BEG1_input;
wire[2-1:0] N1BEG2_input;
wire[2-1:0] N1BEG3_input;
wire[2-1:0] N2BEG0_input;
wire[2-1:0] N2BEG1_input;
wire[2-1:0] N2BEG2_input;
wire[2-1:0] N2BEG3_input;
wire[2-1:0] N2BEG4_input;
wire[2-1:0] N2BEG5_input;
wire[2-1:0] N2BEG6_input;
wire[2-1:0] N2BEG7_input;
wire[2-1:0] N2BEGb0_input;
wire[2-1:0] N2BEGb1_input;
wire[2-1:0] N2BEGb2_input;
wire[2-1:0] N2BEGb3_input;
wire[2-1:0] N2BEGb4_input;
wire[2-1:0] N2BEGb5_input;
wire[2-1:0] N2BEGb6_input;
wire[2-1:0] N2BEGb7_input;
wire[2-1:0] N4BEG0_input;
wire[2-1:0] N4BEG1_input;
wire[2-1:0] N4BEG2_input;
wire[2-1:0] N4BEG3_input;
wire[2-1:0] N4BEG4_input;
wire[2-1:0] N4BEG5_input;
wire[2-1:0] N4BEG6_input;
wire[2-1:0] N4BEG7_input;
wire[2-1:0] N4BEG8_input;
wire[2-1:0] N4BEG9_input;
wire[2-1:0] N4BEG10_input;
wire[2-1:0] N4BEG11_input;
wire[2-1:0] N4BEG12_input;
wire[2-1:0] N4BEG13_input;
wire[2-1:0] N4BEG14_input;
wire[2-1:0] N4BEG15_input;
wire[2-1:0] NN4BEG0_input;
wire[2-1:0] NN4BEG1_input;
wire[2-1:0] NN4BEG2_input;
wire[2-1:0] NN4BEG3_input;
wire[2-1:0] NN4BEG4_input;
wire[2-1:0] NN4BEG5_input;
wire[2-1:0] NN4BEG6_input;
wire[2-1:0] NN4BEG7_input;
wire[2-1:0] NN4BEG8_input;
wire[2-1:0] NN4BEG9_input;
wire[2-1:0] NN4BEG10_input;
wire[2-1:0] NN4BEG11_input;
wire[2-1:0] NN4BEG12_input;
wire[2-1:0] NN4BEG13_input;
wire[2-1:0] NN4BEG14_input;
wire[2-1:0] NN4BEG15_input;
wire[4-1:0] ISSUE_READY_input;
wire[4-1:0] ISSUE_ACCEPT_input;
wire[4-1:0] RESULT_VALID_input;
wire[2-1:0] RESULT_ID0_input;
wire[2-1:0] RESULT_ID1_input;
wire[2-1:0] RESULT_ID2_input;
wire[2-1:0] RESULT_ID3_input;
wire[2-1:0] RESULT_RD0_input;
wire[2-1:0] RESULT_RD1_input;
wire[2-1:0] RESULT_RD2_input;
wire[2-1:0] RESULT_RD3_input;
wire[2-1:0] RESULT_RD4_input;
 //The configuration bits (if any) are just a long shift register
 //This shift register is padded to an even number of flops/latches
 //switch matrix multiplexer W_GBUF_FEED_BEG0 MUX-4
assign W_GBUF_FEED_BEG0_input = {S4END1,S2END7,S1END1,W_GBUF_FEED_END0};
cus_mux41 inst_cus_mux41_W_GBUF_FEED_BEG0 (
    .A0(W_GBUF_FEED_BEG0_input[0]),
    .A1(W_GBUF_FEED_BEG0_input[1]),
    .A2(W_GBUF_FEED_BEG0_input[2]),
    .A3(W_GBUF_FEED_BEG0_input[3]),
    .S0(ConfigBits[0+0]),
    .S0N(ConfigBits_N[0+0]),
    .S1(ConfigBits[0+1]),
    .S1N(ConfigBits_N[0+1]),
    .X(W_GBUF_FEED_BEG0)
);

 //switch matrix multiplexer W_GBUF_FEED_BEG1 MUX-4
assign W_GBUF_FEED_BEG1_input = {S4END2,S2END6,S1END2,W_GBUF_FEED_END1};
cus_mux41 inst_cus_mux41_W_GBUF_FEED_BEG1 (
    .A0(W_GBUF_FEED_BEG1_input[0]),
    .A1(W_GBUF_FEED_BEG1_input[1]),
    .A2(W_GBUF_FEED_BEG1_input[2]),
    .A3(W_GBUF_FEED_BEG1_input[3]),
    .S0(ConfigBits[2+0]),
    .S0N(ConfigBits_N[2+0]),
    .S1(ConfigBits[2+1]),
    .S1N(ConfigBits_N[2+1]),
    .X(W_GBUF_FEED_BEG1)
);

 //switch matrix multiplexer W_GBUF_FEED_BEG2 MUX-4
assign W_GBUF_FEED_BEG2_input = {S4END3,S2END5,S1END3,W_GBUF_FEED_END2};
cus_mux41 inst_cus_mux41_W_GBUF_FEED_BEG2 (
    .A0(W_GBUF_FEED_BEG2_input[0]),
    .A1(W_GBUF_FEED_BEG2_input[1]),
    .A2(W_GBUF_FEED_BEG2_input[2]),
    .A3(W_GBUF_FEED_BEG2_input[3]),
    .S0(ConfigBits[4+0]),
    .S0N(ConfigBits_N[4+0]),
    .S1(ConfigBits[4+1]),
    .S1N(ConfigBits_N[4+1]),
    .X(W_GBUF_FEED_BEG2)
);

 //switch matrix multiplexer W_GBUF_FEED_BEG3 MUX-4
assign W_GBUF_FEED_BEG3_input = {S4END0,S2END4,S1END0,W_GBUF_FEED_END3};
cus_mux41 inst_cus_mux41_W_GBUF_FEED_BEG3 (
    .A0(W_GBUF_FEED_BEG3_input[0]),
    .A1(W_GBUF_FEED_BEG3_input[1]),
    .A2(W_GBUF_FEED_BEG3_input[2]),
    .A3(W_GBUF_FEED_BEG3_input[3]),
    .S0(ConfigBits[6+0]),
    .S0N(ConfigBits_N[6+0]),
    .S1(ConfigBits[6+1]),
    .S1N(ConfigBits_N[6+1]),
    .X(W_GBUF_FEED_BEG3)
);

 //switch matrix multiplexer N_GBUF_BEG0 MUX-1
assign N_GBUF_BEG0 = E_GBUF_END0;

 //switch matrix multiplexer N_GBUF_BEG1 MUX-1
assign N_GBUF_BEG1 = E_GBUF_END1;

 //switch matrix multiplexer N_GBUF_BEG2 MUX-1
assign N_GBUF_BEG2 = E_GBUF_END2;

 //switch matrix multiplexer N_GBUF_BEG3 MUX-1
assign N_GBUF_BEG3 = E_GBUF_END3;

 //switch matrix multiplexer E_GBUF_BEG0 MUX-1
assign E_GBUF_BEG0 = E_GBUF_END0;

 //switch matrix multiplexer E_GBUF_BEG1 MUX-1
assign E_GBUF_BEG1 = E_GBUF_END1;

 //switch matrix multiplexer E_GBUF_BEG2 MUX-1
assign E_GBUF_BEG2 = E_GBUF_END2;

 //switch matrix multiplexer E_GBUF_BEG3 MUX-1
assign E_GBUF_BEG3 = E_GBUF_END3;

 //switch matrix multiplexer N1BEG0 MUX-2
assign N1BEG0_input = {ISSUE_VALID,S1END3};
cus_mux21 inst_cus_mux21_N1BEG0 (
    .A0(N1BEG0_input[0]),
    .A1(N1BEG0_input[1]),
    .S(ConfigBits[8+0]),
    .X(N1BEG0)
);

 //switch matrix multiplexer N1BEG1 MUX-2
assign N1BEG1_input = {ISSUE_VALID,S1END2};
cus_mux21 inst_cus_mux21_N1BEG1 (
    .A0(N1BEG1_input[0]),
    .A1(N1BEG1_input[1]),
    .S(ConfigBits[9+0]),
    .X(N1BEG1)
);

 //switch matrix multiplexer N1BEG2 MUX-2
assign N1BEG2_input = {ISSUE_VALID,S1END1};
cus_mux21 inst_cus_mux21_N1BEG2 (
    .A0(N1BEG2_input[0]),
    .A1(N1BEG2_input[1]),
    .S(ConfigBits[10+0]),
    .X(N1BEG2)
);

 //switch matrix multiplexer N1BEG3 MUX-2
assign N1BEG3_input = {ISSUE_VALID,S1END0};
cus_mux21 inst_cus_mux21_N1BEG3 (
    .A0(N1BEG3_input[0]),
    .A1(N1BEG3_input[1]),
    .S(ConfigBits[11+0]),
    .X(N1BEG3)
);

 //switch matrix multiplexer N2BEG0 MUX-2
assign N2BEG0_input = {ISSUE_ID0,S2MID7};
cus_mux21 inst_cus_mux21_N2BEG0 (
    .A0(N2BEG0_input[0]),
    .A1(N2BEG0_input[1]),
    .S(ConfigBits[12+0]),
    .X(N2BEG0)
);

 //switch matrix multiplexer N2BEG1 MUX-2
assign N2BEG1_input = {ISSUE_ID1,S2MID6};
cus_mux21 inst_cus_mux21_N2BEG1 (
    .A0(N2BEG1_input[0]),
    .A1(N2BEG1_input[1]),
    .S(ConfigBits[13+0]),
    .X(N2BEG1)
);

 //switch matrix multiplexer N2BEG2 MUX-2
assign N2BEG2_input = {ISSUE_ID2,S2MID5};
cus_mux21 inst_cus_mux21_N2BEG2 (
    .A0(N2BEG2_input[0]),
    .A1(N2BEG2_input[1]),
    .S(ConfigBits[14+0]),
    .X(N2BEG2)
);

 //switch matrix multiplexer N2BEG3 MUX-2
assign N2BEG3_input = {ISSUE_ID3,S2MID4};
cus_mux21 inst_cus_mux21_N2BEG3 (
    .A0(N2BEG3_input[0]),
    .A1(N2BEG3_input[1]),
    .S(ConfigBits[15+0]),
    .X(N2BEG3)
);

 //switch matrix multiplexer N2BEG4 MUX-2
assign N2BEG4_input = {ISSUE_VALID,S2MID3};
cus_mux21 inst_cus_mux21_N2BEG4 (
    .A0(N2BEG4_input[0]),
    .A1(N2BEG4_input[1]),
    .S(ConfigBits[16+0]),
    .X(N2BEG4)
);

 //switch matrix multiplexer N2BEG5 MUX-2
assign N2BEG5_input = {ISSUE_VALID,S2MID2};
cus_mux21 inst_cus_mux21_N2BEG5 (
    .A0(N2BEG5_input[0]),
    .A1(N2BEG5_input[1]),
    .S(ConfigBits[17+0]),
    .X(N2BEG5)
);

 //switch matrix multiplexer N2BEG6 MUX-2
assign N2BEG6_input = {ISSUE_VALID,S2MID1};
cus_mux21 inst_cus_mux21_N2BEG6 (
    .A0(N2BEG6_input[0]),
    .A1(N2BEG6_input[1]),
    .S(ConfigBits[18+0]),
    .X(N2BEG6)
);

 //switch matrix multiplexer N2BEG7 MUX-2
assign N2BEG7_input = {ISSUE_VALID,S2MID0};
cus_mux21 inst_cus_mux21_N2BEG7 (
    .A0(N2BEG7_input[0]),
    .A1(N2BEG7_input[1]),
    .S(ConfigBits[19+0]),
    .X(N2BEG7)
);

 //switch matrix multiplexer N2BEGb0 MUX-2
assign N2BEGb0_input = {ISSUE_VALID,S2END7};
cus_mux21 inst_cus_mux21_N2BEGb0 (
    .A0(N2BEGb0_input[0]),
    .A1(N2BEGb0_input[1]),
    .S(ConfigBits[20+0]),
    .X(N2BEGb0)
);

 //switch matrix multiplexer N2BEGb1 MUX-2
assign N2BEGb1_input = {ISSUE_VALID,S2END6};
cus_mux21 inst_cus_mux21_N2BEGb1 (
    .A0(N2BEGb1_input[0]),
    .A1(N2BEGb1_input[1]),
    .S(ConfigBits[21+0]),
    .X(N2BEGb1)
);

 //switch matrix multiplexer N2BEGb2 MUX-2
assign N2BEGb2_input = {ISSUE_VALID,S2END5};
cus_mux21 inst_cus_mux21_N2BEGb2 (
    .A0(N2BEGb2_input[0]),
    .A1(N2BEGb2_input[1]),
    .S(ConfigBits[22+0]),
    .X(N2BEGb2)
);

 //switch matrix multiplexer N2BEGb3 MUX-2
assign N2BEGb3_input = {ISSUE_VALID,S2END4};
cus_mux21 inst_cus_mux21_N2BEGb3 (
    .A0(N2BEGb3_input[0]),
    .A1(N2BEGb3_input[1]),
    .S(ConfigBits[23+0]),
    .X(N2BEGb3)
);

 //switch matrix multiplexer N2BEGb4 MUX-2
assign N2BEGb4_input = {ISSUE_ID0,S2END3};
cus_mux21 inst_cus_mux21_N2BEGb4 (
    .A0(N2BEGb4_input[0]),
    .A1(N2BEGb4_input[1]),
    .S(ConfigBits[24+0]),
    .X(N2BEGb4)
);

 //switch matrix multiplexer N2BEGb5 MUX-2
assign N2BEGb5_input = {ISSUE_ID1,S2END2};
cus_mux21 inst_cus_mux21_N2BEGb5 (
    .A0(N2BEGb5_input[0]),
    .A1(N2BEGb5_input[1]),
    .S(ConfigBits[25+0]),
    .X(N2BEGb5)
);

 //switch matrix multiplexer N2BEGb6 MUX-2
assign N2BEGb6_input = {ISSUE_ID2,S2END1};
cus_mux21 inst_cus_mux21_N2BEGb6 (
    .A0(N2BEGb6_input[0]),
    .A1(N2BEGb6_input[1]),
    .S(ConfigBits[26+0]),
    .X(N2BEGb6)
);

 //switch matrix multiplexer N2BEGb7 MUX-2
assign N2BEGb7_input = {ISSUE_ID3,S2END0};
cus_mux21 inst_cus_mux21_N2BEGb7 (
    .A0(N2BEGb7_input[0]),
    .A1(N2BEGb7_input[1]),
    .S(ConfigBits[27+0]),
    .X(N2BEGb7)
);

 //switch matrix multiplexer N4BEG0 MUX-2
assign N4BEG0_input = {ISSUE_INSTR15,S4END15};
cus_mux21 inst_cus_mux21_N4BEG0 (
    .A0(N4BEG0_input[0]),
    .A1(N4BEG0_input[1]),
    .S(ConfigBits[28+0]),
    .X(N4BEG0)
);

 //switch matrix multiplexer N4BEG1 MUX-2
assign N4BEG1_input = {ISSUE_INSTR14,S4END14};
cus_mux21 inst_cus_mux21_N4BEG1 (
    .A0(N4BEG1_input[0]),
    .A1(N4BEG1_input[1]),
    .S(ConfigBits[29+0]),
    .X(N4BEG1)
);

 //switch matrix multiplexer N4BEG2 MUX-2
assign N4BEG2_input = {ISSUE_INSTR13,S4END13};
cus_mux21 inst_cus_mux21_N4BEG2 (
    .A0(N4BEG2_input[0]),
    .A1(N4BEG2_input[1]),
    .S(ConfigBits[30+0]),
    .X(N4BEG2)
);

 //switch matrix multiplexer N4BEG3 MUX-2
assign N4BEG3_input = {ISSUE_INSTR12,S4END12};
cus_mux21 inst_cus_mux21_N4BEG3 (
    .A0(N4BEG3_input[0]),
    .A1(N4BEG3_input[1]),
    .S(ConfigBits[31+0]),
    .X(N4BEG3)
);

 //switch matrix multiplexer N4BEG4 MUX-2
assign N4BEG4_input = {ISSUE_INSTR11,S4END11};
cus_mux21 inst_cus_mux21_N4BEG4 (
    .A0(N4BEG4_input[0]),
    .A1(N4BEG4_input[1]),
    .S(ConfigBits[32+0]),
    .X(N4BEG4)
);

 //switch matrix multiplexer N4BEG5 MUX-2
assign N4BEG5_input = {ISSUE_INSTR10,S4END10};
cus_mux21 inst_cus_mux21_N4BEG5 (
    .A0(N4BEG5_input[0]),
    .A1(N4BEG5_input[1]),
    .S(ConfigBits[33+0]),
    .X(N4BEG5)
);

 //switch matrix multiplexer N4BEG6 MUX-2
assign N4BEG6_input = {ISSUE_INSTR9,S4END9};
cus_mux21 inst_cus_mux21_N4BEG6 (
    .A0(N4BEG6_input[0]),
    .A1(N4BEG6_input[1]),
    .S(ConfigBits[34+0]),
    .X(N4BEG6)
);

 //switch matrix multiplexer N4BEG7 MUX-2
assign N4BEG7_input = {ISSUE_INSTR8,S4END8};
cus_mux21 inst_cus_mux21_N4BEG7 (
    .A0(N4BEG7_input[0]),
    .A1(N4BEG7_input[1]),
    .S(ConfigBits[35+0]),
    .X(N4BEG7)
);

 //switch matrix multiplexer N4BEG8 MUX-2
assign N4BEG8_input = {ISSUE_INSTR7,S4END7};
cus_mux21 inst_cus_mux21_N4BEG8 (
    .A0(N4BEG8_input[0]),
    .A1(N4BEG8_input[1]),
    .S(ConfigBits[36+0]),
    .X(N4BEG8)
);

 //switch matrix multiplexer N4BEG9 MUX-2
assign N4BEG9_input = {ISSUE_INSTR6,S4END6};
cus_mux21 inst_cus_mux21_N4BEG9 (
    .A0(N4BEG9_input[0]),
    .A1(N4BEG9_input[1]),
    .S(ConfigBits[37+0]),
    .X(N4BEG9)
);

 //switch matrix multiplexer N4BEG10 MUX-2
assign N4BEG10_input = {ISSUE_INSTR5,S4END5};
cus_mux21 inst_cus_mux21_N4BEG10 (
    .A0(N4BEG10_input[0]),
    .A1(N4BEG10_input[1]),
    .S(ConfigBits[38+0]),
    .X(N4BEG10)
);

 //switch matrix multiplexer N4BEG11 MUX-2
assign N4BEG11_input = {ISSUE_INSTR4,S4END4};
cus_mux21 inst_cus_mux21_N4BEG11 (
    .A0(N4BEG11_input[0]),
    .A1(N4BEG11_input[1]),
    .S(ConfigBits[39+0]),
    .X(N4BEG11)
);

 //switch matrix multiplexer N4BEG12 MUX-2
assign N4BEG12_input = {ISSUE_INSTR3,S4END3};
cus_mux21 inst_cus_mux21_N4BEG12 (
    .A0(N4BEG12_input[0]),
    .A1(N4BEG12_input[1]),
    .S(ConfigBits[40+0]),
    .X(N4BEG12)
);

 //switch matrix multiplexer N4BEG13 MUX-2
assign N4BEG13_input = {ISSUE_INSTR2,S4END2};
cus_mux21 inst_cus_mux21_N4BEG13 (
    .A0(N4BEG13_input[0]),
    .A1(N4BEG13_input[1]),
    .S(ConfigBits[41+0]),
    .X(N4BEG13)
);

 //switch matrix multiplexer N4BEG14 MUX-2
assign N4BEG14_input = {ISSUE_INSTR1,S4END1};
cus_mux21 inst_cus_mux21_N4BEG14 (
    .A0(N4BEG14_input[0]),
    .A1(N4BEG14_input[1]),
    .S(ConfigBits[42+0]),
    .X(N4BEG14)
);

 //switch matrix multiplexer N4BEG15 MUX-2
assign N4BEG15_input = {ISSUE_INSTR0,S4END0};
cus_mux21 inst_cus_mux21_N4BEG15 (
    .A0(N4BEG15_input[0]),
    .A1(N4BEG15_input[1]),
    .S(ConfigBits[43+0]),
    .X(N4BEG15)
);

 //switch matrix multiplexer NN4BEG0 MUX-2
assign NN4BEG0_input = {ISSUE_INSTR31,SS4END15};
cus_mux21 inst_cus_mux21_NN4BEG0 (
    .A0(NN4BEG0_input[0]),
    .A1(NN4BEG0_input[1]),
    .S(ConfigBits[44+0]),
    .X(NN4BEG0)
);

 //switch matrix multiplexer NN4BEG1 MUX-2
assign NN4BEG1_input = {ISSUE_INSTR30,SS4END14};
cus_mux21 inst_cus_mux21_NN4BEG1 (
    .A0(NN4BEG1_input[0]),
    .A1(NN4BEG1_input[1]),
    .S(ConfigBits[45+0]),
    .X(NN4BEG1)
);

 //switch matrix multiplexer NN4BEG2 MUX-2
assign NN4BEG2_input = {ISSUE_INSTR29,SS4END13};
cus_mux21 inst_cus_mux21_NN4BEG2 (
    .A0(NN4BEG2_input[0]),
    .A1(NN4BEG2_input[1]),
    .S(ConfigBits[46+0]),
    .X(NN4BEG2)
);

 //switch matrix multiplexer NN4BEG3 MUX-2
assign NN4BEG3_input = {ISSUE_INSTR28,SS4END12};
cus_mux21 inst_cus_mux21_NN4BEG3 (
    .A0(NN4BEG3_input[0]),
    .A1(NN4BEG3_input[1]),
    .S(ConfigBits[47+0]),
    .X(NN4BEG3)
);

 //switch matrix multiplexer NN4BEG4 MUX-2
assign NN4BEG4_input = {ISSUE_INSTR27,SS4END11};
cus_mux21 inst_cus_mux21_NN4BEG4 (
    .A0(NN4BEG4_input[0]),
    .A1(NN4BEG4_input[1]),
    .S(ConfigBits[48+0]),
    .X(NN4BEG4)
);

 //switch matrix multiplexer NN4BEG5 MUX-2
assign NN4BEG5_input = {ISSUE_INSTR26,SS4END10};
cus_mux21 inst_cus_mux21_NN4BEG5 (
    .A0(NN4BEG5_input[0]),
    .A1(NN4BEG5_input[1]),
    .S(ConfigBits[49+0]),
    .X(NN4BEG5)
);

 //switch matrix multiplexer NN4BEG6 MUX-2
assign NN4BEG6_input = {ISSUE_INSTR25,SS4END9};
cus_mux21 inst_cus_mux21_NN4BEG6 (
    .A0(NN4BEG6_input[0]),
    .A1(NN4BEG6_input[1]),
    .S(ConfigBits[50+0]),
    .X(NN4BEG6)
);

 //switch matrix multiplexer NN4BEG7 MUX-2
assign NN4BEG7_input = {ISSUE_INSTR24,SS4END8};
cus_mux21 inst_cus_mux21_NN4BEG7 (
    .A0(NN4BEG7_input[0]),
    .A1(NN4BEG7_input[1]),
    .S(ConfigBits[51+0]),
    .X(NN4BEG7)
);

 //switch matrix multiplexer NN4BEG8 MUX-2
assign NN4BEG8_input = {ISSUE_INSTR23,SS4END7};
cus_mux21 inst_cus_mux21_NN4BEG8 (
    .A0(NN4BEG8_input[0]),
    .A1(NN4BEG8_input[1]),
    .S(ConfigBits[52+0]),
    .X(NN4BEG8)
);

 //switch matrix multiplexer NN4BEG9 MUX-2
assign NN4BEG9_input = {ISSUE_INSTR22,SS4END6};
cus_mux21 inst_cus_mux21_NN4BEG9 (
    .A0(NN4BEG9_input[0]),
    .A1(NN4BEG9_input[1]),
    .S(ConfigBits[53+0]),
    .X(NN4BEG9)
);

 //switch matrix multiplexer NN4BEG10 MUX-2
assign NN4BEG10_input = {ISSUE_INSTR21,SS4END5};
cus_mux21 inst_cus_mux21_NN4BEG10 (
    .A0(NN4BEG10_input[0]),
    .A1(NN4BEG10_input[1]),
    .S(ConfigBits[54+0]),
    .X(NN4BEG10)
);

 //switch matrix multiplexer NN4BEG11 MUX-2
assign NN4BEG11_input = {ISSUE_INSTR20,SS4END4};
cus_mux21 inst_cus_mux21_NN4BEG11 (
    .A0(NN4BEG11_input[0]),
    .A1(NN4BEG11_input[1]),
    .S(ConfigBits[55+0]),
    .X(NN4BEG11)
);

 //switch matrix multiplexer NN4BEG12 MUX-2
assign NN4BEG12_input = {ISSUE_INSTR19,SS4END3};
cus_mux21 inst_cus_mux21_NN4BEG12 (
    .A0(NN4BEG12_input[0]),
    .A1(NN4BEG12_input[1]),
    .S(ConfigBits[56+0]),
    .X(NN4BEG12)
);

 //switch matrix multiplexer NN4BEG13 MUX-2
assign NN4BEG13_input = {ISSUE_INSTR18,SS4END2};
cus_mux21 inst_cus_mux21_NN4BEG13 (
    .A0(NN4BEG13_input[0]),
    .A1(NN4BEG13_input[1]),
    .S(ConfigBits[57+0]),
    .X(NN4BEG13)
);

 //switch matrix multiplexer NN4BEG14 MUX-2
assign NN4BEG14_input = {ISSUE_INSTR17,SS4END1};
cus_mux21 inst_cus_mux21_NN4BEG14 (
    .A0(NN4BEG14_input[0]),
    .A1(NN4BEG14_input[1]),
    .S(ConfigBits[58+0]),
    .X(NN4BEG14)
);

 //switch matrix multiplexer NN4BEG15 MUX-2
assign NN4BEG15_input = {ISSUE_INSTR16,SS4END0};
cus_mux21 inst_cus_mux21_NN4BEG15 (
    .A0(NN4BEG15_input[0]),
    .A1(NN4BEG15_input[1]),
    .S(ConfigBits[59+0]),
    .X(NN4BEG15)
);

 //switch matrix multiplexer Co0 MUX-1
assign Co0 = GND0;

 //switch matrix multiplexer middle2left_ISSUE_OPA0 MUX-1
assign middle2left_ISSUE_OPA0 = ISSUE_OPA0;

 //switch matrix multiplexer middle2left_ISSUE_OPA1 MUX-1
assign middle2left_ISSUE_OPA1 = ISSUE_OPA1;

 //switch matrix multiplexer middle2left_ISSUE_OPA2 MUX-1
assign middle2left_ISSUE_OPA2 = ISSUE_OPA2;

 //switch matrix multiplexer middle2left_ISSUE_OPA3 MUX-1
assign middle2left_ISSUE_OPA3 = ISSUE_OPA3;

 //switch matrix multiplexer middle2left_ISSUE_OPA4 MUX-1
assign middle2left_ISSUE_OPA4 = ISSUE_OPA4;

 //switch matrix multiplexer middle2left_ISSUE_OPA5 MUX-1
assign middle2left_ISSUE_OPA5 = ISSUE_OPA5;

 //switch matrix multiplexer middle2left_ISSUE_OPA6 MUX-1
assign middle2left_ISSUE_OPA6 = ISSUE_OPA6;

 //switch matrix multiplexer middle2left_ISSUE_OPA7 MUX-1
assign middle2left_ISSUE_OPA7 = ISSUE_OPA7;

 //switch matrix multiplexer middle2left_ISSUE_OPA8 MUX-1
assign middle2left_ISSUE_OPA8 = ISSUE_OPA8;

 //switch matrix multiplexer middle2left_ISSUE_OPA9 MUX-1
assign middle2left_ISSUE_OPA9 = ISSUE_OPA9;

 //switch matrix multiplexer middle2left_ISSUE_OPA10 MUX-1
assign middle2left_ISSUE_OPA10 = ISSUE_OPA10;

 //switch matrix multiplexer middle2left_ISSUE_OPA11 MUX-1
assign middle2left_ISSUE_OPA11 = ISSUE_OPA11;

 //switch matrix multiplexer middle2left_ISSUE_OPA12 MUX-1
assign middle2left_ISSUE_OPA12 = ISSUE_OPA12;

 //switch matrix multiplexer middle2left_ISSUE_OPA13 MUX-1
assign middle2left_ISSUE_OPA13 = ISSUE_OPA13;

 //switch matrix multiplexer middle2left_ISSUE_OPA14 MUX-1
assign middle2left_ISSUE_OPA14 = ISSUE_OPA14;

 //switch matrix multiplexer middle2left_ISSUE_OPA15 MUX-1
assign middle2left_ISSUE_OPA15 = ISSUE_OPA15;

 //switch matrix multiplexer middle2left_ISSUE_OPA16 MUX-1
assign middle2left_ISSUE_OPA16 = ISSUE_OPA16;

 //switch matrix multiplexer middle2left_ISSUE_OPA17 MUX-1
assign middle2left_ISSUE_OPA17 = ISSUE_OPA17;

 //switch matrix multiplexer middle2left_ISSUE_OPA18 MUX-1
assign middle2left_ISSUE_OPA18 = ISSUE_OPA18;

 //switch matrix multiplexer middle2left_ISSUE_OPA19 MUX-1
assign middle2left_ISSUE_OPA19 = ISSUE_OPA19;

 //switch matrix multiplexer middle2left_ISSUE_OPA20 MUX-1
assign middle2left_ISSUE_OPA20 = ISSUE_OPA20;

 //switch matrix multiplexer middle2left_ISSUE_OPA21 MUX-1
assign middle2left_ISSUE_OPA21 = ISSUE_OPA21;

 //switch matrix multiplexer middle2left_ISSUE_OPA22 MUX-1
assign middle2left_ISSUE_OPA22 = ISSUE_OPA22;

 //switch matrix multiplexer middle2left_ISSUE_OPA23 MUX-1
assign middle2left_ISSUE_OPA23 = ISSUE_OPA23;

 //switch matrix multiplexer middle2left_ISSUE_OPA24 MUX-1
assign middle2left_ISSUE_OPA24 = ISSUE_OPA24;

 //switch matrix multiplexer middle2left_ISSUE_OPA25 MUX-1
assign middle2left_ISSUE_OPA25 = ISSUE_OPA25;

 //switch matrix multiplexer middle2left_ISSUE_OPA26 MUX-1
assign middle2left_ISSUE_OPA26 = ISSUE_OPA26;

 //switch matrix multiplexer middle2left_ISSUE_OPA27 MUX-1
assign middle2left_ISSUE_OPA27 = ISSUE_OPA27;

 //switch matrix multiplexer middle2left_ISSUE_OPA28 MUX-1
assign middle2left_ISSUE_OPA28 = ISSUE_OPA28;

 //switch matrix multiplexer middle2left_ISSUE_OPA29 MUX-1
assign middle2left_ISSUE_OPA29 = ISSUE_OPA29;

 //switch matrix multiplexer middle2left_ISSUE_OPA30 MUX-1
assign middle2left_ISSUE_OPA30 = ISSUE_OPA30;

 //switch matrix multiplexer middle2left_ISSUE_OPA31 MUX-1
assign middle2left_ISSUE_OPA31 = ISSUE_OPA31;

 //switch matrix multiplexer middle2right_ISSUE_OPB0 MUX-1
assign middle2right_ISSUE_OPB0 = ISSUE_OPB0;

 //switch matrix multiplexer middle2right_ISSUE_OPB1 MUX-1
assign middle2right_ISSUE_OPB1 = ISSUE_OPB1;

 //switch matrix multiplexer middle2right_ISSUE_OPB2 MUX-1
assign middle2right_ISSUE_OPB2 = ISSUE_OPB2;

 //switch matrix multiplexer middle2right_ISSUE_OPB3 MUX-1
assign middle2right_ISSUE_OPB3 = ISSUE_OPB3;

 //switch matrix multiplexer middle2right_ISSUE_OPB4 MUX-1
assign middle2right_ISSUE_OPB4 = ISSUE_OPB4;

 //switch matrix multiplexer middle2right_ISSUE_OPB5 MUX-1
assign middle2right_ISSUE_OPB5 = ISSUE_OPB5;

 //switch matrix multiplexer middle2right_ISSUE_OPB6 MUX-1
assign middle2right_ISSUE_OPB6 = ISSUE_OPB6;

 //switch matrix multiplexer middle2right_ISSUE_OPB7 MUX-1
assign middle2right_ISSUE_OPB7 = ISSUE_OPB7;

 //switch matrix multiplexer middle2right_ISSUE_OPB8 MUX-1
assign middle2right_ISSUE_OPB8 = ISSUE_OPB8;

 //switch matrix multiplexer middle2right_ISSUE_OPB9 MUX-1
assign middle2right_ISSUE_OPB9 = ISSUE_OPB9;

 //switch matrix multiplexer middle2right_ISSUE_OPB10 MUX-1
assign middle2right_ISSUE_OPB10 = ISSUE_OPB10;

 //switch matrix multiplexer middle2right_ISSUE_OPB11 MUX-1
assign middle2right_ISSUE_OPB11 = ISSUE_OPB11;

 //switch matrix multiplexer middle2right_ISSUE_OPB12 MUX-1
assign middle2right_ISSUE_OPB12 = ISSUE_OPB12;

 //switch matrix multiplexer middle2right_ISSUE_OPB13 MUX-1
assign middle2right_ISSUE_OPB13 = ISSUE_OPB13;

 //switch matrix multiplexer middle2right_ISSUE_OPB14 MUX-1
assign middle2right_ISSUE_OPB14 = ISSUE_OPB14;

 //switch matrix multiplexer middle2right_ISSUE_OPB15 MUX-1
assign middle2right_ISSUE_OPB15 = ISSUE_OPB15;

 //switch matrix multiplexer middle2right_ISSUE_OPB16 MUX-1
assign middle2right_ISSUE_OPB16 = ISSUE_OPB16;

 //switch matrix multiplexer middle2right_ISSUE_OPB17 MUX-1
assign middle2right_ISSUE_OPB17 = ISSUE_OPB17;

 //switch matrix multiplexer middle2right_ISSUE_OPB18 MUX-1
assign middle2right_ISSUE_OPB18 = ISSUE_OPB18;

 //switch matrix multiplexer middle2right_ISSUE_OPB19 MUX-1
assign middle2right_ISSUE_OPB19 = ISSUE_OPB19;

 //switch matrix multiplexer middle2right_ISSUE_OPB20 MUX-1
assign middle2right_ISSUE_OPB20 = ISSUE_OPB20;

 //switch matrix multiplexer middle2right_ISSUE_OPB21 MUX-1
assign middle2right_ISSUE_OPB21 = ISSUE_OPB21;

 //switch matrix multiplexer middle2right_ISSUE_OPB22 MUX-1
assign middle2right_ISSUE_OPB22 = ISSUE_OPB22;

 //switch matrix multiplexer middle2right_ISSUE_OPB23 MUX-1
assign middle2right_ISSUE_OPB23 = ISSUE_OPB23;

 //switch matrix multiplexer middle2right_ISSUE_OPB24 MUX-1
assign middle2right_ISSUE_OPB24 = ISSUE_OPB24;

 //switch matrix multiplexer middle2right_ISSUE_OPB25 MUX-1
assign middle2right_ISSUE_OPB25 = ISSUE_OPB25;

 //switch matrix multiplexer middle2right_ISSUE_OPB26 MUX-1
assign middle2right_ISSUE_OPB26 = ISSUE_OPB26;

 //switch matrix multiplexer middle2right_ISSUE_OPB27 MUX-1
assign middle2right_ISSUE_OPB27 = ISSUE_OPB27;

 //switch matrix multiplexer middle2right_ISSUE_OPB28 MUX-1
assign middle2right_ISSUE_OPB28 = ISSUE_OPB28;

 //switch matrix multiplexer middle2right_ISSUE_OPB29 MUX-1
assign middle2right_ISSUE_OPB29 = ISSUE_OPB29;

 //switch matrix multiplexer middle2right_ISSUE_OPB30 MUX-1
assign middle2right_ISSUE_OPB30 = ISSUE_OPB30;

 //switch matrix multiplexer middle2right_ISSUE_OPB31 MUX-1
assign middle2right_ISSUE_OPB31 = ISSUE_OPB31;

 //switch matrix multiplexer ISSUE_READY MUX-4
assign ISSUE_READY_input = {VCC0,GND0,S2MID1,S2MID0};
cus_mux41 inst_cus_mux41_ISSUE_READY (
    .A0(ISSUE_READY_input[0]),
    .A1(ISSUE_READY_input[1]),
    .A2(ISSUE_READY_input[2]),
    .A3(ISSUE_READY_input[3]),
    .S0(ConfigBits[60+0]),
    .S0N(ConfigBits_N[60+0]),
    .S1(ConfigBits[60+1]),
    .S1N(ConfigBits_N[60+1]),
    .X(ISSUE_READY)
);

 //switch matrix multiplexer ISSUE_ACCEPT MUX-4
assign ISSUE_ACCEPT_input = {VCC0,GND0,S2MID3,S2MID2};
cus_mux41 inst_cus_mux41_ISSUE_ACCEPT (
    .A0(ISSUE_ACCEPT_input[0]),
    .A1(ISSUE_ACCEPT_input[1]),
    .A2(ISSUE_ACCEPT_input[2]),
    .A3(ISSUE_ACCEPT_input[3]),
    .S0(ConfigBits[62+0]),
    .S0N(ConfigBits_N[62+0]),
    .S1(ConfigBits[62+1]),
    .S1N(ConfigBits_N[62+1]),
    .X(ISSUE_ACCEPT)
);

 //switch matrix multiplexer RESULT_VALID MUX-4
assign RESULT_VALID_input = {VCC0,GND0,S2MID5,S2MID4};
cus_mux41 inst_cus_mux41_RESULT_VALID (
    .A0(RESULT_VALID_input[0]),
    .A1(RESULT_VALID_input[1]),
    .A2(RESULT_VALID_input[2]),
    .A3(RESULT_VALID_input[3]),
    .S0(ConfigBits[64+0]),
    .S0N(ConfigBits_N[64+0]),
    .S1(ConfigBits[64+1]),
    .S1N(ConfigBits_N[64+1]),
    .X(RESULT_VALID)
);

 //switch matrix multiplexer RESULT_ID0 MUX-2
assign RESULT_ID0_input = {S2END3,S1END3};
cus_mux21 inst_cus_mux21_RESULT_ID0 (
    .A0(RESULT_ID0_input[0]),
    .A1(RESULT_ID0_input[1]),
    .S(ConfigBits[66+0]),
    .X(RESULT_ID0)
);

 //switch matrix multiplexer RESULT_ID1 MUX-2
assign RESULT_ID1_input = {S2END2,S1END2};
cus_mux21 inst_cus_mux21_RESULT_ID1 (
    .A0(RESULT_ID1_input[0]),
    .A1(RESULT_ID1_input[1]),
    .S(ConfigBits[67+0]),
    .X(RESULT_ID1)
);

 //switch matrix multiplexer RESULT_ID2 MUX-2
assign RESULT_ID2_input = {S2END1,S1END1};
cus_mux21 inst_cus_mux21_RESULT_ID2 (
    .A0(RESULT_ID2_input[0]),
    .A1(RESULT_ID2_input[1]),
    .S(ConfigBits[68+0]),
    .X(RESULT_ID2)
);

 //switch matrix multiplexer RESULT_ID3 MUX-2
assign RESULT_ID3_input = {S2END0,S1END0};
cus_mux21 inst_cus_mux21_RESULT_ID3 (
    .A0(RESULT_ID3_input[0]),
    .A1(RESULT_ID3_input[1]),
    .S(ConfigBits[69+0]),
    .X(RESULT_ID3)
);

 //switch matrix multiplexer RESULT_RD0 MUX-2
assign RESULT_RD0_input = {S2END7,S2MID7};
cus_mux21 inst_cus_mux21_RESULT_RD0 (
    .A0(RESULT_RD0_input[0]),
    .A1(RESULT_RD0_input[1]),
    .S(ConfigBits[70+0]),
    .X(RESULT_RD0)
);

 //switch matrix multiplexer RESULT_RD1 MUX-2
assign RESULT_RD1_input = {S2END6,S2MID6};
cus_mux21 inst_cus_mux21_RESULT_RD1 (
    .A0(RESULT_RD1_input[0]),
    .A1(RESULT_RD1_input[1]),
    .S(ConfigBits[71+0]),
    .X(RESULT_RD1)
);

 //switch matrix multiplexer RESULT_RD2 MUX-2
assign RESULT_RD2_input = {S2END5,S2MID5};
cus_mux21 inst_cus_mux21_RESULT_RD2 (
    .A0(RESULT_RD2_input[0]),
    .A1(RESULT_RD2_input[1]),
    .S(ConfigBits[72+0]),
    .X(RESULT_RD2)
);

 //switch matrix multiplexer RESULT_RD3 MUX-2
assign RESULT_RD3_input = {S2END4,S2MID4};
cus_mux21 inst_cus_mux21_RESULT_RD3 (
    .A0(RESULT_RD3_input[0]),
    .A1(RESULT_RD3_input[1]),
    .S(ConfigBits[73+0]),
    .X(RESULT_RD3)
);

 //switch matrix multiplexer RESULT_RD4 MUX-2
assign RESULT_RD4_input = {S2END3,S2MID3};
cus_mux21 inst_cus_mux21_RESULT_RD4 (
    .A0(RESULT_RD4_input[0]),
    .A1(RESULT_RD4_input[1]),
    .S(ConfigBits[74+0]),
    .X(RESULT_RD4)
);

 //switch matrix multiplexer RESULT0 MUX-1
assign RESULT0 = right2middle_RESULT0;

 //switch matrix multiplexer RESULT1 MUX-1
assign RESULT1 = right2middle_RESULT1;

 //switch matrix multiplexer RESULT2 MUX-1
assign RESULT2 = right2middle_RESULT2;

 //switch matrix multiplexer RESULT3 MUX-1
assign RESULT3 = right2middle_RESULT3;

 //switch matrix multiplexer RESULT4 MUX-1
assign RESULT4 = right2middle_RESULT4;

 //switch matrix multiplexer RESULT5 MUX-1
assign RESULT5 = right2middle_RESULT5;

 //switch matrix multiplexer RESULT6 MUX-1
assign RESULT6 = right2middle_RESULT6;

 //switch matrix multiplexer RESULT7 MUX-1
assign RESULT7 = right2middle_RESULT7;

 //switch matrix multiplexer RESULT8 MUX-1
assign RESULT8 = right2middle_RESULT8;

 //switch matrix multiplexer RESULT9 MUX-1
assign RESULT9 = right2middle_RESULT9;

 //switch matrix multiplexer RESULT10 MUX-1
assign RESULT10 = right2middle_RESULT10;

 //switch matrix multiplexer RESULT11 MUX-1
assign RESULT11 = right2middle_RESULT11;

 //switch matrix multiplexer RESULT12 MUX-1
assign RESULT12 = right2middle_RESULT12;

 //switch matrix multiplexer RESULT13 MUX-1
assign RESULT13 = right2middle_RESULT13;

 //switch matrix multiplexer RESULT14 MUX-1
assign RESULT14 = right2middle_RESULT14;

 //switch matrix multiplexer RESULT15 MUX-1
assign RESULT15 = right2middle_RESULT15;

 //switch matrix multiplexer RESULT16 MUX-1
assign RESULT16 = left2middle_RESULT0;

 //switch matrix multiplexer RESULT17 MUX-1
assign RESULT17 = left2middle_RESULT1;

 //switch matrix multiplexer RESULT18 MUX-1
assign RESULT18 = left2middle_RESULT2;

 //switch matrix multiplexer RESULT19 MUX-1
assign RESULT19 = left2middle_RESULT3;

 //switch matrix multiplexer RESULT20 MUX-1
assign RESULT20 = left2middle_RESULT4;

 //switch matrix multiplexer RESULT21 MUX-1
assign RESULT21 = left2middle_RESULT5;

 //switch matrix multiplexer RESULT22 MUX-1
assign RESULT22 = left2middle_RESULT6;

 //switch matrix multiplexer RESULT23 MUX-1
assign RESULT23 = left2middle_RESULT7;

 //switch matrix multiplexer RESULT24 MUX-1
assign RESULT24 = left2middle_RESULT8;

 //switch matrix multiplexer RESULT25 MUX-1
assign RESULT25 = left2middle_RESULT9;

 //switch matrix multiplexer RESULT26 MUX-1
assign RESULT26 = left2middle_RESULT10;

 //switch matrix multiplexer RESULT27 MUX-1
assign RESULT27 = left2middle_RESULT11;

 //switch matrix multiplexer RESULT28 MUX-1
assign RESULT28 = left2middle_RESULT12;

 //switch matrix multiplexer RESULT29 MUX-1
assign RESULT29 = left2middle_RESULT13;

 //switch matrix multiplexer RESULT30 MUX-1
assign RESULT30 = left2middle_RESULT14;

 //switch matrix multiplexer RESULT31 MUX-1
assign RESULT31 = left2middle_RESULT15;

endmodule
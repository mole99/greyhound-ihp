 // NumberOfConfigBits: 64
module S_XIF_left_switch_matrix
    #(
        parameter NoConfigBits=64
    )
    (
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
        input  middle2left_ISSUE_OPA0,
        input  middle2left_ISSUE_OPA1,
        input  middle2left_ISSUE_OPA2,
        input  middle2left_ISSUE_OPA3,
        input  middle2left_ISSUE_OPA4,
        input  middle2left_ISSUE_OPA5,
        input  middle2left_ISSUE_OPA6,
        input  middle2left_ISSUE_OPA7,
        input  middle2left_ISSUE_OPA8,
        input  middle2left_ISSUE_OPA9,
        input  middle2left_ISSUE_OPA10,
        input  middle2left_ISSUE_OPA11,
        input  middle2left_ISSUE_OPA12,
        input  middle2left_ISSUE_OPA13,
        input  middle2left_ISSUE_OPA14,
        input  middle2left_ISSUE_OPA15,
        input  middle2left_ISSUE_OPA16,
        input  middle2left_ISSUE_OPA17,
        input  middle2left_ISSUE_OPA18,
        input  middle2left_ISSUE_OPA19,
        input  middle2left_ISSUE_OPA20,
        input  middle2left_ISSUE_OPA21,
        input  middle2left_ISSUE_OPA22,
        input  middle2left_ISSUE_OPA23,
        input  middle2left_ISSUE_OPA24,
        input  middle2left_ISSUE_OPA25,
        input  middle2left_ISSUE_OPA26,
        input  middle2left_ISSUE_OPA27,
        input  middle2left_ISSUE_OPA28,
        input  middle2left_ISSUE_OPA29,
        input  middle2left_ISSUE_OPA30,
        input  middle2left_ISSUE_OPA31,
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
        output  left2middle_RESULT0,
        output  left2middle_RESULT1,
        output  left2middle_RESULT2,
        output  left2middle_RESULT3,
        output  left2middle_RESULT4,
        output  left2middle_RESULT5,
        output  left2middle_RESULT6,
        output  left2middle_RESULT7,
        output  left2middle_RESULT8,
        output  left2middle_RESULT9,
        output  left2middle_RESULT10,
        output  left2middle_RESULT11,
        output  left2middle_RESULT12,
        output  left2middle_RESULT13,
        output  left2middle_RESULT14,
        output  left2middle_RESULT15,
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
wire[4-1:0] left2middle_RESULT0_input;
wire[4-1:0] left2middle_RESULT1_input;
wire[4-1:0] left2middle_RESULT2_input;
wire[4-1:0] left2middle_RESULT3_input;
wire[4-1:0] left2middle_RESULT4_input;
wire[4-1:0] left2middle_RESULT5_input;
wire[4-1:0] left2middle_RESULT6_input;
wire[4-1:0] left2middle_RESULT7_input;
wire[4-1:0] left2middle_RESULT8_input;
wire[4-1:0] left2middle_RESULT9_input;
wire[4-1:0] left2middle_RESULT10_input;
wire[4-1:0] left2middle_RESULT11_input;
wire[4-1:0] left2middle_RESULT12_input;
wire[4-1:0] left2middle_RESULT13_input;
wire[4-1:0] left2middle_RESULT14_input;
wire[4-1:0] left2middle_RESULT15_input;
 //The configuration bits (if any) are just a long shift register
 //This shift register is padded to an even number of flops/latches
 //switch matrix multiplexer N1BEG0 MUX-1
assign N1BEG0 = S1END3;

 //switch matrix multiplexer N1BEG1 MUX-1
assign N1BEG1 = S1END2;

 //switch matrix multiplexer N1BEG2 MUX-1
assign N1BEG2 = S1END1;

 //switch matrix multiplexer N1BEG3 MUX-1
assign N1BEG3 = S1END0;

 //switch matrix multiplexer N2BEG0 MUX-1
assign N2BEG0 = S2MID7;

 //switch matrix multiplexer N2BEG1 MUX-1
assign N2BEG1 = S2MID6;

 //switch matrix multiplexer N2BEG2 MUX-1
assign N2BEG2 = S2MID5;

 //switch matrix multiplexer N2BEG3 MUX-1
assign N2BEG3 = S2MID4;

 //switch matrix multiplexer N2BEG4 MUX-1
assign N2BEG4 = S2MID3;

 //switch matrix multiplexer N2BEG5 MUX-1
assign N2BEG5 = S2MID2;

 //switch matrix multiplexer N2BEG6 MUX-1
assign N2BEG6 = S2MID1;

 //switch matrix multiplexer N2BEG7 MUX-1
assign N2BEG7 = S2MID0;

 //switch matrix multiplexer N2BEGb0 MUX-1
assign N2BEGb0 = S2END7;

 //switch matrix multiplexer N2BEGb1 MUX-1
assign N2BEGb1 = S2END6;

 //switch matrix multiplexer N2BEGb2 MUX-1
assign N2BEGb2 = S2END5;

 //switch matrix multiplexer N2BEGb3 MUX-1
assign N2BEGb3 = S2END4;

 //switch matrix multiplexer N2BEGb4 MUX-1
assign N2BEGb4 = S2END3;

 //switch matrix multiplexer N2BEGb5 MUX-1
assign N2BEGb5 = S2END2;

 //switch matrix multiplexer N2BEGb6 MUX-1
assign N2BEGb6 = S2END1;

 //switch matrix multiplexer N2BEGb7 MUX-1
assign N2BEGb7 = S2END0;

 //switch matrix multiplexer N4BEG0 MUX-2
assign N4BEG0_input = {middle2left_ISSUE_OPA15,S4END15};
cus_mux21 inst_cus_mux21_N4BEG0 (
    .A0(N4BEG0_input[0]),
    .A1(N4BEG0_input[1]),
    .S(ConfigBits[0+0]),
    .X(N4BEG0)
);

 //switch matrix multiplexer N4BEG1 MUX-2
assign N4BEG1_input = {middle2left_ISSUE_OPA14,S4END14};
cus_mux21 inst_cus_mux21_N4BEG1 (
    .A0(N4BEG1_input[0]),
    .A1(N4BEG1_input[1]),
    .S(ConfigBits[1+0]),
    .X(N4BEG1)
);

 //switch matrix multiplexer N4BEG2 MUX-2
assign N4BEG2_input = {middle2left_ISSUE_OPA13,S4END13};
cus_mux21 inst_cus_mux21_N4BEG2 (
    .A0(N4BEG2_input[0]),
    .A1(N4BEG2_input[1]),
    .S(ConfigBits[2+0]),
    .X(N4BEG2)
);

 //switch matrix multiplexer N4BEG3 MUX-2
assign N4BEG3_input = {middle2left_ISSUE_OPA12,S4END12};
cus_mux21 inst_cus_mux21_N4BEG3 (
    .A0(N4BEG3_input[0]),
    .A1(N4BEG3_input[1]),
    .S(ConfigBits[3+0]),
    .X(N4BEG3)
);

 //switch matrix multiplexer N4BEG4 MUX-2
assign N4BEG4_input = {middle2left_ISSUE_OPA11,S4END11};
cus_mux21 inst_cus_mux21_N4BEG4 (
    .A0(N4BEG4_input[0]),
    .A1(N4BEG4_input[1]),
    .S(ConfigBits[4+0]),
    .X(N4BEG4)
);

 //switch matrix multiplexer N4BEG5 MUX-2
assign N4BEG5_input = {middle2left_ISSUE_OPA10,S4END10};
cus_mux21 inst_cus_mux21_N4BEG5 (
    .A0(N4BEG5_input[0]),
    .A1(N4BEG5_input[1]),
    .S(ConfigBits[5+0]),
    .X(N4BEG5)
);

 //switch matrix multiplexer N4BEG6 MUX-2
assign N4BEG6_input = {middle2left_ISSUE_OPA9,S4END9};
cus_mux21 inst_cus_mux21_N4BEG6 (
    .A0(N4BEG6_input[0]),
    .A1(N4BEG6_input[1]),
    .S(ConfigBits[6+0]),
    .X(N4BEG6)
);

 //switch matrix multiplexer N4BEG7 MUX-2
assign N4BEG7_input = {middle2left_ISSUE_OPA8,S4END8};
cus_mux21 inst_cus_mux21_N4BEG7 (
    .A0(N4BEG7_input[0]),
    .A1(N4BEG7_input[1]),
    .S(ConfigBits[7+0]),
    .X(N4BEG7)
);

 //switch matrix multiplexer N4BEG8 MUX-2
assign N4BEG8_input = {middle2left_ISSUE_OPA7,S4END7};
cus_mux21 inst_cus_mux21_N4BEG8 (
    .A0(N4BEG8_input[0]),
    .A1(N4BEG8_input[1]),
    .S(ConfigBits[8+0]),
    .X(N4BEG8)
);

 //switch matrix multiplexer N4BEG9 MUX-2
assign N4BEG9_input = {middle2left_ISSUE_OPA6,S4END6};
cus_mux21 inst_cus_mux21_N4BEG9 (
    .A0(N4BEG9_input[0]),
    .A1(N4BEG9_input[1]),
    .S(ConfigBits[9+0]),
    .X(N4BEG9)
);

 //switch matrix multiplexer N4BEG10 MUX-2
assign N4BEG10_input = {middle2left_ISSUE_OPA5,S4END5};
cus_mux21 inst_cus_mux21_N4BEG10 (
    .A0(N4BEG10_input[0]),
    .A1(N4BEG10_input[1]),
    .S(ConfigBits[10+0]),
    .X(N4BEG10)
);

 //switch matrix multiplexer N4BEG11 MUX-2
assign N4BEG11_input = {middle2left_ISSUE_OPA4,S4END4};
cus_mux21 inst_cus_mux21_N4BEG11 (
    .A0(N4BEG11_input[0]),
    .A1(N4BEG11_input[1]),
    .S(ConfigBits[11+0]),
    .X(N4BEG11)
);

 //switch matrix multiplexer N4BEG12 MUX-2
assign N4BEG12_input = {middle2left_ISSUE_OPA3,S4END3};
cus_mux21 inst_cus_mux21_N4BEG12 (
    .A0(N4BEG12_input[0]),
    .A1(N4BEG12_input[1]),
    .S(ConfigBits[12+0]),
    .X(N4BEG12)
);

 //switch matrix multiplexer N4BEG13 MUX-2
assign N4BEG13_input = {middle2left_ISSUE_OPA2,S4END2};
cus_mux21 inst_cus_mux21_N4BEG13 (
    .A0(N4BEG13_input[0]),
    .A1(N4BEG13_input[1]),
    .S(ConfigBits[13+0]),
    .X(N4BEG13)
);

 //switch matrix multiplexer N4BEG14 MUX-2
assign N4BEG14_input = {middle2left_ISSUE_OPA1,S4END1};
cus_mux21 inst_cus_mux21_N4BEG14 (
    .A0(N4BEG14_input[0]),
    .A1(N4BEG14_input[1]),
    .S(ConfigBits[14+0]),
    .X(N4BEG14)
);

 //switch matrix multiplexer N4BEG15 MUX-2
assign N4BEG15_input = {middle2left_ISSUE_OPA0,S4END0};
cus_mux21 inst_cus_mux21_N4BEG15 (
    .A0(N4BEG15_input[0]),
    .A1(N4BEG15_input[1]),
    .S(ConfigBits[15+0]),
    .X(N4BEG15)
);

 //switch matrix multiplexer NN4BEG0 MUX-2
assign NN4BEG0_input = {middle2left_ISSUE_OPA31,SS4END15};
cus_mux21 inst_cus_mux21_NN4BEG0 (
    .A0(NN4BEG0_input[0]),
    .A1(NN4BEG0_input[1]),
    .S(ConfigBits[16+0]),
    .X(NN4BEG0)
);

 //switch matrix multiplexer NN4BEG1 MUX-2
assign NN4BEG1_input = {middle2left_ISSUE_OPA30,SS4END14};
cus_mux21 inst_cus_mux21_NN4BEG1 (
    .A0(NN4BEG1_input[0]),
    .A1(NN4BEG1_input[1]),
    .S(ConfigBits[17+0]),
    .X(NN4BEG1)
);

 //switch matrix multiplexer NN4BEG2 MUX-2
assign NN4BEG2_input = {middle2left_ISSUE_OPA29,SS4END13};
cus_mux21 inst_cus_mux21_NN4BEG2 (
    .A0(NN4BEG2_input[0]),
    .A1(NN4BEG2_input[1]),
    .S(ConfigBits[18+0]),
    .X(NN4BEG2)
);

 //switch matrix multiplexer NN4BEG3 MUX-2
assign NN4BEG3_input = {middle2left_ISSUE_OPA28,SS4END12};
cus_mux21 inst_cus_mux21_NN4BEG3 (
    .A0(NN4BEG3_input[0]),
    .A1(NN4BEG3_input[1]),
    .S(ConfigBits[19+0]),
    .X(NN4BEG3)
);

 //switch matrix multiplexer NN4BEG4 MUX-2
assign NN4BEG4_input = {middle2left_ISSUE_OPA27,SS4END11};
cus_mux21 inst_cus_mux21_NN4BEG4 (
    .A0(NN4BEG4_input[0]),
    .A1(NN4BEG4_input[1]),
    .S(ConfigBits[20+0]),
    .X(NN4BEG4)
);

 //switch matrix multiplexer NN4BEG5 MUX-2
assign NN4BEG5_input = {middle2left_ISSUE_OPA26,SS4END10};
cus_mux21 inst_cus_mux21_NN4BEG5 (
    .A0(NN4BEG5_input[0]),
    .A1(NN4BEG5_input[1]),
    .S(ConfigBits[21+0]),
    .X(NN4BEG5)
);

 //switch matrix multiplexer NN4BEG6 MUX-2
assign NN4BEG6_input = {middle2left_ISSUE_OPA25,SS4END9};
cus_mux21 inst_cus_mux21_NN4BEG6 (
    .A0(NN4BEG6_input[0]),
    .A1(NN4BEG6_input[1]),
    .S(ConfigBits[22+0]),
    .X(NN4BEG6)
);

 //switch matrix multiplexer NN4BEG7 MUX-2
assign NN4BEG7_input = {middle2left_ISSUE_OPA24,SS4END8};
cus_mux21 inst_cus_mux21_NN4BEG7 (
    .A0(NN4BEG7_input[0]),
    .A1(NN4BEG7_input[1]),
    .S(ConfigBits[23+0]),
    .X(NN4BEG7)
);

 //switch matrix multiplexer NN4BEG8 MUX-2
assign NN4BEG8_input = {middle2left_ISSUE_OPA23,SS4END7};
cus_mux21 inst_cus_mux21_NN4BEG8 (
    .A0(NN4BEG8_input[0]),
    .A1(NN4BEG8_input[1]),
    .S(ConfigBits[24+0]),
    .X(NN4BEG8)
);

 //switch matrix multiplexer NN4BEG9 MUX-2
assign NN4BEG9_input = {middle2left_ISSUE_OPA22,SS4END6};
cus_mux21 inst_cus_mux21_NN4BEG9 (
    .A0(NN4BEG9_input[0]),
    .A1(NN4BEG9_input[1]),
    .S(ConfigBits[25+0]),
    .X(NN4BEG9)
);

 //switch matrix multiplexer NN4BEG10 MUX-2
assign NN4BEG10_input = {middle2left_ISSUE_OPA21,SS4END5};
cus_mux21 inst_cus_mux21_NN4BEG10 (
    .A0(NN4BEG10_input[0]),
    .A1(NN4BEG10_input[1]),
    .S(ConfigBits[26+0]),
    .X(NN4BEG10)
);

 //switch matrix multiplexer NN4BEG11 MUX-2
assign NN4BEG11_input = {middle2left_ISSUE_OPA20,SS4END4};
cus_mux21 inst_cus_mux21_NN4BEG11 (
    .A0(NN4BEG11_input[0]),
    .A1(NN4BEG11_input[1]),
    .S(ConfigBits[27+0]),
    .X(NN4BEG11)
);

 //switch matrix multiplexer NN4BEG12 MUX-2
assign NN4BEG12_input = {middle2left_ISSUE_OPA19,SS4END3};
cus_mux21 inst_cus_mux21_NN4BEG12 (
    .A0(NN4BEG12_input[0]),
    .A1(NN4BEG12_input[1]),
    .S(ConfigBits[28+0]),
    .X(NN4BEG12)
);

 //switch matrix multiplexer NN4BEG13 MUX-2
assign NN4BEG13_input = {middle2left_ISSUE_OPA18,SS4END2};
cus_mux21 inst_cus_mux21_NN4BEG13 (
    .A0(NN4BEG13_input[0]),
    .A1(NN4BEG13_input[1]),
    .S(ConfigBits[29+0]),
    .X(NN4BEG13)
);

 //switch matrix multiplexer NN4BEG14 MUX-2
assign NN4BEG14_input = {middle2left_ISSUE_OPA17,SS4END1};
cus_mux21 inst_cus_mux21_NN4BEG14 (
    .A0(NN4BEG14_input[0]),
    .A1(NN4BEG14_input[1]),
    .S(ConfigBits[30+0]),
    .X(NN4BEG14)
);

 //switch matrix multiplexer NN4BEG15 MUX-2
assign NN4BEG15_input = {middle2left_ISSUE_OPA16,SS4END0};
cus_mux21 inst_cus_mux21_NN4BEG15 (
    .A0(NN4BEG15_input[0]),
    .A1(NN4BEG15_input[1]),
    .S(ConfigBits[31+0]),
    .X(NN4BEG15)
);

 //switch matrix multiplexer Co0 MUX-1
assign Co0 = GND0;

 //switch matrix multiplexer left2middle_RESULT0 MUX-4
assign left2middle_RESULT0_input = {VCC0,GND0,SS4END0,S4END0};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT0 (
    .A0(left2middle_RESULT0_input[0]),
    .A1(left2middle_RESULT0_input[1]),
    .A2(left2middle_RESULT0_input[2]),
    .A3(left2middle_RESULT0_input[3]),
    .S0(ConfigBits[32+0]),
    .S0N(ConfigBits_N[32+0]),
    .S1(ConfigBits[32+1]),
    .S1N(ConfigBits_N[32+1]),
    .X(left2middle_RESULT0)
);

 //switch matrix multiplexer left2middle_RESULT1 MUX-4
assign left2middle_RESULT1_input = {VCC0,GND0,SS4END1,S4END1};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT1 (
    .A0(left2middle_RESULT1_input[0]),
    .A1(left2middle_RESULT1_input[1]),
    .A2(left2middle_RESULT1_input[2]),
    .A3(left2middle_RESULT1_input[3]),
    .S0(ConfigBits[34+0]),
    .S0N(ConfigBits_N[34+0]),
    .S1(ConfigBits[34+1]),
    .S1N(ConfigBits_N[34+1]),
    .X(left2middle_RESULT1)
);

 //switch matrix multiplexer left2middle_RESULT2 MUX-4
assign left2middle_RESULT2_input = {VCC0,GND0,SS4END2,S4END2};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT2 (
    .A0(left2middle_RESULT2_input[0]),
    .A1(left2middle_RESULT2_input[1]),
    .A2(left2middle_RESULT2_input[2]),
    .A3(left2middle_RESULT2_input[3]),
    .S0(ConfigBits[36+0]),
    .S0N(ConfigBits_N[36+0]),
    .S1(ConfigBits[36+1]),
    .S1N(ConfigBits_N[36+1]),
    .X(left2middle_RESULT2)
);

 //switch matrix multiplexer left2middle_RESULT3 MUX-4
assign left2middle_RESULT3_input = {VCC0,GND0,SS4END3,S4END3};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT3 (
    .A0(left2middle_RESULT3_input[0]),
    .A1(left2middle_RESULT3_input[1]),
    .A2(left2middle_RESULT3_input[2]),
    .A3(left2middle_RESULT3_input[3]),
    .S0(ConfigBits[38+0]),
    .S0N(ConfigBits_N[38+0]),
    .S1(ConfigBits[38+1]),
    .S1N(ConfigBits_N[38+1]),
    .X(left2middle_RESULT3)
);

 //switch matrix multiplexer left2middle_RESULT4 MUX-4
assign left2middle_RESULT4_input = {VCC0,GND0,SS4END4,S4END4};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT4 (
    .A0(left2middle_RESULT4_input[0]),
    .A1(left2middle_RESULT4_input[1]),
    .A2(left2middle_RESULT4_input[2]),
    .A3(left2middle_RESULT4_input[3]),
    .S0(ConfigBits[40+0]),
    .S0N(ConfigBits_N[40+0]),
    .S1(ConfigBits[40+1]),
    .S1N(ConfigBits_N[40+1]),
    .X(left2middle_RESULT4)
);

 //switch matrix multiplexer left2middle_RESULT5 MUX-4
assign left2middle_RESULT5_input = {VCC0,GND0,SS4END5,S4END5};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT5 (
    .A0(left2middle_RESULT5_input[0]),
    .A1(left2middle_RESULT5_input[1]),
    .A2(left2middle_RESULT5_input[2]),
    .A3(left2middle_RESULT5_input[3]),
    .S0(ConfigBits[42+0]),
    .S0N(ConfigBits_N[42+0]),
    .S1(ConfigBits[42+1]),
    .S1N(ConfigBits_N[42+1]),
    .X(left2middle_RESULT5)
);

 //switch matrix multiplexer left2middle_RESULT6 MUX-4
assign left2middle_RESULT6_input = {VCC0,GND0,SS4END6,S4END6};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT6 (
    .A0(left2middle_RESULT6_input[0]),
    .A1(left2middle_RESULT6_input[1]),
    .A2(left2middle_RESULT6_input[2]),
    .A3(left2middle_RESULT6_input[3]),
    .S0(ConfigBits[44+0]),
    .S0N(ConfigBits_N[44+0]),
    .S1(ConfigBits[44+1]),
    .S1N(ConfigBits_N[44+1]),
    .X(left2middle_RESULT6)
);

 //switch matrix multiplexer left2middle_RESULT7 MUX-4
assign left2middle_RESULT7_input = {VCC0,GND0,SS4END7,S4END7};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT7 (
    .A0(left2middle_RESULT7_input[0]),
    .A1(left2middle_RESULT7_input[1]),
    .A2(left2middle_RESULT7_input[2]),
    .A3(left2middle_RESULT7_input[3]),
    .S0(ConfigBits[46+0]),
    .S0N(ConfigBits_N[46+0]),
    .S1(ConfigBits[46+1]),
    .S1N(ConfigBits_N[46+1]),
    .X(left2middle_RESULT7)
);

 //switch matrix multiplexer left2middle_RESULT8 MUX-4
assign left2middle_RESULT8_input = {VCC0,GND0,SS4END8,S4END8};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT8 (
    .A0(left2middle_RESULT8_input[0]),
    .A1(left2middle_RESULT8_input[1]),
    .A2(left2middle_RESULT8_input[2]),
    .A3(left2middle_RESULT8_input[3]),
    .S0(ConfigBits[48+0]),
    .S0N(ConfigBits_N[48+0]),
    .S1(ConfigBits[48+1]),
    .S1N(ConfigBits_N[48+1]),
    .X(left2middle_RESULT8)
);

 //switch matrix multiplexer left2middle_RESULT9 MUX-4
assign left2middle_RESULT9_input = {VCC0,GND0,SS4END9,S4END9};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT9 (
    .A0(left2middle_RESULT9_input[0]),
    .A1(left2middle_RESULT9_input[1]),
    .A2(left2middle_RESULT9_input[2]),
    .A3(left2middle_RESULT9_input[3]),
    .S0(ConfigBits[50+0]),
    .S0N(ConfigBits_N[50+0]),
    .S1(ConfigBits[50+1]),
    .S1N(ConfigBits_N[50+1]),
    .X(left2middle_RESULT9)
);

 //switch matrix multiplexer left2middle_RESULT10 MUX-4
assign left2middle_RESULT10_input = {VCC0,GND0,SS4END10,S4END10};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT10 (
    .A0(left2middle_RESULT10_input[0]),
    .A1(left2middle_RESULT10_input[1]),
    .A2(left2middle_RESULT10_input[2]),
    .A3(left2middle_RESULT10_input[3]),
    .S0(ConfigBits[52+0]),
    .S0N(ConfigBits_N[52+0]),
    .S1(ConfigBits[52+1]),
    .S1N(ConfigBits_N[52+1]),
    .X(left2middle_RESULT10)
);

 //switch matrix multiplexer left2middle_RESULT11 MUX-4
assign left2middle_RESULT11_input = {VCC0,GND0,SS4END11,S4END11};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT11 (
    .A0(left2middle_RESULT11_input[0]),
    .A1(left2middle_RESULT11_input[1]),
    .A2(left2middle_RESULT11_input[2]),
    .A3(left2middle_RESULT11_input[3]),
    .S0(ConfigBits[54+0]),
    .S0N(ConfigBits_N[54+0]),
    .S1(ConfigBits[54+1]),
    .S1N(ConfigBits_N[54+1]),
    .X(left2middle_RESULT11)
);

 //switch matrix multiplexer left2middle_RESULT12 MUX-4
assign left2middle_RESULT12_input = {VCC0,GND0,SS4END12,S4END12};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT12 (
    .A0(left2middle_RESULT12_input[0]),
    .A1(left2middle_RESULT12_input[1]),
    .A2(left2middle_RESULT12_input[2]),
    .A3(left2middle_RESULT12_input[3]),
    .S0(ConfigBits[56+0]),
    .S0N(ConfigBits_N[56+0]),
    .S1(ConfigBits[56+1]),
    .S1N(ConfigBits_N[56+1]),
    .X(left2middle_RESULT12)
);

 //switch matrix multiplexer left2middle_RESULT13 MUX-4
assign left2middle_RESULT13_input = {VCC0,GND0,SS4END13,S4END13};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT13 (
    .A0(left2middle_RESULT13_input[0]),
    .A1(left2middle_RESULT13_input[1]),
    .A2(left2middle_RESULT13_input[2]),
    .A3(left2middle_RESULT13_input[3]),
    .S0(ConfigBits[58+0]),
    .S0N(ConfigBits_N[58+0]),
    .S1(ConfigBits[58+1]),
    .S1N(ConfigBits_N[58+1]),
    .X(left2middle_RESULT13)
);

 //switch matrix multiplexer left2middle_RESULT14 MUX-4
assign left2middle_RESULT14_input = {VCC0,GND0,SS4END14,S4END14};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT14 (
    .A0(left2middle_RESULT14_input[0]),
    .A1(left2middle_RESULT14_input[1]),
    .A2(left2middle_RESULT14_input[2]),
    .A3(left2middle_RESULT14_input[3]),
    .S0(ConfigBits[60+0]),
    .S0N(ConfigBits_N[60+0]),
    .S1(ConfigBits[60+1]),
    .S1N(ConfigBits_N[60+1]),
    .X(left2middle_RESULT14)
);

 //switch matrix multiplexer left2middle_RESULT15 MUX-4
assign left2middle_RESULT15_input = {VCC0,GND0,SS4END15,S4END15};
cus_mux41_buf inst_cus_mux41_buf_left2middle_RESULT15 (
    .A0(left2middle_RESULT15_input[0]),
    .A1(left2middle_RESULT15_input[1]),
    .A2(left2middle_RESULT15_input[2]),
    .A3(left2middle_RESULT15_input[3]),
    .S0(ConfigBits[62+0]),
    .S0N(ConfigBits_N[62+0]),
    .S1(ConfigBits[62+1]),
    .S1N(ConfigBits_N[62+1]),
    .X(left2middle_RESULT15)
);

endmodule
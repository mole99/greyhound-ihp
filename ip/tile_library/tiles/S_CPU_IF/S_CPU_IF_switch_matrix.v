 // NumberOfConfigBits: 88
module S_CPU_IF_switch_matrix
    #(
        parameter NoConfigBits=88
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
        input  O0,
        input  O1,
        input  O2,
        input  O3,
        input  O4,
        input  O5,
        input  O6,
        input  O7,
        input  O8,
        input  O9,
        input  O10,
        input  O11,
        input  O12,
        input  O13,
        input  O14,
        input  O15,
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
        output  I0,
        output  I1,
        output  I2,
        output  I3,
        output  I4,
        output  I5,
        output  I6,
        output  I7,
        output  I8,
        output  I9,
        output  I10,
        output  I11,
        output  I12,
        output  I13,
        output  I14,
        output  I15,
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

wire[4-1:0] N1BEG0_input;
wire[4-1:0] N1BEG1_input;
wire[4-1:0] N1BEG2_input;
wire[4-1:0] N1BEG3_input;
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
wire[4-1:0] I0_input;
wire[4-1:0] I1_input;
wire[4-1:0] I2_input;
wire[4-1:0] I3_input;
wire[4-1:0] I4_input;
wire[4-1:0] I5_input;
wire[4-1:0] I6_input;
wire[4-1:0] I7_input;
wire[4-1:0] I8_input;
wire[4-1:0] I9_input;
wire[4-1:0] I10_input;
wire[4-1:0] I11_input;
wire[4-1:0] I12_input;
wire[4-1:0] I13_input;
wire[4-1:0] I14_input;
wire[4-1:0] I15_input;
 //The configuration bits (if any) are just a long shift register
 //This shift register is padded to an even number of flops/latches
 //switch matrix multiplexer N1BEG0 MUX-4
assign N1BEG0_input = {O15,O7,O3,S1END3};
cus_mux41_buf inst_cus_mux41_buf_N1BEG0 (
    .A0(N1BEG0_input[0]),
    .A1(N1BEG0_input[1]),
    .A2(N1BEG0_input[2]),
    .A3(N1BEG0_input[3]),
    .S0(ConfigBits[0+0]),
    .S0N(ConfigBits_N[0+0]),
    .S1(ConfigBits[0+1]),
    .S1N(ConfigBits_N[0+1]),
    .X(N1BEG0)
);

 //switch matrix multiplexer N1BEG1 MUX-4
assign N1BEG1_input = {O14,O6,O2,S1END2};
cus_mux41_buf inst_cus_mux41_buf_N1BEG1 (
    .A0(N1BEG1_input[0]),
    .A1(N1BEG1_input[1]),
    .A2(N1BEG1_input[2]),
    .A3(N1BEG1_input[3]),
    .S0(ConfigBits[2+0]),
    .S0N(ConfigBits_N[2+0]),
    .S1(ConfigBits[2+1]),
    .S1N(ConfigBits_N[2+1]),
    .X(N1BEG1)
);

 //switch matrix multiplexer N1BEG2 MUX-4
assign N1BEG2_input = {O13,O5,O1,S1END1};
cus_mux41_buf inst_cus_mux41_buf_N1BEG2 (
    .A0(N1BEG2_input[0]),
    .A1(N1BEG2_input[1]),
    .A2(N1BEG2_input[2]),
    .A3(N1BEG2_input[3]),
    .S0(ConfigBits[4+0]),
    .S0N(ConfigBits_N[4+0]),
    .S1(ConfigBits[4+1]),
    .S1N(ConfigBits_N[4+1]),
    .X(N1BEG2)
);

 //switch matrix multiplexer N1BEG3 MUX-4
assign N1BEG3_input = {O12,O4,O0,S1END0};
cus_mux41_buf inst_cus_mux41_buf_N1BEG3 (
    .A0(N1BEG3_input[0]),
    .A1(N1BEG3_input[1]),
    .A2(N1BEG3_input[2]),
    .A3(N1BEG3_input[3]),
    .S0(ConfigBits[6+0]),
    .S0N(ConfigBits_N[6+0]),
    .S1(ConfigBits[6+1]),
    .S1N(ConfigBits_N[6+1]),
    .X(N1BEG3)
);

 //switch matrix multiplexer N2BEG0 MUX-2
assign N2BEG0_input = {O7,S2MID7};
cus_mux21 inst_cus_mux21_N2BEG0 (
    .A0(N2BEG0_input[0]),
    .A1(N2BEG0_input[1]),
    .S(ConfigBits[8+0]),
    .X(N2BEG0)
);

 //switch matrix multiplexer N2BEG1 MUX-2
assign N2BEG1_input = {O6,S2MID6};
cus_mux21 inst_cus_mux21_N2BEG1 (
    .A0(N2BEG1_input[0]),
    .A1(N2BEG1_input[1]),
    .S(ConfigBits[9+0]),
    .X(N2BEG1)
);

 //switch matrix multiplexer N2BEG2 MUX-2
assign N2BEG2_input = {O5,S2MID5};
cus_mux21 inst_cus_mux21_N2BEG2 (
    .A0(N2BEG2_input[0]),
    .A1(N2BEG2_input[1]),
    .S(ConfigBits[10+0]),
    .X(N2BEG2)
);

 //switch matrix multiplexer N2BEG3 MUX-2
assign N2BEG3_input = {O4,S2MID4};
cus_mux21 inst_cus_mux21_N2BEG3 (
    .A0(N2BEG3_input[0]),
    .A1(N2BEG3_input[1]),
    .S(ConfigBits[11+0]),
    .X(N2BEG3)
);

 //switch matrix multiplexer N2BEG4 MUX-2
assign N2BEG4_input = {O3,S2MID3};
cus_mux21 inst_cus_mux21_N2BEG4 (
    .A0(N2BEG4_input[0]),
    .A1(N2BEG4_input[1]),
    .S(ConfigBits[12+0]),
    .X(N2BEG4)
);

 //switch matrix multiplexer N2BEG5 MUX-2
assign N2BEG5_input = {O2,S2MID2};
cus_mux21 inst_cus_mux21_N2BEG5 (
    .A0(N2BEG5_input[0]),
    .A1(N2BEG5_input[1]),
    .S(ConfigBits[13+0]),
    .X(N2BEG5)
);

 //switch matrix multiplexer N2BEG6 MUX-2
assign N2BEG6_input = {O1,S2MID1};
cus_mux21 inst_cus_mux21_N2BEG6 (
    .A0(N2BEG6_input[0]),
    .A1(N2BEG6_input[1]),
    .S(ConfigBits[14+0]),
    .X(N2BEG6)
);

 //switch matrix multiplexer N2BEG7 MUX-2
assign N2BEG7_input = {O0,S2MID0};
cus_mux21 inst_cus_mux21_N2BEG7 (
    .A0(N2BEG7_input[0]),
    .A1(N2BEG7_input[1]),
    .S(ConfigBits[15+0]),
    .X(N2BEG7)
);

 //switch matrix multiplexer N2BEGb0 MUX-2
assign N2BEGb0_input = {O15,S2END7};
cus_mux21 inst_cus_mux21_N2BEGb0 (
    .A0(N2BEGb0_input[0]),
    .A1(N2BEGb0_input[1]),
    .S(ConfigBits[16+0]),
    .X(N2BEGb0)
);

 //switch matrix multiplexer N2BEGb1 MUX-2
assign N2BEGb1_input = {O14,S2END6};
cus_mux21 inst_cus_mux21_N2BEGb1 (
    .A0(N2BEGb1_input[0]),
    .A1(N2BEGb1_input[1]),
    .S(ConfigBits[17+0]),
    .X(N2BEGb1)
);

 //switch matrix multiplexer N2BEGb2 MUX-2
assign N2BEGb2_input = {O13,S2END5};
cus_mux21 inst_cus_mux21_N2BEGb2 (
    .A0(N2BEGb2_input[0]),
    .A1(N2BEGb2_input[1]),
    .S(ConfigBits[18+0]),
    .X(N2BEGb2)
);

 //switch matrix multiplexer N2BEGb3 MUX-2
assign N2BEGb3_input = {O12,S2END4};
cus_mux21 inst_cus_mux21_N2BEGb3 (
    .A0(N2BEGb3_input[0]),
    .A1(N2BEGb3_input[1]),
    .S(ConfigBits[19+0]),
    .X(N2BEGb3)
);

 //switch matrix multiplexer N2BEGb4 MUX-2
assign N2BEGb4_input = {O11,S2END3};
cus_mux21 inst_cus_mux21_N2BEGb4 (
    .A0(N2BEGb4_input[0]),
    .A1(N2BEGb4_input[1]),
    .S(ConfigBits[20+0]),
    .X(N2BEGb4)
);

 //switch matrix multiplexer N2BEGb5 MUX-2
assign N2BEGb5_input = {O10,S2END2};
cus_mux21 inst_cus_mux21_N2BEGb5 (
    .A0(N2BEGb5_input[0]),
    .A1(N2BEGb5_input[1]),
    .S(ConfigBits[21+0]),
    .X(N2BEGb5)
);

 //switch matrix multiplexer N2BEGb6 MUX-2
assign N2BEGb6_input = {O9,S2END1};
cus_mux21 inst_cus_mux21_N2BEGb6 (
    .A0(N2BEGb6_input[0]),
    .A1(N2BEGb6_input[1]),
    .S(ConfigBits[22+0]),
    .X(N2BEGb6)
);

 //switch matrix multiplexer N2BEGb7 MUX-2
assign N2BEGb7_input = {O8,S2END0};
cus_mux21 inst_cus_mux21_N2BEGb7 (
    .A0(N2BEGb7_input[0]),
    .A1(N2BEGb7_input[1]),
    .S(ConfigBits[23+0]),
    .X(N2BEGb7)
);

 //switch matrix multiplexer N4BEG0 MUX-2
assign N4BEG0_input = {O15,S4END15};
cus_mux21 inst_cus_mux21_N4BEG0 (
    .A0(N4BEG0_input[0]),
    .A1(N4BEG0_input[1]),
    .S(ConfigBits[24+0]),
    .X(N4BEG0)
);

 //switch matrix multiplexer N4BEG1 MUX-2
assign N4BEG1_input = {O14,S4END14};
cus_mux21 inst_cus_mux21_N4BEG1 (
    .A0(N4BEG1_input[0]),
    .A1(N4BEG1_input[1]),
    .S(ConfigBits[25+0]),
    .X(N4BEG1)
);

 //switch matrix multiplexer N4BEG2 MUX-2
assign N4BEG2_input = {O13,S4END13};
cus_mux21 inst_cus_mux21_N4BEG2 (
    .A0(N4BEG2_input[0]),
    .A1(N4BEG2_input[1]),
    .S(ConfigBits[26+0]),
    .X(N4BEG2)
);

 //switch matrix multiplexer N4BEG3 MUX-2
assign N4BEG3_input = {O12,S4END12};
cus_mux21 inst_cus_mux21_N4BEG3 (
    .A0(N4BEG3_input[0]),
    .A1(N4BEG3_input[1]),
    .S(ConfigBits[27+0]),
    .X(N4BEG3)
);

 //switch matrix multiplexer N4BEG4 MUX-2
assign N4BEG4_input = {O11,S4END11};
cus_mux21 inst_cus_mux21_N4BEG4 (
    .A0(N4BEG4_input[0]),
    .A1(N4BEG4_input[1]),
    .S(ConfigBits[28+0]),
    .X(N4BEG4)
);

 //switch matrix multiplexer N4BEG5 MUX-2
assign N4BEG5_input = {O10,S4END10};
cus_mux21 inst_cus_mux21_N4BEG5 (
    .A0(N4BEG5_input[0]),
    .A1(N4BEG5_input[1]),
    .S(ConfigBits[29+0]),
    .X(N4BEG5)
);

 //switch matrix multiplexer N4BEG6 MUX-2
assign N4BEG6_input = {O9,S4END9};
cus_mux21 inst_cus_mux21_N4BEG6 (
    .A0(N4BEG6_input[0]),
    .A1(N4BEG6_input[1]),
    .S(ConfigBits[30+0]),
    .X(N4BEG6)
);

 //switch matrix multiplexer N4BEG7 MUX-2
assign N4BEG7_input = {O8,S4END8};
cus_mux21 inst_cus_mux21_N4BEG7 (
    .A0(N4BEG7_input[0]),
    .A1(N4BEG7_input[1]),
    .S(ConfigBits[31+0]),
    .X(N4BEG7)
);

 //switch matrix multiplexer N4BEG8 MUX-2
assign N4BEG8_input = {O7,S4END7};
cus_mux21 inst_cus_mux21_N4BEG8 (
    .A0(N4BEG8_input[0]),
    .A1(N4BEG8_input[1]),
    .S(ConfigBits[32+0]),
    .X(N4BEG8)
);

 //switch matrix multiplexer N4BEG9 MUX-2
assign N4BEG9_input = {O6,S4END6};
cus_mux21 inst_cus_mux21_N4BEG9 (
    .A0(N4BEG9_input[0]),
    .A1(N4BEG9_input[1]),
    .S(ConfigBits[33+0]),
    .X(N4BEG9)
);

 //switch matrix multiplexer N4BEG10 MUX-2
assign N4BEG10_input = {O5,S4END5};
cus_mux21 inst_cus_mux21_N4BEG10 (
    .A0(N4BEG10_input[0]),
    .A1(N4BEG10_input[1]),
    .S(ConfigBits[34+0]),
    .X(N4BEG10)
);

 //switch matrix multiplexer N4BEG11 MUX-2
assign N4BEG11_input = {O4,S4END4};
cus_mux21 inst_cus_mux21_N4BEG11 (
    .A0(N4BEG11_input[0]),
    .A1(N4BEG11_input[1]),
    .S(ConfigBits[35+0]),
    .X(N4BEG11)
);

 //switch matrix multiplexer N4BEG12 MUX-2
assign N4BEG12_input = {O3,S4END3};
cus_mux21 inst_cus_mux21_N4BEG12 (
    .A0(N4BEG12_input[0]),
    .A1(N4BEG12_input[1]),
    .S(ConfigBits[36+0]),
    .X(N4BEG12)
);

 //switch matrix multiplexer N4BEG13 MUX-2
assign N4BEG13_input = {O2,S4END2};
cus_mux21 inst_cus_mux21_N4BEG13 (
    .A0(N4BEG13_input[0]),
    .A1(N4BEG13_input[1]),
    .S(ConfigBits[37+0]),
    .X(N4BEG13)
);

 //switch matrix multiplexer N4BEG14 MUX-2
assign N4BEG14_input = {O1,S4END1};
cus_mux21 inst_cus_mux21_N4BEG14 (
    .A0(N4BEG14_input[0]),
    .A1(N4BEG14_input[1]),
    .S(ConfigBits[38+0]),
    .X(N4BEG14)
);

 //switch matrix multiplexer N4BEG15 MUX-2
assign N4BEG15_input = {O0,S4END0};
cus_mux21 inst_cus_mux21_N4BEG15 (
    .A0(N4BEG15_input[0]),
    .A1(N4BEG15_input[1]),
    .S(ConfigBits[39+0]),
    .X(N4BEG15)
);

 //switch matrix multiplexer NN4BEG0 MUX-2
assign NN4BEG0_input = {O15,SS4END15};
cus_mux21 inst_cus_mux21_NN4BEG0 (
    .A0(NN4BEG0_input[0]),
    .A1(NN4BEG0_input[1]),
    .S(ConfigBits[40+0]),
    .X(NN4BEG0)
);

 //switch matrix multiplexer NN4BEG1 MUX-2
assign NN4BEG1_input = {O14,SS4END14};
cus_mux21 inst_cus_mux21_NN4BEG1 (
    .A0(NN4BEG1_input[0]),
    .A1(NN4BEG1_input[1]),
    .S(ConfigBits[41+0]),
    .X(NN4BEG1)
);

 //switch matrix multiplexer NN4BEG2 MUX-2
assign NN4BEG2_input = {O13,SS4END13};
cus_mux21 inst_cus_mux21_NN4BEG2 (
    .A0(NN4BEG2_input[0]),
    .A1(NN4BEG2_input[1]),
    .S(ConfigBits[42+0]),
    .X(NN4BEG2)
);

 //switch matrix multiplexer NN4BEG3 MUX-2
assign NN4BEG3_input = {O12,SS4END12};
cus_mux21 inst_cus_mux21_NN4BEG3 (
    .A0(NN4BEG3_input[0]),
    .A1(NN4BEG3_input[1]),
    .S(ConfigBits[43+0]),
    .X(NN4BEG3)
);

 //switch matrix multiplexer NN4BEG4 MUX-2
assign NN4BEG4_input = {O11,SS4END11};
cus_mux21 inst_cus_mux21_NN4BEG4 (
    .A0(NN4BEG4_input[0]),
    .A1(NN4BEG4_input[1]),
    .S(ConfigBits[44+0]),
    .X(NN4BEG4)
);

 //switch matrix multiplexer NN4BEG5 MUX-2
assign NN4BEG5_input = {O10,SS4END10};
cus_mux21 inst_cus_mux21_NN4BEG5 (
    .A0(NN4BEG5_input[0]),
    .A1(NN4BEG5_input[1]),
    .S(ConfigBits[45+0]),
    .X(NN4BEG5)
);

 //switch matrix multiplexer NN4BEG6 MUX-2
assign NN4BEG6_input = {O9,SS4END9};
cus_mux21 inst_cus_mux21_NN4BEG6 (
    .A0(NN4BEG6_input[0]),
    .A1(NN4BEG6_input[1]),
    .S(ConfigBits[46+0]),
    .X(NN4BEG6)
);

 //switch matrix multiplexer NN4BEG7 MUX-2
assign NN4BEG7_input = {O8,SS4END8};
cus_mux21 inst_cus_mux21_NN4BEG7 (
    .A0(NN4BEG7_input[0]),
    .A1(NN4BEG7_input[1]),
    .S(ConfigBits[47+0]),
    .X(NN4BEG7)
);

 //switch matrix multiplexer NN4BEG8 MUX-2
assign NN4BEG8_input = {O7,SS4END7};
cus_mux21 inst_cus_mux21_NN4BEG8 (
    .A0(NN4BEG8_input[0]),
    .A1(NN4BEG8_input[1]),
    .S(ConfigBits[48+0]),
    .X(NN4BEG8)
);

 //switch matrix multiplexer NN4BEG9 MUX-2
assign NN4BEG9_input = {O6,SS4END6};
cus_mux21 inst_cus_mux21_NN4BEG9 (
    .A0(NN4BEG9_input[0]),
    .A1(NN4BEG9_input[1]),
    .S(ConfigBits[49+0]),
    .X(NN4BEG9)
);

 //switch matrix multiplexer NN4BEG10 MUX-2
assign NN4BEG10_input = {O5,SS4END5};
cus_mux21 inst_cus_mux21_NN4BEG10 (
    .A0(NN4BEG10_input[0]),
    .A1(NN4BEG10_input[1]),
    .S(ConfigBits[50+0]),
    .X(NN4BEG10)
);

 //switch matrix multiplexer NN4BEG11 MUX-2
assign NN4BEG11_input = {O4,SS4END4};
cus_mux21 inst_cus_mux21_NN4BEG11 (
    .A0(NN4BEG11_input[0]),
    .A1(NN4BEG11_input[1]),
    .S(ConfigBits[51+0]),
    .X(NN4BEG11)
);

 //switch matrix multiplexer NN4BEG12 MUX-2
assign NN4BEG12_input = {O3,SS4END3};
cus_mux21 inst_cus_mux21_NN4BEG12 (
    .A0(NN4BEG12_input[0]),
    .A1(NN4BEG12_input[1]),
    .S(ConfigBits[52+0]),
    .X(NN4BEG12)
);

 //switch matrix multiplexer NN4BEG13 MUX-2
assign NN4BEG13_input = {O2,SS4END2};
cus_mux21 inst_cus_mux21_NN4BEG13 (
    .A0(NN4BEG13_input[0]),
    .A1(NN4BEG13_input[1]),
    .S(ConfigBits[53+0]),
    .X(NN4BEG13)
);

 //switch matrix multiplexer NN4BEG14 MUX-2
assign NN4BEG14_input = {O1,SS4END1};
cus_mux21 inst_cus_mux21_NN4BEG14 (
    .A0(NN4BEG14_input[0]),
    .A1(NN4BEG14_input[1]),
    .S(ConfigBits[54+0]),
    .X(NN4BEG14)
);

 //switch matrix multiplexer NN4BEG15 MUX-2
assign NN4BEG15_input = {O0,SS4END0};
cus_mux21 inst_cus_mux21_NN4BEG15 (
    .A0(NN4BEG15_input[0]),
    .A1(NN4BEG15_input[1]),
    .S(ConfigBits[55+0]),
    .X(NN4BEG15)
);

 //switch matrix multiplexer Co0 MUX-1
assign Co0 = GND0;

 //switch matrix multiplexer I0 MUX-4
assign I0_input = {SS4END0,S4END0,S2MID0,S1END0};
cus_mux41_buf inst_cus_mux41_buf_I0 (
    .A0(I0_input[0]),
    .A1(I0_input[1]),
    .A2(I0_input[2]),
    .A3(I0_input[3]),
    .S0(ConfigBits[56+0]),
    .S0N(ConfigBits_N[56+0]),
    .S1(ConfigBits[56+1]),
    .S1N(ConfigBits_N[56+1]),
    .X(I0)
);

 //switch matrix multiplexer I1 MUX-4
assign I1_input = {SS4END1,S4END1,S2MID1,S1END1};
cus_mux41_buf inst_cus_mux41_buf_I1 (
    .A0(I1_input[0]),
    .A1(I1_input[1]),
    .A2(I1_input[2]),
    .A3(I1_input[3]),
    .S0(ConfigBits[58+0]),
    .S0N(ConfigBits_N[58+0]),
    .S1(ConfigBits[58+1]),
    .S1N(ConfigBits_N[58+1]),
    .X(I1)
);

 //switch matrix multiplexer I2 MUX-4
assign I2_input = {SS4END2,S4END2,S2MID2,S1END2};
cus_mux41_buf inst_cus_mux41_buf_I2 (
    .A0(I2_input[0]),
    .A1(I2_input[1]),
    .A2(I2_input[2]),
    .A3(I2_input[3]),
    .S0(ConfigBits[60+0]),
    .S0N(ConfigBits_N[60+0]),
    .S1(ConfigBits[60+1]),
    .S1N(ConfigBits_N[60+1]),
    .X(I2)
);

 //switch matrix multiplexer I3 MUX-4
assign I3_input = {SS4END3,S4END3,S2MID3,S1END3};
cus_mux41_buf inst_cus_mux41_buf_I3 (
    .A0(I3_input[0]),
    .A1(I3_input[1]),
    .A2(I3_input[2]),
    .A3(I3_input[3]),
    .S0(ConfigBits[62+0]),
    .S0N(ConfigBits_N[62+0]),
    .S1(ConfigBits[62+1]),
    .S1N(ConfigBits_N[62+1]),
    .X(I3)
);

 //switch matrix multiplexer I4 MUX-4
assign I4_input = {SS4END4,S4END4,S2END0,S1END0};
cus_mux41_buf inst_cus_mux41_buf_I4 (
    .A0(I4_input[0]),
    .A1(I4_input[1]),
    .A2(I4_input[2]),
    .A3(I4_input[3]),
    .S0(ConfigBits[64+0]),
    .S0N(ConfigBits_N[64+0]),
    .S1(ConfigBits[64+1]),
    .S1N(ConfigBits_N[64+1]),
    .X(I4)
);

 //switch matrix multiplexer I5 MUX-4
assign I5_input = {SS4END5,S4END5,S2END1,S1END1};
cus_mux41_buf inst_cus_mux41_buf_I5 (
    .A0(I5_input[0]),
    .A1(I5_input[1]),
    .A2(I5_input[2]),
    .A3(I5_input[3]),
    .S0(ConfigBits[66+0]),
    .S0N(ConfigBits_N[66+0]),
    .S1(ConfigBits[66+1]),
    .S1N(ConfigBits_N[66+1]),
    .X(I5)
);

 //switch matrix multiplexer I6 MUX-4
assign I6_input = {SS4END6,S4END6,S2END2,S1END2};
cus_mux41_buf inst_cus_mux41_buf_I6 (
    .A0(I6_input[0]),
    .A1(I6_input[1]),
    .A2(I6_input[2]),
    .A3(I6_input[3]),
    .S0(ConfigBits[68+0]),
    .S0N(ConfigBits_N[68+0]),
    .S1(ConfigBits[68+1]),
    .S1N(ConfigBits_N[68+1]),
    .X(I6)
);

 //switch matrix multiplexer I7 MUX-4
assign I7_input = {SS4END7,S4END7,S2END3,S1END3};
cus_mux41_buf inst_cus_mux41_buf_I7 (
    .A0(I7_input[0]),
    .A1(I7_input[1]),
    .A2(I7_input[2]),
    .A3(I7_input[3]),
    .S0(ConfigBits[70+0]),
    .S0N(ConfigBits_N[70+0]),
    .S1(ConfigBits[70+1]),
    .S1N(ConfigBits_N[70+1]),
    .X(I7)
);

 //switch matrix multiplexer I8 MUX-4
assign I8_input = {SS4END8,S4END8,S2END4,S1END0};
cus_mux41_buf inst_cus_mux41_buf_I8 (
    .A0(I8_input[0]),
    .A1(I8_input[1]),
    .A2(I8_input[2]),
    .A3(I8_input[3]),
    .S0(ConfigBits[72+0]),
    .S0N(ConfigBits_N[72+0]),
    .S1(ConfigBits[72+1]),
    .S1N(ConfigBits_N[72+1]),
    .X(I8)
);

 //switch matrix multiplexer I9 MUX-4
assign I9_input = {SS4END9,S4END9,S2END5,S1END1};
cus_mux41_buf inst_cus_mux41_buf_I9 (
    .A0(I9_input[0]),
    .A1(I9_input[1]),
    .A2(I9_input[2]),
    .A3(I9_input[3]),
    .S0(ConfigBits[74+0]),
    .S0N(ConfigBits_N[74+0]),
    .S1(ConfigBits[74+1]),
    .S1N(ConfigBits_N[74+1]),
    .X(I9)
);

 //switch matrix multiplexer I10 MUX-4
assign I10_input = {SS4END10,S4END10,S2END6,S1END2};
cus_mux41_buf inst_cus_mux41_buf_I10 (
    .A0(I10_input[0]),
    .A1(I10_input[1]),
    .A2(I10_input[2]),
    .A3(I10_input[3]),
    .S0(ConfigBits[76+0]),
    .S0N(ConfigBits_N[76+0]),
    .S1(ConfigBits[76+1]),
    .S1N(ConfigBits_N[76+1]),
    .X(I10)
);

 //switch matrix multiplexer I11 MUX-4
assign I11_input = {SS4END11,S4END11,S2END7,S1END3};
cus_mux41_buf inst_cus_mux41_buf_I11 (
    .A0(I11_input[0]),
    .A1(I11_input[1]),
    .A2(I11_input[2]),
    .A3(I11_input[3]),
    .S0(ConfigBits[78+0]),
    .S0N(ConfigBits_N[78+0]),
    .S1(ConfigBits[78+1]),
    .S1N(ConfigBits_N[78+1]),
    .X(I11)
);

 //switch matrix multiplexer I12 MUX-4
assign I12_input = {SS4END12,S4END12,S2MID4,S1END0};
cus_mux41_buf inst_cus_mux41_buf_I12 (
    .A0(I12_input[0]),
    .A1(I12_input[1]),
    .A2(I12_input[2]),
    .A3(I12_input[3]),
    .S0(ConfigBits[80+0]),
    .S0N(ConfigBits_N[80+0]),
    .S1(ConfigBits[80+1]),
    .S1N(ConfigBits_N[80+1]),
    .X(I12)
);

 //switch matrix multiplexer I13 MUX-4
assign I13_input = {SS4END13,S4END13,S2MID5,S1END1};
cus_mux41_buf inst_cus_mux41_buf_I13 (
    .A0(I13_input[0]),
    .A1(I13_input[1]),
    .A2(I13_input[2]),
    .A3(I13_input[3]),
    .S0(ConfigBits[82+0]),
    .S0N(ConfigBits_N[82+0]),
    .S1(ConfigBits[82+1]),
    .S1N(ConfigBits_N[82+1]),
    .X(I13)
);

 //switch matrix multiplexer I14 MUX-4
assign I14_input = {SS4END14,S4END14,S2MID6,S1END2};
cus_mux41_buf inst_cus_mux41_buf_I14 (
    .A0(I14_input[0]),
    .A1(I14_input[1]),
    .A2(I14_input[2]),
    .A3(I14_input[3]),
    .S0(ConfigBits[84+0]),
    .S0N(ConfigBits_N[84+0]),
    .S1(ConfigBits[84+1]),
    .S1N(ConfigBits_N[84+1]),
    .X(I14)
);

 //switch matrix multiplexer I15 MUX-4
assign I15_input = {SS4END15,S4END15,S2MID7,S1END3};
cus_mux41_buf inst_cus_mux41_buf_I15 (
    .A0(I15_input[0]),
    .A1(I15_input[1]),
    .A2(I15_input[2]),
    .A3(I15_input[3]),
    .S0(ConfigBits[86+0]),
    .S0N(ConfigBits_N[86+0]),
    .S1(ConfigBits[86+1]),
    .S1N(ConfigBits_N[86+1]),
    .X(I15)
);

endmodule
 // NumberOfConfigBits: 70
module S_OBI_right_switch_matrix
    #(
        parameter NoConfigBits=70
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
        input  middle2right_WDATA0,
        input  middle2right_WDATA1,
        input  middle2right_WDATA2,
        input  middle2right_WDATA3,
        input  middle2right_WDATA4,
        input  middle2right_WDATA5,
        input  middle2right_WDATA6,
        input  middle2right_WDATA7,
        input  middle2right_WDATA8,
        input  middle2right_WDATA9,
        input  middle2right_ADDR0,
        input  middle2right_ADDR1,
        input  middle2right_ADDR2,
        input  middle2right_ADDR3,
        input  middle2right_ADDR4,
        input  middle2right_ADDR5,
        input  middle2right_ADDR6,
        input  middle2right_ADDR7,
        input  middle2right_ADDR8,
        input  middle2right_ADDR9,
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
        output  right2middle_RDATA0,
        output  right2middle_RDATA1,
        output  right2middle_RDATA2,
        output  right2middle_RDATA3,
        output  right2middle_RDATA4,
        output  right2middle_RDATA5,
        output  right2middle_RDATA6,
        output  right2middle_RDATA7,
        output  right2middle_RDATA8,
        output  right2middle_RDATA9,
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
wire[8-1:0] right2middle_RDATA0_input;
wire[8-1:0] right2middle_RDATA1_input;
wire[8-1:0] right2middle_RDATA2_input;
wire[8-1:0] right2middle_RDATA3_input;
wire[8-1:0] right2middle_RDATA4_input;
wire[8-1:0] right2middle_RDATA5_input;
wire[8-1:0] right2middle_RDATA6_input;
wire[8-1:0] right2middle_RDATA7_input;
wire[8-1:0] right2middle_RDATA8_input;
wire[8-1:0] right2middle_RDATA9_input;
 //The configuration bits (if any) are just a long shift register
 //This shift register is padded to an even number of flops/latches
 //switch matrix multiplexer N1BEG0 MUX-2
assign N1BEG0_input = {middle2right_WDATA9,S1END3};
cus_mux21 inst_cus_mux21_N1BEG0 (
    .A0(N1BEG0_input[0]),
    .A1(N1BEG0_input[1]),
    .S(ConfigBits[0+0]),
    .X(N1BEG0)
);

 //switch matrix multiplexer N1BEG1 MUX-2
assign N1BEG1_input = {middle2right_WDATA8,S1END2};
cus_mux21 inst_cus_mux21_N1BEG1 (
    .A0(N1BEG1_input[0]),
    .A1(N1BEG1_input[1]),
    .S(ConfigBits[1+0]),
    .X(N1BEG1)
);

 //switch matrix multiplexer N1BEG2 MUX-2
assign N1BEG2_input = {middle2right_ADDR9,S1END1};
cus_mux21 inst_cus_mux21_N1BEG2 (
    .A0(N1BEG2_input[0]),
    .A1(N1BEG2_input[1]),
    .S(ConfigBits[2+0]),
    .X(N1BEG2)
);

 //switch matrix multiplexer N1BEG3 MUX-2
assign N1BEG3_input = {middle2right_ADDR8,S1END0};
cus_mux21 inst_cus_mux21_N1BEG3 (
    .A0(N1BEG3_input[0]),
    .A1(N1BEG3_input[1]),
    .S(ConfigBits[3+0]),
    .X(N1BEG3)
);

 //switch matrix multiplexer N2BEG0 MUX-2
assign N2BEG0_input = {middle2right_WDATA7,S2MID7};
cus_mux21 inst_cus_mux21_N2BEG0 (
    .A0(N2BEG0_input[0]),
    .A1(N2BEG0_input[1]),
    .S(ConfigBits[4+0]),
    .X(N2BEG0)
);

 //switch matrix multiplexer N2BEG1 MUX-2
assign N2BEG1_input = {middle2right_WDATA6,S2MID6};
cus_mux21 inst_cus_mux21_N2BEG1 (
    .A0(N2BEG1_input[0]),
    .A1(N2BEG1_input[1]),
    .S(ConfigBits[5+0]),
    .X(N2BEG1)
);

 //switch matrix multiplexer N2BEG2 MUX-2
assign N2BEG2_input = {middle2right_WDATA5,S2MID5};
cus_mux21 inst_cus_mux21_N2BEG2 (
    .A0(N2BEG2_input[0]),
    .A1(N2BEG2_input[1]),
    .S(ConfigBits[6+0]),
    .X(N2BEG2)
);

 //switch matrix multiplexer N2BEG3 MUX-2
assign N2BEG3_input = {middle2right_WDATA4,S2MID4};
cus_mux21 inst_cus_mux21_N2BEG3 (
    .A0(N2BEG3_input[0]),
    .A1(N2BEG3_input[1]),
    .S(ConfigBits[7+0]),
    .X(N2BEG3)
);

 //switch matrix multiplexer N2BEG4 MUX-2
assign N2BEG4_input = {middle2right_WDATA3,S2MID3};
cus_mux21 inst_cus_mux21_N2BEG4 (
    .A0(N2BEG4_input[0]),
    .A1(N2BEG4_input[1]),
    .S(ConfigBits[8+0]),
    .X(N2BEG4)
);

 //switch matrix multiplexer N2BEG5 MUX-2
assign N2BEG5_input = {middle2right_WDATA2,S2MID2};
cus_mux21 inst_cus_mux21_N2BEG5 (
    .A0(N2BEG5_input[0]),
    .A1(N2BEG5_input[1]),
    .S(ConfigBits[9+0]),
    .X(N2BEG5)
);

 //switch matrix multiplexer N2BEG6 MUX-2
assign N2BEG6_input = {middle2right_WDATA1,S2MID1};
cus_mux21 inst_cus_mux21_N2BEG6 (
    .A0(N2BEG6_input[0]),
    .A1(N2BEG6_input[1]),
    .S(ConfigBits[10+0]),
    .X(N2BEG6)
);

 //switch matrix multiplexer N2BEG7 MUX-2
assign N2BEG7_input = {middle2right_WDATA0,S2MID0};
cus_mux21 inst_cus_mux21_N2BEG7 (
    .A0(N2BEG7_input[0]),
    .A1(N2BEG7_input[1]),
    .S(ConfigBits[11+0]),
    .X(N2BEG7)
);

 //switch matrix multiplexer N2BEGb0 MUX-2
assign N2BEGb0_input = {middle2right_ADDR7,S2END7};
cus_mux21 inst_cus_mux21_N2BEGb0 (
    .A0(N2BEGb0_input[0]),
    .A1(N2BEGb0_input[1]),
    .S(ConfigBits[12+0]),
    .X(N2BEGb0)
);

 //switch matrix multiplexer N2BEGb1 MUX-2
assign N2BEGb1_input = {middle2right_ADDR6,S2END6};
cus_mux21 inst_cus_mux21_N2BEGb1 (
    .A0(N2BEGb1_input[0]),
    .A1(N2BEGb1_input[1]),
    .S(ConfigBits[13+0]),
    .X(N2BEGb1)
);

 //switch matrix multiplexer N2BEGb2 MUX-2
assign N2BEGb2_input = {middle2right_ADDR5,S2END5};
cus_mux21 inst_cus_mux21_N2BEGb2 (
    .A0(N2BEGb2_input[0]),
    .A1(N2BEGb2_input[1]),
    .S(ConfigBits[14+0]),
    .X(N2BEGb2)
);

 //switch matrix multiplexer N2BEGb3 MUX-2
assign N2BEGb3_input = {middle2right_ADDR4,S2END4};
cus_mux21 inst_cus_mux21_N2BEGb3 (
    .A0(N2BEGb3_input[0]),
    .A1(N2BEGb3_input[1]),
    .S(ConfigBits[15+0]),
    .X(N2BEGb3)
);

 //switch matrix multiplexer N2BEGb4 MUX-2
assign N2BEGb4_input = {middle2right_ADDR3,S2END3};
cus_mux21 inst_cus_mux21_N2BEGb4 (
    .A0(N2BEGb4_input[0]),
    .A1(N2BEGb4_input[1]),
    .S(ConfigBits[16+0]),
    .X(N2BEGb4)
);

 //switch matrix multiplexer N2BEGb5 MUX-2
assign N2BEGb5_input = {middle2right_ADDR2,S2END2};
cus_mux21 inst_cus_mux21_N2BEGb5 (
    .A0(N2BEGb5_input[0]),
    .A1(N2BEGb5_input[1]),
    .S(ConfigBits[17+0]),
    .X(N2BEGb5)
);

 //switch matrix multiplexer N2BEGb6 MUX-2
assign N2BEGb6_input = {middle2right_ADDR1,S2END1};
cus_mux21 inst_cus_mux21_N2BEGb6 (
    .A0(N2BEGb6_input[0]),
    .A1(N2BEGb6_input[1]),
    .S(ConfigBits[18+0]),
    .X(N2BEGb6)
);

 //switch matrix multiplexer N2BEGb7 MUX-2
assign N2BEGb7_input = {middle2right_ADDR0,S2END0};
cus_mux21 inst_cus_mux21_N2BEGb7 (
    .A0(N2BEGb7_input[0]),
    .A1(N2BEGb7_input[1]),
    .S(ConfigBits[19+0]),
    .X(N2BEGb7)
);

 //switch matrix multiplexer N4BEG0 MUX-2
assign N4BEG0_input = {middle2right_WDATA9,S4END15};
cus_mux21 inst_cus_mux21_N4BEG0 (
    .A0(N4BEG0_input[0]),
    .A1(N4BEG0_input[1]),
    .S(ConfigBits[20+0]),
    .X(N4BEG0)
);

 //switch matrix multiplexer N4BEG1 MUX-2
assign N4BEG1_input = {middle2right_WDATA8,S4END14};
cus_mux21 inst_cus_mux21_N4BEG1 (
    .A0(N4BEG1_input[0]),
    .A1(N4BEG1_input[1]),
    .S(ConfigBits[21+0]),
    .X(N4BEG1)
);

 //switch matrix multiplexer N4BEG2 MUX-2
assign N4BEG2_input = {middle2right_WDATA7,S4END13};
cus_mux21 inst_cus_mux21_N4BEG2 (
    .A0(N4BEG2_input[0]),
    .A1(N4BEG2_input[1]),
    .S(ConfigBits[22+0]),
    .X(N4BEG2)
);

 //switch matrix multiplexer N4BEG3 MUX-2
assign N4BEG3_input = {middle2right_WDATA6,S4END12};
cus_mux21 inst_cus_mux21_N4BEG3 (
    .A0(N4BEG3_input[0]),
    .A1(N4BEG3_input[1]),
    .S(ConfigBits[23+0]),
    .X(N4BEG3)
);

 //switch matrix multiplexer N4BEG4 MUX-2
assign N4BEG4_input = {middle2right_WDATA5,S4END11};
cus_mux21 inst_cus_mux21_N4BEG4 (
    .A0(N4BEG4_input[0]),
    .A1(N4BEG4_input[1]),
    .S(ConfigBits[24+0]),
    .X(N4BEG4)
);

 //switch matrix multiplexer N4BEG5 MUX-2
assign N4BEG5_input = {middle2right_WDATA4,S4END10};
cus_mux21 inst_cus_mux21_N4BEG5 (
    .A0(N4BEG5_input[0]),
    .A1(N4BEG5_input[1]),
    .S(ConfigBits[25+0]),
    .X(N4BEG5)
);

 //switch matrix multiplexer N4BEG6 MUX-2
assign N4BEG6_input = {middle2right_WDATA3,S4END9};
cus_mux21 inst_cus_mux21_N4BEG6 (
    .A0(N4BEG6_input[0]),
    .A1(N4BEG6_input[1]),
    .S(ConfigBits[26+0]),
    .X(N4BEG6)
);

 //switch matrix multiplexer N4BEG7 MUX-2
assign N4BEG7_input = {middle2right_WDATA2,S4END8};
cus_mux21 inst_cus_mux21_N4BEG7 (
    .A0(N4BEG7_input[0]),
    .A1(N4BEG7_input[1]),
    .S(ConfigBits[27+0]),
    .X(N4BEG7)
);

 //switch matrix multiplexer N4BEG8 MUX-2
assign N4BEG8_input = {middle2right_WDATA1,S4END7};
cus_mux21 inst_cus_mux21_N4BEG8 (
    .A0(N4BEG8_input[0]),
    .A1(N4BEG8_input[1]),
    .S(ConfigBits[28+0]),
    .X(N4BEG8)
);

 //switch matrix multiplexer N4BEG9 MUX-2
assign N4BEG9_input = {middle2right_WDATA0,S4END6};
cus_mux21 inst_cus_mux21_N4BEG9 (
    .A0(N4BEG9_input[0]),
    .A1(N4BEG9_input[1]),
    .S(ConfigBits[29+0]),
    .X(N4BEG9)
);

 //switch matrix multiplexer N4BEG10 MUX-1
assign N4BEG10 = S4END5;

 //switch matrix multiplexer N4BEG11 MUX-1
assign N4BEG11 = S4END4;

 //switch matrix multiplexer N4BEG12 MUX-1
assign N4BEG12 = S4END3;

 //switch matrix multiplexer N4BEG13 MUX-1
assign N4BEG13 = S4END2;

 //switch matrix multiplexer N4BEG14 MUX-1
assign N4BEG14 = S4END1;

 //switch matrix multiplexer N4BEG15 MUX-1
assign N4BEG15 = S4END0;

 //switch matrix multiplexer NN4BEG0 MUX-2
assign NN4BEG0_input = {middle2right_ADDR9,SS4END15};
cus_mux21 inst_cus_mux21_NN4BEG0 (
    .A0(NN4BEG0_input[0]),
    .A1(NN4BEG0_input[1]),
    .S(ConfigBits[30+0]),
    .X(NN4BEG0)
);

 //switch matrix multiplexer NN4BEG1 MUX-2
assign NN4BEG1_input = {middle2right_ADDR8,SS4END14};
cus_mux21 inst_cus_mux21_NN4BEG1 (
    .A0(NN4BEG1_input[0]),
    .A1(NN4BEG1_input[1]),
    .S(ConfigBits[31+0]),
    .X(NN4BEG1)
);

 //switch matrix multiplexer NN4BEG2 MUX-2
assign NN4BEG2_input = {middle2right_ADDR7,SS4END13};
cus_mux21 inst_cus_mux21_NN4BEG2 (
    .A0(NN4BEG2_input[0]),
    .A1(NN4BEG2_input[1]),
    .S(ConfigBits[32+0]),
    .X(NN4BEG2)
);

 //switch matrix multiplexer NN4BEG3 MUX-2
assign NN4BEG3_input = {middle2right_ADDR6,SS4END12};
cus_mux21 inst_cus_mux21_NN4BEG3 (
    .A0(NN4BEG3_input[0]),
    .A1(NN4BEG3_input[1]),
    .S(ConfigBits[33+0]),
    .X(NN4BEG3)
);

 //switch matrix multiplexer NN4BEG4 MUX-2
assign NN4BEG4_input = {middle2right_ADDR5,SS4END11};
cus_mux21 inst_cus_mux21_NN4BEG4 (
    .A0(NN4BEG4_input[0]),
    .A1(NN4BEG4_input[1]),
    .S(ConfigBits[34+0]),
    .X(NN4BEG4)
);

 //switch matrix multiplexer NN4BEG5 MUX-2
assign NN4BEG5_input = {middle2right_ADDR4,SS4END10};
cus_mux21 inst_cus_mux21_NN4BEG5 (
    .A0(NN4BEG5_input[0]),
    .A1(NN4BEG5_input[1]),
    .S(ConfigBits[35+0]),
    .X(NN4BEG5)
);

 //switch matrix multiplexer NN4BEG6 MUX-2
assign NN4BEG6_input = {middle2right_ADDR3,SS4END9};
cus_mux21 inst_cus_mux21_NN4BEG6 (
    .A0(NN4BEG6_input[0]),
    .A1(NN4BEG6_input[1]),
    .S(ConfigBits[36+0]),
    .X(NN4BEG6)
);

 //switch matrix multiplexer NN4BEG7 MUX-2
assign NN4BEG7_input = {middle2right_ADDR2,SS4END8};
cus_mux21 inst_cus_mux21_NN4BEG7 (
    .A0(NN4BEG7_input[0]),
    .A1(NN4BEG7_input[1]),
    .S(ConfigBits[37+0]),
    .X(NN4BEG7)
);

 //switch matrix multiplexer NN4BEG8 MUX-2
assign NN4BEG8_input = {middle2right_ADDR1,SS4END7};
cus_mux21 inst_cus_mux21_NN4BEG8 (
    .A0(NN4BEG8_input[0]),
    .A1(NN4BEG8_input[1]),
    .S(ConfigBits[38+0]),
    .X(NN4BEG8)
);

 //switch matrix multiplexer NN4BEG9 MUX-2
assign NN4BEG9_input = {middle2right_ADDR0,SS4END6};
cus_mux21 inst_cus_mux21_NN4BEG9 (
    .A0(NN4BEG9_input[0]),
    .A1(NN4BEG9_input[1]),
    .S(ConfigBits[39+0]),
    .X(NN4BEG9)
);

 //switch matrix multiplexer NN4BEG10 MUX-1
assign NN4BEG10 = SS4END5;

 //switch matrix multiplexer NN4BEG11 MUX-1
assign NN4BEG11 = SS4END4;

 //switch matrix multiplexer NN4BEG12 MUX-1
assign NN4BEG12 = SS4END3;

 //switch matrix multiplexer NN4BEG13 MUX-1
assign NN4BEG13 = SS4END2;

 //switch matrix multiplexer NN4BEG14 MUX-1
assign NN4BEG14 = SS4END1;

 //switch matrix multiplexer NN4BEG15 MUX-1
assign NN4BEG15 = SS4END0;

 //switch matrix multiplexer Co0 MUX-1
assign Co0 = GND0;

 //switch matrix multiplexer right2middle_RDATA0 MUX-8
assign right2middle_RDATA0_input = {VCC0,GND0,SS4END6,SS4END0,S4END6,S4END0,S2END0,S2MID0};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA0 (
    .A0(right2middle_RDATA0_input[0]),
    .A1(right2middle_RDATA0_input[1]),
    .A2(right2middle_RDATA0_input[2]),
    .A3(right2middle_RDATA0_input[3]),
    .A4(right2middle_RDATA0_input[4]),
    .A5(right2middle_RDATA0_input[5]),
    .A6(right2middle_RDATA0_input[6]),
    .A7(right2middle_RDATA0_input[7]),
    .S0(ConfigBits[40+0]),
    .S0N(ConfigBits_N[40+0]),
    .S1(ConfigBits[40+1]),
    .S1N(ConfigBits_N[40+1]),
    .S2(ConfigBits[40+2]),
    .S2N(ConfigBits_N[40+2]),
    .X(right2middle_RDATA0)
);

 //switch matrix multiplexer right2middle_RDATA1 MUX-8
assign right2middle_RDATA1_input = {VCC0,GND0,SS4END7,SS4END1,S4END7,S4END1,S2END1,S2MID1};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA1 (
    .A0(right2middle_RDATA1_input[0]),
    .A1(right2middle_RDATA1_input[1]),
    .A2(right2middle_RDATA1_input[2]),
    .A3(right2middle_RDATA1_input[3]),
    .A4(right2middle_RDATA1_input[4]),
    .A5(right2middle_RDATA1_input[5]),
    .A6(right2middle_RDATA1_input[6]),
    .A7(right2middle_RDATA1_input[7]),
    .S0(ConfigBits[43+0]),
    .S0N(ConfigBits_N[43+0]),
    .S1(ConfigBits[43+1]),
    .S1N(ConfigBits_N[43+1]),
    .S2(ConfigBits[43+2]),
    .S2N(ConfigBits_N[43+2]),
    .X(right2middle_RDATA1)
);

 //switch matrix multiplexer right2middle_RDATA2 MUX-8
assign right2middle_RDATA2_input = {VCC0,GND0,SS4END8,SS4END2,S4END8,S4END2,S2END2,S2MID2};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA2 (
    .A0(right2middle_RDATA2_input[0]),
    .A1(right2middle_RDATA2_input[1]),
    .A2(right2middle_RDATA2_input[2]),
    .A3(right2middle_RDATA2_input[3]),
    .A4(right2middle_RDATA2_input[4]),
    .A5(right2middle_RDATA2_input[5]),
    .A6(right2middle_RDATA2_input[6]),
    .A7(right2middle_RDATA2_input[7]),
    .S0(ConfigBits[46+0]),
    .S0N(ConfigBits_N[46+0]),
    .S1(ConfigBits[46+1]),
    .S1N(ConfigBits_N[46+1]),
    .S2(ConfigBits[46+2]),
    .S2N(ConfigBits_N[46+2]),
    .X(right2middle_RDATA2)
);

 //switch matrix multiplexer right2middle_RDATA3 MUX-8
assign right2middle_RDATA3_input = {VCC0,GND0,SS4END9,SS4END3,S4END9,S4END3,S2END3,S2MID3};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA3 (
    .A0(right2middle_RDATA3_input[0]),
    .A1(right2middle_RDATA3_input[1]),
    .A2(right2middle_RDATA3_input[2]),
    .A3(right2middle_RDATA3_input[3]),
    .A4(right2middle_RDATA3_input[4]),
    .A5(right2middle_RDATA3_input[5]),
    .A6(right2middle_RDATA3_input[6]),
    .A7(right2middle_RDATA3_input[7]),
    .S0(ConfigBits[49+0]),
    .S0N(ConfigBits_N[49+0]),
    .S1(ConfigBits[49+1]),
    .S1N(ConfigBits_N[49+1]),
    .S2(ConfigBits[49+2]),
    .S2N(ConfigBits_N[49+2]),
    .X(right2middle_RDATA3)
);

 //switch matrix multiplexer right2middle_RDATA4 MUX-8
assign right2middle_RDATA4_input = {VCC0,GND0,SS4END10,SS4END4,S4END10,S4END4,S2END4,S2MID4};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA4 (
    .A0(right2middle_RDATA4_input[0]),
    .A1(right2middle_RDATA4_input[1]),
    .A2(right2middle_RDATA4_input[2]),
    .A3(right2middle_RDATA4_input[3]),
    .A4(right2middle_RDATA4_input[4]),
    .A5(right2middle_RDATA4_input[5]),
    .A6(right2middle_RDATA4_input[6]),
    .A7(right2middle_RDATA4_input[7]),
    .S0(ConfigBits[52+0]),
    .S0N(ConfigBits_N[52+0]),
    .S1(ConfigBits[52+1]),
    .S1N(ConfigBits_N[52+1]),
    .S2(ConfigBits[52+2]),
    .S2N(ConfigBits_N[52+2]),
    .X(right2middle_RDATA4)
);

 //switch matrix multiplexer right2middle_RDATA5 MUX-8
assign right2middle_RDATA5_input = {VCC0,GND0,SS4END11,SS4END5,S4END11,S4END5,S2END5,S2MID5};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA5 (
    .A0(right2middle_RDATA5_input[0]),
    .A1(right2middle_RDATA5_input[1]),
    .A2(right2middle_RDATA5_input[2]),
    .A3(right2middle_RDATA5_input[3]),
    .A4(right2middle_RDATA5_input[4]),
    .A5(right2middle_RDATA5_input[5]),
    .A6(right2middle_RDATA5_input[6]),
    .A7(right2middle_RDATA5_input[7]),
    .S0(ConfigBits[55+0]),
    .S0N(ConfigBits_N[55+0]),
    .S1(ConfigBits[55+1]),
    .S1N(ConfigBits_N[55+1]),
    .S2(ConfigBits[55+2]),
    .S2N(ConfigBits_N[55+2]),
    .X(right2middle_RDATA5)
);

 //switch matrix multiplexer right2middle_RDATA6 MUX-8
assign right2middle_RDATA6_input = {VCC0,GND0,SS4END12,SS4END6,S4END12,S4END6,S2END6,S2MID6};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA6 (
    .A0(right2middle_RDATA6_input[0]),
    .A1(right2middle_RDATA6_input[1]),
    .A2(right2middle_RDATA6_input[2]),
    .A3(right2middle_RDATA6_input[3]),
    .A4(right2middle_RDATA6_input[4]),
    .A5(right2middle_RDATA6_input[5]),
    .A6(right2middle_RDATA6_input[6]),
    .A7(right2middle_RDATA6_input[7]),
    .S0(ConfigBits[58+0]),
    .S0N(ConfigBits_N[58+0]),
    .S1(ConfigBits[58+1]),
    .S1N(ConfigBits_N[58+1]),
    .S2(ConfigBits[58+2]),
    .S2N(ConfigBits_N[58+2]),
    .X(right2middle_RDATA6)
);

 //switch matrix multiplexer right2middle_RDATA7 MUX-8
assign right2middle_RDATA7_input = {VCC0,GND0,SS4END13,SS4END7,S4END13,S4END7,S2END7,S2MID7};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA7 (
    .A0(right2middle_RDATA7_input[0]),
    .A1(right2middle_RDATA7_input[1]),
    .A2(right2middle_RDATA7_input[2]),
    .A3(right2middle_RDATA7_input[3]),
    .A4(right2middle_RDATA7_input[4]),
    .A5(right2middle_RDATA7_input[5]),
    .A6(right2middle_RDATA7_input[6]),
    .A7(right2middle_RDATA7_input[7]),
    .S0(ConfigBits[61+0]),
    .S0N(ConfigBits_N[61+0]),
    .S1(ConfigBits[61+1]),
    .S1N(ConfigBits_N[61+1]),
    .S2(ConfigBits[61+2]),
    .S2N(ConfigBits_N[61+2]),
    .X(right2middle_RDATA7)
);

 //switch matrix multiplexer right2middle_RDATA8 MUX-8
assign right2middle_RDATA8_input = {VCC0,GND0,SS4END14,SS4END8,S4END14,S4END8,S1END2,S1END0};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA8 (
    .A0(right2middle_RDATA8_input[0]),
    .A1(right2middle_RDATA8_input[1]),
    .A2(right2middle_RDATA8_input[2]),
    .A3(right2middle_RDATA8_input[3]),
    .A4(right2middle_RDATA8_input[4]),
    .A5(right2middle_RDATA8_input[5]),
    .A6(right2middle_RDATA8_input[6]),
    .A7(right2middle_RDATA8_input[7]),
    .S0(ConfigBits[64+0]),
    .S0N(ConfigBits_N[64+0]),
    .S1(ConfigBits[64+1]),
    .S1N(ConfigBits_N[64+1]),
    .S2(ConfigBits[64+2]),
    .S2N(ConfigBits_N[64+2]),
    .X(right2middle_RDATA8)
);

 //switch matrix multiplexer right2middle_RDATA9 MUX-8
assign right2middle_RDATA9_input = {VCC0,GND0,SS4END15,SS4END9,S4END15,S4END9,S1END3,S1END1};
cus_mux81_buf inst_cus_mux81_buf_right2middle_RDATA9 (
    .A0(right2middle_RDATA9_input[0]),
    .A1(right2middle_RDATA9_input[1]),
    .A2(right2middle_RDATA9_input[2]),
    .A3(right2middle_RDATA9_input[3]),
    .A4(right2middle_RDATA9_input[4]),
    .A5(right2middle_RDATA9_input[5]),
    .A6(right2middle_RDATA9_input[6]),
    .A7(right2middle_RDATA9_input[7]),
    .S0(ConfigBits[67+0]),
    .S0N(ConfigBits_N[67+0]),
    .S1(ConfigBits[67+1]),
    .S1N(ConfigBits_N[67+1]),
    .S2(ConfigBits[67+2]),
    .S2N(ConfigBits_N[67+2]),
    .X(right2middle_RDATA9)
);

endmodule
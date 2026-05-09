 // NumberOfConfigBits: 94
module S_OBI_middle_switch_matrix
    #(
        parameter NoConfigBits=94
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
        input  left2middle_RDATA0,
        input  left2middle_RDATA1,
        input  left2middle_RDATA2,
        input  left2middle_RDATA3,
        input  left2middle_RDATA4,
        input  left2middle_RDATA5,
        input  left2middle_RDATA6,
        input  left2middle_RDATA7,
        input  left2middle_RDATA8,
        input  left2middle_RDATA9,
        input  right2middle_RDATA0,
        input  right2middle_RDATA1,
        input  right2middle_RDATA2,
        input  right2middle_RDATA3,
        input  right2middle_RDATA4,
        input  right2middle_RDATA5,
        input  right2middle_RDATA6,
        input  right2middle_RDATA7,
        input  right2middle_RDATA8,
        input  right2middle_RDATA9,
        input  REQ,
        input  WE,
        input  BE0,
        input  BE1,
        input  BE2,
        input  BE3,
        input  ADDR0,
        input  ADDR1,
        input  ADDR2,
        input  ADDR3,
        input  ADDR4,
        input  ADDR5,
        input  ADDR6,
        input  ADDR7,
        input  ADDR8,
        input  ADDR9,
        input  ADDR10,
        input  ADDR11,
        input  ADDR12,
        input  ADDR13,
        input  ADDR14,
        input  ADDR15,
        input  ADDR16,
        input  ADDR17,
        input  ADDR18,
        input  ADDR19,
        input  ADDR20,
        input  ADDR21,
        input  ADDR22,
        input  ADDR23,
        input  WDATA0,
        input  WDATA1,
        input  WDATA2,
        input  WDATA3,
        input  WDATA4,
        input  WDATA5,
        input  WDATA6,
        input  WDATA7,
        input  WDATA8,
        input  WDATA9,
        input  WDATA10,
        input  WDATA11,
        input  WDATA12,
        input  WDATA13,
        input  WDATA14,
        input  WDATA15,
        input  WDATA16,
        input  WDATA17,
        input  WDATA18,
        input  WDATA19,
        input  WDATA20,
        input  WDATA21,
        input  WDATA22,
        input  WDATA23,
        input  WDATA24,
        input  WDATA25,
        input  WDATA26,
        input  WDATA27,
        input  WDATA28,
        input  WDATA29,
        input  WDATA30,
        input  WDATA31,
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
        output  middle2left_WDATA0,
        output  middle2left_WDATA1,
        output  middle2left_WDATA2,
        output  middle2left_WDATA3,
        output  middle2left_WDATA4,
        output  middle2left_WDATA5,
        output  middle2left_WDATA6,
        output  middle2left_WDATA7,
        output  middle2left_WDATA8,
        output  middle2left_WDATA9,
        output  middle2left_ADDR0,
        output  middle2left_ADDR1,
        output  middle2left_ADDR2,
        output  middle2left_ADDR3,
        output  middle2left_ADDR4,
        output  middle2left_ADDR5,
        output  middle2left_ADDR6,
        output  middle2left_ADDR7,
        output  middle2left_ADDR8,
        output  middle2left_ADDR9,
        output  middle2right_WDATA0,
        output  middle2right_WDATA1,
        output  middle2right_WDATA2,
        output  middle2right_WDATA3,
        output  middle2right_WDATA4,
        output  middle2right_WDATA5,
        output  middle2right_WDATA6,
        output  middle2right_WDATA7,
        output  middle2right_WDATA8,
        output  middle2right_WDATA9,
        output  middle2right_ADDR0,
        output  middle2right_ADDR1,
        output  middle2right_ADDR2,
        output  middle2right_ADDR3,
        output  middle2right_ADDR4,
        output  middle2right_ADDR5,
        output  middle2right_ADDR6,
        output  middle2right_ADDR7,
        output  middle2right_ADDR8,
        output  middle2right_ADDR9,
        output  GNT,
        output  RVALID,
        output  RDATA0,
        output  RDATA1,
        output  RDATA2,
        output  RDATA3,
        output  RDATA4,
        output  RDATA5,
        output  RDATA6,
        output  RDATA7,
        output  RDATA8,
        output  RDATA9,
        output  RDATA10,
        output  RDATA11,
        output  RDATA12,
        output  RDATA13,
        output  RDATA14,
        output  RDATA15,
        output  RDATA16,
        output  RDATA17,
        output  RDATA18,
        output  RDATA19,
        output  RDATA20,
        output  RDATA21,
        output  RDATA22,
        output  RDATA23,
        output  RDATA24,
        output  RDATA25,
        output  RDATA26,
        output  RDATA27,
        output  RDATA28,
        output  RDATA29,
        output  RDATA30,
        output  RDATA31,
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
wire[8-1:0] GNT_input;
wire[8-1:0] RVALID_input;
wire[4-1:0] RDATA20_input;
wire[4-1:0] RDATA21_input;
wire[4-1:0] RDATA22_input;
wire[4-1:0] RDATA23_input;
wire[4-1:0] RDATA24_input;
wire[4-1:0] RDATA25_input;
wire[4-1:0] RDATA26_input;
wire[4-1:0] RDATA27_input;
wire[4-1:0] RDATA28_input;
wire[4-1:0] RDATA29_input;
wire[4-1:0] RDATA30_input;
wire[4-1:0] RDATA31_input;
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

 //switch matrix multiplexer N1BEG0 MUX-4
assign N1BEG0_input = {BE3,WE,REQ,S1END3};
cus_mux41 inst_cus_mux41_N1BEG0 (
    .A0(N1BEG0_input[0]),
    .A1(N1BEG0_input[1]),
    .A2(N1BEG0_input[2]),
    .A3(N1BEG0_input[3]),
    .S0(ConfigBits[8+0]),
    .S0N(ConfigBits_N[8+0]),
    .S1(ConfigBits[8+1]),
    .S1N(ConfigBits_N[8+1]),
    .X(N1BEG0)
);

 //switch matrix multiplexer N1BEG1 MUX-4
assign N1BEG1_input = {BE2,WE,REQ,S1END2};
cus_mux41 inst_cus_mux41_N1BEG1 (
    .A0(N1BEG1_input[0]),
    .A1(N1BEG1_input[1]),
    .A2(N1BEG1_input[2]),
    .A3(N1BEG1_input[3]),
    .S0(ConfigBits[10+0]),
    .S0N(ConfigBits_N[10+0]),
    .S1(ConfigBits[10+1]),
    .S1N(ConfigBits_N[10+1]),
    .X(N1BEG1)
);

 //switch matrix multiplexer N1BEG2 MUX-4
assign N1BEG2_input = {BE1,WE,REQ,S1END1};
cus_mux41 inst_cus_mux41_N1BEG2 (
    .A0(N1BEG2_input[0]),
    .A1(N1BEG2_input[1]),
    .A2(N1BEG2_input[2]),
    .A3(N1BEG2_input[3]),
    .S0(ConfigBits[12+0]),
    .S0N(ConfigBits_N[12+0]),
    .S1(ConfigBits[12+1]),
    .S1N(ConfigBits_N[12+1]),
    .X(N1BEG2)
);

 //switch matrix multiplexer N1BEG3 MUX-4
assign N1BEG3_input = {BE0,WE,REQ,S1END0};
cus_mux41 inst_cus_mux41_N1BEG3 (
    .A0(N1BEG3_input[0]),
    .A1(N1BEG3_input[1]),
    .A2(N1BEG3_input[2]),
    .A3(N1BEG3_input[3]),
    .S0(ConfigBits[14+0]),
    .S0N(ConfigBits_N[14+0]),
    .S1(ConfigBits[14+1]),
    .S1N(ConfigBits_N[14+1]),
    .X(N1BEG3)
);

 //switch matrix multiplexer N2BEG0 MUX-2
assign N2BEG0_input = {BE0,S2MID7};
cus_mux21 inst_cus_mux21_N2BEG0 (
    .A0(N2BEG0_input[0]),
    .A1(N2BEG0_input[1]),
    .S(ConfigBits[16+0]),
    .X(N2BEG0)
);

 //switch matrix multiplexer N2BEG1 MUX-2
assign N2BEG1_input = {BE1,S2MID6};
cus_mux21 inst_cus_mux21_N2BEG1 (
    .A0(N2BEG1_input[0]),
    .A1(N2BEG1_input[1]),
    .S(ConfigBits[17+0]),
    .X(N2BEG1)
);

 //switch matrix multiplexer N2BEG2 MUX-2
assign N2BEG2_input = {BE2,S2MID5};
cus_mux21 inst_cus_mux21_N2BEG2 (
    .A0(N2BEG2_input[0]),
    .A1(N2BEG2_input[1]),
    .S(ConfigBits[18+0]),
    .X(N2BEG2)
);

 //switch matrix multiplexer N2BEG3 MUX-2
assign N2BEG3_input = {BE3,S2MID4};
cus_mux21 inst_cus_mux21_N2BEG3 (
    .A0(N2BEG3_input[0]),
    .A1(N2BEG3_input[1]),
    .S(ConfigBits[19+0]),
    .X(N2BEG3)
);

 //switch matrix multiplexer N2BEG4 MUX-2
assign N2BEG4_input = {BE0,S2MID3};
cus_mux21 inst_cus_mux21_N2BEG4 (
    .A0(N2BEG4_input[0]),
    .A1(N2BEG4_input[1]),
    .S(ConfigBits[20+0]),
    .X(N2BEG4)
);

 //switch matrix multiplexer N2BEG5 MUX-2
assign N2BEG5_input = {BE1,S2MID2};
cus_mux21 inst_cus_mux21_N2BEG5 (
    .A0(N2BEG5_input[0]),
    .A1(N2BEG5_input[1]),
    .S(ConfigBits[21+0]),
    .X(N2BEG5)
);

 //switch matrix multiplexer N2BEG6 MUX-2
assign N2BEG6_input = {BE2,S2MID1};
cus_mux21 inst_cus_mux21_N2BEG6 (
    .A0(N2BEG6_input[0]),
    .A1(N2BEG6_input[1]),
    .S(ConfigBits[22+0]),
    .X(N2BEG6)
);

 //switch matrix multiplexer N2BEG7 MUX-2
assign N2BEG7_input = {BE3,S2MID0};
cus_mux21 inst_cus_mux21_N2BEG7 (
    .A0(N2BEG7_input[0]),
    .A1(N2BEG7_input[1]),
    .S(ConfigBits[23+0]),
    .X(N2BEG7)
);

 //switch matrix multiplexer N2BEGb0 MUX-2
assign N2BEGb0_input = {ADDR23,S2END7};
cus_mux21 inst_cus_mux21_N2BEGb0 (
    .A0(N2BEGb0_input[0]),
    .A1(N2BEGb0_input[1]),
    .S(ConfigBits[24+0]),
    .X(N2BEGb0)
);

 //switch matrix multiplexer N2BEGb1 MUX-2
assign N2BEGb1_input = {ADDR22,S2END6};
cus_mux21 inst_cus_mux21_N2BEGb1 (
    .A0(N2BEGb1_input[0]),
    .A1(N2BEGb1_input[1]),
    .S(ConfigBits[25+0]),
    .X(N2BEGb1)
);

 //switch matrix multiplexer N2BEGb2 MUX-2
assign N2BEGb2_input = {ADDR21,S2END5};
cus_mux21 inst_cus_mux21_N2BEGb2 (
    .A0(N2BEGb2_input[0]),
    .A1(N2BEGb2_input[1]),
    .S(ConfigBits[26+0]),
    .X(N2BEGb2)
);

 //switch matrix multiplexer N2BEGb3 MUX-2
assign N2BEGb3_input = {ADDR20,S2END4};
cus_mux21 inst_cus_mux21_N2BEGb3 (
    .A0(N2BEGb3_input[0]),
    .A1(N2BEGb3_input[1]),
    .S(ConfigBits[27+0]),
    .X(N2BEGb3)
);

 //switch matrix multiplexer N2BEGb4 MUX-2
assign N2BEGb4_input = {ADDR23,S2END3};
cus_mux21 inst_cus_mux21_N2BEGb4 (
    .A0(N2BEGb4_input[0]),
    .A1(N2BEGb4_input[1]),
    .S(ConfigBits[28+0]),
    .X(N2BEGb4)
);

 //switch matrix multiplexer N2BEGb5 MUX-2
assign N2BEGb5_input = {ADDR22,S2END2};
cus_mux21 inst_cus_mux21_N2BEGb5 (
    .A0(N2BEGb5_input[0]),
    .A1(N2BEGb5_input[1]),
    .S(ConfigBits[29+0]),
    .X(N2BEGb5)
);

 //switch matrix multiplexer N2BEGb6 MUX-2
assign N2BEGb6_input = {ADDR21,S2END1};
cus_mux21 inst_cus_mux21_N2BEGb6 (
    .A0(N2BEGb6_input[0]),
    .A1(N2BEGb6_input[1]),
    .S(ConfigBits[30+0]),
    .X(N2BEGb6)
);

 //switch matrix multiplexer N2BEGb7 MUX-2
assign N2BEGb7_input = {ADDR20,S2END0};
cus_mux21 inst_cus_mux21_N2BEGb7 (
    .A0(N2BEGb7_input[0]),
    .A1(N2BEGb7_input[1]),
    .S(ConfigBits[31+0]),
    .X(N2BEGb7)
);

 //switch matrix multiplexer N4BEG0 MUX-2
assign N4BEG0_input = {ADDR23,S4END15};
cus_mux21 inst_cus_mux21_N4BEG0 (
    .A0(N4BEG0_input[0]),
    .A1(N4BEG0_input[1]),
    .S(ConfigBits[32+0]),
    .X(N4BEG0)
);

 //switch matrix multiplexer N4BEG1 MUX-2
assign N4BEG1_input = {ADDR22,S4END14};
cus_mux21 inst_cus_mux21_N4BEG1 (
    .A0(N4BEG1_input[0]),
    .A1(N4BEG1_input[1]),
    .S(ConfigBits[33+0]),
    .X(N4BEG1)
);

 //switch matrix multiplexer N4BEG2 MUX-2
assign N4BEG2_input = {ADDR21,S4END13};
cus_mux21 inst_cus_mux21_N4BEG2 (
    .A0(N4BEG2_input[0]),
    .A1(N4BEG2_input[1]),
    .S(ConfigBits[34+0]),
    .X(N4BEG2)
);

 //switch matrix multiplexer N4BEG3 MUX-2
assign N4BEG3_input = {ADDR20,S4END12};
cus_mux21 inst_cus_mux21_N4BEG3 (
    .A0(N4BEG3_input[0]),
    .A1(N4BEG3_input[1]),
    .S(ConfigBits[35+0]),
    .X(N4BEG3)
);

 //switch matrix multiplexer N4BEG4 MUX-2
assign N4BEG4_input = {WDATA31,S4END11};
cus_mux21 inst_cus_mux21_N4BEG4 (
    .A0(N4BEG4_input[0]),
    .A1(N4BEG4_input[1]),
    .S(ConfigBits[36+0]),
    .X(N4BEG4)
);

 //switch matrix multiplexer N4BEG5 MUX-2
assign N4BEG5_input = {WDATA30,S4END10};
cus_mux21 inst_cus_mux21_N4BEG5 (
    .A0(N4BEG5_input[0]),
    .A1(N4BEG5_input[1]),
    .S(ConfigBits[37+0]),
    .X(N4BEG5)
);

 //switch matrix multiplexer N4BEG6 MUX-2
assign N4BEG6_input = {WDATA29,S4END9};
cus_mux21 inst_cus_mux21_N4BEG6 (
    .A0(N4BEG6_input[0]),
    .A1(N4BEG6_input[1]),
    .S(ConfigBits[38+0]),
    .X(N4BEG6)
);

 //switch matrix multiplexer N4BEG7 MUX-2
assign N4BEG7_input = {WDATA28,S4END8};
cus_mux21 inst_cus_mux21_N4BEG7 (
    .A0(N4BEG7_input[0]),
    .A1(N4BEG7_input[1]),
    .S(ConfigBits[39+0]),
    .X(N4BEG7)
);

 //switch matrix multiplexer N4BEG8 MUX-2
assign N4BEG8_input = {WDATA27,S4END7};
cus_mux21 inst_cus_mux21_N4BEG8 (
    .A0(N4BEG8_input[0]),
    .A1(N4BEG8_input[1]),
    .S(ConfigBits[40+0]),
    .X(N4BEG8)
);

 //switch matrix multiplexer N4BEG9 MUX-2
assign N4BEG9_input = {WDATA26,S4END6};
cus_mux21 inst_cus_mux21_N4BEG9 (
    .A0(N4BEG9_input[0]),
    .A1(N4BEG9_input[1]),
    .S(ConfigBits[41+0]),
    .X(N4BEG9)
);

 //switch matrix multiplexer N4BEG10 MUX-2
assign N4BEG10_input = {WDATA25,S4END5};
cus_mux21 inst_cus_mux21_N4BEG10 (
    .A0(N4BEG10_input[0]),
    .A1(N4BEG10_input[1]),
    .S(ConfigBits[42+0]),
    .X(N4BEG10)
);

 //switch matrix multiplexer N4BEG11 MUX-2
assign N4BEG11_input = {WDATA24,S4END4};
cus_mux21 inst_cus_mux21_N4BEG11 (
    .A0(N4BEG11_input[0]),
    .A1(N4BEG11_input[1]),
    .S(ConfigBits[43+0]),
    .X(N4BEG11)
);

 //switch matrix multiplexer N4BEG12 MUX-2
assign N4BEG12_input = {WDATA23,S4END3};
cus_mux21 inst_cus_mux21_N4BEG12 (
    .A0(N4BEG12_input[0]),
    .A1(N4BEG12_input[1]),
    .S(ConfigBits[44+0]),
    .X(N4BEG12)
);

 //switch matrix multiplexer N4BEG13 MUX-2
assign N4BEG13_input = {WDATA22,S4END2};
cus_mux21 inst_cus_mux21_N4BEG13 (
    .A0(N4BEG13_input[0]),
    .A1(N4BEG13_input[1]),
    .S(ConfigBits[45+0]),
    .X(N4BEG13)
);

 //switch matrix multiplexer N4BEG14 MUX-2
assign N4BEG14_input = {WDATA21,S4END1};
cus_mux21 inst_cus_mux21_N4BEG14 (
    .A0(N4BEG14_input[0]),
    .A1(N4BEG14_input[1]),
    .S(ConfigBits[46+0]),
    .X(N4BEG14)
);

 //switch matrix multiplexer N4BEG15 MUX-2
assign N4BEG15_input = {WDATA20,S4END0};
cus_mux21 inst_cus_mux21_N4BEG15 (
    .A0(N4BEG15_input[0]),
    .A1(N4BEG15_input[1]),
    .S(ConfigBits[47+0]),
    .X(N4BEG15)
);

 //switch matrix multiplexer NN4BEG0 MUX-2
assign NN4BEG0_input = {ADDR23,SS4END15};
cus_mux21 inst_cus_mux21_NN4BEG0 (
    .A0(NN4BEG0_input[0]),
    .A1(NN4BEG0_input[1]),
    .S(ConfigBits[48+0]),
    .X(NN4BEG0)
);

 //switch matrix multiplexer NN4BEG1 MUX-2
assign NN4BEG1_input = {ADDR22,SS4END14};
cus_mux21 inst_cus_mux21_NN4BEG1 (
    .A0(NN4BEG1_input[0]),
    .A1(NN4BEG1_input[1]),
    .S(ConfigBits[49+0]),
    .X(NN4BEG1)
);

 //switch matrix multiplexer NN4BEG2 MUX-2
assign NN4BEG2_input = {ADDR21,SS4END13};
cus_mux21 inst_cus_mux21_NN4BEG2 (
    .A0(NN4BEG2_input[0]),
    .A1(NN4BEG2_input[1]),
    .S(ConfigBits[50+0]),
    .X(NN4BEG2)
);

 //switch matrix multiplexer NN4BEG3 MUX-2
assign NN4BEG3_input = {ADDR20,SS4END12};
cus_mux21 inst_cus_mux21_NN4BEG3 (
    .A0(NN4BEG3_input[0]),
    .A1(NN4BEG3_input[1]),
    .S(ConfigBits[51+0]),
    .X(NN4BEG3)
);

 //switch matrix multiplexer NN4BEG4 MUX-2
assign NN4BEG4_input = {WDATA31,SS4END11};
cus_mux21 inst_cus_mux21_NN4BEG4 (
    .A0(NN4BEG4_input[0]),
    .A1(NN4BEG4_input[1]),
    .S(ConfigBits[52+0]),
    .X(NN4BEG4)
);

 //switch matrix multiplexer NN4BEG5 MUX-2
assign NN4BEG5_input = {WDATA30,SS4END10};
cus_mux21 inst_cus_mux21_NN4BEG5 (
    .A0(NN4BEG5_input[0]),
    .A1(NN4BEG5_input[1]),
    .S(ConfigBits[53+0]),
    .X(NN4BEG5)
);

 //switch matrix multiplexer NN4BEG6 MUX-2
assign NN4BEG6_input = {WDATA29,SS4END9};
cus_mux21 inst_cus_mux21_NN4BEG6 (
    .A0(NN4BEG6_input[0]),
    .A1(NN4BEG6_input[1]),
    .S(ConfigBits[54+0]),
    .X(NN4BEG6)
);

 //switch matrix multiplexer NN4BEG7 MUX-2
assign NN4BEG7_input = {WDATA28,SS4END8};
cus_mux21 inst_cus_mux21_NN4BEG7 (
    .A0(NN4BEG7_input[0]),
    .A1(NN4BEG7_input[1]),
    .S(ConfigBits[55+0]),
    .X(NN4BEG7)
);

 //switch matrix multiplexer NN4BEG8 MUX-2
assign NN4BEG8_input = {WDATA27,SS4END7};
cus_mux21 inst_cus_mux21_NN4BEG8 (
    .A0(NN4BEG8_input[0]),
    .A1(NN4BEG8_input[1]),
    .S(ConfigBits[56+0]),
    .X(NN4BEG8)
);

 //switch matrix multiplexer NN4BEG9 MUX-2
assign NN4BEG9_input = {WDATA26,SS4END6};
cus_mux21 inst_cus_mux21_NN4BEG9 (
    .A0(NN4BEG9_input[0]),
    .A1(NN4BEG9_input[1]),
    .S(ConfigBits[57+0]),
    .X(NN4BEG9)
);

 //switch matrix multiplexer NN4BEG10 MUX-2
assign NN4BEG10_input = {WDATA25,SS4END5};
cus_mux21 inst_cus_mux21_NN4BEG10 (
    .A0(NN4BEG10_input[0]),
    .A1(NN4BEG10_input[1]),
    .S(ConfigBits[58+0]),
    .X(NN4BEG10)
);

 //switch matrix multiplexer NN4BEG11 MUX-2
assign NN4BEG11_input = {WDATA24,SS4END4};
cus_mux21 inst_cus_mux21_NN4BEG11 (
    .A0(NN4BEG11_input[0]),
    .A1(NN4BEG11_input[1]),
    .S(ConfigBits[59+0]),
    .X(NN4BEG11)
);

 //switch matrix multiplexer NN4BEG12 MUX-2
assign NN4BEG12_input = {WDATA23,SS4END3};
cus_mux21 inst_cus_mux21_NN4BEG12 (
    .A0(NN4BEG12_input[0]),
    .A1(NN4BEG12_input[1]),
    .S(ConfigBits[60+0]),
    .X(NN4BEG12)
);

 //switch matrix multiplexer NN4BEG13 MUX-2
assign NN4BEG13_input = {WDATA22,SS4END2};
cus_mux21 inst_cus_mux21_NN4BEG13 (
    .A0(NN4BEG13_input[0]),
    .A1(NN4BEG13_input[1]),
    .S(ConfigBits[61+0]),
    .X(NN4BEG13)
);

 //switch matrix multiplexer NN4BEG14 MUX-2
assign NN4BEG14_input = {WDATA21,SS4END1};
cus_mux21 inst_cus_mux21_NN4BEG14 (
    .A0(NN4BEG14_input[0]),
    .A1(NN4BEG14_input[1]),
    .S(ConfigBits[62+0]),
    .X(NN4BEG14)
);

 //switch matrix multiplexer NN4BEG15 MUX-2
assign NN4BEG15_input = {WDATA20,SS4END0};
cus_mux21 inst_cus_mux21_NN4BEG15 (
    .A0(NN4BEG15_input[0]),
    .A1(NN4BEG15_input[1]),
    .S(ConfigBits[63+0]),
    .X(NN4BEG15)
);

 //switch matrix multiplexer Co0 MUX-1
assign Co0 = GND0;

 //switch matrix multiplexer middle2left_WDATA0 MUX-1
assign middle2left_WDATA0 = WDATA0;

 //switch matrix multiplexer middle2left_WDATA1 MUX-1
assign middle2left_WDATA1 = WDATA1;

 //switch matrix multiplexer middle2left_WDATA2 MUX-1
assign middle2left_WDATA2 = WDATA2;

 //switch matrix multiplexer middle2left_WDATA3 MUX-1
assign middle2left_WDATA3 = WDATA3;

 //switch matrix multiplexer middle2left_WDATA4 MUX-1
assign middle2left_WDATA4 = WDATA4;

 //switch matrix multiplexer middle2left_WDATA5 MUX-1
assign middle2left_WDATA5 = WDATA5;

 //switch matrix multiplexer middle2left_WDATA6 MUX-1
assign middle2left_WDATA6 = WDATA6;

 //switch matrix multiplexer middle2left_WDATA7 MUX-1
assign middle2left_WDATA7 = WDATA7;

 //switch matrix multiplexer middle2left_WDATA8 MUX-1
assign middle2left_WDATA8 = WDATA8;

 //switch matrix multiplexer middle2left_WDATA9 MUX-1
assign middle2left_WDATA9 = WDATA9;

 //switch matrix multiplexer middle2left_ADDR0 MUX-1
assign middle2left_ADDR0 = ADDR0;

 //switch matrix multiplexer middle2left_ADDR1 MUX-1
assign middle2left_ADDR1 = ADDR1;

 //switch matrix multiplexer middle2left_ADDR2 MUX-1
assign middle2left_ADDR2 = ADDR2;

 //switch matrix multiplexer middle2left_ADDR3 MUX-1
assign middle2left_ADDR3 = ADDR3;

 //switch matrix multiplexer middle2left_ADDR4 MUX-1
assign middle2left_ADDR4 = ADDR4;

 //switch matrix multiplexer middle2left_ADDR5 MUX-1
assign middle2left_ADDR5 = ADDR5;

 //switch matrix multiplexer middle2left_ADDR6 MUX-1
assign middle2left_ADDR6 = ADDR6;

 //switch matrix multiplexer middle2left_ADDR7 MUX-1
assign middle2left_ADDR7 = ADDR7;

 //switch matrix multiplexer middle2left_ADDR8 MUX-1
assign middle2left_ADDR8 = ADDR8;

 //switch matrix multiplexer middle2left_ADDR9 MUX-1
assign middle2left_ADDR9 = ADDR9;

 //switch matrix multiplexer middle2right_WDATA0 MUX-1
assign middle2right_WDATA0 = WDATA10;

 //switch matrix multiplexer middle2right_WDATA1 MUX-1
assign middle2right_WDATA1 = WDATA11;

 //switch matrix multiplexer middle2right_WDATA2 MUX-1
assign middle2right_WDATA2 = WDATA12;

 //switch matrix multiplexer middle2right_WDATA3 MUX-1
assign middle2right_WDATA3 = WDATA13;

 //switch matrix multiplexer middle2right_WDATA4 MUX-1
assign middle2right_WDATA4 = WDATA14;

 //switch matrix multiplexer middle2right_WDATA5 MUX-1
assign middle2right_WDATA5 = WDATA15;

 //switch matrix multiplexer middle2right_WDATA6 MUX-1
assign middle2right_WDATA6 = WDATA16;

 //switch matrix multiplexer middle2right_WDATA7 MUX-1
assign middle2right_WDATA7 = WDATA17;

 //switch matrix multiplexer middle2right_WDATA8 MUX-1
assign middle2right_WDATA8 = WDATA18;

 //switch matrix multiplexer middle2right_WDATA9 MUX-1
assign middle2right_WDATA9 = WDATA19;

 //switch matrix multiplexer middle2right_ADDR0 MUX-1
assign middle2right_ADDR0 = ADDR10;

 //switch matrix multiplexer middle2right_ADDR1 MUX-1
assign middle2right_ADDR1 = ADDR11;

 //switch matrix multiplexer middle2right_ADDR2 MUX-1
assign middle2right_ADDR2 = ADDR12;

 //switch matrix multiplexer middle2right_ADDR3 MUX-1
assign middle2right_ADDR3 = ADDR13;

 //switch matrix multiplexer middle2right_ADDR4 MUX-1
assign middle2right_ADDR4 = ADDR14;

 //switch matrix multiplexer middle2right_ADDR5 MUX-1
assign middle2right_ADDR5 = ADDR15;

 //switch matrix multiplexer middle2right_ADDR6 MUX-1
assign middle2right_ADDR6 = ADDR16;

 //switch matrix multiplexer middle2right_ADDR7 MUX-1
assign middle2right_ADDR7 = ADDR17;

 //switch matrix multiplexer middle2right_ADDR8 MUX-1
assign middle2right_ADDR8 = ADDR18;

 //switch matrix multiplexer middle2right_ADDR9 MUX-1
assign middle2right_ADDR9 = ADDR19;

 //switch matrix multiplexer GNT MUX-8
assign GNT_input = {VCC0,GND0,S2MID1,S2MID0,S1END3,S1END2,S1END1,S1END0};
cus_mux81 inst_cus_mux81_GNT (
    .A0(GNT_input[0]),
    .A1(GNT_input[1]),
    .A2(GNT_input[2]),
    .A3(GNT_input[3]),
    .A4(GNT_input[4]),
    .A5(GNT_input[5]),
    .A6(GNT_input[6]),
    .A7(GNT_input[7]),
    .S0(ConfigBits[64+0]),
    .S0N(ConfigBits_N[64+0]),
    .S1(ConfigBits[64+1]),
    .S1N(ConfigBits_N[64+1]),
    .S2(ConfigBits[64+2]),
    .S2N(ConfigBits_N[64+2]),
    .X(GNT)
);

 //switch matrix multiplexer RVALID MUX-8
assign RVALID_input = {VCC0,GND0,S2MID3,S2MID2,S1END3,S1END2,S1END1,S1END0};
cus_mux81 inst_cus_mux81_RVALID (
    .A0(RVALID_input[0]),
    .A1(RVALID_input[1]),
    .A2(RVALID_input[2]),
    .A3(RVALID_input[3]),
    .A4(RVALID_input[4]),
    .A5(RVALID_input[5]),
    .A6(RVALID_input[6]),
    .A7(RVALID_input[7]),
    .S0(ConfigBits[67+0]),
    .S0N(ConfigBits_N[67+0]),
    .S1(ConfigBits[67+1]),
    .S1N(ConfigBits_N[67+1]),
    .S2(ConfigBits[67+2]),
    .S2N(ConfigBits_N[67+2]),
    .X(RVALID)
);

 //switch matrix multiplexer RDATA0 MUX-1
assign RDATA0 = left2middle_RDATA0;

 //switch matrix multiplexer RDATA1 MUX-1
assign RDATA1 = left2middle_RDATA1;

 //switch matrix multiplexer RDATA2 MUX-1
assign RDATA2 = left2middle_RDATA2;

 //switch matrix multiplexer RDATA3 MUX-1
assign RDATA3 = left2middle_RDATA3;

 //switch matrix multiplexer RDATA4 MUX-1
assign RDATA4 = left2middle_RDATA4;

 //switch matrix multiplexer RDATA5 MUX-1
assign RDATA5 = left2middle_RDATA5;

 //switch matrix multiplexer RDATA6 MUX-1
assign RDATA6 = left2middle_RDATA6;

 //switch matrix multiplexer RDATA7 MUX-1
assign RDATA7 = left2middle_RDATA7;

 //switch matrix multiplexer RDATA8 MUX-1
assign RDATA8 = left2middle_RDATA8;

 //switch matrix multiplexer RDATA9 MUX-1
assign RDATA9 = left2middle_RDATA9;

 //switch matrix multiplexer RDATA10 MUX-1
assign RDATA10 = right2middle_RDATA0;

 //switch matrix multiplexer RDATA11 MUX-1
assign RDATA11 = right2middle_RDATA1;

 //switch matrix multiplexer RDATA12 MUX-1
assign RDATA12 = right2middle_RDATA2;

 //switch matrix multiplexer RDATA13 MUX-1
assign RDATA13 = right2middle_RDATA3;

 //switch matrix multiplexer RDATA14 MUX-1
assign RDATA14 = right2middle_RDATA4;

 //switch matrix multiplexer RDATA15 MUX-1
assign RDATA15 = right2middle_RDATA5;

 //switch matrix multiplexer RDATA16 MUX-1
assign RDATA16 = right2middle_RDATA6;

 //switch matrix multiplexer RDATA17 MUX-1
assign RDATA17 = right2middle_RDATA7;

 //switch matrix multiplexer RDATA18 MUX-1
assign RDATA18 = right2middle_RDATA8;

 //switch matrix multiplexer RDATA19 MUX-1
assign RDATA19 = right2middle_RDATA9;

 //switch matrix multiplexer RDATA20 MUX-4
assign RDATA20_input = {VCC0,GND0,SS4END0,S4END0};
cus_mux41 inst_cus_mux41_RDATA20 (
    .A0(RDATA20_input[0]),
    .A1(RDATA20_input[1]),
    .A2(RDATA20_input[2]),
    .A3(RDATA20_input[3]),
    .S0(ConfigBits[70+0]),
    .S0N(ConfigBits_N[70+0]),
    .S1(ConfigBits[70+1]),
    .S1N(ConfigBits_N[70+1]),
    .X(RDATA20)
);

 //switch matrix multiplexer RDATA21 MUX-4
assign RDATA21_input = {VCC0,GND0,SS4END1,S4END1};
cus_mux41 inst_cus_mux41_RDATA21 (
    .A0(RDATA21_input[0]),
    .A1(RDATA21_input[1]),
    .A2(RDATA21_input[2]),
    .A3(RDATA21_input[3]),
    .S0(ConfigBits[72+0]),
    .S0N(ConfigBits_N[72+0]),
    .S1(ConfigBits[72+1]),
    .S1N(ConfigBits_N[72+1]),
    .X(RDATA21)
);

 //switch matrix multiplexer RDATA22 MUX-4
assign RDATA22_input = {VCC0,GND0,SS4END2,S4END2};
cus_mux41 inst_cus_mux41_RDATA22 (
    .A0(RDATA22_input[0]),
    .A1(RDATA22_input[1]),
    .A2(RDATA22_input[2]),
    .A3(RDATA22_input[3]),
    .S0(ConfigBits[74+0]),
    .S0N(ConfigBits_N[74+0]),
    .S1(ConfigBits[74+1]),
    .S1N(ConfigBits_N[74+1]),
    .X(RDATA22)
);

 //switch matrix multiplexer RDATA23 MUX-4
assign RDATA23_input = {VCC0,GND0,SS4END3,S4END3};
cus_mux41 inst_cus_mux41_RDATA23 (
    .A0(RDATA23_input[0]),
    .A1(RDATA23_input[1]),
    .A2(RDATA23_input[2]),
    .A3(RDATA23_input[3]),
    .S0(ConfigBits[76+0]),
    .S0N(ConfigBits_N[76+0]),
    .S1(ConfigBits[76+1]),
    .S1N(ConfigBits_N[76+1]),
    .X(RDATA23)
);

 //switch matrix multiplexer RDATA24 MUX-4
assign RDATA24_input = {VCC0,GND0,SS4END4,S4END4};
cus_mux41 inst_cus_mux41_RDATA24 (
    .A0(RDATA24_input[0]),
    .A1(RDATA24_input[1]),
    .A2(RDATA24_input[2]),
    .A3(RDATA24_input[3]),
    .S0(ConfigBits[78+0]),
    .S0N(ConfigBits_N[78+0]),
    .S1(ConfigBits[78+1]),
    .S1N(ConfigBits_N[78+1]),
    .X(RDATA24)
);

 //switch matrix multiplexer RDATA25 MUX-4
assign RDATA25_input = {VCC0,GND0,SS4END5,S4END5};
cus_mux41 inst_cus_mux41_RDATA25 (
    .A0(RDATA25_input[0]),
    .A1(RDATA25_input[1]),
    .A2(RDATA25_input[2]),
    .A3(RDATA25_input[3]),
    .S0(ConfigBits[80+0]),
    .S0N(ConfigBits_N[80+0]),
    .S1(ConfigBits[80+1]),
    .S1N(ConfigBits_N[80+1]),
    .X(RDATA25)
);

 //switch matrix multiplexer RDATA26 MUX-4
assign RDATA26_input = {VCC0,GND0,SS4END6,S4END6};
cus_mux41 inst_cus_mux41_RDATA26 (
    .A0(RDATA26_input[0]),
    .A1(RDATA26_input[1]),
    .A2(RDATA26_input[2]),
    .A3(RDATA26_input[3]),
    .S0(ConfigBits[82+0]),
    .S0N(ConfigBits_N[82+0]),
    .S1(ConfigBits[82+1]),
    .S1N(ConfigBits_N[82+1]),
    .X(RDATA26)
);

 //switch matrix multiplexer RDATA27 MUX-4
assign RDATA27_input = {VCC0,GND0,SS4END7,S4END7};
cus_mux41 inst_cus_mux41_RDATA27 (
    .A0(RDATA27_input[0]),
    .A1(RDATA27_input[1]),
    .A2(RDATA27_input[2]),
    .A3(RDATA27_input[3]),
    .S0(ConfigBits[84+0]),
    .S0N(ConfigBits_N[84+0]),
    .S1(ConfigBits[84+1]),
    .S1N(ConfigBits_N[84+1]),
    .X(RDATA27)
);

 //switch matrix multiplexer RDATA28 MUX-4
assign RDATA28_input = {VCC0,GND0,SS4END8,S4END8};
cus_mux41 inst_cus_mux41_RDATA28 (
    .A0(RDATA28_input[0]),
    .A1(RDATA28_input[1]),
    .A2(RDATA28_input[2]),
    .A3(RDATA28_input[3]),
    .S0(ConfigBits[86+0]),
    .S0N(ConfigBits_N[86+0]),
    .S1(ConfigBits[86+1]),
    .S1N(ConfigBits_N[86+1]),
    .X(RDATA28)
);

 //switch matrix multiplexer RDATA29 MUX-4
assign RDATA29_input = {VCC0,GND0,SS4END9,S4END9};
cus_mux41 inst_cus_mux41_RDATA29 (
    .A0(RDATA29_input[0]),
    .A1(RDATA29_input[1]),
    .A2(RDATA29_input[2]),
    .A3(RDATA29_input[3]),
    .S0(ConfigBits[88+0]),
    .S0N(ConfigBits_N[88+0]),
    .S1(ConfigBits[88+1]),
    .S1N(ConfigBits_N[88+1]),
    .X(RDATA29)
);

 //switch matrix multiplexer RDATA30 MUX-4
assign RDATA30_input = {VCC0,GND0,SS4END10,S4END10};
cus_mux41 inst_cus_mux41_RDATA30 (
    .A0(RDATA30_input[0]),
    .A1(RDATA30_input[1]),
    .A2(RDATA30_input[2]),
    .A3(RDATA30_input[3]),
    .S0(ConfigBits[90+0]),
    .S0N(ConfigBits_N[90+0]),
    .S1(ConfigBits[90+1]),
    .S1N(ConfigBits_N[90+1]),
    .X(RDATA30)
);

 //switch matrix multiplexer RDATA31 MUX-4
assign RDATA31_input = {VCC0,GND0,SS4END11,S4END11};
cus_mux41 inst_cus_mux41_RDATA31 (
    .A0(RDATA31_input[0]),
    .A1(RDATA31_input[1]),
    .A2(RDATA31_input[2]),
    .A3(RDATA31_input[3]),
    .S0(ConfigBits[92+0]),
    .S0N(ConfigBits_N[92+0]),
    .S1(ConfigBits[92+1]),
    .S1N(ConfigBits_N[92+1]),
    .X(RDATA31)
);

endmodule
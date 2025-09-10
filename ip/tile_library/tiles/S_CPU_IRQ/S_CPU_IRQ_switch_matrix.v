 // NumberOfConfigBits: 12
module S_CPU_IRQ_switch_matrix
    #(
        parameter NoConfigBits=12
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
        output  IRQ0,
        output  IRQ1,
        output  IRQ2,
        output  IRQ3,
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

wire[8-1:0] IRQ0_input;
wire[8-1:0] IRQ1_input;
wire[8-1:0] IRQ2_input;
wire[8-1:0] IRQ3_input;
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

 //switch matrix multiplexer N4BEG0 MUX-1
assign N4BEG0 = S4END15;

 //switch matrix multiplexer N4BEG1 MUX-1
assign N4BEG1 = S4END14;

 //switch matrix multiplexer N4BEG2 MUX-1
assign N4BEG2 = S4END13;

 //switch matrix multiplexer N4BEG3 MUX-1
assign N4BEG3 = S4END12;

 //switch matrix multiplexer N4BEG4 MUX-1
assign N4BEG4 = S4END11;

 //switch matrix multiplexer N4BEG5 MUX-1
assign N4BEG5 = S4END10;

 //switch matrix multiplexer N4BEG6 MUX-1
assign N4BEG6 = S4END9;

 //switch matrix multiplexer N4BEG7 MUX-1
assign N4BEG7 = S4END8;

 //switch matrix multiplexer N4BEG8 MUX-1
assign N4BEG8 = S4END7;

 //switch matrix multiplexer N4BEG9 MUX-1
assign N4BEG9 = S4END6;

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

 //switch matrix multiplexer NN4BEG0 MUX-1
assign NN4BEG0 = SS4END15;

 //switch matrix multiplexer NN4BEG1 MUX-1
assign NN4BEG1 = SS4END14;

 //switch matrix multiplexer NN4BEG2 MUX-1
assign NN4BEG2 = SS4END13;

 //switch matrix multiplexer NN4BEG3 MUX-1
assign NN4BEG3 = SS4END12;

 //switch matrix multiplexer NN4BEG4 MUX-1
assign NN4BEG4 = SS4END11;

 //switch matrix multiplexer NN4BEG5 MUX-1
assign NN4BEG5 = SS4END10;

 //switch matrix multiplexer NN4BEG6 MUX-1
assign NN4BEG6 = SS4END9;

 //switch matrix multiplexer NN4BEG7 MUX-1
assign NN4BEG7 = SS4END8;

 //switch matrix multiplexer NN4BEG8 MUX-1
assign NN4BEG8 = SS4END7;

 //switch matrix multiplexer NN4BEG9 MUX-1
assign NN4BEG9 = SS4END6;

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

 //switch matrix multiplexer IRQ0 MUX-8
assign IRQ0_input = {SS4END4,SS4END0,S4END4,S4END0,S2END4,S2END0,S2MID0,S1END0};
cus_mux81_buf inst_cus_mux81_buf_IRQ0 (
    .A0(IRQ0_input[0]),
    .A1(IRQ0_input[1]),
    .A2(IRQ0_input[2]),
    .A3(IRQ0_input[3]),
    .A4(IRQ0_input[4]),
    .A5(IRQ0_input[5]),
    .A6(IRQ0_input[6]),
    .A7(IRQ0_input[7]),
    .S0(ConfigBits[0+0]),
    .S0N(ConfigBits_N[0+0]),
    .S1(ConfigBits[0+1]),
    .S1N(ConfigBits_N[0+1]),
    .S2(ConfigBits[0+2]),
    .S2N(ConfigBits_N[0+2]),
    .X(IRQ0)
);

 //switch matrix multiplexer IRQ1 MUX-8
assign IRQ1_input = {SS4END5,SS4END1,S4END5,S4END1,S2END5,S2END1,S2MID1,S1END1};
cus_mux81_buf inst_cus_mux81_buf_IRQ1 (
    .A0(IRQ1_input[0]),
    .A1(IRQ1_input[1]),
    .A2(IRQ1_input[2]),
    .A3(IRQ1_input[3]),
    .A4(IRQ1_input[4]),
    .A5(IRQ1_input[5]),
    .A6(IRQ1_input[6]),
    .A7(IRQ1_input[7]),
    .S0(ConfigBits[3+0]),
    .S0N(ConfigBits_N[3+0]),
    .S1(ConfigBits[3+1]),
    .S1N(ConfigBits_N[3+1]),
    .S2(ConfigBits[3+2]),
    .S2N(ConfigBits_N[3+2]),
    .X(IRQ1)
);

 //switch matrix multiplexer IRQ2 MUX-8
assign IRQ2_input = {SS4END6,SS4END2,S4END6,S4END2,S2END6,S2END2,S2MID2,S1END2};
cus_mux81_buf inst_cus_mux81_buf_IRQ2 (
    .A0(IRQ2_input[0]),
    .A1(IRQ2_input[1]),
    .A2(IRQ2_input[2]),
    .A3(IRQ2_input[3]),
    .A4(IRQ2_input[4]),
    .A5(IRQ2_input[5]),
    .A6(IRQ2_input[6]),
    .A7(IRQ2_input[7]),
    .S0(ConfigBits[6+0]),
    .S0N(ConfigBits_N[6+0]),
    .S1(ConfigBits[6+1]),
    .S1N(ConfigBits_N[6+1]),
    .S2(ConfigBits[6+2]),
    .S2N(ConfigBits_N[6+2]),
    .X(IRQ2)
);

 //switch matrix multiplexer IRQ3 MUX-8
assign IRQ3_input = {SS4END7,SS4END3,S4END7,S4END3,S2END7,S2END3,S2MID3,S1END3};
cus_mux81_buf inst_cus_mux81_buf_IRQ3 (
    .A0(IRQ3_input[0]),
    .A1(IRQ3_input[1]),
    .A2(IRQ3_input[2]),
    .A3(IRQ3_input[3]),
    .A4(IRQ3_input[4]),
    .A5(IRQ3_input[5]),
    .A6(IRQ3_input[6]),
    .A7(IRQ3_input[7]),
    .S0(ConfigBits[9+0]),
    .S0N(ConfigBits_N[9+0]),
    .S1(ConfigBits[9+1]),
    .S1N(ConfigBits_N[9+1]),
    .S2(ConfigBits[9+2]),
    .S2N(ConfigBits_N[9+2]),
    .X(IRQ3)
);

endmodule
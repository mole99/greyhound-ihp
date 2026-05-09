module S_OBI_middle_ConfigMem
    #(
`ifdef EMULATION
        parameter [639:0] Emulate_Bitstream=640'b0,
`endif
        parameter MaxFramesPerCol=20,
        parameter FrameBitsPerRow=32,
        parameter NoConfigBits=94
    )
    (
        input  [FrameBitsPerRow - 1:0] FrameData,
        input  [MaxFramesPerCol - 1:0] FrameStrobe,
        output  [NoConfigBits - 1:0] ConfigBits,
        output  [NoConfigBits - 1:0] ConfigBits_N
    );

`ifdef EMULATION
assign ConfigBits[93] = Emulate_Bitstream[31];
assign ConfigBits[92] = Emulate_Bitstream[30];
assign ConfigBits[91] = Emulate_Bitstream[29];
assign ConfigBits[90] = Emulate_Bitstream[28];
assign ConfigBits[89] = Emulate_Bitstream[27];
assign ConfigBits[88] = Emulate_Bitstream[26];
assign ConfigBits[87] = Emulate_Bitstream[25];
assign ConfigBits[86] = Emulate_Bitstream[24];
assign ConfigBits[85] = Emulate_Bitstream[23];
assign ConfigBits[84] = Emulate_Bitstream[22];
assign ConfigBits[83] = Emulate_Bitstream[21];
assign ConfigBits[82] = Emulate_Bitstream[20];
assign ConfigBits[81] = Emulate_Bitstream[19];
assign ConfigBits[80] = Emulate_Bitstream[18];
assign ConfigBits[79] = Emulate_Bitstream[17];
assign ConfigBits[78] = Emulate_Bitstream[16];
assign ConfigBits[77] = Emulate_Bitstream[15];
assign ConfigBits[76] = Emulate_Bitstream[14];
assign ConfigBits[75] = Emulate_Bitstream[13];
assign ConfigBits[74] = Emulate_Bitstream[12];
assign ConfigBits[73] = Emulate_Bitstream[11];
assign ConfigBits[72] = Emulate_Bitstream[10];
assign ConfigBits[71] = Emulate_Bitstream[9];
assign ConfigBits[70] = Emulate_Bitstream[8];
assign ConfigBits[69] = Emulate_Bitstream[7];
assign ConfigBits[68] = Emulate_Bitstream[6];
assign ConfigBits[67] = Emulate_Bitstream[5];
assign ConfigBits[66] = Emulate_Bitstream[4];
assign ConfigBits[65] = Emulate_Bitstream[3];
assign ConfigBits[64] = Emulate_Bitstream[2];
assign ConfigBits[63] = Emulate_Bitstream[1];
assign ConfigBits[62] = Emulate_Bitstream[0];
assign ConfigBits[61] = Emulate_Bitstream[63];
assign ConfigBits[60] = Emulate_Bitstream[62];
assign ConfigBits[59] = Emulate_Bitstream[61];
assign ConfigBits[58] = Emulate_Bitstream[60];
assign ConfigBits[57] = Emulate_Bitstream[59];
assign ConfigBits[56] = Emulate_Bitstream[58];
assign ConfigBits[55] = Emulate_Bitstream[57];
assign ConfigBits[54] = Emulate_Bitstream[56];
assign ConfigBits[53] = Emulate_Bitstream[55];
assign ConfigBits[52] = Emulate_Bitstream[54];
assign ConfigBits[51] = Emulate_Bitstream[53];
assign ConfigBits[50] = Emulate_Bitstream[52];
assign ConfigBits[49] = Emulate_Bitstream[51];
assign ConfigBits[48] = Emulate_Bitstream[50];
assign ConfigBits[47] = Emulate_Bitstream[49];
assign ConfigBits[46] = Emulate_Bitstream[48];
assign ConfigBits[45] = Emulate_Bitstream[47];
assign ConfigBits[44] = Emulate_Bitstream[46];
assign ConfigBits[43] = Emulate_Bitstream[45];
assign ConfigBits[42] = Emulate_Bitstream[44];
assign ConfigBits[41] = Emulate_Bitstream[43];
assign ConfigBits[40] = Emulate_Bitstream[42];
assign ConfigBits[39] = Emulate_Bitstream[41];
assign ConfigBits[38] = Emulate_Bitstream[40];
assign ConfigBits[37] = Emulate_Bitstream[39];
assign ConfigBits[36] = Emulate_Bitstream[38];
assign ConfigBits[35] = Emulate_Bitstream[37];
assign ConfigBits[34] = Emulate_Bitstream[36];
assign ConfigBits[33] = Emulate_Bitstream[35];
assign ConfigBits[32] = Emulate_Bitstream[34];
assign ConfigBits[31] = Emulate_Bitstream[33];
assign ConfigBits[30] = Emulate_Bitstream[32];
assign ConfigBits[29] = Emulate_Bitstream[95];
assign ConfigBits[28] = Emulate_Bitstream[94];
assign ConfigBits[27] = Emulate_Bitstream[93];
assign ConfigBits[26] = Emulate_Bitstream[92];
assign ConfigBits[25] = Emulate_Bitstream[91];
assign ConfigBits[24] = Emulate_Bitstream[90];
assign ConfigBits[23] = Emulate_Bitstream[89];
assign ConfigBits[22] = Emulate_Bitstream[88];
assign ConfigBits[21] = Emulate_Bitstream[87];
assign ConfigBits[20] = Emulate_Bitstream[86];
assign ConfigBits[19] = Emulate_Bitstream[85];
assign ConfigBits[18] = Emulate_Bitstream[84];
assign ConfigBits[17] = Emulate_Bitstream[83];
assign ConfigBits[16] = Emulate_Bitstream[82];
assign ConfigBits[15] = Emulate_Bitstream[81];
assign ConfigBits[14] = Emulate_Bitstream[80];
assign ConfigBits[13] = Emulate_Bitstream[79];
assign ConfigBits[12] = Emulate_Bitstream[78];
assign ConfigBits[11] = Emulate_Bitstream[77];
assign ConfigBits[10] = Emulate_Bitstream[76];
assign ConfigBits[9] = Emulate_Bitstream[75];
assign ConfigBits[8] = Emulate_Bitstream[74];
assign ConfigBits[7] = Emulate_Bitstream[73];
assign ConfigBits[6] = Emulate_Bitstream[72];
assign ConfigBits[5] = Emulate_Bitstream[71];
assign ConfigBits[4] = Emulate_Bitstream[70];
assign ConfigBits[3] = Emulate_Bitstream[69];
assign ConfigBits[2] = Emulate_Bitstream[68];
assign ConfigBits[1] = Emulate_Bitstream[67];
assign ConfigBits[0] = Emulate_Bitstream[66];
`else

 //instantiate frame latches
config_latch Inst_frame0_bit31 (
    .D(FrameData[31]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[93]),
    .QN(ConfigBits_N[93])
);

config_latch Inst_frame0_bit30 (
    .D(FrameData[30]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[92]),
    .QN(ConfigBits_N[92])
);

config_latch Inst_frame0_bit29 (
    .D(FrameData[29]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[91]),
    .QN(ConfigBits_N[91])
);

config_latch Inst_frame0_bit28 (
    .D(FrameData[28]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[90]),
    .QN(ConfigBits_N[90])
);

config_latch Inst_frame0_bit27 (
    .D(FrameData[27]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[89]),
    .QN(ConfigBits_N[89])
);

config_latch Inst_frame0_bit26 (
    .D(FrameData[26]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[88]),
    .QN(ConfigBits_N[88])
);

config_latch Inst_frame0_bit25 (
    .D(FrameData[25]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[87]),
    .QN(ConfigBits_N[87])
);

config_latch Inst_frame0_bit24 (
    .D(FrameData[24]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[86]),
    .QN(ConfigBits_N[86])
);

config_latch Inst_frame0_bit23 (
    .D(FrameData[23]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[85]),
    .QN(ConfigBits_N[85])
);

config_latch Inst_frame0_bit22 (
    .D(FrameData[22]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[84]),
    .QN(ConfigBits_N[84])
);

config_latch Inst_frame0_bit21 (
    .D(FrameData[21]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[83]),
    .QN(ConfigBits_N[83])
);

config_latch Inst_frame0_bit20 (
    .D(FrameData[20]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[82]),
    .QN(ConfigBits_N[82])
);

config_latch Inst_frame0_bit19 (
    .D(FrameData[19]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[81]),
    .QN(ConfigBits_N[81])
);

config_latch Inst_frame0_bit18 (
    .D(FrameData[18]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[80]),
    .QN(ConfigBits_N[80])
);

config_latch Inst_frame0_bit17 (
    .D(FrameData[17]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[79]),
    .QN(ConfigBits_N[79])
);

config_latch Inst_frame0_bit16 (
    .D(FrameData[16]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[78]),
    .QN(ConfigBits_N[78])
);

config_latch Inst_frame0_bit15 (
    .D(FrameData[15]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[77]),
    .QN(ConfigBits_N[77])
);

config_latch Inst_frame0_bit14 (
    .D(FrameData[14]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[76]),
    .QN(ConfigBits_N[76])
);

config_latch Inst_frame0_bit13 (
    .D(FrameData[13]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[75]),
    .QN(ConfigBits_N[75])
);

config_latch Inst_frame0_bit12 (
    .D(FrameData[12]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[74]),
    .QN(ConfigBits_N[74])
);

config_latch Inst_frame0_bit11 (
    .D(FrameData[11]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[73]),
    .QN(ConfigBits_N[73])
);

config_latch Inst_frame0_bit10 (
    .D(FrameData[10]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[72]),
    .QN(ConfigBits_N[72])
);

config_latch Inst_frame0_bit9 (
    .D(FrameData[9]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[71]),
    .QN(ConfigBits_N[71])
);

config_latch Inst_frame0_bit8 (
    .D(FrameData[8]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[70]),
    .QN(ConfigBits_N[70])
);

config_latch Inst_frame0_bit7 (
    .D(FrameData[7]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[69]),
    .QN(ConfigBits_N[69])
);

config_latch Inst_frame0_bit6 (
    .D(FrameData[6]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[68]),
    .QN(ConfigBits_N[68])
);

config_latch Inst_frame0_bit5 (
    .D(FrameData[5]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[67]),
    .QN(ConfigBits_N[67])
);

config_latch Inst_frame0_bit4 (
    .D(FrameData[4]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[66]),
    .QN(ConfigBits_N[66])
);

config_latch Inst_frame0_bit3 (
    .D(FrameData[3]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[65]),
    .QN(ConfigBits_N[65])
);

config_latch Inst_frame0_bit2 (
    .D(FrameData[2]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[64]),
    .QN(ConfigBits_N[64])
);

config_latch Inst_frame0_bit1 (
    .D(FrameData[1]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[63]),
    .QN(ConfigBits_N[63])
);

config_latch Inst_frame0_bit0 (
    .D(FrameData[0]),
    .E(FrameStrobe[0]),
    .Q(ConfigBits[62]),
    .QN(ConfigBits_N[62])
);

config_latch Inst_frame1_bit31 (
    .D(FrameData[31]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[61]),
    .QN(ConfigBits_N[61])
);

config_latch Inst_frame1_bit30 (
    .D(FrameData[30]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[60]),
    .QN(ConfigBits_N[60])
);

config_latch Inst_frame1_bit29 (
    .D(FrameData[29]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[59]),
    .QN(ConfigBits_N[59])
);

config_latch Inst_frame1_bit28 (
    .D(FrameData[28]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[58]),
    .QN(ConfigBits_N[58])
);

config_latch Inst_frame1_bit27 (
    .D(FrameData[27]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[57]),
    .QN(ConfigBits_N[57])
);

config_latch Inst_frame1_bit26 (
    .D(FrameData[26]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[56]),
    .QN(ConfigBits_N[56])
);

config_latch Inst_frame1_bit25 (
    .D(FrameData[25]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[55]),
    .QN(ConfigBits_N[55])
);

config_latch Inst_frame1_bit24 (
    .D(FrameData[24]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[54]),
    .QN(ConfigBits_N[54])
);

config_latch Inst_frame1_bit23 (
    .D(FrameData[23]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[53]),
    .QN(ConfigBits_N[53])
);

config_latch Inst_frame1_bit22 (
    .D(FrameData[22]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[52]),
    .QN(ConfigBits_N[52])
);

config_latch Inst_frame1_bit21 (
    .D(FrameData[21]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[51]),
    .QN(ConfigBits_N[51])
);

config_latch Inst_frame1_bit20 (
    .D(FrameData[20]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[50]),
    .QN(ConfigBits_N[50])
);

config_latch Inst_frame1_bit19 (
    .D(FrameData[19]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[49]),
    .QN(ConfigBits_N[49])
);

config_latch Inst_frame1_bit18 (
    .D(FrameData[18]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[48]),
    .QN(ConfigBits_N[48])
);

config_latch Inst_frame1_bit17 (
    .D(FrameData[17]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[47]),
    .QN(ConfigBits_N[47])
);

config_latch Inst_frame1_bit16 (
    .D(FrameData[16]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[46]),
    .QN(ConfigBits_N[46])
);

config_latch Inst_frame1_bit15 (
    .D(FrameData[15]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[45]),
    .QN(ConfigBits_N[45])
);

config_latch Inst_frame1_bit14 (
    .D(FrameData[14]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[44]),
    .QN(ConfigBits_N[44])
);

config_latch Inst_frame1_bit13 (
    .D(FrameData[13]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[43]),
    .QN(ConfigBits_N[43])
);

config_latch Inst_frame1_bit12 (
    .D(FrameData[12]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[42]),
    .QN(ConfigBits_N[42])
);

config_latch Inst_frame1_bit11 (
    .D(FrameData[11]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[41]),
    .QN(ConfigBits_N[41])
);

config_latch Inst_frame1_bit10 (
    .D(FrameData[10]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[40]),
    .QN(ConfigBits_N[40])
);

config_latch Inst_frame1_bit9 (
    .D(FrameData[9]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[39]),
    .QN(ConfigBits_N[39])
);

config_latch Inst_frame1_bit8 (
    .D(FrameData[8]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[38]),
    .QN(ConfigBits_N[38])
);

config_latch Inst_frame1_bit7 (
    .D(FrameData[7]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[37]),
    .QN(ConfigBits_N[37])
);

config_latch Inst_frame1_bit6 (
    .D(FrameData[6]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[36]),
    .QN(ConfigBits_N[36])
);

config_latch Inst_frame1_bit5 (
    .D(FrameData[5]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[35]),
    .QN(ConfigBits_N[35])
);

config_latch Inst_frame1_bit4 (
    .D(FrameData[4]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[34]),
    .QN(ConfigBits_N[34])
);

config_latch Inst_frame1_bit3 (
    .D(FrameData[3]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[33]),
    .QN(ConfigBits_N[33])
);

config_latch Inst_frame1_bit2 (
    .D(FrameData[2]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[32]),
    .QN(ConfigBits_N[32])
);

config_latch Inst_frame1_bit1 (
    .D(FrameData[1]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[31]),
    .QN(ConfigBits_N[31])
);

config_latch Inst_frame1_bit0 (
    .D(FrameData[0]),
    .E(FrameStrobe[1]),
    .Q(ConfigBits[30]),
    .QN(ConfigBits_N[30])
);

config_latch Inst_frame2_bit31 (
    .D(FrameData[31]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[29]),
    .QN(ConfigBits_N[29])
);

config_latch Inst_frame2_bit30 (
    .D(FrameData[30]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[28]),
    .QN(ConfigBits_N[28])
);

config_latch Inst_frame2_bit29 (
    .D(FrameData[29]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[27]),
    .QN(ConfigBits_N[27])
);

config_latch Inst_frame2_bit28 (
    .D(FrameData[28]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[26]),
    .QN(ConfigBits_N[26])
);

config_latch Inst_frame2_bit27 (
    .D(FrameData[27]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[25]),
    .QN(ConfigBits_N[25])
);

config_latch Inst_frame2_bit26 (
    .D(FrameData[26]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[24]),
    .QN(ConfigBits_N[24])
);

config_latch Inst_frame2_bit25 (
    .D(FrameData[25]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[23]),
    .QN(ConfigBits_N[23])
);

config_latch Inst_frame2_bit24 (
    .D(FrameData[24]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[22]),
    .QN(ConfigBits_N[22])
);

config_latch Inst_frame2_bit23 (
    .D(FrameData[23]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[21]),
    .QN(ConfigBits_N[21])
);

config_latch Inst_frame2_bit22 (
    .D(FrameData[22]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[20]),
    .QN(ConfigBits_N[20])
);

config_latch Inst_frame2_bit21 (
    .D(FrameData[21]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[19]),
    .QN(ConfigBits_N[19])
);

config_latch Inst_frame2_bit20 (
    .D(FrameData[20]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[18]),
    .QN(ConfigBits_N[18])
);

config_latch Inst_frame2_bit19 (
    .D(FrameData[19]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[17]),
    .QN(ConfigBits_N[17])
);

config_latch Inst_frame2_bit18 (
    .D(FrameData[18]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[16]),
    .QN(ConfigBits_N[16])
);

config_latch Inst_frame2_bit17 (
    .D(FrameData[17]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[15]),
    .QN(ConfigBits_N[15])
);

config_latch Inst_frame2_bit16 (
    .D(FrameData[16]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[14]),
    .QN(ConfigBits_N[14])
);

config_latch Inst_frame2_bit15 (
    .D(FrameData[15]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[13]),
    .QN(ConfigBits_N[13])
);

config_latch Inst_frame2_bit14 (
    .D(FrameData[14]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[12]),
    .QN(ConfigBits_N[12])
);

config_latch Inst_frame2_bit13 (
    .D(FrameData[13]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[11]),
    .QN(ConfigBits_N[11])
);

config_latch Inst_frame2_bit12 (
    .D(FrameData[12]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[10]),
    .QN(ConfigBits_N[10])
);

config_latch Inst_frame2_bit11 (
    .D(FrameData[11]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[9]),
    .QN(ConfigBits_N[9])
);

config_latch Inst_frame2_bit10 (
    .D(FrameData[10]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[8]),
    .QN(ConfigBits_N[8])
);

config_latch Inst_frame2_bit9 (
    .D(FrameData[9]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[7]),
    .QN(ConfigBits_N[7])
);

config_latch Inst_frame2_bit8 (
    .D(FrameData[8]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[6]),
    .QN(ConfigBits_N[6])
);

config_latch Inst_frame2_bit7 (
    .D(FrameData[7]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[5]),
    .QN(ConfigBits_N[5])
);

config_latch Inst_frame2_bit6 (
    .D(FrameData[6]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[4]),
    .QN(ConfigBits_N[4])
);

config_latch Inst_frame2_bit5 (
    .D(FrameData[5]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[3]),
    .QN(ConfigBits_N[3])
);

config_latch Inst_frame2_bit4 (
    .D(FrameData[4]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[2]),
    .QN(ConfigBits_N[2])
);

config_latch Inst_frame2_bit3 (
    .D(FrameData[3]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[1]),
    .QN(ConfigBits_N[1])
);

config_latch Inst_frame2_bit2 (
    .D(FrameData[2]),
    .E(FrameStrobe[2]),
    .Q(ConfigBits[0]),
    .QN(ConfigBits_N[0])
);

`endif
endmodule
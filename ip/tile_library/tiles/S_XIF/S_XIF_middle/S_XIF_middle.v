module S_XIF_middle
    #(
`ifdef EMULATION
        parameter [639:0] Emulate_Bitstream=640'b0,
`endif
        parameter MaxFramesPerCol=20,
        parameter FrameBitsPerRow=32,
        parameter NoConfigBits=67
    )
    (
 //Side.NORTH
        output  [3:0] N1BEG,        //Port(Name=N1BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=4, Side=NORTH)
        output  [7:0] N2BEG,        //Port(Name=N2BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [7:0] N2BEGb,        //Port(Name=N2BEGb, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [15:0] N4BEG,        //Port(Name=N4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [15:0] NN4BEG,        //Port(Name=NN4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [0:0] Co,        //Port(Name=Co, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=1, Side=NORTH)
        input  [3:0] S1END,        //Port(Name=S1END, IO=INPUT, XOffset=0, YOffset=1, WireCount=4, Side=NORTH)
        input  [7:0] S2MID,        //Port(Name=S2MID, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [7:0] S2END,        //Port(Name=S2END, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [15:0] S4END,        //Port(Name=S4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
        input  [15:0] SS4END,        //Port(Name=SS4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
 //Side.EAST
        input  [15:0] right2middle_RESULT,        //Port(Name=right2middle_RESULT, IO=INPUT, XOffset=-1, YOffset=0, WireCount=16, Side=EAST)
        output  [31:0] middle2right_ISSUE_OPB,        //Port(Name=middle2right_ISSUE_OPB, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=32, Side=EAST)
 //Side.WEST
        input  [15:0] left2middle_RESULT,        //Port(Name=left2middle_RESULT, IO=INPUT, XOffset=1, YOffset=0, WireCount=16, Side=WEST)
        output  [31:0] middle2left_ISSUE_OPA,        //Port(Name=middle2left_ISSUE_OPA, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=32, Side=WEST)
        input  ISSUE_VALID_top,
        input  ISSUE_INSTR_top0,
        input  ISSUE_INSTR_top1,
        input  ISSUE_INSTR_top2,
        input  ISSUE_INSTR_top3,
        input  ISSUE_INSTR_top4,
        input  ISSUE_INSTR_top5,
        input  ISSUE_INSTR_top6,
        input  ISSUE_INSTR_top7,
        input  ISSUE_INSTR_top8,
        input  ISSUE_INSTR_top9,
        input  ISSUE_INSTR_top10,
        input  ISSUE_INSTR_top11,
        input  ISSUE_INSTR_top12,
        input  ISSUE_INSTR_top13,
        input  ISSUE_INSTR_top14,
        input  ISSUE_INSTR_top15,
        input  ISSUE_INSTR_top16,
        input  ISSUE_INSTR_top17,
        input  ISSUE_INSTR_top18,
        input  ISSUE_INSTR_top19,
        input  ISSUE_INSTR_top20,
        input  ISSUE_INSTR_top21,
        input  ISSUE_INSTR_top22,
        input  ISSUE_INSTR_top23,
        input  ISSUE_INSTR_top24,
        input  ISSUE_INSTR_top25,
        input  ISSUE_INSTR_top26,
        input  ISSUE_INSTR_top27,
        input  ISSUE_INSTR_top28,
        input  ISSUE_INSTR_top29,
        input  ISSUE_INSTR_top30,
        input  ISSUE_INSTR_top31,
        input  ISSUE_OPA_top0,
        input  ISSUE_OPA_top1,
        input  ISSUE_OPA_top2,
        input  ISSUE_OPA_top3,
        input  ISSUE_OPA_top4,
        input  ISSUE_OPA_top5,
        input  ISSUE_OPA_top6,
        input  ISSUE_OPA_top7,
        input  ISSUE_OPA_top8,
        input  ISSUE_OPA_top9,
        input  ISSUE_OPA_top10,
        input  ISSUE_OPA_top11,
        input  ISSUE_OPA_top12,
        input  ISSUE_OPA_top13,
        input  ISSUE_OPA_top14,
        input  ISSUE_OPA_top15,
        input  ISSUE_OPA_top16,
        input  ISSUE_OPA_top17,
        input  ISSUE_OPA_top18,
        input  ISSUE_OPA_top19,
        input  ISSUE_OPA_top20,
        input  ISSUE_OPA_top21,
        input  ISSUE_OPA_top22,
        input  ISSUE_OPA_top23,
        input  ISSUE_OPA_top24,
        input  ISSUE_OPA_top25,
        input  ISSUE_OPA_top26,
        input  ISSUE_OPA_top27,
        input  ISSUE_OPA_top28,
        input  ISSUE_OPA_top29,
        input  ISSUE_OPA_top30,
        input  ISSUE_OPA_top31,
        input  ISSUE_OPB_top0,
        input  ISSUE_OPB_top1,
        input  ISSUE_OPB_top2,
        input  ISSUE_OPB_top3,
        input  ISSUE_OPB_top4,
        input  ISSUE_OPB_top5,
        input  ISSUE_OPB_top6,
        input  ISSUE_OPB_top7,
        input  ISSUE_OPB_top8,
        input  ISSUE_OPB_top9,
        input  ISSUE_OPB_top10,
        input  ISSUE_OPB_top11,
        input  ISSUE_OPB_top12,
        input  ISSUE_OPB_top13,
        input  ISSUE_OPB_top14,
        input  ISSUE_OPB_top15,
        input  ISSUE_OPB_top16,
        input  ISSUE_OPB_top17,
        input  ISSUE_OPB_top18,
        input  ISSUE_OPB_top19,
        input  ISSUE_OPB_top20,
        input  ISSUE_OPB_top21,
        input  ISSUE_OPB_top22,
        input  ISSUE_OPB_top23,
        input  ISSUE_OPB_top24,
        input  ISSUE_OPB_top25,
        input  ISSUE_OPB_top26,
        input  ISSUE_OPB_top27,
        input  ISSUE_OPB_top28,
        input  ISSUE_OPB_top29,
        input  ISSUE_OPB_top30,
        input  ISSUE_OPB_top31,
        input  ISSUE_ID_top0,
        input  ISSUE_ID_top1,
        input  ISSUE_ID_top2,
        input  ISSUE_ID_top3,
        output  ISSUE_READY_top,
        output  ISSUE_ACCEPT_top,
        output  RESULT_VALID_top,
        output  RESULT_ID_top0,
        output  RESULT_ID_top1,
        output  RESULT_ID_top2,
        output  RESULT_ID_top3,
        output  RESULT_RD_top0,
        output  RESULT_RD_top1,
        output  RESULT_RD_top2,
        output  RESULT_RD_top3,
        output  RESULT_RD_top4,
        output  RESULT_top0,
        output  RESULT_top1,
        output  RESULT_top2,
        output  RESULT_top3,
        output  RESULT_top4,
        output  RESULT_top5,
        output  RESULT_top6,
        output  RESULT_top7,
        output  RESULT_top8,
        output  RESULT_top9,
        output  RESULT_top10,
        output  RESULT_top11,
        output  RESULT_top12,
        output  RESULT_top13,
        output  RESULT_top14,
        output  RESULT_top15,
        output  RESULT_top16,
        output  RESULT_top17,
        output  RESULT_top18,
        output  RESULT_top19,
        output  RESULT_top20,
        output  RESULT_top21,
        output  RESULT_top22,
        output  RESULT_top23,
        output  RESULT_top24,
        output  RESULT_top25,
        output  RESULT_top26,
        output  RESULT_top27,
        output  RESULT_top28,
        output  RESULT_top29,
        output  RESULT_top30,
        output  RESULT_top31,
    //Tile IO ports from BELs
        input  UserCLK,
        output  UserCLKo,
        input  [FrameBitsPerRow-1:0] FrameData, //CONFIG_PORT
        output  [FrameBitsPerRow-1:0] FrameData_O,
        input  [MaxFramesPerCol-1:0] FrameStrobe, //CONFIG_PORT
        output  [MaxFramesPerCol-1:0] FrameStrobe_O
    //global
);
 //signal declarations
 //BEL ports (e.g., slices)
wire ISSUE_READY;
wire ISSUE_ACCEPT;
wire RESULT_VALID;
wire RESULT_ID0;
wire RESULT_ID1;
wire RESULT_ID2;
wire RESULT_ID3;
wire RESULT_RD0;
wire RESULT_RD1;
wire RESULT_RD2;
wire RESULT_RD3;
wire RESULT_RD4;
wire RESULT0;
wire RESULT1;
wire RESULT2;
wire RESULT3;
wire RESULT4;
wire RESULT5;
wire RESULT6;
wire RESULT7;
wire RESULT8;
wire RESULT9;
wire RESULT10;
wire RESULT11;
wire RESULT12;
wire RESULT13;
wire RESULT14;
wire RESULT15;
wire RESULT16;
wire RESULT17;
wire RESULT18;
wire RESULT19;
wire RESULT20;
wire RESULT21;
wire RESULT22;
wire RESULT23;
wire RESULT24;
wire RESULT25;
wire RESULT26;
wire RESULT27;
wire RESULT28;
wire RESULT29;
wire RESULT30;
wire RESULT31;
wire ISSUE_VALID;
wire ISSUE_INSTR0;
wire ISSUE_INSTR1;
wire ISSUE_INSTR2;
wire ISSUE_INSTR3;
wire ISSUE_INSTR4;
wire ISSUE_INSTR5;
wire ISSUE_INSTR6;
wire ISSUE_INSTR7;
wire ISSUE_INSTR8;
wire ISSUE_INSTR9;
wire ISSUE_INSTR10;
wire ISSUE_INSTR11;
wire ISSUE_INSTR12;
wire ISSUE_INSTR13;
wire ISSUE_INSTR14;
wire ISSUE_INSTR15;
wire ISSUE_INSTR16;
wire ISSUE_INSTR17;
wire ISSUE_INSTR18;
wire ISSUE_INSTR19;
wire ISSUE_INSTR20;
wire ISSUE_INSTR21;
wire ISSUE_INSTR22;
wire ISSUE_INSTR23;
wire ISSUE_INSTR24;
wire ISSUE_INSTR25;
wire ISSUE_INSTR26;
wire ISSUE_INSTR27;
wire ISSUE_INSTR28;
wire ISSUE_INSTR29;
wire ISSUE_INSTR30;
wire ISSUE_INSTR31;
wire ISSUE_OPA0;
wire ISSUE_OPA1;
wire ISSUE_OPA2;
wire ISSUE_OPA3;
wire ISSUE_OPA4;
wire ISSUE_OPA5;
wire ISSUE_OPA6;
wire ISSUE_OPA7;
wire ISSUE_OPA8;
wire ISSUE_OPA9;
wire ISSUE_OPA10;
wire ISSUE_OPA11;
wire ISSUE_OPA12;
wire ISSUE_OPA13;
wire ISSUE_OPA14;
wire ISSUE_OPA15;
wire ISSUE_OPA16;
wire ISSUE_OPA17;
wire ISSUE_OPA18;
wire ISSUE_OPA19;
wire ISSUE_OPA20;
wire ISSUE_OPA21;
wire ISSUE_OPA22;
wire ISSUE_OPA23;
wire ISSUE_OPA24;
wire ISSUE_OPA25;
wire ISSUE_OPA26;
wire ISSUE_OPA27;
wire ISSUE_OPA28;
wire ISSUE_OPA29;
wire ISSUE_OPA30;
wire ISSUE_OPA31;
wire ISSUE_OPB0;
wire ISSUE_OPB1;
wire ISSUE_OPB2;
wire ISSUE_OPB3;
wire ISSUE_OPB4;
wire ISSUE_OPB5;
wire ISSUE_OPB6;
wire ISSUE_OPB7;
wire ISSUE_OPB8;
wire ISSUE_OPB9;
wire ISSUE_OPB10;
wire ISSUE_OPB11;
wire ISSUE_OPB12;
wire ISSUE_OPB13;
wire ISSUE_OPB14;
wire ISSUE_OPB15;
wire ISSUE_OPB16;
wire ISSUE_OPB17;
wire ISSUE_OPB18;
wire ISSUE_OPB19;
wire ISSUE_OPB20;
wire ISSUE_OPB21;
wire ISSUE_OPB22;
wire ISSUE_OPB23;
wire ISSUE_OPB24;
wire ISSUE_OPB25;
wire ISSUE_OPB26;
wire ISSUE_OPB27;
wire ISSUE_OPB28;
wire ISSUE_OPB29;
wire ISSUE_OPB30;
wire ISSUE_OPB31;
wire ISSUE_ID0;
wire ISSUE_ID1;
wire ISSUE_ID2;
wire ISSUE_ID3;
 //Jump wires
 //internal configuration data signal to daisy-chain all BELs (if any and in the order they are listed in the fabric.csv)
wire[NoConfigBits-1:0] ConfigBits;
wire[NoConfigBits-1:0] ConfigBits_N;

 //Connection for outgoing wires
wire[FrameBitsPerRow-1:0] FrameData_i;
wire[FrameBitsPerRow-1:0] FrameData_O_i;
wire[MaxFramesPerCol-1:0] FrameStrobe_i;
wire[MaxFramesPerCol-1:0] FrameStrobe_O_i;

assign FrameData_O_i = FrameData_i;

my_buf data_inbuf_0 (
    .A(FrameData[0]),
    .X(FrameData_i[0])
);

my_buf data_inbuf_1 (
    .A(FrameData[1]),
    .X(FrameData_i[1])
);

my_buf data_inbuf_2 (
    .A(FrameData[2]),
    .X(FrameData_i[2])
);

my_buf data_inbuf_3 (
    .A(FrameData[3]),
    .X(FrameData_i[3])
);

my_buf data_inbuf_4 (
    .A(FrameData[4]),
    .X(FrameData_i[4])
);

my_buf data_inbuf_5 (
    .A(FrameData[5]),
    .X(FrameData_i[5])
);

my_buf data_inbuf_6 (
    .A(FrameData[6]),
    .X(FrameData_i[6])
);

my_buf data_inbuf_7 (
    .A(FrameData[7]),
    .X(FrameData_i[7])
);

my_buf data_inbuf_8 (
    .A(FrameData[8]),
    .X(FrameData_i[8])
);

my_buf data_inbuf_9 (
    .A(FrameData[9]),
    .X(FrameData_i[9])
);

my_buf data_inbuf_10 (
    .A(FrameData[10]),
    .X(FrameData_i[10])
);

my_buf data_inbuf_11 (
    .A(FrameData[11]),
    .X(FrameData_i[11])
);

my_buf data_inbuf_12 (
    .A(FrameData[12]),
    .X(FrameData_i[12])
);

my_buf data_inbuf_13 (
    .A(FrameData[13]),
    .X(FrameData_i[13])
);

my_buf data_inbuf_14 (
    .A(FrameData[14]),
    .X(FrameData_i[14])
);

my_buf data_inbuf_15 (
    .A(FrameData[15]),
    .X(FrameData_i[15])
);

my_buf data_inbuf_16 (
    .A(FrameData[16]),
    .X(FrameData_i[16])
);

my_buf data_inbuf_17 (
    .A(FrameData[17]),
    .X(FrameData_i[17])
);

my_buf data_inbuf_18 (
    .A(FrameData[18]),
    .X(FrameData_i[18])
);

my_buf data_inbuf_19 (
    .A(FrameData[19]),
    .X(FrameData_i[19])
);

my_buf data_inbuf_20 (
    .A(FrameData[20]),
    .X(FrameData_i[20])
);

my_buf data_inbuf_21 (
    .A(FrameData[21]),
    .X(FrameData_i[21])
);

my_buf data_inbuf_22 (
    .A(FrameData[22]),
    .X(FrameData_i[22])
);

my_buf data_inbuf_23 (
    .A(FrameData[23]),
    .X(FrameData_i[23])
);

my_buf data_inbuf_24 (
    .A(FrameData[24]),
    .X(FrameData_i[24])
);

my_buf data_inbuf_25 (
    .A(FrameData[25]),
    .X(FrameData_i[25])
);

my_buf data_inbuf_26 (
    .A(FrameData[26]),
    .X(FrameData_i[26])
);

my_buf data_inbuf_27 (
    .A(FrameData[27]),
    .X(FrameData_i[27])
);

my_buf data_inbuf_28 (
    .A(FrameData[28]),
    .X(FrameData_i[28])
);

my_buf data_inbuf_29 (
    .A(FrameData[29]),
    .X(FrameData_i[29])
);

my_buf data_inbuf_30 (
    .A(FrameData[30]),
    .X(FrameData_i[30])
);

my_buf data_inbuf_31 (
    .A(FrameData[31]),
    .X(FrameData_i[31])
);

my_buf data_outbuf_0 (
    .A(FrameData_O_i[0]),
    .X(FrameData_O[0])
);

my_buf data_outbuf_1 (
    .A(FrameData_O_i[1]),
    .X(FrameData_O[1])
);

my_buf data_outbuf_2 (
    .A(FrameData_O_i[2]),
    .X(FrameData_O[2])
);

my_buf data_outbuf_3 (
    .A(FrameData_O_i[3]),
    .X(FrameData_O[3])
);

my_buf data_outbuf_4 (
    .A(FrameData_O_i[4]),
    .X(FrameData_O[4])
);

my_buf data_outbuf_5 (
    .A(FrameData_O_i[5]),
    .X(FrameData_O[5])
);

my_buf data_outbuf_6 (
    .A(FrameData_O_i[6]),
    .X(FrameData_O[6])
);

my_buf data_outbuf_7 (
    .A(FrameData_O_i[7]),
    .X(FrameData_O[7])
);

my_buf data_outbuf_8 (
    .A(FrameData_O_i[8]),
    .X(FrameData_O[8])
);

my_buf data_outbuf_9 (
    .A(FrameData_O_i[9]),
    .X(FrameData_O[9])
);

my_buf data_outbuf_10 (
    .A(FrameData_O_i[10]),
    .X(FrameData_O[10])
);

my_buf data_outbuf_11 (
    .A(FrameData_O_i[11]),
    .X(FrameData_O[11])
);

my_buf data_outbuf_12 (
    .A(FrameData_O_i[12]),
    .X(FrameData_O[12])
);

my_buf data_outbuf_13 (
    .A(FrameData_O_i[13]),
    .X(FrameData_O[13])
);

my_buf data_outbuf_14 (
    .A(FrameData_O_i[14]),
    .X(FrameData_O[14])
);

my_buf data_outbuf_15 (
    .A(FrameData_O_i[15]),
    .X(FrameData_O[15])
);

my_buf data_outbuf_16 (
    .A(FrameData_O_i[16]),
    .X(FrameData_O[16])
);

my_buf data_outbuf_17 (
    .A(FrameData_O_i[17]),
    .X(FrameData_O[17])
);

my_buf data_outbuf_18 (
    .A(FrameData_O_i[18]),
    .X(FrameData_O[18])
);

my_buf data_outbuf_19 (
    .A(FrameData_O_i[19]),
    .X(FrameData_O[19])
);

my_buf data_outbuf_20 (
    .A(FrameData_O_i[20]),
    .X(FrameData_O[20])
);

my_buf data_outbuf_21 (
    .A(FrameData_O_i[21]),
    .X(FrameData_O[21])
);

my_buf data_outbuf_22 (
    .A(FrameData_O_i[22]),
    .X(FrameData_O[22])
);

my_buf data_outbuf_23 (
    .A(FrameData_O_i[23]),
    .X(FrameData_O[23])
);

my_buf data_outbuf_24 (
    .A(FrameData_O_i[24]),
    .X(FrameData_O[24])
);

my_buf data_outbuf_25 (
    .A(FrameData_O_i[25]),
    .X(FrameData_O[25])
);

my_buf data_outbuf_26 (
    .A(FrameData_O_i[26]),
    .X(FrameData_O[26])
);

my_buf data_outbuf_27 (
    .A(FrameData_O_i[27]),
    .X(FrameData_O[27])
);

my_buf data_outbuf_28 (
    .A(FrameData_O_i[28]),
    .X(FrameData_O[28])
);

my_buf data_outbuf_29 (
    .A(FrameData_O_i[29]),
    .X(FrameData_O[29])
);

my_buf data_outbuf_30 (
    .A(FrameData_O_i[30]),
    .X(FrameData_O[30])
);

my_buf data_outbuf_31 (
    .A(FrameData_O_i[31]),
    .X(FrameData_O[31])
);

assign FrameStrobe_O_i = FrameStrobe_i;

my_buf strobe_inbuf_0 (
    .A(FrameStrobe[0]),
    .X(FrameStrobe_i[0])
);

my_buf strobe_inbuf_1 (
    .A(FrameStrobe[1]),
    .X(FrameStrobe_i[1])
);

my_buf strobe_inbuf_2 (
    .A(FrameStrobe[2]),
    .X(FrameStrobe_i[2])
);

my_buf strobe_inbuf_3 (
    .A(FrameStrobe[3]),
    .X(FrameStrobe_i[3])
);

my_buf strobe_inbuf_4 (
    .A(FrameStrobe[4]),
    .X(FrameStrobe_i[4])
);

my_buf strobe_inbuf_5 (
    .A(FrameStrobe[5]),
    .X(FrameStrobe_i[5])
);

my_buf strobe_inbuf_6 (
    .A(FrameStrobe[6]),
    .X(FrameStrobe_i[6])
);

my_buf strobe_inbuf_7 (
    .A(FrameStrobe[7]),
    .X(FrameStrobe_i[7])
);

my_buf strobe_inbuf_8 (
    .A(FrameStrobe[8]),
    .X(FrameStrobe_i[8])
);

my_buf strobe_inbuf_9 (
    .A(FrameStrobe[9]),
    .X(FrameStrobe_i[9])
);

my_buf strobe_inbuf_10 (
    .A(FrameStrobe[10]),
    .X(FrameStrobe_i[10])
);

my_buf strobe_inbuf_11 (
    .A(FrameStrobe[11]),
    .X(FrameStrobe_i[11])
);

my_buf strobe_inbuf_12 (
    .A(FrameStrobe[12]),
    .X(FrameStrobe_i[12])
);

my_buf strobe_inbuf_13 (
    .A(FrameStrobe[13]),
    .X(FrameStrobe_i[13])
);

my_buf strobe_inbuf_14 (
    .A(FrameStrobe[14]),
    .X(FrameStrobe_i[14])
);

my_buf strobe_inbuf_15 (
    .A(FrameStrobe[15]),
    .X(FrameStrobe_i[15])
);

my_buf strobe_inbuf_16 (
    .A(FrameStrobe[16]),
    .X(FrameStrobe_i[16])
);

my_buf strobe_inbuf_17 (
    .A(FrameStrobe[17]),
    .X(FrameStrobe_i[17])
);

my_buf strobe_inbuf_18 (
    .A(FrameStrobe[18]),
    .X(FrameStrobe_i[18])
);

my_buf strobe_inbuf_19 (
    .A(FrameStrobe[19]),
    .X(FrameStrobe_i[19])
);

my_buf strobe_outbuf_0 (
    .A(FrameStrobe_O_i[0]),
    .X(FrameStrobe_O[0])
);

my_buf strobe_outbuf_1 (
    .A(FrameStrobe_O_i[1]),
    .X(FrameStrobe_O[1])
);

my_buf strobe_outbuf_2 (
    .A(FrameStrobe_O_i[2]),
    .X(FrameStrobe_O[2])
);

my_buf strobe_outbuf_3 (
    .A(FrameStrobe_O_i[3]),
    .X(FrameStrobe_O[3])
);

my_buf strobe_outbuf_4 (
    .A(FrameStrobe_O_i[4]),
    .X(FrameStrobe_O[4])
);

my_buf strobe_outbuf_5 (
    .A(FrameStrobe_O_i[5]),
    .X(FrameStrobe_O[5])
);

my_buf strobe_outbuf_6 (
    .A(FrameStrobe_O_i[6]),
    .X(FrameStrobe_O[6])
);

my_buf strobe_outbuf_7 (
    .A(FrameStrobe_O_i[7]),
    .X(FrameStrobe_O[7])
);

my_buf strobe_outbuf_8 (
    .A(FrameStrobe_O_i[8]),
    .X(FrameStrobe_O[8])
);

my_buf strobe_outbuf_9 (
    .A(FrameStrobe_O_i[9]),
    .X(FrameStrobe_O[9])
);

my_buf strobe_outbuf_10 (
    .A(FrameStrobe_O_i[10]),
    .X(FrameStrobe_O[10])
);

my_buf strobe_outbuf_11 (
    .A(FrameStrobe_O_i[11]),
    .X(FrameStrobe_O[11])
);

my_buf strobe_outbuf_12 (
    .A(FrameStrobe_O_i[12]),
    .X(FrameStrobe_O[12])
);

my_buf strobe_outbuf_13 (
    .A(FrameStrobe_O_i[13]),
    .X(FrameStrobe_O[13])
);

my_buf strobe_outbuf_14 (
    .A(FrameStrobe_O_i[14]),
    .X(FrameStrobe_O[14])
);

my_buf strobe_outbuf_15 (
    .A(FrameStrobe_O_i[15]),
    .X(FrameStrobe_O[15])
);

my_buf strobe_outbuf_16 (
    .A(FrameStrobe_O_i[16]),
    .X(FrameStrobe_O[16])
);

my_buf strobe_outbuf_17 (
    .A(FrameStrobe_O_i[17]),
    .X(FrameStrobe_O[17])
);

my_buf strobe_outbuf_18 (
    .A(FrameStrobe_O_i[18]),
    .X(FrameStrobe_O[18])
);

my_buf strobe_outbuf_19 (
    .A(FrameStrobe_O_i[19]),
    .X(FrameStrobe_O[19])
);

clk_buf inst_clk_buf (
    .A(UserCLK),
    .X(UserCLKo)
);


 //configuration storage latches
S_XIF_middle_ConfigMem
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Emulate_Bitstream)
    )
`endif
    Inst_S_XIF_middle_ConfigMem
    (
    .FrameData(FrameData),
    .FrameStrobe(FrameStrobe),
    .ConfigBits(ConfigBits),
    .ConfigBits_N(ConfigBits_N)
);


 //BEL component instantiations
CUSTOM_INSTRUCTION Inst_CUSTOM_INSTRUCTION (
    .ISSUE_READY(ISSUE_READY),
    .ISSUE_ACCEPT(ISSUE_ACCEPT),
    .RESULT_VALID(RESULT_VALID),
    .RESULT_ID({RESULT_ID3, RESULT_ID2, RESULT_ID1, RESULT_ID0}),
    .RESULT_RD({RESULT_RD4, RESULT_RD3, RESULT_RD2, RESULT_RD1, RESULT_RD0}),
    .RESULT({RESULT31, RESULT30, RESULT29, RESULT28, RESULT27, RESULT26, RESULT25, RESULT24, RESULT23, RESULT22, RESULT21, RESULT20, RESULT19, RESULT18, RESULT17, RESULT16, RESULT15, RESULT14, RESULT13, RESULT12, RESULT11, RESULT10, RESULT9, RESULT8, RESULT7, RESULT6, RESULT5, RESULT4, RESULT3, RESULT2, RESULT1, RESULT0}),
    .ISSUE_VALID(ISSUE_VALID),
    .ISSUE_INSTR({ISSUE_INSTR31, ISSUE_INSTR30, ISSUE_INSTR29, ISSUE_INSTR28, ISSUE_INSTR27, ISSUE_INSTR26, ISSUE_INSTR25, ISSUE_INSTR24, ISSUE_INSTR23, ISSUE_INSTR22, ISSUE_INSTR21, ISSUE_INSTR20, ISSUE_INSTR19, ISSUE_INSTR18, ISSUE_INSTR17, ISSUE_INSTR16, ISSUE_INSTR15, ISSUE_INSTR14, ISSUE_INSTR13, ISSUE_INSTR12, ISSUE_INSTR11, ISSUE_INSTR10, ISSUE_INSTR9, ISSUE_INSTR8, ISSUE_INSTR7, ISSUE_INSTR6, ISSUE_INSTR5, ISSUE_INSTR4, ISSUE_INSTR3, ISSUE_INSTR2, ISSUE_INSTR1, ISSUE_INSTR0}),
    .ISSUE_OPA({ISSUE_OPA31, ISSUE_OPA30, ISSUE_OPA29, ISSUE_OPA28, ISSUE_OPA27, ISSUE_OPA26, ISSUE_OPA25, ISSUE_OPA24, ISSUE_OPA23, ISSUE_OPA22, ISSUE_OPA21, ISSUE_OPA20, ISSUE_OPA19, ISSUE_OPA18, ISSUE_OPA17, ISSUE_OPA16, ISSUE_OPA15, ISSUE_OPA14, ISSUE_OPA13, ISSUE_OPA12, ISSUE_OPA11, ISSUE_OPA10, ISSUE_OPA9, ISSUE_OPA8, ISSUE_OPA7, ISSUE_OPA6, ISSUE_OPA5, ISSUE_OPA4, ISSUE_OPA3, ISSUE_OPA2, ISSUE_OPA1, ISSUE_OPA0}),
    .ISSUE_OPB({ISSUE_OPB31, ISSUE_OPB30, ISSUE_OPB29, ISSUE_OPB28, ISSUE_OPB27, ISSUE_OPB26, ISSUE_OPB25, ISSUE_OPB24, ISSUE_OPB23, ISSUE_OPB22, ISSUE_OPB21, ISSUE_OPB20, ISSUE_OPB19, ISSUE_OPB18, ISSUE_OPB17, ISSUE_OPB16, ISSUE_OPB15, ISSUE_OPB14, ISSUE_OPB13, ISSUE_OPB12, ISSUE_OPB11, ISSUE_OPB10, ISSUE_OPB9, ISSUE_OPB8, ISSUE_OPB7, ISSUE_OPB6, ISSUE_OPB5, ISSUE_OPB4, ISSUE_OPB3, ISSUE_OPB2, ISSUE_OPB1, ISSUE_OPB0}),
    .ISSUE_ID({ISSUE_ID3, ISSUE_ID2, ISSUE_ID1, ISSUE_ID0}),
    .ISSUE_VALID_top(ISSUE_VALID_top),
    .ISSUE_INSTR_top({ISSUE_INSTR_top31, ISSUE_INSTR_top30, ISSUE_INSTR_top29, ISSUE_INSTR_top28, ISSUE_INSTR_top27, ISSUE_INSTR_top26, ISSUE_INSTR_top25, ISSUE_INSTR_top24, ISSUE_INSTR_top23, ISSUE_INSTR_top22, ISSUE_INSTR_top21, ISSUE_INSTR_top20, ISSUE_INSTR_top19, ISSUE_INSTR_top18, ISSUE_INSTR_top17, ISSUE_INSTR_top16, ISSUE_INSTR_top15, ISSUE_INSTR_top14, ISSUE_INSTR_top13, ISSUE_INSTR_top12, ISSUE_INSTR_top11, ISSUE_INSTR_top10, ISSUE_INSTR_top9, ISSUE_INSTR_top8, ISSUE_INSTR_top7, ISSUE_INSTR_top6, ISSUE_INSTR_top5, ISSUE_INSTR_top4, ISSUE_INSTR_top3, ISSUE_INSTR_top2, ISSUE_INSTR_top1, ISSUE_INSTR_top0}),
    .ISSUE_OPA_top({ISSUE_OPA_top31, ISSUE_OPA_top30, ISSUE_OPA_top29, ISSUE_OPA_top28, ISSUE_OPA_top27, ISSUE_OPA_top26, ISSUE_OPA_top25, ISSUE_OPA_top24, ISSUE_OPA_top23, ISSUE_OPA_top22, ISSUE_OPA_top21, ISSUE_OPA_top20, ISSUE_OPA_top19, ISSUE_OPA_top18, ISSUE_OPA_top17, ISSUE_OPA_top16, ISSUE_OPA_top15, ISSUE_OPA_top14, ISSUE_OPA_top13, ISSUE_OPA_top12, ISSUE_OPA_top11, ISSUE_OPA_top10, ISSUE_OPA_top9, ISSUE_OPA_top8, ISSUE_OPA_top7, ISSUE_OPA_top6, ISSUE_OPA_top5, ISSUE_OPA_top4, ISSUE_OPA_top3, ISSUE_OPA_top2, ISSUE_OPA_top1, ISSUE_OPA_top0}),
    .ISSUE_OPB_top({ISSUE_OPB_top31, ISSUE_OPB_top30, ISSUE_OPB_top29, ISSUE_OPB_top28, ISSUE_OPB_top27, ISSUE_OPB_top26, ISSUE_OPB_top25, ISSUE_OPB_top24, ISSUE_OPB_top23, ISSUE_OPB_top22, ISSUE_OPB_top21, ISSUE_OPB_top20, ISSUE_OPB_top19, ISSUE_OPB_top18, ISSUE_OPB_top17, ISSUE_OPB_top16, ISSUE_OPB_top15, ISSUE_OPB_top14, ISSUE_OPB_top13, ISSUE_OPB_top12, ISSUE_OPB_top11, ISSUE_OPB_top10, ISSUE_OPB_top9, ISSUE_OPB_top8, ISSUE_OPB_top7, ISSUE_OPB_top6, ISSUE_OPB_top5, ISSUE_OPB_top4, ISSUE_OPB_top3, ISSUE_OPB_top2, ISSUE_OPB_top1, ISSUE_OPB_top0}),
    .ISSUE_ID_top({ISSUE_ID_top3, ISSUE_ID_top2, ISSUE_ID_top1, ISSUE_ID_top0}),
    .ISSUE_READY_top(ISSUE_READY_top),
    .ISSUE_ACCEPT_top(ISSUE_ACCEPT_top),
    .RESULT_VALID_top(RESULT_VALID_top),
    .RESULT_ID_top({RESULT_ID_top3, RESULT_ID_top2, RESULT_ID_top1, RESULT_ID_top0}),
    .RESULT_RD_top({RESULT_RD_top4, RESULT_RD_top3, RESULT_RD_top2, RESULT_RD_top1, RESULT_RD_top0}),
    .RESULT_top({RESULT_top31, RESULT_top30, RESULT_top29, RESULT_top28, RESULT_top27, RESULT_top26, RESULT_top25, RESULT_top24, RESULT_top23, RESULT_top22, RESULT_top21, RESULT_top20, RESULT_top19, RESULT_top18, RESULT_top17, RESULT_top16, RESULT_top15, RESULT_top14, RESULT_top13, RESULT_top12, RESULT_top11, RESULT_top10, RESULT_top9, RESULT_top8, RESULT_top7, RESULT_top6, RESULT_top5, RESULT_top4, RESULT_top3, RESULT_top2, RESULT_top1, RESULT_top0})
);

S_XIF_middle_switch_matrix Inst_S_XIF_middle_switch_matrix (
    .S1END0(S1END[0]),
    .S1END1(S1END[1]),
    .S1END2(S1END[2]),
    .S1END3(S1END[3]),
    .S2MID0(S2MID[0]),
    .S2MID1(S2MID[1]),
    .S2MID2(S2MID[2]),
    .S2MID3(S2MID[3]),
    .S2MID4(S2MID[4]),
    .S2MID5(S2MID[5]),
    .S2MID6(S2MID[6]),
    .S2MID7(S2MID[7]),
    .S2END0(S2END[0]),
    .S2END1(S2END[1]),
    .S2END2(S2END[2]),
    .S2END3(S2END[3]),
    .S2END4(S2END[4]),
    .S2END5(S2END[5]),
    .S2END6(S2END[6]),
    .S2END7(S2END[7]),
    .S4END0(S4END[0]),
    .S4END1(S4END[1]),
    .S4END2(S4END[2]),
    .S4END3(S4END[3]),
    .S4END4(S4END[4]),
    .S4END5(S4END[5]),
    .S4END6(S4END[6]),
    .S4END7(S4END[7]),
    .S4END8(S4END[8]),
    .S4END9(S4END[9]),
    .S4END10(S4END[10]),
    .S4END11(S4END[11]),
    .S4END12(S4END[12]),
    .S4END13(S4END[13]),
    .S4END14(S4END[14]),
    .S4END15(S4END[15]),
    .SS4END0(SS4END[0]),
    .SS4END1(SS4END[1]),
    .SS4END2(SS4END[2]),
    .SS4END3(SS4END[3]),
    .SS4END4(SS4END[4]),
    .SS4END5(SS4END[5]),
    .SS4END6(SS4END[6]),
    .SS4END7(SS4END[7]),
    .SS4END8(SS4END[8]),
    .SS4END9(SS4END[9]),
    .SS4END10(SS4END[10]),
    .SS4END11(SS4END[11]),
    .SS4END12(SS4END[12]),
    .SS4END13(SS4END[13]),
    .SS4END14(SS4END[14]),
    .SS4END15(SS4END[15]),
    .left2middle_RESULT0(left2middle_RESULT[0]),
    .left2middle_RESULT1(left2middle_RESULT[1]),
    .left2middle_RESULT2(left2middle_RESULT[2]),
    .left2middle_RESULT3(left2middle_RESULT[3]),
    .left2middle_RESULT4(left2middle_RESULT[4]),
    .left2middle_RESULT5(left2middle_RESULT[5]),
    .left2middle_RESULT6(left2middle_RESULT[6]),
    .left2middle_RESULT7(left2middle_RESULT[7]),
    .left2middle_RESULT8(left2middle_RESULT[8]),
    .left2middle_RESULT9(left2middle_RESULT[9]),
    .left2middle_RESULT10(left2middle_RESULT[10]),
    .left2middle_RESULT11(left2middle_RESULT[11]),
    .left2middle_RESULT12(left2middle_RESULT[12]),
    .left2middle_RESULT13(left2middle_RESULT[13]),
    .left2middle_RESULT14(left2middle_RESULT[14]),
    .left2middle_RESULT15(left2middle_RESULT[15]),
    .right2middle_RESULT0(right2middle_RESULT[0]),
    .right2middle_RESULT1(right2middle_RESULT[1]),
    .right2middle_RESULT2(right2middle_RESULT[2]),
    .right2middle_RESULT3(right2middle_RESULT[3]),
    .right2middle_RESULT4(right2middle_RESULT[4]),
    .right2middle_RESULT5(right2middle_RESULT[5]),
    .right2middle_RESULT6(right2middle_RESULT[6]),
    .right2middle_RESULT7(right2middle_RESULT[7]),
    .right2middle_RESULT8(right2middle_RESULT[8]),
    .right2middle_RESULT9(right2middle_RESULT[9]),
    .right2middle_RESULT10(right2middle_RESULT[10]),
    .right2middle_RESULT11(right2middle_RESULT[11]),
    .right2middle_RESULT12(right2middle_RESULT[12]),
    .right2middle_RESULT13(right2middle_RESULT[13]),
    .right2middle_RESULT14(right2middle_RESULT[14]),
    .right2middle_RESULT15(right2middle_RESULT[15]),
    .ISSUE_VALID(ISSUE_VALID),
    .ISSUE_INSTR0(ISSUE_INSTR0),
    .ISSUE_INSTR1(ISSUE_INSTR1),
    .ISSUE_INSTR2(ISSUE_INSTR2),
    .ISSUE_INSTR3(ISSUE_INSTR3),
    .ISSUE_INSTR4(ISSUE_INSTR4),
    .ISSUE_INSTR5(ISSUE_INSTR5),
    .ISSUE_INSTR6(ISSUE_INSTR6),
    .ISSUE_INSTR7(ISSUE_INSTR7),
    .ISSUE_INSTR8(ISSUE_INSTR8),
    .ISSUE_INSTR9(ISSUE_INSTR9),
    .ISSUE_INSTR10(ISSUE_INSTR10),
    .ISSUE_INSTR11(ISSUE_INSTR11),
    .ISSUE_INSTR12(ISSUE_INSTR12),
    .ISSUE_INSTR13(ISSUE_INSTR13),
    .ISSUE_INSTR14(ISSUE_INSTR14),
    .ISSUE_INSTR15(ISSUE_INSTR15),
    .ISSUE_INSTR16(ISSUE_INSTR16),
    .ISSUE_INSTR17(ISSUE_INSTR17),
    .ISSUE_INSTR18(ISSUE_INSTR18),
    .ISSUE_INSTR19(ISSUE_INSTR19),
    .ISSUE_INSTR20(ISSUE_INSTR20),
    .ISSUE_INSTR21(ISSUE_INSTR21),
    .ISSUE_INSTR22(ISSUE_INSTR22),
    .ISSUE_INSTR23(ISSUE_INSTR23),
    .ISSUE_INSTR24(ISSUE_INSTR24),
    .ISSUE_INSTR25(ISSUE_INSTR25),
    .ISSUE_INSTR26(ISSUE_INSTR26),
    .ISSUE_INSTR27(ISSUE_INSTR27),
    .ISSUE_INSTR28(ISSUE_INSTR28),
    .ISSUE_INSTR29(ISSUE_INSTR29),
    .ISSUE_INSTR30(ISSUE_INSTR30),
    .ISSUE_INSTR31(ISSUE_INSTR31),
    .ISSUE_OPA0(ISSUE_OPA0),
    .ISSUE_OPA1(ISSUE_OPA1),
    .ISSUE_OPA2(ISSUE_OPA2),
    .ISSUE_OPA3(ISSUE_OPA3),
    .ISSUE_OPA4(ISSUE_OPA4),
    .ISSUE_OPA5(ISSUE_OPA5),
    .ISSUE_OPA6(ISSUE_OPA6),
    .ISSUE_OPA7(ISSUE_OPA7),
    .ISSUE_OPA8(ISSUE_OPA8),
    .ISSUE_OPA9(ISSUE_OPA9),
    .ISSUE_OPA10(ISSUE_OPA10),
    .ISSUE_OPA11(ISSUE_OPA11),
    .ISSUE_OPA12(ISSUE_OPA12),
    .ISSUE_OPA13(ISSUE_OPA13),
    .ISSUE_OPA14(ISSUE_OPA14),
    .ISSUE_OPA15(ISSUE_OPA15),
    .ISSUE_OPA16(ISSUE_OPA16),
    .ISSUE_OPA17(ISSUE_OPA17),
    .ISSUE_OPA18(ISSUE_OPA18),
    .ISSUE_OPA19(ISSUE_OPA19),
    .ISSUE_OPA20(ISSUE_OPA20),
    .ISSUE_OPA21(ISSUE_OPA21),
    .ISSUE_OPA22(ISSUE_OPA22),
    .ISSUE_OPA23(ISSUE_OPA23),
    .ISSUE_OPA24(ISSUE_OPA24),
    .ISSUE_OPA25(ISSUE_OPA25),
    .ISSUE_OPA26(ISSUE_OPA26),
    .ISSUE_OPA27(ISSUE_OPA27),
    .ISSUE_OPA28(ISSUE_OPA28),
    .ISSUE_OPA29(ISSUE_OPA29),
    .ISSUE_OPA30(ISSUE_OPA30),
    .ISSUE_OPA31(ISSUE_OPA31),
    .ISSUE_OPB0(ISSUE_OPB0),
    .ISSUE_OPB1(ISSUE_OPB1),
    .ISSUE_OPB2(ISSUE_OPB2),
    .ISSUE_OPB3(ISSUE_OPB3),
    .ISSUE_OPB4(ISSUE_OPB4),
    .ISSUE_OPB5(ISSUE_OPB5),
    .ISSUE_OPB6(ISSUE_OPB6),
    .ISSUE_OPB7(ISSUE_OPB7),
    .ISSUE_OPB8(ISSUE_OPB8),
    .ISSUE_OPB9(ISSUE_OPB9),
    .ISSUE_OPB10(ISSUE_OPB10),
    .ISSUE_OPB11(ISSUE_OPB11),
    .ISSUE_OPB12(ISSUE_OPB12),
    .ISSUE_OPB13(ISSUE_OPB13),
    .ISSUE_OPB14(ISSUE_OPB14),
    .ISSUE_OPB15(ISSUE_OPB15),
    .ISSUE_OPB16(ISSUE_OPB16),
    .ISSUE_OPB17(ISSUE_OPB17),
    .ISSUE_OPB18(ISSUE_OPB18),
    .ISSUE_OPB19(ISSUE_OPB19),
    .ISSUE_OPB20(ISSUE_OPB20),
    .ISSUE_OPB21(ISSUE_OPB21),
    .ISSUE_OPB22(ISSUE_OPB22),
    .ISSUE_OPB23(ISSUE_OPB23),
    .ISSUE_OPB24(ISSUE_OPB24),
    .ISSUE_OPB25(ISSUE_OPB25),
    .ISSUE_OPB26(ISSUE_OPB26),
    .ISSUE_OPB27(ISSUE_OPB27),
    .ISSUE_OPB28(ISSUE_OPB28),
    .ISSUE_OPB29(ISSUE_OPB29),
    .ISSUE_OPB30(ISSUE_OPB30),
    .ISSUE_OPB31(ISSUE_OPB31),
    .ISSUE_ID0(ISSUE_ID0),
    .ISSUE_ID1(ISSUE_ID1),
    .ISSUE_ID2(ISSUE_ID2),
    .ISSUE_ID3(ISSUE_ID3),
    .N1BEG0(N1BEG[0]),
    .N1BEG1(N1BEG[1]),
    .N1BEG2(N1BEG[2]),
    .N1BEG3(N1BEG[3]),
    .N2BEG0(N2BEG[0]),
    .N2BEG1(N2BEG[1]),
    .N2BEG2(N2BEG[2]),
    .N2BEG3(N2BEG[3]),
    .N2BEG4(N2BEG[4]),
    .N2BEG5(N2BEG[5]),
    .N2BEG6(N2BEG[6]),
    .N2BEG7(N2BEG[7]),
    .N2BEGb0(N2BEGb[0]),
    .N2BEGb1(N2BEGb[1]),
    .N2BEGb2(N2BEGb[2]),
    .N2BEGb3(N2BEGb[3]),
    .N2BEGb4(N2BEGb[4]),
    .N2BEGb5(N2BEGb[5]),
    .N2BEGb6(N2BEGb[6]),
    .N2BEGb7(N2BEGb[7]),
    .N4BEG0(N4BEG[0]),
    .N4BEG1(N4BEG[1]),
    .N4BEG2(N4BEG[2]),
    .N4BEG3(N4BEG[3]),
    .N4BEG4(N4BEG[4]),
    .N4BEG5(N4BEG[5]),
    .N4BEG6(N4BEG[6]),
    .N4BEG7(N4BEG[7]),
    .N4BEG8(N4BEG[8]),
    .N4BEG9(N4BEG[9]),
    .N4BEG10(N4BEG[10]),
    .N4BEG11(N4BEG[11]),
    .N4BEG12(N4BEG[12]),
    .N4BEG13(N4BEG[13]),
    .N4BEG14(N4BEG[14]),
    .N4BEG15(N4BEG[15]),
    .NN4BEG0(NN4BEG[0]),
    .NN4BEG1(NN4BEG[1]),
    .NN4BEG2(NN4BEG[2]),
    .NN4BEG3(NN4BEG[3]),
    .NN4BEG4(NN4BEG[4]),
    .NN4BEG5(NN4BEG[5]),
    .NN4BEG6(NN4BEG[6]),
    .NN4BEG7(NN4BEG[7]),
    .NN4BEG8(NN4BEG[8]),
    .NN4BEG9(NN4BEG[9]),
    .NN4BEG10(NN4BEG[10]),
    .NN4BEG11(NN4BEG[11]),
    .NN4BEG12(NN4BEG[12]),
    .NN4BEG13(NN4BEG[13]),
    .NN4BEG14(NN4BEG[14]),
    .NN4BEG15(NN4BEG[15]),
    .Co0(Co[0]),
    .middle2left_ISSUE_OPA0(middle2left_ISSUE_OPA[0]),
    .middle2left_ISSUE_OPA1(middle2left_ISSUE_OPA[1]),
    .middle2left_ISSUE_OPA2(middle2left_ISSUE_OPA[2]),
    .middle2left_ISSUE_OPA3(middle2left_ISSUE_OPA[3]),
    .middle2left_ISSUE_OPA4(middle2left_ISSUE_OPA[4]),
    .middle2left_ISSUE_OPA5(middle2left_ISSUE_OPA[5]),
    .middle2left_ISSUE_OPA6(middle2left_ISSUE_OPA[6]),
    .middle2left_ISSUE_OPA7(middle2left_ISSUE_OPA[7]),
    .middle2left_ISSUE_OPA8(middle2left_ISSUE_OPA[8]),
    .middle2left_ISSUE_OPA9(middle2left_ISSUE_OPA[9]),
    .middle2left_ISSUE_OPA10(middle2left_ISSUE_OPA[10]),
    .middle2left_ISSUE_OPA11(middle2left_ISSUE_OPA[11]),
    .middle2left_ISSUE_OPA12(middle2left_ISSUE_OPA[12]),
    .middle2left_ISSUE_OPA13(middle2left_ISSUE_OPA[13]),
    .middle2left_ISSUE_OPA14(middle2left_ISSUE_OPA[14]),
    .middle2left_ISSUE_OPA15(middle2left_ISSUE_OPA[15]),
    .middle2left_ISSUE_OPA16(middle2left_ISSUE_OPA[16]),
    .middle2left_ISSUE_OPA17(middle2left_ISSUE_OPA[17]),
    .middle2left_ISSUE_OPA18(middle2left_ISSUE_OPA[18]),
    .middle2left_ISSUE_OPA19(middle2left_ISSUE_OPA[19]),
    .middle2left_ISSUE_OPA20(middle2left_ISSUE_OPA[20]),
    .middle2left_ISSUE_OPA21(middle2left_ISSUE_OPA[21]),
    .middle2left_ISSUE_OPA22(middle2left_ISSUE_OPA[22]),
    .middle2left_ISSUE_OPA23(middle2left_ISSUE_OPA[23]),
    .middle2left_ISSUE_OPA24(middle2left_ISSUE_OPA[24]),
    .middle2left_ISSUE_OPA25(middle2left_ISSUE_OPA[25]),
    .middle2left_ISSUE_OPA26(middle2left_ISSUE_OPA[26]),
    .middle2left_ISSUE_OPA27(middle2left_ISSUE_OPA[27]),
    .middle2left_ISSUE_OPA28(middle2left_ISSUE_OPA[28]),
    .middle2left_ISSUE_OPA29(middle2left_ISSUE_OPA[29]),
    .middle2left_ISSUE_OPA30(middle2left_ISSUE_OPA[30]),
    .middle2left_ISSUE_OPA31(middle2left_ISSUE_OPA[31]),
    .middle2right_ISSUE_OPB0(middle2right_ISSUE_OPB[0]),
    .middle2right_ISSUE_OPB1(middle2right_ISSUE_OPB[1]),
    .middle2right_ISSUE_OPB2(middle2right_ISSUE_OPB[2]),
    .middle2right_ISSUE_OPB3(middle2right_ISSUE_OPB[3]),
    .middle2right_ISSUE_OPB4(middle2right_ISSUE_OPB[4]),
    .middle2right_ISSUE_OPB5(middle2right_ISSUE_OPB[5]),
    .middle2right_ISSUE_OPB6(middle2right_ISSUE_OPB[6]),
    .middle2right_ISSUE_OPB7(middle2right_ISSUE_OPB[7]),
    .middle2right_ISSUE_OPB8(middle2right_ISSUE_OPB[8]),
    .middle2right_ISSUE_OPB9(middle2right_ISSUE_OPB[9]),
    .middle2right_ISSUE_OPB10(middle2right_ISSUE_OPB[10]),
    .middle2right_ISSUE_OPB11(middle2right_ISSUE_OPB[11]),
    .middle2right_ISSUE_OPB12(middle2right_ISSUE_OPB[12]),
    .middle2right_ISSUE_OPB13(middle2right_ISSUE_OPB[13]),
    .middle2right_ISSUE_OPB14(middle2right_ISSUE_OPB[14]),
    .middle2right_ISSUE_OPB15(middle2right_ISSUE_OPB[15]),
    .middle2right_ISSUE_OPB16(middle2right_ISSUE_OPB[16]),
    .middle2right_ISSUE_OPB17(middle2right_ISSUE_OPB[17]),
    .middle2right_ISSUE_OPB18(middle2right_ISSUE_OPB[18]),
    .middle2right_ISSUE_OPB19(middle2right_ISSUE_OPB[19]),
    .middle2right_ISSUE_OPB20(middle2right_ISSUE_OPB[20]),
    .middle2right_ISSUE_OPB21(middle2right_ISSUE_OPB[21]),
    .middle2right_ISSUE_OPB22(middle2right_ISSUE_OPB[22]),
    .middle2right_ISSUE_OPB23(middle2right_ISSUE_OPB[23]),
    .middle2right_ISSUE_OPB24(middle2right_ISSUE_OPB[24]),
    .middle2right_ISSUE_OPB25(middle2right_ISSUE_OPB[25]),
    .middle2right_ISSUE_OPB26(middle2right_ISSUE_OPB[26]),
    .middle2right_ISSUE_OPB27(middle2right_ISSUE_OPB[27]),
    .middle2right_ISSUE_OPB28(middle2right_ISSUE_OPB[28]),
    .middle2right_ISSUE_OPB29(middle2right_ISSUE_OPB[29]),
    .middle2right_ISSUE_OPB30(middle2right_ISSUE_OPB[30]),
    .middle2right_ISSUE_OPB31(middle2right_ISSUE_OPB[31]),
    .ISSUE_READY(ISSUE_READY),
    .ISSUE_ACCEPT(ISSUE_ACCEPT),
    .RESULT_VALID(RESULT_VALID),
    .RESULT_ID0(RESULT_ID0),
    .RESULT_ID1(RESULT_ID1),
    .RESULT_ID2(RESULT_ID2),
    .RESULT_ID3(RESULT_ID3),
    .RESULT_RD0(RESULT_RD0),
    .RESULT_RD1(RESULT_RD1),
    .RESULT_RD2(RESULT_RD2),
    .RESULT_RD3(RESULT_RD3),
    .RESULT_RD4(RESULT_RD4),
    .RESULT0(RESULT0),
    .RESULT1(RESULT1),
    .RESULT2(RESULT2),
    .RESULT3(RESULT3),
    .RESULT4(RESULT4),
    .RESULT5(RESULT5),
    .RESULT6(RESULT6),
    .RESULT7(RESULT7),
    .RESULT8(RESULT8),
    .RESULT9(RESULT9),
    .RESULT10(RESULT10),
    .RESULT11(RESULT11),
    .RESULT12(RESULT12),
    .RESULT13(RESULT13),
    .RESULT14(RESULT14),
    .RESULT15(RESULT15),
    .RESULT16(RESULT16),
    .RESULT17(RESULT17),
    .RESULT18(RESULT18),
    .RESULT19(RESULT19),
    .RESULT20(RESULT20),
    .RESULT21(RESULT21),
    .RESULT22(RESULT22),
    .RESULT23(RESULT23),
    .RESULT24(RESULT24),
    .RESULT25(RESULT25),
    .RESULT26(RESULT26),
    .RESULT27(RESULT27),
    .RESULT28(RESULT28),
    .RESULT29(RESULT29),
    .RESULT30(RESULT30),
    .RESULT31(RESULT31),
    .ConfigBits(ConfigBits[67-1:0]),
    .ConfigBits_N(ConfigBits_N[67-1:0])
);

endmodule
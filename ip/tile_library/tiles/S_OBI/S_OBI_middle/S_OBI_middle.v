module S_OBI_middle
    #(
`ifdef EMULATION
        parameter [639:0] Emulate_Bitstream=640'b0,
`endif
        parameter MaxFramesPerCol=20,
        parameter FrameBitsPerRow=32,
        parameter NoConfigBits=86
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
        input  [9:0] right2middle_RDATA,        //Port(Name=right2middle_RDATA, IO=INPUT, XOffset=-1, YOffset=0, WireCount=10, Side=EAST)
        output  [9:0] middle2right_WDATA,        //Port(Name=middle2right_WDATA, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=10, Side=EAST)
        output  [9:0] middle2right_ADDR,        //Port(Name=middle2right_ADDR, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=10, Side=EAST)
 //Side.WEST
        input  [9:0] left2middle_RDATA,        //Port(Name=left2middle_RDATA, IO=INPUT, XOffset=1, YOffset=0, WireCount=10, Side=WEST)
        output  [9:0] middle2left_WDATA,        //Port(Name=middle2left_WDATA, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=10, Side=WEST)
        output  [9:0] middle2left_ADDR,        //Port(Name=middle2left_ADDR, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=10, Side=WEST)
        input  REQ_top,
        input  WE_top,
        input  BE_top0,
        input  BE_top1,
        input  BE_top2,
        input  BE_top3,
        input  ADDR_top0,
        input  ADDR_top1,
        input  ADDR_top2,
        input  ADDR_top3,
        input  ADDR_top4,
        input  ADDR_top5,
        input  ADDR_top6,
        input  ADDR_top7,
        input  ADDR_top8,
        input  ADDR_top9,
        input  ADDR_top10,
        input  ADDR_top11,
        input  ADDR_top12,
        input  ADDR_top13,
        input  ADDR_top14,
        input  ADDR_top15,
        input  ADDR_top16,
        input  ADDR_top17,
        input  ADDR_top18,
        input  ADDR_top19,
        input  ADDR_top20,
        input  ADDR_top21,
        input  ADDR_top22,
        input  ADDR_top23,
        input  WDATA_top0,
        input  WDATA_top1,
        input  WDATA_top2,
        input  WDATA_top3,
        input  WDATA_top4,
        input  WDATA_top5,
        input  WDATA_top6,
        input  WDATA_top7,
        input  WDATA_top8,
        input  WDATA_top9,
        input  WDATA_top10,
        input  WDATA_top11,
        input  WDATA_top12,
        input  WDATA_top13,
        input  WDATA_top14,
        input  WDATA_top15,
        input  WDATA_top16,
        input  WDATA_top17,
        input  WDATA_top18,
        input  WDATA_top19,
        input  WDATA_top20,
        input  WDATA_top21,
        input  WDATA_top22,
        input  WDATA_top23,
        input  WDATA_top24,
        input  WDATA_top25,
        input  WDATA_top26,
        input  WDATA_top27,
        input  WDATA_top28,
        input  WDATA_top29,
        input  WDATA_top30,
        input  WDATA_top31,
        output  GNT_top,
        output  RVALID_top,
        output  RDATA_top0,
        output  RDATA_top1,
        output  RDATA_top2,
        output  RDATA_top3,
        output  RDATA_top4,
        output  RDATA_top5,
        output  RDATA_top6,
        output  RDATA_top7,
        output  RDATA_top8,
        output  RDATA_top9,
        output  RDATA_top10,
        output  RDATA_top11,
        output  RDATA_top12,
        output  RDATA_top13,
        output  RDATA_top14,
        output  RDATA_top15,
        output  RDATA_top16,
        output  RDATA_top17,
        output  RDATA_top18,
        output  RDATA_top19,
        output  RDATA_top20,
        output  RDATA_top21,
        output  RDATA_top22,
        output  RDATA_top23,
        output  RDATA_top24,
        output  RDATA_top25,
        output  RDATA_top26,
        output  RDATA_top27,
        output  RDATA_top28,
        output  RDATA_top29,
        output  RDATA_top30,
        output  RDATA_top31,
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
wire GNT;
wire RVALID;
wire RDATA0;
wire RDATA1;
wire RDATA2;
wire RDATA3;
wire RDATA4;
wire RDATA5;
wire RDATA6;
wire RDATA7;
wire RDATA8;
wire RDATA9;
wire RDATA10;
wire RDATA11;
wire RDATA12;
wire RDATA13;
wire RDATA14;
wire RDATA15;
wire RDATA16;
wire RDATA17;
wire RDATA18;
wire RDATA19;
wire RDATA20;
wire RDATA21;
wire RDATA22;
wire RDATA23;
wire RDATA24;
wire RDATA25;
wire RDATA26;
wire RDATA27;
wire RDATA28;
wire RDATA29;
wire RDATA30;
wire RDATA31;
wire REQ;
wire WE;
wire BE0;
wire BE1;
wire BE2;
wire BE3;
wire ADDR0;
wire ADDR1;
wire ADDR2;
wire ADDR3;
wire ADDR4;
wire ADDR5;
wire ADDR6;
wire ADDR7;
wire ADDR8;
wire ADDR9;
wire ADDR10;
wire ADDR11;
wire ADDR12;
wire ADDR13;
wire ADDR14;
wire ADDR15;
wire ADDR16;
wire ADDR17;
wire ADDR18;
wire ADDR19;
wire ADDR20;
wire ADDR21;
wire ADDR22;
wire ADDR23;
wire WDATA0;
wire WDATA1;
wire WDATA2;
wire WDATA3;
wire WDATA4;
wire WDATA5;
wire WDATA6;
wire WDATA7;
wire WDATA8;
wire WDATA9;
wire WDATA10;
wire WDATA11;
wire WDATA12;
wire WDATA13;
wire WDATA14;
wire WDATA15;
wire WDATA16;
wire WDATA17;
wire WDATA18;
wire WDATA19;
wire WDATA20;
wire WDATA21;
wire WDATA22;
wire WDATA23;
wire WDATA24;
wire WDATA25;
wire WDATA26;
wire WDATA27;
wire WDATA28;
wire WDATA29;
wire WDATA30;
wire WDATA31;
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
S_OBI_middle_ConfigMem
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Emulate_Bitstream)
    )
`endif
    Inst_S_OBI_middle_ConfigMem
    (
    .FrameData(FrameData),
    .FrameStrobe(FrameStrobe),
    .ConfigBits(ConfigBits),
    .ConfigBits_N(ConfigBits_N)
);


 //BEL component instantiations
OBI_PERIPHERAL Inst_OBI_PERIPHERAL (
    .GNT(GNT),
    .RVALID(RVALID),
    .RDATA({RDATA31, RDATA30, RDATA29, RDATA28, RDATA27, RDATA26, RDATA25, RDATA24, RDATA23, RDATA22, RDATA21, RDATA20, RDATA19, RDATA18, RDATA17, RDATA16, RDATA15, RDATA14, RDATA13, RDATA12, RDATA11, RDATA10, RDATA9, RDATA8, RDATA7, RDATA6, RDATA5, RDATA4, RDATA3, RDATA2, RDATA1, RDATA0}),
    .REQ(REQ),
    .WE(WE),
    .BE({BE3, BE2, BE1, BE0}),
    .ADDR({ADDR23, ADDR22, ADDR21, ADDR20, ADDR19, ADDR18, ADDR17, ADDR16, ADDR15, ADDR14, ADDR13, ADDR12, ADDR11, ADDR10, ADDR9, ADDR8, ADDR7, ADDR6, ADDR5, ADDR4, ADDR3, ADDR2, ADDR1, ADDR0}),
    .WDATA({WDATA31, WDATA30, WDATA29, WDATA28, WDATA27, WDATA26, WDATA25, WDATA24, WDATA23, WDATA22, WDATA21, WDATA20, WDATA19, WDATA18, WDATA17, WDATA16, WDATA15, WDATA14, WDATA13, WDATA12, WDATA11, WDATA10, WDATA9, WDATA8, WDATA7, WDATA6, WDATA5, WDATA4, WDATA3, WDATA2, WDATA1, WDATA0}),
    .REQ_top(REQ_top),
    .WE_top(WE_top),
    .BE_top({BE_top3, BE_top2, BE_top1, BE_top0}),
    .ADDR_top({ADDR_top23, ADDR_top22, ADDR_top21, ADDR_top20, ADDR_top19, ADDR_top18, ADDR_top17, ADDR_top16, ADDR_top15, ADDR_top14, ADDR_top13, ADDR_top12, ADDR_top11, ADDR_top10, ADDR_top9, ADDR_top8, ADDR_top7, ADDR_top6, ADDR_top5, ADDR_top4, ADDR_top3, ADDR_top2, ADDR_top1, ADDR_top0}),
    .WDATA_top({WDATA_top31, WDATA_top30, WDATA_top29, WDATA_top28, WDATA_top27, WDATA_top26, WDATA_top25, WDATA_top24, WDATA_top23, WDATA_top22, WDATA_top21, WDATA_top20, WDATA_top19, WDATA_top18, WDATA_top17, WDATA_top16, WDATA_top15, WDATA_top14, WDATA_top13, WDATA_top12, WDATA_top11, WDATA_top10, WDATA_top9, WDATA_top8, WDATA_top7, WDATA_top6, WDATA_top5, WDATA_top4, WDATA_top3, WDATA_top2, WDATA_top1, WDATA_top0}),
    .GNT_top(GNT_top),
    .RVALID_top(RVALID_top),
    .RDATA_top({RDATA_top31, RDATA_top30, RDATA_top29, RDATA_top28, RDATA_top27, RDATA_top26, RDATA_top25, RDATA_top24, RDATA_top23, RDATA_top22, RDATA_top21, RDATA_top20, RDATA_top19, RDATA_top18, RDATA_top17, RDATA_top16, RDATA_top15, RDATA_top14, RDATA_top13, RDATA_top12, RDATA_top11, RDATA_top10, RDATA_top9, RDATA_top8, RDATA_top7, RDATA_top6, RDATA_top5, RDATA_top4, RDATA_top3, RDATA_top2, RDATA_top1, RDATA_top0})
);

S_OBI_middle_switch_matrix Inst_S_OBI_middle_switch_matrix (
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
    .left2middle_RDATA0(left2middle_RDATA[0]),
    .left2middle_RDATA1(left2middle_RDATA[1]),
    .left2middle_RDATA2(left2middle_RDATA[2]),
    .left2middle_RDATA3(left2middle_RDATA[3]),
    .left2middle_RDATA4(left2middle_RDATA[4]),
    .left2middle_RDATA5(left2middle_RDATA[5]),
    .left2middle_RDATA6(left2middle_RDATA[6]),
    .left2middle_RDATA7(left2middle_RDATA[7]),
    .left2middle_RDATA8(left2middle_RDATA[8]),
    .left2middle_RDATA9(left2middle_RDATA[9]),
    .right2middle_RDATA0(right2middle_RDATA[0]),
    .right2middle_RDATA1(right2middle_RDATA[1]),
    .right2middle_RDATA2(right2middle_RDATA[2]),
    .right2middle_RDATA3(right2middle_RDATA[3]),
    .right2middle_RDATA4(right2middle_RDATA[4]),
    .right2middle_RDATA5(right2middle_RDATA[5]),
    .right2middle_RDATA6(right2middle_RDATA[6]),
    .right2middle_RDATA7(right2middle_RDATA[7]),
    .right2middle_RDATA8(right2middle_RDATA[8]),
    .right2middle_RDATA9(right2middle_RDATA[9]),
    .REQ(REQ),
    .WE(WE),
    .BE0(BE0),
    .BE1(BE1),
    .BE2(BE2),
    .BE3(BE3),
    .ADDR0(ADDR0),
    .ADDR1(ADDR1),
    .ADDR2(ADDR2),
    .ADDR3(ADDR3),
    .ADDR4(ADDR4),
    .ADDR5(ADDR5),
    .ADDR6(ADDR6),
    .ADDR7(ADDR7),
    .ADDR8(ADDR8),
    .ADDR9(ADDR9),
    .ADDR10(ADDR10),
    .ADDR11(ADDR11),
    .ADDR12(ADDR12),
    .ADDR13(ADDR13),
    .ADDR14(ADDR14),
    .ADDR15(ADDR15),
    .ADDR16(ADDR16),
    .ADDR17(ADDR17),
    .ADDR18(ADDR18),
    .ADDR19(ADDR19),
    .ADDR20(ADDR20),
    .ADDR21(ADDR21),
    .ADDR22(ADDR22),
    .ADDR23(ADDR23),
    .WDATA0(WDATA0),
    .WDATA1(WDATA1),
    .WDATA2(WDATA2),
    .WDATA3(WDATA3),
    .WDATA4(WDATA4),
    .WDATA5(WDATA5),
    .WDATA6(WDATA6),
    .WDATA7(WDATA7),
    .WDATA8(WDATA8),
    .WDATA9(WDATA9),
    .WDATA10(WDATA10),
    .WDATA11(WDATA11),
    .WDATA12(WDATA12),
    .WDATA13(WDATA13),
    .WDATA14(WDATA14),
    .WDATA15(WDATA15),
    .WDATA16(WDATA16),
    .WDATA17(WDATA17),
    .WDATA18(WDATA18),
    .WDATA19(WDATA19),
    .WDATA20(WDATA20),
    .WDATA21(WDATA21),
    .WDATA22(WDATA22),
    .WDATA23(WDATA23),
    .WDATA24(WDATA24),
    .WDATA25(WDATA25),
    .WDATA26(WDATA26),
    .WDATA27(WDATA27),
    .WDATA28(WDATA28),
    .WDATA29(WDATA29),
    .WDATA30(WDATA30),
    .WDATA31(WDATA31),
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
    .middle2left_WDATA0(middle2left_WDATA[0]),
    .middle2left_WDATA1(middle2left_WDATA[1]),
    .middle2left_WDATA2(middle2left_WDATA[2]),
    .middle2left_WDATA3(middle2left_WDATA[3]),
    .middle2left_WDATA4(middle2left_WDATA[4]),
    .middle2left_WDATA5(middle2left_WDATA[5]),
    .middle2left_WDATA6(middle2left_WDATA[6]),
    .middle2left_WDATA7(middle2left_WDATA[7]),
    .middle2left_WDATA8(middle2left_WDATA[8]),
    .middle2left_WDATA9(middle2left_WDATA[9]),
    .middle2left_ADDR0(middle2left_ADDR[0]),
    .middle2left_ADDR1(middle2left_ADDR[1]),
    .middle2left_ADDR2(middle2left_ADDR[2]),
    .middle2left_ADDR3(middle2left_ADDR[3]),
    .middle2left_ADDR4(middle2left_ADDR[4]),
    .middle2left_ADDR5(middle2left_ADDR[5]),
    .middle2left_ADDR6(middle2left_ADDR[6]),
    .middle2left_ADDR7(middle2left_ADDR[7]),
    .middle2left_ADDR8(middle2left_ADDR[8]),
    .middle2left_ADDR9(middle2left_ADDR[9]),
    .middle2right_WDATA0(middle2right_WDATA[0]),
    .middle2right_WDATA1(middle2right_WDATA[1]),
    .middle2right_WDATA2(middle2right_WDATA[2]),
    .middle2right_WDATA3(middle2right_WDATA[3]),
    .middle2right_WDATA4(middle2right_WDATA[4]),
    .middle2right_WDATA5(middle2right_WDATA[5]),
    .middle2right_WDATA6(middle2right_WDATA[6]),
    .middle2right_WDATA7(middle2right_WDATA[7]),
    .middle2right_WDATA8(middle2right_WDATA[8]),
    .middle2right_WDATA9(middle2right_WDATA[9]),
    .middle2right_ADDR0(middle2right_ADDR[0]),
    .middle2right_ADDR1(middle2right_ADDR[1]),
    .middle2right_ADDR2(middle2right_ADDR[2]),
    .middle2right_ADDR3(middle2right_ADDR[3]),
    .middle2right_ADDR4(middle2right_ADDR[4]),
    .middle2right_ADDR5(middle2right_ADDR[5]),
    .middle2right_ADDR6(middle2right_ADDR[6]),
    .middle2right_ADDR7(middle2right_ADDR[7]),
    .middle2right_ADDR8(middle2right_ADDR[8]),
    .middle2right_ADDR9(middle2right_ADDR[9]),
    .GNT(GNT),
    .RVALID(RVALID),
    .RDATA0(RDATA0),
    .RDATA1(RDATA1),
    .RDATA2(RDATA2),
    .RDATA3(RDATA3),
    .RDATA4(RDATA4),
    .RDATA5(RDATA5),
    .RDATA6(RDATA6),
    .RDATA7(RDATA7),
    .RDATA8(RDATA8),
    .RDATA9(RDATA9),
    .RDATA10(RDATA10),
    .RDATA11(RDATA11),
    .RDATA12(RDATA12),
    .RDATA13(RDATA13),
    .RDATA14(RDATA14),
    .RDATA15(RDATA15),
    .RDATA16(RDATA16),
    .RDATA17(RDATA17),
    .RDATA18(RDATA18),
    .RDATA19(RDATA19),
    .RDATA20(RDATA20),
    .RDATA21(RDATA21),
    .RDATA22(RDATA22),
    .RDATA23(RDATA23),
    .RDATA24(RDATA24),
    .RDATA25(RDATA25),
    .RDATA26(RDATA26),
    .RDATA27(RDATA27),
    .RDATA28(RDATA28),
    .RDATA29(RDATA29),
    .RDATA30(RDATA30),
    .RDATA31(RDATA31),
    .ConfigBits(ConfigBits[86-1:0]),
    .ConfigBits_N(ConfigBits_N[86-1:0])
);

endmodule
module S_OBI
    #(
`ifdef EMULATION
        parameter [639:0] Tile_X0Y0_Emulate_Bitstream=640'b0,
        parameter [639:0] Tile_X1Y0_Emulate_Bitstream=640'b0,
        parameter [639:0] Tile_X2Y0_Emulate_Bitstream=640'b0,
`endif
        parameter MaxFramesPerCol=20,
        parameter FrameBitsPerRow=32
    )
    (
    //Tile_X0Y0_Direction.NORTH
        output  [3:0] Tile_X0Y0_N1BEG, //Port(Name=N1BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=4, Side=NORTH)
        output  [7:0] Tile_X0Y0_N2BEG, //Port(Name=N2BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [7:0] Tile_X0Y0_N2BEGb, //Port(Name=N2BEGb, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [15:0] Tile_X0Y0_N4BEG, //Port(Name=N4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [15:0] Tile_X0Y0_NN4BEG, //Port(Name=NN4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [0:0] Tile_X0Y0_Co, //Port(Name=Co, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=1, Side=NORTH)
        input  [3:0] Tile_X0Y0_S1END, //Port(Name=S1END, IO=INPUT, XOffset=0, YOffset=1, WireCount=4, Side=NORTH)
        input  [7:0] Tile_X0Y0_S2MID, //Port(Name=S2MID, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [7:0] Tile_X0Y0_S2END, //Port(Name=S2END, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [15:0] Tile_X0Y0_S4END, //Port(Name=S4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
        input  [15:0] Tile_X0Y0_SS4END, //Port(Name=SS4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
    //Tile_X1Y0_Direction.NORTH
        output  [3:0] Tile_X1Y0_N1BEG, //Port(Name=N1BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=4, Side=NORTH)
        output  [7:0] Tile_X1Y0_N2BEG, //Port(Name=N2BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [7:0] Tile_X1Y0_N2BEGb, //Port(Name=N2BEGb, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [15:0] Tile_X1Y0_N4BEG, //Port(Name=N4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [15:0] Tile_X1Y0_NN4BEG, //Port(Name=NN4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [0:0] Tile_X1Y0_Co, //Port(Name=Co, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=1, Side=NORTH)
        input  [3:0] Tile_X1Y0_S1END, //Port(Name=S1END, IO=INPUT, XOffset=0, YOffset=1, WireCount=4, Side=NORTH)
        input  [7:0] Tile_X1Y0_S2MID, //Port(Name=S2MID, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [7:0] Tile_X1Y0_S2END, //Port(Name=S2END, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [15:0] Tile_X1Y0_S4END, //Port(Name=S4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
        input  [15:0] Tile_X1Y0_SS4END, //Port(Name=SS4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
    //Tile_X2Y0_Direction.NORTH
        output  [3:0] Tile_X2Y0_N1BEG, //Port(Name=N1BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=4, Side=NORTH)
        output  [7:0] Tile_X2Y0_N2BEG, //Port(Name=N2BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [7:0] Tile_X2Y0_N2BEGb, //Port(Name=N2BEGb, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
        output  [15:0] Tile_X2Y0_N4BEG, //Port(Name=N4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [15:0] Tile_X2Y0_NN4BEG, //Port(Name=NN4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
        output  [0:0] Tile_X2Y0_Co, //Port(Name=Co, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=1, Side=NORTH)
        input  [3:0] Tile_X2Y0_S1END, //Port(Name=S1END, IO=INPUT, XOffset=0, YOffset=1, WireCount=4, Side=NORTH)
        input  [7:0] Tile_X2Y0_S2MID, //Port(Name=S2MID, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [7:0] Tile_X2Y0_S2END, //Port(Name=S2END, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [15:0] Tile_X2Y0_S4END, //Port(Name=S4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
        input  [15:0] Tile_X2Y0_SS4END, //Port(Name=SS4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
    //Tile IO ports from BELs
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
        output  [MaxFramesPerCol-1:0] Tile_X0Y0_FrameStrobe_O, //CONFIG_PORT
        input  [FrameBitsPerRow-1:0] Tile_X0Y0_FrameData, //CONFIG_PORT
        input  [MaxFramesPerCol-1:0] Tile_X0Y0_FrameStrobe, //CONFIG_PORT
        output  [MaxFramesPerCol-1:0] Tile_X1Y0_FrameStrobe_O, //CONFIG_PORT
        input  [MaxFramesPerCol-1:0] Tile_X1Y0_FrameStrobe, //CONFIG_PORT
        output  [MaxFramesPerCol-1:0] Tile_X2Y0_FrameStrobe_O, //CONFIG_PORT
        input  [MaxFramesPerCol-1:0] Tile_X2Y0_FrameStrobe, //CONFIG_PORT
        output  [FrameBitsPerRow-1:0] Tile_X2Y0_FrameData_O, //CONFIG_PORT
        output  Tile_X0Y0_UserCLKo,
        input  Tile_X0Y0_UserCLK,
        output  Tile_X1Y0_UserCLKo,
        input  Tile_X1Y0_UserCLK,
        output  Tile_X2Y0_UserCLKo,
        input  Tile_X2Y0_UserCLK
);

 //signal declarations
 //Tile_X0Y0_Direction.EAST
    wire[9:0] Tile_X0Y0_left2middle_RDATA; //Port(Name=left2middle_RDATA, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=10, Side=EAST)
 //Tile_X1Y0_Direction.WEST
    wire[9:0] Tile_X1Y0_middle2right_WDATA; //Port(Name=middle2right_WDATA, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=10, Side=EAST)
    wire[9:0] Tile_X1Y0_middle2right_ADDR; //Port(Name=middle2right_ADDR, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=10, Side=EAST)
 //Tile_X1Y0_Direction.EAST
    wire[9:0] Tile_X1Y0_middle2left_WDATA; //Port(Name=middle2left_WDATA, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=10, Side=WEST)
    wire[9:0] Tile_X1Y0_middle2left_ADDR; //Port(Name=middle2left_ADDR, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=10, Side=WEST)
 //Tile_X2Y0_Direction.WEST
    wire[9:0] Tile_X2Y0_right2middle_RDATA; //Port(Name=right2middle_RDATA, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=10, Side=WEST)
    wire[FrameBitsPerRow-1:0] Tile_X0Y0_FrameData_O;
    wire[FrameBitsPerRow-1:0] Tile_X1Y0_FrameData_O;

S_OBI_left
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X0Y0_Emulate_Bitstream)
    )
`endif
    Tile_X0Y0_S_OBI_left
    (
    .S1END(Tile_X0Y0_S1END),
    .S2MID(Tile_X0Y0_S2MID),
    .S2END(Tile_X0Y0_S2END),
    .S4END(Tile_X0Y0_S4END),
    .SS4END(Tile_X0Y0_SS4END),
    .middle2left_WDATA(Tile_X1Y0_middle2left_WDATA),
    .middle2left_ADDR(Tile_X1Y0_middle2left_ADDR),
    .N1BEG(Tile_X0Y0_N1BEG),
    .N2BEG(Tile_X0Y0_N2BEG),
    .N2BEGb(Tile_X0Y0_N2BEGb),
    .N4BEG(Tile_X0Y0_N4BEG),
    .NN4BEG(Tile_X0Y0_NN4BEG),
    .Co(Tile_X0Y0_Co),
    .left2middle_RDATA(Tile_X0Y0_left2middle_RDATA),
    .UserCLK(Tile_X0Y0_UserCLK),
    .UserCLKo(Tile_X0Y0_UserCLKo),
    .FrameData(Tile_X0Y0_FrameData),
    .FrameData_O(Tile_X0Y0_FrameData_O),
    .FrameStrobe(Tile_X0Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X0Y0_FrameStrobe_O)
);

S_OBI_middle
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X1Y0_Emulate_Bitstream)
    )
`endif
    Tile_X1Y0_S_OBI_middle
    (
    .left2middle_RDATA(Tile_X0Y0_left2middle_RDATA),
    .S1END(Tile_X1Y0_S1END),
    .S2MID(Tile_X1Y0_S2MID),
    .S2END(Tile_X1Y0_S2END),
    .S4END(Tile_X1Y0_S4END),
    .SS4END(Tile_X1Y0_SS4END),
    .right2middle_RDATA(Tile_X2Y0_right2middle_RDATA),
    .N1BEG(Tile_X1Y0_N1BEG),
    .N2BEG(Tile_X1Y0_N2BEG),
    .N2BEGb(Tile_X1Y0_N2BEGb),
    .N4BEG(Tile_X1Y0_N4BEG),
    .NN4BEG(Tile_X1Y0_NN4BEG),
    .Co(Tile_X1Y0_Co),
    .middle2right_WDATA(Tile_X1Y0_middle2right_WDATA),
    .middle2right_ADDR(Tile_X1Y0_middle2right_ADDR),
    .middle2left_WDATA(Tile_X1Y0_middle2left_WDATA),
    .middle2left_ADDR(Tile_X1Y0_middle2left_ADDR),
    .REQ_top(REQ_top),
    .WE_top(WE_top),
    .BE_top0(BE_top0),
    .BE_top1(BE_top1),
    .BE_top2(BE_top2),
    .BE_top3(BE_top3),
    .ADDR_top0(ADDR_top0),
    .ADDR_top1(ADDR_top1),
    .ADDR_top2(ADDR_top2),
    .ADDR_top3(ADDR_top3),
    .ADDR_top4(ADDR_top4),
    .ADDR_top5(ADDR_top5),
    .ADDR_top6(ADDR_top6),
    .ADDR_top7(ADDR_top7),
    .ADDR_top8(ADDR_top8),
    .ADDR_top9(ADDR_top9),
    .ADDR_top10(ADDR_top10),
    .ADDR_top11(ADDR_top11),
    .ADDR_top12(ADDR_top12),
    .ADDR_top13(ADDR_top13),
    .ADDR_top14(ADDR_top14),
    .ADDR_top15(ADDR_top15),
    .ADDR_top16(ADDR_top16),
    .ADDR_top17(ADDR_top17),
    .ADDR_top18(ADDR_top18),
    .ADDR_top19(ADDR_top19),
    .ADDR_top20(ADDR_top20),
    .ADDR_top21(ADDR_top21),
    .ADDR_top22(ADDR_top22),
    .ADDR_top23(ADDR_top23),
    .WDATA_top0(WDATA_top0),
    .WDATA_top1(WDATA_top1),
    .WDATA_top2(WDATA_top2),
    .WDATA_top3(WDATA_top3),
    .WDATA_top4(WDATA_top4),
    .WDATA_top5(WDATA_top5),
    .WDATA_top6(WDATA_top6),
    .WDATA_top7(WDATA_top7),
    .WDATA_top8(WDATA_top8),
    .WDATA_top9(WDATA_top9),
    .WDATA_top10(WDATA_top10),
    .WDATA_top11(WDATA_top11),
    .WDATA_top12(WDATA_top12),
    .WDATA_top13(WDATA_top13),
    .WDATA_top14(WDATA_top14),
    .WDATA_top15(WDATA_top15),
    .WDATA_top16(WDATA_top16),
    .WDATA_top17(WDATA_top17),
    .WDATA_top18(WDATA_top18),
    .WDATA_top19(WDATA_top19),
    .WDATA_top20(WDATA_top20),
    .WDATA_top21(WDATA_top21),
    .WDATA_top22(WDATA_top22),
    .WDATA_top23(WDATA_top23),
    .WDATA_top24(WDATA_top24),
    .WDATA_top25(WDATA_top25),
    .WDATA_top26(WDATA_top26),
    .WDATA_top27(WDATA_top27),
    .WDATA_top28(WDATA_top28),
    .WDATA_top29(WDATA_top29),
    .WDATA_top30(WDATA_top30),
    .WDATA_top31(WDATA_top31),
    .GNT_top(GNT_top),
    .RVALID_top(RVALID_top),
    .RDATA_top0(RDATA_top0),
    .RDATA_top1(RDATA_top1),
    .RDATA_top2(RDATA_top2),
    .RDATA_top3(RDATA_top3),
    .RDATA_top4(RDATA_top4),
    .RDATA_top5(RDATA_top5),
    .RDATA_top6(RDATA_top6),
    .RDATA_top7(RDATA_top7),
    .RDATA_top8(RDATA_top8),
    .RDATA_top9(RDATA_top9),
    .RDATA_top10(RDATA_top10),
    .RDATA_top11(RDATA_top11),
    .RDATA_top12(RDATA_top12),
    .RDATA_top13(RDATA_top13),
    .RDATA_top14(RDATA_top14),
    .RDATA_top15(RDATA_top15),
    .RDATA_top16(RDATA_top16),
    .RDATA_top17(RDATA_top17),
    .RDATA_top18(RDATA_top18),
    .RDATA_top19(RDATA_top19),
    .RDATA_top20(RDATA_top20),
    .RDATA_top21(RDATA_top21),
    .RDATA_top22(RDATA_top22),
    .RDATA_top23(RDATA_top23),
    .RDATA_top24(RDATA_top24),
    .RDATA_top25(RDATA_top25),
    .RDATA_top26(RDATA_top26),
    .RDATA_top27(RDATA_top27),
    .RDATA_top28(RDATA_top28),
    .RDATA_top29(RDATA_top29),
    .RDATA_top30(RDATA_top30),
    .RDATA_top31(RDATA_top31),
    .UserCLK(Tile_X1Y0_UserCLK),
    .UserCLKo(Tile_X1Y0_UserCLKo),
    .FrameData(Tile_X0Y0_FrameData_O),
    .FrameData_O(Tile_X1Y0_FrameData_O),
    .FrameStrobe(Tile_X1Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X1Y0_FrameStrobe_O)
);

S_OBI_right
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X2Y0_Emulate_Bitstream)
    )
`endif
    Tile_X2Y0_S_OBI_right
    (
    .middle2right_WDATA(Tile_X1Y0_middle2right_WDATA),
    .middle2right_ADDR(Tile_X1Y0_middle2right_ADDR),
    .S1END(Tile_X2Y0_S1END),
    .S2MID(Tile_X2Y0_S2MID),
    .S2END(Tile_X2Y0_S2END),
    .S4END(Tile_X2Y0_S4END),
    .SS4END(Tile_X2Y0_SS4END),
    .N1BEG(Tile_X2Y0_N1BEG),
    .N2BEG(Tile_X2Y0_N2BEG),
    .N2BEGb(Tile_X2Y0_N2BEGb),
    .N4BEG(Tile_X2Y0_N4BEG),
    .NN4BEG(Tile_X2Y0_NN4BEG),
    .Co(Tile_X2Y0_Co),
    .right2middle_RDATA(Tile_X2Y0_right2middle_RDATA),
    .UserCLK(Tile_X2Y0_UserCLK),
    .UserCLKo(Tile_X2Y0_UserCLKo),
    .FrameData(Tile_X1Y0_FrameData_O),
    .FrameData_O(Tile_X2Y0_FrameData_O),
    .FrameStrobe(Tile_X2Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X2Y0_FrameStrobe_O)
);

endmodule
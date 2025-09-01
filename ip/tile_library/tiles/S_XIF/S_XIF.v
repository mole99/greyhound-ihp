module S_XIF
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
    wire[15:0] Tile_X0Y0_left2middle_RESULT; //Port(Name=left2middle_RESULT, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=16, Side=EAST)
 //Tile_X1Y0_Direction.WEST
    wire[31:0] Tile_X1Y0_middle2right_ISSUE_OPB; //Port(Name=middle2right_ISSUE_OPB, IO=OUTPUT, XOffset=1, YOffset=0, WireCount=32, Side=EAST)
 //Tile_X1Y0_Direction.EAST
    wire[31:0] Tile_X1Y0_middle2left_ISSUE_OPA; //Port(Name=middle2left_ISSUE_OPA, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=32, Side=WEST)
 //Tile_X2Y0_Direction.WEST
    wire[15:0] Tile_X2Y0_right2middle_RESULT; //Port(Name=right2middle_RESULT, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=16, Side=WEST)
    wire[FrameBitsPerRow-1:0] Tile_X0Y0_FrameData_O;
    wire[FrameBitsPerRow-1:0] Tile_X1Y0_FrameData_O;

S_XIF_left
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X0Y0_Emulate_Bitstream)
    )
`endif
    Tile_X0Y0_S_XIF_left
    (
    .S1END(Tile_X0Y0_S1END),
    .S2MID(Tile_X0Y0_S2MID),
    .S2END(Tile_X0Y0_S2END),
    .S4END(Tile_X0Y0_S4END),
    .SS4END(Tile_X0Y0_SS4END),
    .middle2left_ISSUE_OPA(Tile_X1Y0_middle2left_ISSUE_OPA),
    .N1BEG(Tile_X0Y0_N1BEG),
    .N2BEG(Tile_X0Y0_N2BEG),
    .N2BEGb(Tile_X0Y0_N2BEGb),
    .N4BEG(Tile_X0Y0_N4BEG),
    .NN4BEG(Tile_X0Y0_NN4BEG),
    .Co(Tile_X0Y0_Co),
    .left2middle_RESULT(Tile_X0Y0_left2middle_RESULT),
    .UserCLK(Tile_X0Y0_UserCLK),
    .UserCLKo(Tile_X0Y0_UserCLKo),
    .FrameData(Tile_X0Y0_FrameData),
    .FrameData_O(Tile_X0Y0_FrameData_O),
    .FrameStrobe(Tile_X0Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X0Y0_FrameStrobe_O)
);

S_XIF_middle
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X1Y0_Emulate_Bitstream)
    )
`endif
    Tile_X1Y0_S_XIF_middle
    (
    .left2middle_RESULT(Tile_X0Y0_left2middle_RESULT),
    .S1END(Tile_X1Y0_S1END),
    .S2MID(Tile_X1Y0_S2MID),
    .S2END(Tile_X1Y0_S2END),
    .S4END(Tile_X1Y0_S4END),
    .SS4END(Tile_X1Y0_SS4END),
    .right2middle_RESULT(Tile_X2Y0_right2middle_RESULT),
    .N1BEG(Tile_X1Y0_N1BEG),
    .N2BEG(Tile_X1Y0_N2BEG),
    .N2BEGb(Tile_X1Y0_N2BEGb),
    .N4BEG(Tile_X1Y0_N4BEG),
    .NN4BEG(Tile_X1Y0_NN4BEG),
    .Co(Tile_X1Y0_Co),
    .middle2right_ISSUE_OPB(Tile_X1Y0_middle2right_ISSUE_OPB),
    .middle2left_ISSUE_OPA(Tile_X1Y0_middle2left_ISSUE_OPA),
    .ISSUE_VALID_top(ISSUE_VALID_top),
    .ISSUE_INSTR_top0(ISSUE_INSTR_top0),
    .ISSUE_INSTR_top1(ISSUE_INSTR_top1),
    .ISSUE_INSTR_top2(ISSUE_INSTR_top2),
    .ISSUE_INSTR_top3(ISSUE_INSTR_top3),
    .ISSUE_INSTR_top4(ISSUE_INSTR_top4),
    .ISSUE_INSTR_top5(ISSUE_INSTR_top5),
    .ISSUE_INSTR_top6(ISSUE_INSTR_top6),
    .ISSUE_INSTR_top7(ISSUE_INSTR_top7),
    .ISSUE_INSTR_top8(ISSUE_INSTR_top8),
    .ISSUE_INSTR_top9(ISSUE_INSTR_top9),
    .ISSUE_INSTR_top10(ISSUE_INSTR_top10),
    .ISSUE_INSTR_top11(ISSUE_INSTR_top11),
    .ISSUE_INSTR_top12(ISSUE_INSTR_top12),
    .ISSUE_INSTR_top13(ISSUE_INSTR_top13),
    .ISSUE_INSTR_top14(ISSUE_INSTR_top14),
    .ISSUE_INSTR_top15(ISSUE_INSTR_top15),
    .ISSUE_INSTR_top16(ISSUE_INSTR_top16),
    .ISSUE_INSTR_top17(ISSUE_INSTR_top17),
    .ISSUE_INSTR_top18(ISSUE_INSTR_top18),
    .ISSUE_INSTR_top19(ISSUE_INSTR_top19),
    .ISSUE_INSTR_top20(ISSUE_INSTR_top20),
    .ISSUE_INSTR_top21(ISSUE_INSTR_top21),
    .ISSUE_INSTR_top22(ISSUE_INSTR_top22),
    .ISSUE_INSTR_top23(ISSUE_INSTR_top23),
    .ISSUE_INSTR_top24(ISSUE_INSTR_top24),
    .ISSUE_INSTR_top25(ISSUE_INSTR_top25),
    .ISSUE_INSTR_top26(ISSUE_INSTR_top26),
    .ISSUE_INSTR_top27(ISSUE_INSTR_top27),
    .ISSUE_INSTR_top28(ISSUE_INSTR_top28),
    .ISSUE_INSTR_top29(ISSUE_INSTR_top29),
    .ISSUE_INSTR_top30(ISSUE_INSTR_top30),
    .ISSUE_INSTR_top31(ISSUE_INSTR_top31),
    .ISSUE_OPA_top0(ISSUE_OPA_top0),
    .ISSUE_OPA_top1(ISSUE_OPA_top1),
    .ISSUE_OPA_top2(ISSUE_OPA_top2),
    .ISSUE_OPA_top3(ISSUE_OPA_top3),
    .ISSUE_OPA_top4(ISSUE_OPA_top4),
    .ISSUE_OPA_top5(ISSUE_OPA_top5),
    .ISSUE_OPA_top6(ISSUE_OPA_top6),
    .ISSUE_OPA_top7(ISSUE_OPA_top7),
    .ISSUE_OPA_top8(ISSUE_OPA_top8),
    .ISSUE_OPA_top9(ISSUE_OPA_top9),
    .ISSUE_OPA_top10(ISSUE_OPA_top10),
    .ISSUE_OPA_top11(ISSUE_OPA_top11),
    .ISSUE_OPA_top12(ISSUE_OPA_top12),
    .ISSUE_OPA_top13(ISSUE_OPA_top13),
    .ISSUE_OPA_top14(ISSUE_OPA_top14),
    .ISSUE_OPA_top15(ISSUE_OPA_top15),
    .ISSUE_OPA_top16(ISSUE_OPA_top16),
    .ISSUE_OPA_top17(ISSUE_OPA_top17),
    .ISSUE_OPA_top18(ISSUE_OPA_top18),
    .ISSUE_OPA_top19(ISSUE_OPA_top19),
    .ISSUE_OPA_top20(ISSUE_OPA_top20),
    .ISSUE_OPA_top21(ISSUE_OPA_top21),
    .ISSUE_OPA_top22(ISSUE_OPA_top22),
    .ISSUE_OPA_top23(ISSUE_OPA_top23),
    .ISSUE_OPA_top24(ISSUE_OPA_top24),
    .ISSUE_OPA_top25(ISSUE_OPA_top25),
    .ISSUE_OPA_top26(ISSUE_OPA_top26),
    .ISSUE_OPA_top27(ISSUE_OPA_top27),
    .ISSUE_OPA_top28(ISSUE_OPA_top28),
    .ISSUE_OPA_top29(ISSUE_OPA_top29),
    .ISSUE_OPA_top30(ISSUE_OPA_top30),
    .ISSUE_OPA_top31(ISSUE_OPA_top31),
    .ISSUE_OPB_top0(ISSUE_OPB_top0),
    .ISSUE_OPB_top1(ISSUE_OPB_top1),
    .ISSUE_OPB_top2(ISSUE_OPB_top2),
    .ISSUE_OPB_top3(ISSUE_OPB_top3),
    .ISSUE_OPB_top4(ISSUE_OPB_top4),
    .ISSUE_OPB_top5(ISSUE_OPB_top5),
    .ISSUE_OPB_top6(ISSUE_OPB_top6),
    .ISSUE_OPB_top7(ISSUE_OPB_top7),
    .ISSUE_OPB_top8(ISSUE_OPB_top8),
    .ISSUE_OPB_top9(ISSUE_OPB_top9),
    .ISSUE_OPB_top10(ISSUE_OPB_top10),
    .ISSUE_OPB_top11(ISSUE_OPB_top11),
    .ISSUE_OPB_top12(ISSUE_OPB_top12),
    .ISSUE_OPB_top13(ISSUE_OPB_top13),
    .ISSUE_OPB_top14(ISSUE_OPB_top14),
    .ISSUE_OPB_top15(ISSUE_OPB_top15),
    .ISSUE_OPB_top16(ISSUE_OPB_top16),
    .ISSUE_OPB_top17(ISSUE_OPB_top17),
    .ISSUE_OPB_top18(ISSUE_OPB_top18),
    .ISSUE_OPB_top19(ISSUE_OPB_top19),
    .ISSUE_OPB_top20(ISSUE_OPB_top20),
    .ISSUE_OPB_top21(ISSUE_OPB_top21),
    .ISSUE_OPB_top22(ISSUE_OPB_top22),
    .ISSUE_OPB_top23(ISSUE_OPB_top23),
    .ISSUE_OPB_top24(ISSUE_OPB_top24),
    .ISSUE_OPB_top25(ISSUE_OPB_top25),
    .ISSUE_OPB_top26(ISSUE_OPB_top26),
    .ISSUE_OPB_top27(ISSUE_OPB_top27),
    .ISSUE_OPB_top28(ISSUE_OPB_top28),
    .ISSUE_OPB_top29(ISSUE_OPB_top29),
    .ISSUE_OPB_top30(ISSUE_OPB_top30),
    .ISSUE_OPB_top31(ISSUE_OPB_top31),
    .ISSUE_ID_top0(ISSUE_ID_top0),
    .ISSUE_ID_top1(ISSUE_ID_top1),
    .ISSUE_ID_top2(ISSUE_ID_top2),
    .ISSUE_ID_top3(ISSUE_ID_top3),
    .ISSUE_READY_top(ISSUE_READY_top),
    .ISSUE_ACCEPT_top(ISSUE_ACCEPT_top),
    .RESULT_VALID_top(RESULT_VALID_top),
    .RESULT_ID_top0(RESULT_ID_top0),
    .RESULT_ID_top1(RESULT_ID_top1),
    .RESULT_ID_top2(RESULT_ID_top2),
    .RESULT_ID_top3(RESULT_ID_top3),
    .RESULT_RD_top0(RESULT_RD_top0),
    .RESULT_RD_top1(RESULT_RD_top1),
    .RESULT_RD_top2(RESULT_RD_top2),
    .RESULT_RD_top3(RESULT_RD_top3),
    .RESULT_RD_top4(RESULT_RD_top4),
    .RESULT_top0(RESULT_top0),
    .RESULT_top1(RESULT_top1),
    .RESULT_top2(RESULT_top2),
    .RESULT_top3(RESULT_top3),
    .RESULT_top4(RESULT_top4),
    .RESULT_top5(RESULT_top5),
    .RESULT_top6(RESULT_top6),
    .RESULT_top7(RESULT_top7),
    .RESULT_top8(RESULT_top8),
    .RESULT_top9(RESULT_top9),
    .RESULT_top10(RESULT_top10),
    .RESULT_top11(RESULT_top11),
    .RESULT_top12(RESULT_top12),
    .RESULT_top13(RESULT_top13),
    .RESULT_top14(RESULT_top14),
    .RESULT_top15(RESULT_top15),
    .RESULT_top16(RESULT_top16),
    .RESULT_top17(RESULT_top17),
    .RESULT_top18(RESULT_top18),
    .RESULT_top19(RESULT_top19),
    .RESULT_top20(RESULT_top20),
    .RESULT_top21(RESULT_top21),
    .RESULT_top22(RESULT_top22),
    .RESULT_top23(RESULT_top23),
    .RESULT_top24(RESULT_top24),
    .RESULT_top25(RESULT_top25),
    .RESULT_top26(RESULT_top26),
    .RESULT_top27(RESULT_top27),
    .RESULT_top28(RESULT_top28),
    .RESULT_top29(RESULT_top29),
    .RESULT_top30(RESULT_top30),
    .RESULT_top31(RESULT_top31),
    .UserCLK(Tile_X1Y0_UserCLK),
    .UserCLKo(Tile_X1Y0_UserCLKo),
    .FrameData(Tile_X0Y0_FrameData_O),
    .FrameData_O(Tile_X1Y0_FrameData_O),
    .FrameStrobe(Tile_X1Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X1Y0_FrameStrobe_O)
);

S_XIF_right
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X2Y0_Emulate_Bitstream)
    )
`endif
    Tile_X2Y0_S_XIF_right
    (
    .middle2right_ISSUE_OPB(Tile_X1Y0_middle2right_ISSUE_OPB),
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
    .right2middle_RESULT(Tile_X2Y0_right2middle_RESULT),
    .UserCLK(Tile_X2Y0_UserCLK),
    .UserCLKo(Tile_X2Y0_UserCLKo),
    .FrameData(Tile_X1Y0_FrameData_O),
    .FrameData_O(Tile_X2Y0_FrameData_O),
    .FrameStrobe(Tile_X2Y0_FrameStrobe),
    .FrameStrobe_O(Tile_X2Y0_FrameStrobe_O)
);

endmodule
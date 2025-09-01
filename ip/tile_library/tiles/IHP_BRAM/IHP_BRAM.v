module IHP_BRAM
    #(
`ifdef EMULATION
        parameter [639:0] Tile_X0Y0_Emulate_Bitstream=640'b0,
        parameter [639:0] Tile_X0Y1_Emulate_Bitstream=640'b0,
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
        input  [3:0] Tile_X0Y0_S1END, //Port(Name=S1END, IO=INPUT, XOffset=0, YOffset=1, WireCount=4, Side=NORTH)
        input  [7:0] Tile_X0Y0_S2MID, //Port(Name=S2MID, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [7:0] Tile_X0Y0_S2END, //Port(Name=S2END, IO=INPUT, XOffset=0, YOffset=1, WireCount=8, Side=NORTH)
        input  [15:0] Tile_X0Y0_S4END, //Port(Name=S4END, IO=INPUT, XOffset=0, YOffset=4, WireCount=4, Side=NORTH)
    //Tile_X0Y0_Direction.EAST
        input  [3:0] Tile_X0Y0_E1END, //Port(Name=E1END, IO=INPUT, XOffset=1, YOffset=0, WireCount=4, Side=WEST)
        input  [7:0] Tile_X0Y0_E2MID, //Port(Name=E2MID, IO=INPUT, XOffset=1, YOffset=0, WireCount=8, Side=WEST)
        input  [7:0] Tile_X0Y0_E2END, //Port(Name=E2END, IO=INPUT, XOffset=1, YOffset=0, WireCount=8, Side=WEST)
        input  [15:0] Tile_X0Y0_EE4END, //Port(Name=EE4END, IO=INPUT, XOffset=4, YOffset=0, WireCount=4, Side=WEST)
        input  [11:0] Tile_X0Y0_E6END, //Port(Name=E6END, IO=INPUT, XOffset=6, YOffset=0, WireCount=2, Side=WEST)
        output  [3:0] Tile_X0Y0_W1BEG, //Port(Name=W1BEG, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=4, Side=WEST)
        output  [7:0] Tile_X0Y0_W2BEG, //Port(Name=W2BEG, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=8, Side=WEST)
        output  [7:0] Tile_X0Y0_W2BEGb, //Port(Name=W2BEGb, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=8, Side=WEST)
        output  [15:0] Tile_X0Y0_WW4BEG, //Port(Name=WW4BEG, IO=OUTPUT, XOffset=-4, YOffset=0, WireCount=4, Side=WEST)
        output  [11:0] Tile_X0Y0_W6BEG, //Port(Name=W6BEG, IO=OUTPUT, XOffset=-6, YOffset=0, WireCount=2, Side=WEST)
    //Tile_X0Y1_Direction.NORTH
        input  [3:0] Tile_X0Y1_N1END, //Port(Name=N1END, IO=INPUT, XOffset=0, YOffset=-1, WireCount=4, Side=SOUTH)
        input  [7:0] Tile_X0Y1_N2MID, //Port(Name=N2MID, IO=INPUT, XOffset=0, YOffset=-1, WireCount=8, Side=SOUTH)
        input  [7:0] Tile_X0Y1_N2END, //Port(Name=N2END, IO=INPUT, XOffset=0, YOffset=-1, WireCount=8, Side=SOUTH)
        input  [15:0] Tile_X0Y1_N4END, //Port(Name=N4END, IO=INPUT, XOffset=0, YOffset=-4, WireCount=4, Side=SOUTH)
        output  [3:0] Tile_X0Y1_S1BEG, //Port(Name=S1BEG, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=4, Side=SOUTH)
        output  [7:0] Tile_X0Y1_S2BEG, //Port(Name=S2BEG, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
        output  [7:0] Tile_X0Y1_S2BEGb, //Port(Name=S2BEGb, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
        output  [15:0] Tile_X0Y1_S4BEG, //Port(Name=S4BEG, IO=OUTPUT, XOffset=0, YOffset=4, WireCount=4, Side=SOUTH)
    //Tile_X0Y1_Direction.EAST
        input  [3:0] Tile_X0Y1_E1END, //Port(Name=E1END, IO=INPUT, XOffset=1, YOffset=0, WireCount=4, Side=WEST)
        input  [7:0] Tile_X0Y1_E2MID, //Port(Name=E2MID, IO=INPUT, XOffset=1, YOffset=0, WireCount=8, Side=WEST)
        input  [7:0] Tile_X0Y1_E2END, //Port(Name=E2END, IO=INPUT, XOffset=1, YOffset=0, WireCount=8, Side=WEST)
        input  [15:0] Tile_X0Y1_EE4END, //Port(Name=EE4END, IO=INPUT, XOffset=4, YOffset=0, WireCount=4, Side=WEST)
        input  [11:0] Tile_X0Y1_E6END, //Port(Name=E6END, IO=INPUT, XOffset=6, YOffset=0, WireCount=2, Side=WEST)
        output  [3:0] Tile_X0Y1_W1BEG, //Port(Name=W1BEG, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=4, Side=WEST)
        output  [7:0] Tile_X0Y1_W2BEG, //Port(Name=W2BEG, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=8, Side=WEST)
        output  [7:0] Tile_X0Y1_W2BEGb, //Port(Name=W2BEGb, IO=OUTPUT, XOffset=-1, YOffset=0, WireCount=8, Side=WEST)
        output  [15:0] Tile_X0Y1_WW4BEG, //Port(Name=WW4BEG, IO=OUTPUT, XOffset=-4, YOffset=0, WireCount=4, Side=WEST)
        output  [11:0] Tile_X0Y1_W6BEG, //Port(Name=W6BEG, IO=OUTPUT, XOffset=-6, YOffset=0, WireCount=2, Side=WEST)
    //Tile IO ports from BELs
        input  A_DOUT_BRAM0,
        input  A_DOUT_BRAM1,
        input  A_DOUT_BRAM2,
        input  A_DOUT_BRAM3,
        input  A_DOUT_BRAM4,
        input  A_DOUT_BRAM5,
        input  A_DOUT_BRAM6,
        input  A_DOUT_BRAM7,
        input  A_DOUT_BRAM8,
        input  A_DOUT_BRAM9,
        input  A_DOUT_BRAM10,
        input  A_DOUT_BRAM11,
        input  A_DOUT_BRAM12,
        input  A_DOUT_BRAM13,
        input  A_DOUT_BRAM14,
        input  A_DOUT_BRAM15,
        input  B_DOUT_BRAM0,
        input  B_DOUT_BRAM1,
        input  B_DOUT_BRAM2,
        input  B_DOUT_BRAM3,
        input  B_DOUT_BRAM4,
        input  B_DOUT_BRAM5,
        input  B_DOUT_BRAM6,
        input  B_DOUT_BRAM7,
        input  B_DOUT_BRAM8,
        input  B_DOUT_BRAM9,
        input  B_DOUT_BRAM10,
        input  B_DOUT_BRAM11,
        input  B_DOUT_BRAM12,
        input  B_DOUT_BRAM13,
        input  B_DOUT_BRAM14,
        input  B_DOUT_BRAM15,
        input  CONFIGURED_top,
        output  A_ADDR_BRAM0,
        output  A_ADDR_BRAM1,
        output  A_ADDR_BRAM2,
        output  A_ADDR_BRAM3,
        output  A_ADDR_BRAM4,
        output  A_ADDR_BRAM5,
        output  A_ADDR_BRAM6,
        output  A_ADDR_BRAM7,
        output  A_ADDR_BRAM8,
        output  A_ADDR_BRAM9,
        output  A_DIN_BRAM0,
        output  A_DIN_BRAM1,
        output  A_DIN_BRAM2,
        output  A_DIN_BRAM3,
        output  A_DIN_BRAM4,
        output  A_DIN_BRAM5,
        output  A_DIN_BRAM6,
        output  A_DIN_BRAM7,
        output  A_DIN_BRAM8,
        output  A_DIN_BRAM9,
        output  A_DIN_BRAM10,
        output  A_DIN_BRAM11,
        output  A_DIN_BRAM12,
        output  A_DIN_BRAM13,
        output  A_DIN_BRAM14,
        output  A_DIN_BRAM15,
        output  A_BM_BRAM0,
        output  A_BM_BRAM1,
        output  A_BM_BRAM2,
        output  A_BM_BRAM3,
        output  A_BM_BRAM4,
        output  A_BM_BRAM5,
        output  A_BM_BRAM6,
        output  A_BM_BRAM7,
        output  A_BM_BRAM8,
        output  A_BM_BRAM9,
        output  A_BM_BRAM10,
        output  A_BM_BRAM11,
        output  A_BM_BRAM12,
        output  A_BM_BRAM13,
        output  A_BM_BRAM14,
        output  A_BM_BRAM15,
        output  A_WEN_BRAM,
        output  A_MEN_BRAM,
        output  A_REN_BRAM,
        output  A_CLK_BRAM,
        output  A_TIE_HIGH_BRAM,
        output  A_TIE_LOW_BRAM,
        output  B_ADDR_BRAM0,
        output  B_ADDR_BRAM1,
        output  B_ADDR_BRAM2,
        output  B_ADDR_BRAM3,
        output  B_ADDR_BRAM4,
        output  B_ADDR_BRAM5,
        output  B_ADDR_BRAM6,
        output  B_ADDR_BRAM7,
        output  B_ADDR_BRAM8,
        output  B_ADDR_BRAM9,
        output  B_DIN_BRAM0,
        output  B_DIN_BRAM1,
        output  B_DIN_BRAM2,
        output  B_DIN_BRAM3,
        output  B_DIN_BRAM4,
        output  B_DIN_BRAM5,
        output  B_DIN_BRAM6,
        output  B_DIN_BRAM7,
        output  B_DIN_BRAM8,
        output  B_DIN_BRAM9,
        output  B_DIN_BRAM10,
        output  B_DIN_BRAM11,
        output  B_DIN_BRAM12,
        output  B_DIN_BRAM13,
        output  B_DIN_BRAM14,
        output  B_DIN_BRAM15,
        output  B_BM_BRAM0,
        output  B_BM_BRAM1,
        output  B_BM_BRAM2,
        output  B_BM_BRAM3,
        output  B_BM_BRAM4,
        output  B_BM_BRAM5,
        output  B_BM_BRAM6,
        output  B_BM_BRAM7,
        output  B_BM_BRAM8,
        output  B_BM_BRAM9,
        output  B_BM_BRAM10,
        output  B_BM_BRAM11,
        output  B_BM_BRAM12,
        output  B_BM_BRAM13,
        output  B_BM_BRAM14,
        output  B_BM_BRAM15,
        output  B_WEN_BRAM,
        output  B_MEN_BRAM,
        output  B_REN_BRAM,
        output  B_CLK_BRAM,
        output  B_TIE_HIGH_BRAM,
        output  B_TIE_LOW_BRAM,
        output  [MaxFramesPerCol-1:0] Tile_X0Y0_FrameStrobe_O, //CONFIG_PORT
        input  [FrameBitsPerRow-1:0] Tile_X0Y0_FrameData, //CONFIG_PORT
        output  [FrameBitsPerRow-1:0] Tile_X0Y0_FrameData_O, //CONFIG_PORT
        input  [FrameBitsPerRow-1:0] Tile_X0Y1_FrameData, //CONFIG_PORT
        input  [MaxFramesPerCol-1:0] Tile_X0Y1_FrameStrobe, //CONFIG_PORT
        output  [FrameBitsPerRow-1:0] Tile_X0Y1_FrameData_O, //CONFIG_PORT
        output  Tile_X0Y0_UserCLKo,
        input  Tile_X0Y1_UserCLK
);

 //signal declarations
 //Tile_X0Y0_Direction.NORTH
    wire[3:0] Tile_X0Y0_S1BEG; //Port(Name=S1BEG, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=4, Side=SOUTH)
    wire[7:0] Tile_X0Y0_S2BEG; //Port(Name=S2BEG, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[7:0] Tile_X0Y0_S2BEGb; //Port(Name=S2BEGb, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[15:0] Tile_X0Y0_S4BEG; //Port(Name=S4BEG, IO=OUTPUT, XOffset=0, YOffset=4, WireCount=4, Side=SOUTH)
    wire[7:0] Tile_X0Y0_top2bot_A_DIN; //Port(Name=top2bot_A_DIN, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[7:0] Tile_X0Y0_top2bot_A_BM; //Port(Name=top2bot_A_BM, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[4:0] Tile_X0Y0_top2bot_A_ADDR; //Port(Name=top2bot_A_ADDR, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=5, Side=SOUTH)
    wire[7:0] Tile_X0Y0_top2bot_B_DIN; //Port(Name=top2bot_B_DIN, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[7:0] Tile_X0Y0_top2bot_B_BM; //Port(Name=top2bot_B_BM, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=8, Side=SOUTH)
    wire[4:0] Tile_X0Y0_top2bot_B_ADDR; //Port(Name=top2bot_B_ADDR, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=5, Side=SOUTH)
    wire[0:0] Tile_X0Y0_top2bot_B_WEN; //Port(Name=top2bot_B_WEN, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=1, Side=SOUTH)
    wire[0:0] Tile_X0Y0_top2bot_B_MEN; //Port(Name=top2bot_B_MEN, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=1, Side=SOUTH)
    wire[0:0] Tile_X0Y0_top2bot_B_REN; //Port(Name=top2bot_B_REN, IO=OUTPUT, XOffset=0, YOffset=1, WireCount=1, Side=SOUTH)
 //Tile_X0Y1_Direction.NORTH
    wire[3:0] Tile_X0Y1_N1BEG; //Port(Name=N1BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=4, Side=NORTH)
    wire[7:0] Tile_X0Y1_N2BEG; //Port(Name=N2BEG, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
    wire[7:0] Tile_X0Y1_N2BEGb; //Port(Name=N2BEGb, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
    wire[15:0] Tile_X0Y1_N4BEG; //Port(Name=N4BEG, IO=OUTPUT, XOffset=0, YOffset=-4, WireCount=4, Side=NORTH)
    wire[7:0] Tile_X0Y1_bot2top_A_DOUT; //Port(Name=bot2top_A_DOUT, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
    wire[7:0] Tile_X0Y1_bot2top_B_DOUT; //Port(Name=bot2top_B_DOUT, IO=OUTPUT, XOffset=0, YOffset=-1, WireCount=8, Side=NORTH)
    wire[MaxFramesPerCol-1:0] Tile_X0Y1_FrameStrobe_O;
    wire Tile_X0Y1_UserCLKo;

IHP_BRAM_top
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X0Y0_Emulate_Bitstream)
    )
`endif
    Tile_X0Y0_IHP_BRAM_top
    (
    .N1END(Tile_X0Y1_N1BEG),
    .N2MID(Tile_X0Y1_N2BEG),
    .N2END(Tile_X0Y1_N2BEGb),
    .N4END(Tile_X0Y1_N4BEG),
    .bot2top_A_DOUT(Tile_X0Y1_bot2top_A_DOUT),
    .bot2top_B_DOUT(Tile_X0Y1_bot2top_B_DOUT),
    .E1END(Tile_X0Y0_E1END),
    .E2MID(Tile_X0Y0_E2MID),
    .E2END(Tile_X0Y0_E2END),
    .EE4END(Tile_X0Y0_EE4END),
    .E6END(Tile_X0Y0_E6END),
    .S1END(Tile_X0Y0_S1END),
    .S2MID(Tile_X0Y0_S2MID),
    .S2END(Tile_X0Y0_S2END),
    .S4END(Tile_X0Y0_S4END),
    .N1BEG(Tile_X0Y0_N1BEG),
    .N2BEG(Tile_X0Y0_N2BEG),
    .N2BEGb(Tile_X0Y0_N2BEGb),
    .N4BEG(Tile_X0Y0_N4BEG),
    .S1BEG(Tile_X0Y0_S1BEG),
    .S2BEG(Tile_X0Y0_S2BEG),
    .S2BEGb(Tile_X0Y0_S2BEGb),
    .S4BEG(Tile_X0Y0_S4BEG),
    .top2bot_A_DIN(Tile_X0Y0_top2bot_A_DIN),
    .top2bot_A_BM(Tile_X0Y0_top2bot_A_BM),
    .top2bot_A_ADDR(Tile_X0Y0_top2bot_A_ADDR),
    .top2bot_B_DIN(Tile_X0Y0_top2bot_B_DIN),
    .top2bot_B_BM(Tile_X0Y0_top2bot_B_BM),
    .top2bot_B_ADDR(Tile_X0Y0_top2bot_B_ADDR),
    .top2bot_B_WEN(Tile_X0Y0_top2bot_B_WEN),
    .top2bot_B_MEN(Tile_X0Y0_top2bot_B_MEN),
    .top2bot_B_REN(Tile_X0Y0_top2bot_B_REN),
    .W1BEG(Tile_X0Y0_W1BEG),
    .W2BEG(Tile_X0Y0_W2BEG),
    .W2BEGb(Tile_X0Y0_W2BEGb),
    .WW4BEG(Tile_X0Y0_WW4BEG),
    .W6BEG(Tile_X0Y0_W6BEG),
    .UserCLK(Tile_X0Y1_UserCLKo),
    .UserCLKo(Tile_X0Y0_UserCLKo),
    .FrameData(Tile_X0Y0_FrameData),
    .FrameData_O(Tile_X0Y0_FrameData_O),
    .FrameStrobe(Tile_X0Y1_FrameStrobe_O),
    .FrameStrobe_O(Tile_X0Y0_FrameStrobe_O)
);

IHP_BRAM_bot
`ifdef EMULATION
    #(
    .Emulate_Bitstream(Tile_X0Y1_Emulate_Bitstream)
    )
`endif
    Tile_X0Y1_IHP_BRAM_bot
    (
    .N1END(Tile_X0Y1_N1END),
    .N2MID(Tile_X0Y1_N2MID),
    .N2END(Tile_X0Y1_N2END),
    .N4END(Tile_X0Y1_N4END),
    .E1END(Tile_X0Y1_E1END),
    .E2MID(Tile_X0Y1_E2MID),
    .E2END(Tile_X0Y1_E2END),
    .EE4END(Tile_X0Y1_EE4END),
    .E6END(Tile_X0Y1_E6END),
    .S1END(Tile_X0Y0_S1BEG),
    .S2MID(Tile_X0Y0_S2BEG),
    .S2END(Tile_X0Y0_S2BEGb),
    .S4END(Tile_X0Y0_S4BEG),
    .top2bot_A_DIN(Tile_X0Y0_top2bot_A_DIN),
    .top2bot_A_BM(Tile_X0Y0_top2bot_A_BM),
    .top2bot_A_ADDR(Tile_X0Y0_top2bot_A_ADDR),
    .top2bot_B_DIN(Tile_X0Y0_top2bot_B_DIN),
    .top2bot_B_BM(Tile_X0Y0_top2bot_B_BM),
    .top2bot_B_ADDR(Tile_X0Y0_top2bot_B_ADDR),
    .top2bot_B_WEN(Tile_X0Y0_top2bot_B_WEN),
    .top2bot_B_MEN(Tile_X0Y0_top2bot_B_MEN),
    .top2bot_B_REN(Tile_X0Y0_top2bot_B_REN),
    .N1BEG(Tile_X0Y1_N1BEG),
    .N2BEG(Tile_X0Y1_N2BEG),
    .N2BEGb(Tile_X0Y1_N2BEGb),
    .N4BEG(Tile_X0Y1_N4BEG),
    .bot2top_A_DOUT(Tile_X0Y1_bot2top_A_DOUT),
    .bot2top_B_DOUT(Tile_X0Y1_bot2top_B_DOUT),
    .S1BEG(Tile_X0Y1_S1BEG),
    .S2BEG(Tile_X0Y1_S2BEG),
    .S2BEGb(Tile_X0Y1_S2BEGb),
    .S4BEG(Tile_X0Y1_S4BEG),
    .W1BEG(Tile_X0Y1_W1BEG),
    .W2BEG(Tile_X0Y1_W2BEG),
    .W2BEGb(Tile_X0Y1_W2BEGb),
    .WW4BEG(Tile_X0Y1_WW4BEG),
    .W6BEG(Tile_X0Y1_W6BEG),
    .A_DOUT_BRAM0(A_DOUT_BRAM0),
    .A_DOUT_BRAM1(A_DOUT_BRAM1),
    .A_DOUT_BRAM2(A_DOUT_BRAM2),
    .A_DOUT_BRAM3(A_DOUT_BRAM3),
    .A_DOUT_BRAM4(A_DOUT_BRAM4),
    .A_DOUT_BRAM5(A_DOUT_BRAM5),
    .A_DOUT_BRAM6(A_DOUT_BRAM6),
    .A_DOUT_BRAM7(A_DOUT_BRAM7),
    .A_DOUT_BRAM8(A_DOUT_BRAM8),
    .A_DOUT_BRAM9(A_DOUT_BRAM9),
    .A_DOUT_BRAM10(A_DOUT_BRAM10),
    .A_DOUT_BRAM11(A_DOUT_BRAM11),
    .A_DOUT_BRAM12(A_DOUT_BRAM12),
    .A_DOUT_BRAM13(A_DOUT_BRAM13),
    .A_DOUT_BRAM14(A_DOUT_BRAM14),
    .A_DOUT_BRAM15(A_DOUT_BRAM15),
    .B_DOUT_BRAM0(B_DOUT_BRAM0),
    .B_DOUT_BRAM1(B_DOUT_BRAM1),
    .B_DOUT_BRAM2(B_DOUT_BRAM2),
    .B_DOUT_BRAM3(B_DOUT_BRAM3),
    .B_DOUT_BRAM4(B_DOUT_BRAM4),
    .B_DOUT_BRAM5(B_DOUT_BRAM5),
    .B_DOUT_BRAM6(B_DOUT_BRAM6),
    .B_DOUT_BRAM7(B_DOUT_BRAM7),
    .B_DOUT_BRAM8(B_DOUT_BRAM8),
    .B_DOUT_BRAM9(B_DOUT_BRAM9),
    .B_DOUT_BRAM10(B_DOUT_BRAM10),
    .B_DOUT_BRAM11(B_DOUT_BRAM11),
    .B_DOUT_BRAM12(B_DOUT_BRAM12),
    .B_DOUT_BRAM13(B_DOUT_BRAM13),
    .B_DOUT_BRAM14(B_DOUT_BRAM14),
    .B_DOUT_BRAM15(B_DOUT_BRAM15),
    .CONFIGURED_top(CONFIGURED_top),
    .A_ADDR_BRAM0(A_ADDR_BRAM0),
    .A_ADDR_BRAM1(A_ADDR_BRAM1),
    .A_ADDR_BRAM2(A_ADDR_BRAM2),
    .A_ADDR_BRAM3(A_ADDR_BRAM3),
    .A_ADDR_BRAM4(A_ADDR_BRAM4),
    .A_ADDR_BRAM5(A_ADDR_BRAM5),
    .A_ADDR_BRAM6(A_ADDR_BRAM6),
    .A_ADDR_BRAM7(A_ADDR_BRAM7),
    .A_ADDR_BRAM8(A_ADDR_BRAM8),
    .A_ADDR_BRAM9(A_ADDR_BRAM9),
    .A_DIN_BRAM0(A_DIN_BRAM0),
    .A_DIN_BRAM1(A_DIN_BRAM1),
    .A_DIN_BRAM2(A_DIN_BRAM2),
    .A_DIN_BRAM3(A_DIN_BRAM3),
    .A_DIN_BRAM4(A_DIN_BRAM4),
    .A_DIN_BRAM5(A_DIN_BRAM5),
    .A_DIN_BRAM6(A_DIN_BRAM6),
    .A_DIN_BRAM7(A_DIN_BRAM7),
    .A_DIN_BRAM8(A_DIN_BRAM8),
    .A_DIN_BRAM9(A_DIN_BRAM9),
    .A_DIN_BRAM10(A_DIN_BRAM10),
    .A_DIN_BRAM11(A_DIN_BRAM11),
    .A_DIN_BRAM12(A_DIN_BRAM12),
    .A_DIN_BRAM13(A_DIN_BRAM13),
    .A_DIN_BRAM14(A_DIN_BRAM14),
    .A_DIN_BRAM15(A_DIN_BRAM15),
    .A_BM_BRAM0(A_BM_BRAM0),
    .A_BM_BRAM1(A_BM_BRAM1),
    .A_BM_BRAM2(A_BM_BRAM2),
    .A_BM_BRAM3(A_BM_BRAM3),
    .A_BM_BRAM4(A_BM_BRAM4),
    .A_BM_BRAM5(A_BM_BRAM5),
    .A_BM_BRAM6(A_BM_BRAM6),
    .A_BM_BRAM7(A_BM_BRAM7),
    .A_BM_BRAM8(A_BM_BRAM8),
    .A_BM_BRAM9(A_BM_BRAM9),
    .A_BM_BRAM10(A_BM_BRAM10),
    .A_BM_BRAM11(A_BM_BRAM11),
    .A_BM_BRAM12(A_BM_BRAM12),
    .A_BM_BRAM13(A_BM_BRAM13),
    .A_BM_BRAM14(A_BM_BRAM14),
    .A_BM_BRAM15(A_BM_BRAM15),
    .A_WEN_BRAM(A_WEN_BRAM),
    .A_MEN_BRAM(A_MEN_BRAM),
    .A_REN_BRAM(A_REN_BRAM),
    .A_CLK_BRAM(A_CLK_BRAM),
    .A_TIE_HIGH_BRAM(A_TIE_HIGH_BRAM),
    .A_TIE_LOW_BRAM(A_TIE_LOW_BRAM),
    .B_ADDR_BRAM0(B_ADDR_BRAM0),
    .B_ADDR_BRAM1(B_ADDR_BRAM1),
    .B_ADDR_BRAM2(B_ADDR_BRAM2),
    .B_ADDR_BRAM3(B_ADDR_BRAM3),
    .B_ADDR_BRAM4(B_ADDR_BRAM4),
    .B_ADDR_BRAM5(B_ADDR_BRAM5),
    .B_ADDR_BRAM6(B_ADDR_BRAM6),
    .B_ADDR_BRAM7(B_ADDR_BRAM7),
    .B_ADDR_BRAM8(B_ADDR_BRAM8),
    .B_ADDR_BRAM9(B_ADDR_BRAM9),
    .B_DIN_BRAM0(B_DIN_BRAM0),
    .B_DIN_BRAM1(B_DIN_BRAM1),
    .B_DIN_BRAM2(B_DIN_BRAM2),
    .B_DIN_BRAM3(B_DIN_BRAM3),
    .B_DIN_BRAM4(B_DIN_BRAM4),
    .B_DIN_BRAM5(B_DIN_BRAM5),
    .B_DIN_BRAM6(B_DIN_BRAM6),
    .B_DIN_BRAM7(B_DIN_BRAM7),
    .B_DIN_BRAM8(B_DIN_BRAM8),
    .B_DIN_BRAM9(B_DIN_BRAM9),
    .B_DIN_BRAM10(B_DIN_BRAM10),
    .B_DIN_BRAM11(B_DIN_BRAM11),
    .B_DIN_BRAM12(B_DIN_BRAM12),
    .B_DIN_BRAM13(B_DIN_BRAM13),
    .B_DIN_BRAM14(B_DIN_BRAM14),
    .B_DIN_BRAM15(B_DIN_BRAM15),
    .B_BM_BRAM0(B_BM_BRAM0),
    .B_BM_BRAM1(B_BM_BRAM1),
    .B_BM_BRAM2(B_BM_BRAM2),
    .B_BM_BRAM3(B_BM_BRAM3),
    .B_BM_BRAM4(B_BM_BRAM4),
    .B_BM_BRAM5(B_BM_BRAM5),
    .B_BM_BRAM6(B_BM_BRAM6),
    .B_BM_BRAM7(B_BM_BRAM7),
    .B_BM_BRAM8(B_BM_BRAM8),
    .B_BM_BRAM9(B_BM_BRAM9),
    .B_BM_BRAM10(B_BM_BRAM10),
    .B_BM_BRAM11(B_BM_BRAM11),
    .B_BM_BRAM12(B_BM_BRAM12),
    .B_BM_BRAM13(B_BM_BRAM13),
    .B_BM_BRAM14(B_BM_BRAM14),
    .B_BM_BRAM15(B_BM_BRAM15),
    .B_WEN_BRAM(B_WEN_BRAM),
    .B_MEN_BRAM(B_MEN_BRAM),
    .B_REN_BRAM(B_REN_BRAM),
    .B_CLK_BRAM(B_CLK_BRAM),
    .B_TIE_HIGH_BRAM(B_TIE_HIGH_BRAM),
    .B_TIE_LOW_BRAM(B_TIE_LOW_BRAM),
    .UserCLK(Tile_X0Y1_UserCLK),
    .UserCLKo(Tile_X0Y1_UserCLKo),
    .FrameData(Tile_X0Y1_FrameData),
    .FrameData_O(Tile_X0Y1_FrameData_O),
    .FrameStrobe(Tile_X0Y1_FrameStrobe),
    .FrameStrobe_O(Tile_X0Y1_FrameStrobe_O)
);

endmodule
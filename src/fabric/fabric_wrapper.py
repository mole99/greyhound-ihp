from contextlib import redirect_stdout

FABRIC_NAME = "classic_fabric_greyhound"
FABRIC_HEIGHT = 18
FABRIC_WIDTH = 12
FABRIC_NUM_IO_WEST = 32
BELS_PER_IO_TILE = ['A', 'B']
NUM_SRAM = 4
NUM_BRAM = 4
SRAM_WIDTH = 32
BRAM_WIDTH = 16

WARMBOOT_LOC = "X1Y17"
CPU_IRQ_LOC = "X2Y17"
OBI_PERIPHERAL_LOC = "X4Y17"
CUSTOM_INSTRUCTION_LOC = "X8Y17"

BRAM_LOCS = ["X11Y2", "X11Y4", "X11Y6", "X11Y8"]
SRAM_LOCS = ["X11Y10", "X11Y12", "X11Y14", "X11Y16"]

with open('fabric_wrapper.sv', 'w') as f:
    with redirect_stdout(f):

        print(f"""`default_nettype none

module fabric_wrapper #(
    parameter FrameBitsPerRow = 32,
    parameter MaxFramesPerCol = 20,
    
    parameter NumColumns = {FABRIC_WIDTH},
    parameter NumRows = {FABRIC_HEIGHT},
    
    parameter FABRIC_NUM_IO_WEST = {FABRIC_NUM_IO_WEST}
)(\n""")

        print(f'    // Configuration')
        print("""    input  logic [(FrameBitsPerRow*NumRows)-1:0]    FrameData_i,""")
        print("""    input  logic [(MaxFramesPerCol*NumColumns)-1:0] FrameStrobe_i,\n""")

        print(f'    // Fabric is configured')
        print("""    input                                configured_i,""")
        print("""    input                                sys_reset_i,\n""")

        # I/Os
        print(f'    // I/Os South')
        print("""    input  [FABRIC_NUM_IO_WEST-1:0]      io_west_in_i,
    output [FABRIC_NUM_IO_WEST-1:0]      io_west_out_o,
    output [FABRIC_NUM_IO_WEST-1:0]      io_west_oe_o,\n""")

        print("""    // WARMBOOT
    output        fabric_warmboot_trigger_o,
    output  [3:0] fabric_warmboot_slot_o,\n""")

        print("""    // CPU_IRQ
    output  [3:0] fabric_irq_o,\n""")
    
        print("""    // CUSTOM_INSTRUCTION
    output logic        fabric_issue_ready_o,
    output logic        fabric_issue_accept_o,
    input  logic        fabric_issue_valid_i,
    input  logic [31:0] fabric_issue_instr_i,
    input  logic [31:0] fabric_issue_op0_i,
    input  logic [31:0] fabric_issue_op1_i,
    input  logic [3 :0] fabric_issue_id_i,
    
    output logic        fabric_result_valid_o,
    output logic [3 :0] fabric_result_id_o,
    output logic [4 :0] fabric_result_rd_o,
    output logic [31:0] fabric_result_o,\n""")

        print("""    // OBI_PERIPHERAL
    input          fabric_obi_req_i,
    input          fabric_obi_we_i,
    input   [3 :0] fabric_obi_be_i,
    input   [23:0] fabric_obi_addr_i,
    input   [31:0] fabric_obi_wdata_i,
    output         fabric_obi_gnt_o,
    output         fabric_obi_rvalid_o,
    output  [31:0] fabric_obi_rdata_o
);\n""")

        # SRAM
        for i in range(NUM_SRAM):
            print(f'    // SRAM {i}')
            print(f"""    logic [{SRAM_WIDTH-1}:0] fabric_sram{i}_dout_i;
    logic [9 :0] fabric_sram{i}_addr_o;
    logic [{SRAM_WIDTH-1}:0] fabric_sram{i}_bm_o;
    logic [{SRAM_WIDTH-1}:0] fabric_sram{i}_din_o;
    logic        fabric_sram{i}_wen_o;
    logic        fabric_sram{i}_men_o;
    logic        fabric_sram{i}_ren_o;
    logic        fabric_sram{i}_clk_o;
    logic        fabric_sram{i}_tie_high_o;
    logic        fabric_sram{i}_tie_low_o;\n""")

        # BRAM
        for i in range(NUM_BRAM):
            print(f'    // BRAM {i}')
            print(f"""    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_a_dout_i;
    logic [9 :0] fabric_bram{i}_a_addr_o;
    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_a_bm_o;
    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_a_din_o;
    logic        fabric_bram{i}_a_wen_o;
    logic        fabric_bram{i}_a_men_o;
    logic        fabric_bram{i}_a_ren_o;
    logic        fabric_bram{i}_a_clk_o;
    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_b_dout_i;
    logic [9 :0] fabric_bram{i}_b_addr_o;
    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_b_bm_o;
    logic [{BRAM_WIDTH-1}:0] fabric_bram{i}_b_din_o;
    logic        fabric_bram{i}_b_wen_o;
    logic        fabric_bram{i}_b_men_o;
    logic        fabric_bram{i}_b_ren_o;
    logic        fabric_bram{i}_b_clk_o;
    logic        fabric_bram{i}_tie_high_o;
    logic        fabric_bram{i}_tie_low_o;\n""")

        print(f"""    {FABRIC_NAME}
    //#(
    //    .MaxFramesPerCol(MaxFramesPerCol),
    //    .FrameBitsPerRow(FrameBitsPerRow)
    //)
    {FABRIC_NAME}
    (""")

        print(f"""        .FrameData      (FrameData_i),""")
        print(f"""        .FrameStrobe    (FrameStrobe_i),\n""")

        # I/Os
        print(f"""        // West I/Os""")
        num_bels = len(BELS_PER_IO_TILE)
        IO_WEST_OFFSET = 1
        for i in range(IO_WEST_OFFSET,(FABRIC_NUM_IO_WEST//num_bels)+1):
            for j, bel in enumerate(BELS_PER_IO_TILE):
                print(f"""        .Tile_X{0}Y{i}_{bel}_OUT_top(io_west_in_i[{(i-IO_WEST_OFFSET)*num_bels+j}]),
        .Tile_X{0}Y{i}_{bel}_IN_top(io_west_out_o[{(i-IO_WEST_OFFSET)*num_bels+j}]),
        .Tile_X{0}Y{i}_{bel}_EN_top(io_west_oe_o[{(i-IO_WEST_OFFSET)*num_bels+j}]),\n""")

        print(f"""        // SYS_RESET""")
        print(f"""        .Tile_X0Y{FABRIC_HEIGHT-1}_SYS_RESET_RESET_top(sys_reset_i),\n""")

        print(f"""        // WARMBOOT""")
        print(f"""        .Tile_{WARMBOOT_LOC}_TRIGGER_top(fabric_warmboot_trigger_o),""")
        print(f"""        .Tile_{WARMBOOT_LOC}_SLOT_top0(fabric_warmboot_slot_o[0]),""")
        print(f"""        .Tile_{WARMBOOT_LOC}_SLOT_top1(fabric_warmboot_slot_o[1]),""")
        print(f"""        .Tile_{WARMBOOT_LOC}_SLOT_top2(fabric_warmboot_slot_o[2]),""")
        print(f"""        .Tile_{WARMBOOT_LOC}_SLOT_top3(fabric_warmboot_slot_o[3]),\n""")

        print(f"""        // IRQ""")
        print(f"""        .Tile_{CPU_IRQ_LOC}_IRQ_top0(fabric_irq_o[0]),""")
        print(f"""        .Tile_{CPU_IRQ_LOC}_IRQ_top1(fabric_irq_o[1]),""")
        print(f"""        .Tile_{CPU_IRQ_LOC}_IRQ_top2(fabric_irq_o[2]),""")
        print(f"""        .Tile_{CPU_IRQ_LOC}_IRQ_top3(fabric_irq_o[3]),""")
        print(f"""        .Tile_{CPU_IRQ_LOC}_CONFIGURED_top(configured_i),\n""")

        # BRAM
        for i, BRAM_LOC in enumerate(BRAM_LOCS):
            print(f'        // BRAM {i}')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_A_DOUT_SRAM{j}(fabric_bram{i}_a_dout_i[{j}]),')
            for j in range(10):
                print(f'        .Tile_{BRAM_LOC}_A_ADDR_SRAM{j}(fabric_bram{i}_a_addr_o[{j}]),')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_A_BM_SRAM{j}(fabric_bram{i}_a_bm_o[{j}]),')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_A_DIN_SRAM{j}(fabric_bram{i}_a_din_o[{j}]),')
            print(f'        .Tile_{BRAM_LOC}_A_WEN_SRAM(fabric_bram{i}_a_wen_o),')
            print(f'        .Tile_{BRAM_LOC}_A_MEN_SRAM(fabric_bram{i}_a_men_o),')
            print(f'        .Tile_{BRAM_LOC}_A_REN_SRAM(fabric_bram{i}_a_ren_o),')
            print(f'        .Tile_{BRAM_LOC}_A_CLK_SRAM(fabric_bram{i}_a_clk_o),')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_B_DOUT_SRAM{j}(fabric_bram{i}_b_dout_i[{j}]),')
            for j in range(10):
                print(f'        .Tile_{BRAM_LOC}_B_ADDR_SRAM{j}(fabric_bram{i}_b_addr_o[{j}]),')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_B_BM_SRAM{j}(fabric_bram{i}_b_bm_o[{j}]),')
            for j in range(BRAM_WIDTH):
                print(f'        .Tile_{BRAM_LOC}_B_DIN_SRAM{j}(fabric_bram{i}_b_din_o[{j}]),')
            print(f'        .Tile_{BRAM_LOC}_B_WEN_SRAM(fabric_bram{i}_b_wen_o),')
            print(f'        .Tile_{BRAM_LOC}_B_MEN_SRAM(fabric_bram{i}_b_men_o),')
            print(f'        .Tile_{BRAM_LOC}_B_REN_SRAM(fabric_bram{i}_b_ren_o),')
            print(f'        .Tile_{BRAM_LOC}_B_CLK_SRAM(fabric_bram{i}_b_clk_o),')
            print(f'        .Tile_{BRAM_LOC}_TIE_HIGH_SRAM(fabric_bram{i}_tie_high_o),')
            print(f'        .Tile_{BRAM_LOC}_TIE_LOW_SRAM(fabric_bram{i}_tie_low_o),')
            print(f'        .Tile_{BRAM_LOC}_CONFIGURED_top(configured_i),')

        # SRAM
        for i, SRAM_LOC in enumerate(SRAM_LOCS):
            print(f'        // SRAM {i}')
            for j in range(SRAM_WIDTH):
                print(f'        .Tile_{SRAM_LOC}_DOUT_SRAM{j}(fabric_sram{i}_dout_i[{j}]),')
            for j in range(10):
                print(f'        .Tile_{SRAM_LOC}_ADDR_SRAM{j}(fabric_sram{i}_addr_o[{j}]),')
            for j in range(SRAM_WIDTH):
                print(f'        .Tile_{SRAM_LOC}_BM_SRAM{j}(fabric_sram{i}_bm_o[{j}]),')
            for j in range(SRAM_WIDTH):
                print(f'        .Tile_{SRAM_LOC}_DIN_SRAM{j}(fabric_sram{i}_din_o[{j}]),')
            print(f'        .Tile_{SRAM_LOC}_WEN_SRAM(fabric_sram{i}_wen_o),')
            print(f'        .Tile_{SRAM_LOC}_MEN_SRAM(fabric_sram{i}_men_o),')
            print(f'        .Tile_{SRAM_LOC}_REN_SRAM(fabric_sram{i}_ren_o),')
            print(f'        .Tile_{SRAM_LOC}_CLK_SRAM(fabric_sram{i}_clk_o),')
            print(f'        .Tile_{SRAM_LOC}_TIE_HIGH_SRAM(fabric_sram{i}_tie_high_o),')
            print(f'        .Tile_{SRAM_LOC}_TIE_LOW_SRAM(fabric_sram{i}_tie_low_o),')
            if (i==NUM_SRAM-1):
                print(f'        .Tile_{SRAM_LOC}_CONFIGURED_top(configured_i)')
            else:
                print(f'        .Tile_{SRAM_LOC}_CONFIGURED_top(configured_i),')
        print("    );\n")

        for i in range(NUM_SRAM):

            print(f"""    // SRAM {i} instances

    RM_IHPSG13_1P_1024x32_c2_bm_bist sram{i} (
        .A_CLK      (fabric_sram{i}_clk_o),
        .A_MEN      (fabric_sram{i}_men_o),
        .A_WEN      (fabric_sram{i}_wen_o),
        .A_REN      (fabric_sram{i}_ren_o),
        .A_ADDR     (fabric_sram{i}_addr_o),
        .A_DIN      (fabric_sram{i}_din_o),
        .A_DLY      (fabric_sram{i}_tie_high_o),
        .A_DOUT     (fabric_sram{i}_dout_i),
        .A_BM       (fabric_sram{i}_bm_o),

        .A_BIST_EN      (fabric_sram{i}_tie_low_o),
        .A_BIST_CLK     (fabric_sram{i}_tie_low_o),
        .A_BIST_MEN     (fabric_sram{i}_tie_low_o),
        .A_BIST_WEN     (fabric_sram{i}_tie_low_o),
        .A_BIST_REN     (fabric_sram{i}_tie_low_o),
        .A_BIST_ADDR    ({{10{{fabric_sram{i}_tie_low_o}}}}),
        .A_BIST_DIN     ({{32{{fabric_sram{i}_tie_low_o}}}}),
        .A_BIST_BM      ({{32{{fabric_sram{i}_tie_low_o}}}})
    );""")

        for i in range(NUM_BRAM):

            print(f"""    // BRAM {i} instances

    RM_IHPSG13_2P_1024x16_c2_bm_bist bram{i} (
        .A_CLK      (fabric_bram{i}_a_clk_o),
        .A_MEN      (fabric_bram{i}_a_men_o),
        .A_WEN      (fabric_bram{i}_a_wen_o),
        .A_REN      (fabric_bram{i}_a_ren_o),
        .A_ADDR     (fabric_bram{i}_a_addr_o),
        .A_DIN      (fabric_bram{i}_a_din_o),
        .A_DLY      (fabric_bram{i}_tie_high_o),
        .A_DOUT     (fabric_bram{i}_a_dout_i),
        .A_BM       (fabric_bram{i}_a_bm_o),

        .A_BIST_EN      (fabric_bram{i}_tie_low_o),
        .A_BIST_CLK     (fabric_bram{i}_tie_low_o),
        .A_BIST_MEN     (fabric_bram{i}_tie_low_o),
        .A_BIST_WEN     (fabric_bram{i}_tie_low_o),
        .A_BIST_REN     (fabric_bram{i}_tie_low_o),
        .A_BIST_ADDR    ({{10{{fabric_bram{i}_tie_low_o}}}}),
        .A_BIST_DIN     ({{16{{fabric_bram{i}_tie_low_o}}}}),
        .A_BIST_BM      ({{16{{fabric_bram{i}_tie_low_o}}}}),
        
        .B_CLK      (fabric_bram{i}_b_clk_o),
        .B_MEN      (fabric_bram{i}_b_men_o),
        .B_WEN      (fabric_bram{i}_b_wen_o),
        .B_REN      (fabric_bram{i}_b_ren_o),
        .B_ADDR     (fabric_bram{i}_b_addr_o),
        .B_DIN      (fabric_bram{i}_b_din_o),
        .B_DLY      (fabric_bram{i}_tie_high_o),
        .B_DOUT     (fabric_bram{i}_b_dout_i),
        .B_BM       (fabric_bram{i}_b_bm_o),

        .B_BIST_EN      (fabric_bram{i}_tie_low_o),
        .B_BIST_CLK     (fabric_bram{i}_tie_low_o),
        .B_BIST_MEN     (fabric_bram{i}_tie_low_o),
        .B_BIST_WEN     (fabric_bram{i}_tie_low_o),
        .B_BIST_REN     (fabric_bram{i}_tie_low_o),
        .B_BIST_ADDR    ({{10{{fabric_bram{i}_tie_low_o}}}}),
        .B_BIST_DIN     ({{16{{fabric_bram{i}_tie_low_o}}}}),
        .B_BIST_BM      ({{16{{fabric_bram{i}_tie_low_o}}}}) 
    );""")

        print("\nendmodule")

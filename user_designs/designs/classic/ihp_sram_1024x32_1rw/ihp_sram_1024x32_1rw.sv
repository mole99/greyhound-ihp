// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module ihp_sram_1024x32_1rw (
    input  wire       clk1,
    
    input  wire [9:0] ram_addr,
    input  wire [1:0] ram_byte_sel,
    input  wire       ram_wen,
    input  wire       ram_men,
    input  wire       ram_ren,
    input  wire [7:0] ram_din_byte,
    output wire [7:0] ram_dout_byte
);

    logic clk1_buf;

    GBUF clock1_buf (
      .IN   (clk1),
      .OUT  (clk1_buf)
    );
    
    logic [31:0] ram_din;
    logic [31:0] ram_dout;
    
    assign ram_din = ram_din_byte << (8 * ram_byte_sel);

    IHP_SRAM_1024x32_1RW_wrapper IHP_SRAM_1024x32_1RW_wrapper (
        .CLK    (clk1_buf),
        .ADDR   (ram_addr),
        .DIN    (ram_din),
        .BM     ({{8{ram_byte_sel == 2'd3}}, {8{ram_byte_sel == 2'd2}}, {8{ram_byte_sel == 2'd1}}, {8{ram_byte_sel == 2'd0}}}),
        .WEN    (ram_wen),
        .MEN    (ram_men),
        .REN    (ram_ren),
        .DOUT   (ram_dout)
    );
    
    logic [7:0] ram_dout_byte_tmp;
    
    always_comb begin
        case (ram_byte_sel)
            2'd0: ram_dout_byte_tmp = ram_dout[7:0];
            2'd1: ram_dout_byte_tmp = ram_dout[15:8];
            2'd2: ram_dout_byte_tmp = ram_dout[23:16];
            2'd3: ram_dout_byte_tmp = ram_dout[31:24];
            default: ram_dout_byte_tmp = 8'bx;
        endcase
    end
    
    assign ram_dout_byte = ram_dout_byte_tmp;

endmodule

module IHP_SRAM_1024x32_1RW_wrapper (
    input                 CLK,
    input  [(10 - 1) : 0] ADDR,
    input  [(32 - 1) : 0] DIN,
    input  [(32 - 1) : 0] BM,
    input                 WEN,
    input                 MEN,
    input                 REN,
    	output [(32 - 1) : 0] DOUT
);

    IHP_SRAM_1024x32_1RW IHP_SRAM_1024x32_1RW (
        .CLK  (CLK),
        .ADDR0 (ADDR[0]),
        .ADDR1 (ADDR[1]),
        .ADDR2 (ADDR[2]),
        .ADDR3 (ADDR[3]),
        .ADDR4 (ADDR[4]),
        .ADDR5 (ADDR[5]),
        .ADDR6 (ADDR[6]),
        .ADDR7 (ADDR[7]),
        .ADDR8 (ADDR[8]),
        .ADDR9 (ADDR[9]),
        .DIN0 (DIN[0]),
        .DIN1 (DIN[1]),
        .DIN2 (DIN[2]),
        .DIN3 (DIN[3]),
        .DIN4 (DIN[4]),
        .DIN5 (DIN[5]),
        .DIN6 (DIN[6]),
        .DIN7 (DIN[7]),
        .DIN8 (DIN[8]),
        .DIN9 (DIN[9]),
        .DIN10 (DIN[10]),
        .DIN11 (DIN[11]),
        .DIN12 (DIN[12]),
        .DIN13 (DIN[13]),
        .DIN14 (DIN[14]),
        .DIN15 (DIN[15]),
        .DIN16 (DIN[16]),
        .DIN17 (DIN[17]),
        .DIN18 (DIN[18]),
        .DIN19 (DIN[19]),
        .DIN20 (DIN[20]),
        .DIN21 (DIN[21]),
        .DIN22 (DIN[22]),
        .DIN23 (DIN[23]),
        .DIN24 (DIN[24]),
        .DIN25 (DIN[25]),
        .DIN26 (DIN[26]),
        .DIN27 (DIN[27]),
        .DIN28 (DIN[28]),
        .DIN29 (DIN[29]),
        .DIN30 (DIN[30]),
        .DIN31 (DIN[31]),
        .BM0 (BM[0]),
        .BM1 (BM[1]),
        .BM2 (BM[2]),
        .BM3 (BM[3]),
        .BM4 (BM[4]),
        .BM5 (BM[5]),
        .BM6 (BM[6]),
        .BM7 (BM[7]),
        .BM8 (BM[8]),
        .BM9 (BM[9]),
        .BM10 (BM[10]),
        .BM11 (BM[11]),
        .BM12 (BM[12]),
        .BM13 (BM[13]),
        .BM14 (BM[14]),
        .BM15 (BM[15]),
        .BM16 (BM[16]),
        .BM17 (BM[17]),
        .BM18 (BM[18]),
        .BM19 (BM[19]),
        .BM20 (BM[20]),
        .BM21 (BM[21]),
        .BM22 (BM[22]),
        .BM23 (BM[23]),
        .BM24 (BM[24]),
        .BM25 (BM[25]),
        .BM26 (BM[26]),
        .BM27 (BM[27]),
        .BM28 (BM[28]),
        .BM29 (BM[29]),
        .BM30 (BM[30]),
        .BM31 (BM[31]),
        .WEN  (WEN),
        .MEN  (MEN),
        .REN  (REN),
        .DOUT0 (DOUT[0]),
        .DOUT1 (DOUT[1]),
        .DOUT2 (DOUT[2]),
        .DOUT3 (DOUT[3]),
        .DOUT4 (DOUT[4]),
        .DOUT5 (DOUT[5]),
        .DOUT6 (DOUT[6]),
        .DOUT7 (DOUT[7]),
        .DOUT8 (DOUT[8]),
        .DOUT9 (DOUT[9]),
        .DOUT10 (DOUT[10]),
        .DOUT11 (DOUT[11]),
        .DOUT12 (DOUT[12]),
        .DOUT13 (DOUT[13]),
        .DOUT14 (DOUT[14]),
        .DOUT15 (DOUT[15]),
        .DOUT16 (DOUT[16]),
        .DOUT17 (DOUT[17]),
        .DOUT18 (DOUT[18]),
        .DOUT19 (DOUT[19]),
        .DOUT20 (DOUT[20]),
        .DOUT21 (DOUT[21]),
        .DOUT22 (DOUT[22]),
        .DOUT23 (DOUT[23]),
        .DOUT24 (DOUT[24]),
        .DOUT25 (DOUT[25]),
        .DOUT26 (DOUT[26]),
        .DOUT27 (DOUT[27]),
        .DOUT28 (DOUT[28]),
        .DOUT29 (DOUT[29]),
        .DOUT30 (DOUT[30]),
        .DOUT31 (DOUT[31])
    );

endmodule

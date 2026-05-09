// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module ram_32x4_2r_1w (
    input  wire       clk1,
    input  wire       clk2,
    input  wire       rst,
    input  wire       ena,
    
    input  wire [4:0] addr_a,
    input  wire [4:0] addr_b,
    input  wire [1:0] addr_c,
    
    // Input word
    input  wire [3:0] word_a,
    
    // Output words
    output wire [3:0] word_b,
    output wire [3:0] word_c
);

    logic clk1_buf;

    (* keep, BEL="X0Y9.A" *) GBUF clock1_buf (
      .IN   (clk1),
      .OUT  (clk1_buf)
    );

    logic clk2_buf;

    (* keep, BEL="X0Y9.B" *) GBUF clock2_buf (
      .IN   (clk2),
      .OUT  (clk2_buf)
    );

    localparam WIDTH = 4;
    localparam DEPTH = 5;

    // We need to combine individual bits into vectors
    // since FABulous doesn't support vectors for primitives yet
    wire [DEPTH-1:0] A_ADDR;
    wire [WIDTH-1:0] A_DIN;

    wire [DEPTH-1:0] B_ADDR;
    wire [WIDTH-1:0] B_DOUT;

    wire [DEPTH-1:0] C_ADDR;
    wire [WIDTH-1:0] C_DOUT;
    
    assign A_ADDR = addr_a;
    assign A_DIN = word_a;
    
    assign B_ADDR = addr_b;
    assign word_b = B_DOUT;

    assign C_ADDR = {3'b0, addr_c};
    assign word_c = C_DOUT;

    RAM_32x4_2R_1W #(
      .B_REG  (1'b1),
      .C_REG  (1'b0)
      ) RAM_32x4_2R_1W (
        // Port A - Write
        .A_CLK    (clk1_buf),
        .A_ADDR0  (A_ADDR[0]),
        .A_ADDR1  (A_ADDR[1]),
        .A_ADDR2  (A_ADDR[2]),
        .A_ADDR3  (A_ADDR[3]),
        .A_ADDR4  (A_ADDR[4]),
        .A_WEN    (1'b1),
        .A_DIN0   (A_DIN[0]),
        .A_DIN1   (A_DIN[1]),
        .A_DIN2   (A_DIN[2]),
        .A_DIN3   (A_DIN[3]),

        // Port B - Read
        .B_CLK    (clk2_buf),
        .B_ADDR0  (B_ADDR[0]),
        .B_ADDR1  (B_ADDR[1]),
        .B_ADDR2  (B_ADDR[2]),
        .B_ADDR3  (B_ADDR[3]),
        .B_ADDR4  (B_ADDR[4]),
        .B_REN    (1'b1),
        .B_DOUT0  (B_DOUT[0]),
        .B_DOUT1  (B_DOUT[1]),
        .B_DOUT2  (B_DOUT[2]),
        .B_DOUT3  (B_DOUT[3]),

        // Port C - Read
        .C_CLK    (),
        .C_ADDR0  (C_ADDR[0]),
        .C_ADDR1  (C_ADDR[1]),
        .C_ADDR2  (C_ADDR[2]),
        .C_ADDR3  (C_ADDR[3]),
        .C_ADDR4  (C_ADDR[4]),
        .C_REN    (1'b1),
        .C_DOUT0  (C_DOUT[0]),
        .C_DOUT1  (C_DOUT[1]),
        .C_DOUT2  (C_DOUT[2]),
        .C_DOUT3  (C_DOUT[3])
    );

endmodule

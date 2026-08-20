// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module macc_8x8_20 (
    input  wire       clk1,
    input  wire       rst,
    input  wire       ena,
    
    input  wire [ 5:0] a,
    input  wire [ 5:0] b,
    output wire [11:0] product
);

    logic clk1_buf;

    GBUF clock1_buf (
      .IN   (clk1),
      .OUT  (clk1_buf)
    );

    // We need to combine individual bits into vectors
    // since FABulous doesn't support vectors for primitives yet
    wire [ 7:0] A;
    wire [ 7:0] B;
    wire [19:0] C;
    wire [19:0] Q;
    
    assign A = {2'b0, a};
    assign B = {2'b0, b};
    assign C = '0;
    
    assign product = Q[11:0]; 

    MACC_8x8_20 #(
        .A_REG    (1'b0),
        .B_REG    (1'b0),
        .C_REG    (1'b0),
        .SIGN_EXT (1'b0),
        .ACC_SEL  (1'b0),
        .ACC_OUT  (1'b0),
        .CLK_INV  (1'b0)
      ) MACC_8x8_20 (
        .CLK  (clk1_buf),
        .EN   (ena),

        .ACC_RST  (rst),
        .ACC_CI   (1'b0),
        .ACC_CO   (),
        
        .A0 (A[0]),
        .A1 (A[1]),
        .A2 (A[2]),
        .A3 (A[3]),
        .A4 (A[4]),
        .A5 (A[5]),
        .A6 (A[6]),
        .A7 (A[7]),

        .B0 (B[0]),
        .B1 (B[1]),
        .B2 (B[2]),
        .B3 (B[3]),
        .B4 (B[4]),
        .B5 (B[5]),
        .B6 (B[6]),
        .B7 (B[7]),

        .C0 (C[0]),
        .C1 (C[1]),
        .C2 (C[2]),
        .C3 (C[3]),
        .C4 (C[4]),
        .C5 (C[5]),
        .C6 (C[6]),
        .C7 (C[7]),
        .C8 (C[8]),
        .C9 (C[9]),
        .C10 (C[10]),
        .C11 (C[11]),
        .C12 (C[12]),
        .C13 (C[13]),
        .C14 (C[14]),
        .C15 (C[15]),
        .C16 (C[16]),
        .C17 (C[17]),
        .C18 (C[18]),
        .C19 (C[19]),
        
        .Q0 (Q[0]),
        .Q1 (Q[1]),
        .Q2 (Q[2]),
        .Q3 (Q[3]),
        .Q4 (Q[4]),
        .Q5 (Q[5]),
        .Q6 (Q[6]),
        .Q7 (Q[7]),
        .Q8 (Q[8]),
        .Q9 (Q[9]),
        .Q10 (Q[10]),
        .Q11 (Q[11]),
        .Q12 (Q[12]),
        .Q13 (Q[13]),
        .Q14 (Q[14]),
        .Q15 (Q[15]),
        .Q16 (Q[16]),
        .Q17 (Q[17]),
        .Q18 (Q[18]),
        .Q19 (Q[19])
    );

endmodule

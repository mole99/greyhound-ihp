// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module register_file (
    input  wire       clk1,
    input  wire       clk2,
    input  wire       rst,
    input  wire       ena,
    
    input  wire [3:0] addr_a,
    input  wire [3:0] addr_b,
    input  wire [1:0] addr_c,
    
    // Input word
    input  wire [3:0] word_a,
    
    // Output words
    output wire [3:0] word_b,
    output wire [3:0] word_c
);

    logic [3:0] mem [16];

    // Port A
    always_ff @(posedge clk1) begin
        mem[addr_a] <= word_a;
    end

    logic [3:0] word_b_reg;

    // Port B
    always_ff @(posedge clk2) begin
        word_b_reg <= mem[addr_b]; 
    end
    
    assign word_b = word_b_reg;
    
    // Port C
    assign word_c = mem[{3'b0, addr_c}];

endmodule

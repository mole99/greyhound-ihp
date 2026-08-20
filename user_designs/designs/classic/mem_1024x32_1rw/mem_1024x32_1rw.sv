// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module mem_1024x32_1rw (
    input  wire       clk1,
    
    input  wire [9:0] ram_addr,
    input  wire [1:0] ram_byte_sel,
    input  wire       ram_wen,
    input  wire       ram_men,
    input  wire       ram_ren,
    input  wire [7:0] ram_din_byte,
    output wire [7:0] ram_dout_byte
);
    
    logic [31:0] ram_din;
    logic [31:0] ram_dout;
    
    assign ram_din = ram_din_byte << (8 * ram_byte_sel);

    (* ram_style = "block" *) logic [31:0] mem [1024];

    always @(posedge clk1) begin
        if (ram_men && ram_wen) begin
            if (ram_byte_sel == 2'd0) mem[ram_addr][ 7: 0] <= ram_din[ 7: 0];
            if (ram_byte_sel == 2'd1) mem[ram_addr][15: 8] <= ram_din[15: 8];
            if (ram_byte_sel == 2'd2) mem[ram_addr][23:16] <= ram_din[23:16];
            if (ram_byte_sel == 2'd3) mem[ram_addr][31:24] <= ram_din[31:24];
        end else if (ram_men && ram_ren) begin
            ram_dout <= mem[ram_addr];
        end
    end
    
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

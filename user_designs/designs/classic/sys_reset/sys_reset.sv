// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module sys_reset (
    input  wire clk1,
    
    input  wire [5:0] a,
    output wire [5:0] b
);

    wire clk1_buf;

    GBUF clock_buf_i (
      .IN   (clk1),
      .OUT  (clk1_buf)
    );

    wire rst, rst_buf;

    SYS_RESET SYS_RESET (
        .RESET(rst)
    );
    
    GBUF rst_buf_i (
      .IN   (rst),
      .OUT  (rst_buf)
    );

    logic [5:0] data;

    always_ff @(posedge clk1_buf) begin
        if (rst_buf) begin
            data <= 8'h37;
        end else begin
            data <= a;
        end
    end

    assign b = data;

endmodule

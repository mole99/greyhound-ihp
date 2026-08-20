// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module addition (
    input  wire [5:0] a,
    input  wire [5:0] b,
    output wire [7:0] c
);

    assign c = a + b;

endmodule

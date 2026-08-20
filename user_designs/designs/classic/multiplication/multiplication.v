// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module multiplication (
    input  wire [5:0] a,
    input  wire [5:0] b,
    output wire [11:0] product
);

    assign product = a * b;

endmodule

// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module passthrough (
    input  wire [5:0] a,
    output wire [5:0] b
);

    assign b = a;

endmodule

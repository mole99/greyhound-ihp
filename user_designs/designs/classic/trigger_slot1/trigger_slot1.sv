// SPDX-FileCopyrightText: © 2026 Leo Moser
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module trigger_slot1 (
    input  wire sys_clk,
    output wire [31:0] all
);

    // Boot from slot 1

    WARMBOOT_wrapper WARMBOOT_wrapper (
        .SLOT    (4'd1),
        .TRIGGER (1'b1)
    );

    assign all = '0;

endmodule

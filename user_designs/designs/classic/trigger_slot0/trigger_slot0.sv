// SPDX-FileCopyrightText: © 2026 Leo Moser
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module trigger_slot0 (
    input  wire sys_clk,
    
    output wire [31:0] all
);

    logic reset, reset_buf, reset_fabric;

    SYS_RESET SYS_RESET (
        .RESET  (reset)
    );
    
    GBUF GBUF (
        .IN  (reset),
        .OUT (reset_buf)
    );

    WARMBOOT_wrapper WARMBOOT_wrapper (
        .SLOT    (4'd0),
        .TRIGGER (trigger)
    );

    // Boot from slot 0 when the counter
    // has reached the value 0
    
    logic RESET;
    logic [3:0] counter;
    logic trigger;
    
    always_ff @(posedge sys_clk) begin
        if (reset_buf) begin
            counter <= '1;
            trigger <= 1'b0;
        end else begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                trigger <= 1'b1;
            end
        end
    end

    assign all = '1;

endmodule

// SPDX-FileCopyrightText: © 2026 Leo Moser
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module trigger_irq (
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
        .TRIGGER (1'b0)
    );

    // Trigger IRQ0 when the counter
    // has reached the value 0
    
    logic [3:0] counter;
    logic trigger_irq0;
    
    always_ff @(posedge sys_clk) begin
        if (reset_buf) begin
            counter <= '1;
            trigger_irq0 <= 1'b0;
        end else begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                trigger_irq0 <= 1'b1;
            end
        end
    end
    
    CPU_IRQ CPU_IRQ (
        .IRQ0    (trigger_irq0),
        .IRQ1    (1'b0),
        .IRQ2    (1'b0),
        .IRQ3    (1'b0)
    );

    assign all = 32'hCAFECAFE;

endmodule

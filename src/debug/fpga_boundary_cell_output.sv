// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

// IO cell in accordance to IEEE1149.1 Figure 11-31, adjusted for non gated clk and tap device used here
module fpga_boundary_cell_output (
    input  logic clk_i,
    input  logic jclk_rising_i,
    input  logic jclk_falling_i,
    input  logic trst_n_sync_i,
    input  logic tclear_i,
    // Gated clk
    input  logic capture_bsr_select_i,
    input  logic shift_bsr_select_i,
    input  logic update_bsr_select_i,
    // System logic connection
    input  logic output_data_i,
    // Mode configuration
    input  logic mode1_i,
    input  logic highZ_i,
    // Daisy chain connection
    input  logic td_i,
    output logic td_o,
    // System pin connection
    output logic pin_o
);
    logic tdo_d, tdo_q;
    logic output_data_q, pino_d;

    assign pino_d = mode1_i ? output_data_q : output_data_i;
    assign pin_o  = highZ_i ? 1'b0 : pino_d;
    assign tdo_d  = shift_bsr_select_i ? td_i : output_data_i;
    assign td_o   = tdo_q;

    // Boundary regs
    always_ff @(posedge clk_i) begin
        if (!trst_n_sync_i) begin
            tdo_q <= '0;
        end
        else if (jclk_rising_i) begin
            if (tclear_i) begin
                tdo_q <= '0;
            end
            else if (shift_bsr_select_i | capture_bsr_select_i) begin
                tdo_q <= tdo_d;
            end
        end
    end

    always_ff @(posedge clk_i) begin
        if (!trst_n_sync_i) begin
            output_data_q <= '0;
        end
        else if (jclk_falling_i) begin
            if (tclear_i) begin
                output_data_q <= '0;
            end
            else if (update_bsr_select_i) begin
                output_data_q <= tdo_q;
            end
        end
    end
endmodule
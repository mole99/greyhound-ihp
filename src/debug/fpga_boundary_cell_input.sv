// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

// IO cell in accordance to IEEE1149.1 Figure 11-15, adjusted for non gated clk and tap device used here
module fpga_boundary_cell_input (
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
    output logic input_data_o,
    // Mode configuration
    input  logic mode2_i,
    // Daisy chain connection
    input  logic td_i,
    output logic td_o,
    // System pin connection
    input  logic pin_i
);
    logic tdo_d, tdo_q;
    logic input_data_q;

    assign input_data_o = mode2_i ? input_data_q : pin_i;
    assign tdo_d        = shift_bsr_select_i ? td_i : input_data_o;
    assign td_o         = tdo_q;

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
            input_data_q <= '0;
        end
        else if (jclk_falling_i) begin
            if (tclear_i) begin
                input_data_q <= '0;
            end
            else if (update_bsr_select_i) begin
                input_data_q <= tdo_q;
            end
        end
    end
endmodule
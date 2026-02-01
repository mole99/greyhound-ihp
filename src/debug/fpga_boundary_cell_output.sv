// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

// IO cell in accordance to IEEE1149.1 Figure 11-31, adjusted for non gated clk and tap device used here
module fpga_boundary_cell_output (
    input  logic tclk_i,
    input  logic tclk_ni,
    input  logic trst_ni,
    input  logic tclear_i,
    // Gated clk
    input  logic capture_bsr_select_i,
    input  logic shift_bsr_select_i,
    input  logic update_bsr_select_i,
    // System logic connection
    input  logic output_data_i,
    // Mode configuration
    input  logic mode1_i,
    // Daisy chain connection
    input  logic td_i,
    output logic td_o,
    // System pin connection
    output logic pin_o
);
    logic tdo_d, tdo_q;
    logic output_data_q;

    assign pin_o = mode1_i ? output_data_q : output_data_i;
    assign tdo_d = shift_bsr_select_i ? td_i : output_data_i;
    assign td_o  = tdo_q;

    // Boundary regs
    always_ff @(posedge tclk_i, negedge trst_ni) begin
        if (!trst_ni) begin
            tdo_q <= '0;
        end
        else begin
            if (tclear_i) begin
                tdo_q <= '0;
            end
            else if (shift_bsr_select_i | capture_bsr_select_i) begin
                tdo_q <= tdo_d;
            end
        end
    end

    always_ff @(posedge tclk_ni, negedge trst_ni) begin
        if (!trst_ni) begin
            output_data_q <= '0;
        end
        else begin
            if (tclear_i) begin
                output_data_q <= '0;
            end
            else if (update_bsr_select_i) begin
                output_data_q <= tdo_q;
            end
        end
    end
endmodule
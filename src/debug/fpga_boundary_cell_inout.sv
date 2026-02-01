// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0

// IO cell in accordance to IEEE1149.1 Figure 11-38, adjusted for non gated clk and tap device used here
module fpga_boundary_cell_inout (
    input  logic tclk_i,
    input  logic tclk_ni,
    input  logic trst_ni,
    input  logic tclear_i,
    // Gated clk
    input  logic capture_bsr_select_i,
    input  logic shift_bsr_select_i,
    input  logic update_bsr_select_i,
    // System logic connection
    input  logic output_enable_i,
    input  logic output_data_i,
    output logic input_data_o,
    // Mode configuration
    input  logic mode2_i,
    input  logic mode5_i,
    input  logic mode6_i,
    // Daisy chain connection
    input  logic td_i,
    output logic td_o,
    // System pin connection
    input  logic pin_i,
    output logic pin_o,
    output logic enable_pin_o
);
    logic output_enable, output_enable_q;
    logic tdo_d, tdo_q;
    logic pino_g11_d, pino_g11_q;
    logic pino_g1, input_data;

    // Control cell
    assign enable_pin_o  = mode6_i & output_enable;
    assign output_enable = mode5_i ? output_enable_q : output_enable_i;
    assign tdo_d         = shift_bsr_select_i ? pino_g11_q : output_enable;
    assign td_o          = tdo_q;

    // Combined input/output cell
    assign pin_o        = mode5_i ? input_data : output_data_i;
    assign pino_g1      = (output_enable & ~mode5_i) ? pin_o : input_data_o;
    assign pino_g11_d   = shift_bsr_select_i ? td_i : pino_g1;
    assign input_data_o = mode2_i ? input_data : pin_i;

    // Boundary regs
    always_ff @(posedge tclk_i, negedge trst_ni) begin
        if (!trst_ni) begin
            pino_g11_q <= '0;
            tdo_q      <= '0;
        end
        else begin
            if (tclear_i) begin
                pino_g11_q <= '0;
                tdo_q      <= '0;
            end
            else if (shift_bsr_select_i | capture_bsr_select_i) begin
                pino_g11_q <= pino_g11_d;
                tdo_q      <= tdo_d;
            end
        end
    end

    always_ff @(posedge tclk_ni, negedge trst_ni) begin
        if (!trst_ni) begin
            output_enable_q <= '0;
            input_data      <= '0;
        end
        else begin
            if (tclear_i) begin
                output_enable_q <= '0;
                input_data      <= '0;
            end
            else if (update_bsr_select_i) begin
                output_enable_q <= tdo_q;
                input_data      <= pino_g11_q;
            end
        end
    end
endmodule
// SPDX-FileCopyrightText: © 2018 ETH Zurich and University of Bologna
// SPDX-License-Identifier: Apache-2.0 
// SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

module tc_clk_inverter (
    input  logic clk_i,
    output logic clk_o
  );
  (* keep *)(* dont_touch = "true" *)
  sg13g2_inv_1 i_inv (
    .A ( clk_i ),
    .Y ( clk_o )
  );

endmodule

module tc_clk_mux2 (
    input  logic clk0_i,
    input  logic clk1_i,
    input  logic clk_sel_i,
    output logic clk_o
  );
  (* keep *)(* dont_touch = "true" *)
  sg13g2_mux2_1 i_mux (
    .A0 ( clk0_i    ),
    .A1 ( clk1_i    ),
    .S  ( clk_sel_i ),
    .X  ( clk_o     )
  );
endmodule

module tc_clk_gating (
  input  logic clk_i,
  input  logic en_i,
  output logic clk_o
);
  (* keep, dont_touch *)
  sg13g2_lgcp_1 clk_gate (
    .CLK  (clk_i),
    .GATE (en_i),
    .GCLK (clk_o)
  );
endmodule

// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

module cv32e40x_clock_gate
#(
  parameter LIB = 0
  )
(
    input  logic clk_i,
    input  logic en_i,
    input  logic scan_cg_en_i,
    output logic clk_o
  );

  /*sky130_fd_sc_hd__dlclkp_4 clk_gate (
    `ifdef USE_POWER_PINS
    .VPWR(1'b1),
    .VGND(1'b0),
    .VPB (1'b1),
    .VNB (1'b0),
    `endif
    .CLK(clk_i),
    .GATE(en_i | scan_cg_en_i),
    .GCLK(clk_o)
  );*/  
  
  sg13g2_lgcp_1 clk_gate (
      .CLK      (clk_i),
      .GATE     (en_i | scan_cg_en_i),
      .GCLK     (clk_o)
  );

endmodule // cv32e40x_clock_gate

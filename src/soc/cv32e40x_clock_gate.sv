// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// !!! cv32e40x_sim_clock_gate file is meant for simulation only !!!
// !!! It must not be used for ASIC synthesis                    !!!
// !!! It must not be used for FPGA synthesis                    !!!

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

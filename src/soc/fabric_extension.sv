// SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module fabric_extension import cv32e40x_pkg::*;
(
    cv32e40x_if_xif.coproc_compressed xif_compressed,
    cv32e40x_if_xif.coproc_issue      xif_issue,
    cv32e40x_if_xif.coproc_commit     xif_commit,
    cv32e40x_if_xif.coproc_mem        xif_mem,
    cv32e40x_if_xif.coproc_mem_result xif_mem_result,
    cv32e40x_if_xif.coproc_result     xif_result,
    
    // Our custom instruction interface
    input  logic        fabric_issue_ready_i,
    input  logic        fabric_issue_accept_i,
    output logic        fabric_issue_valid_o,
    output logic [31:0] fabric_issue_instr_o,
    output logic [31:0] fabric_issue_op0_o,
    output logic [31:0] fabric_issue_op1_o,
    output logic [3 :0] fabric_issue_id_o,
    
    input  logic        fabric_result_valid_i,
    input  logic [3 :0] fabric_result_id_i,
    input  logic [4 :0] fabric_result_rd_i,
    input  logic [31:0] fabric_result_i
);
    assign xif_compressed.compressed_ready       = '0;
    assign xif_compressed.compressed_resp.accept = '0;
    assign xif_compressed.compressed_resp.instr  = '0;

    assign xif_issue.issue_ready           = fabric_issue_ready_i;
    assign xif_issue.issue_resp.accept     = fabric_issue_accept_i;
    assign xif_issue.issue_resp.writeback  = '1;
    assign xif_issue.issue_resp.dualwrite  = '0;
    assign xif_issue.issue_resp.dualread   = '0;
    assign xif_issue.issue_resp.loadstore  = '0;
    assign xif_issue.issue_resp.ecswrite   = '0;
    assign xif_issue.issue_resp.exc        = '0;

    assign xif_mem.mem_valid        = '0;
    assign xif_mem.mem_req.id       = '0;
    assign xif_mem.mem_req.addr     = '0;
    assign xif_mem.mem_req.mode     = '0;
    assign xif_mem.mem_req.we       = '0;
    assign xif_mem.mem_req.size     = '0;
    assign xif_mem.mem_req.be       = '0;
    assign xif_mem.mem_req.attr     = '0;
    assign xif_mem.mem_req.wdata    = '0;
    assign xif_mem.mem_req.last     = '0;
    assign xif_mem.mem_req.spec     = '0;

    assign xif_result.result_valid      = fabric_result_valid_i;
    assign xif_result.result.id         = fabric_result_id_i;
    assign xif_result.result.data       = fabric_result_i;
    assign xif_result.result.rd         = fabric_result_rd_i;
    assign xif_result.result.we         = '0;
    assign xif_result.result.ecsdata    = '0;
    assign xif_result.result.ecswe      = '0;
    assign xif_result.result.exc        = '0;
    assign xif_result.result.exccode    = '0;
    assign xif_result.result.err        = '0;
    assign xif_result.result.dbg        = '0;

    assign fabric_issue_valid_o = xif_issue.issue_valid;
    assign fabric_issue_instr_o = xif_issue.issue_req.instr;
    assign fabric_issue_op0_o   = xif_issue.issue_req.rs[0];
    assign fabric_issue_op1_o   = xif_issue.issue_req.rs[1];
    assign fabric_issue_id_o    = xif_issue.issue_req.id;

endmodule

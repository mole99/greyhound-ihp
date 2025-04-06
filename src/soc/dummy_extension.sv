`default_nettype none

module dummy_extension import cv32e40x_pkg::*;
(
    input logic              clk_i,
    input logic              rst_ni,

    cv32e40x_if_xif.coproc_compressed xif_compressed,
    cv32e40x_if_xif.coproc_issue      xif_issue,
    cv32e40x_if_xif.coproc_commit     xif_commit,
    cv32e40x_if_xif.coproc_mem        xif_mem,
    cv32e40x_if_xif.coproc_mem_result xif_mem_result,
    cv32e40x_if_xif.coproc_result     xif_result
);

    assign xif_compressed.compressed_ready       = '0;
    assign xif_compressed.compressed_resp.accept = '0;
    assign xif_compressed.compressed_resp.instr  = '0;

    assign xif_issue.issue_ready           = '1;
    assign xif_issue.issue_resp.accept     = xif_issue.issue_valid && xif_issue.issue_req.instr[6:0] == 7'h42;
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

    assign xif_result.result_valid      = xif_result.result_ready;
    assign xif_result.result.id         = xif_issue.issue_req.id;
    assign xif_result.result.data       = 32'hDEAD_BEEF;
    assign xif_result.result.rd         = xif_issue.issue_req.instr[11:7];
    assign xif_result.result.we         = '0;
    assign xif_result.result.ecsdata    = '0;
    assign xif_result.result.ecswe      = '0;
    assign xif_result.result.exc        = '0;
    assign xif_result.result.exccode    = '0;
    assign xif_result.result.err        = '0;
    assign xif_result.result.dbg        = '0;

    /*
    xif_issue_if.issue_valid && xif_issue_if.issue_req.instr[6:0] == OPCODE_TODO
    
    rs0 <= xif_issue_if.issue_req.rs[0];
    rs1 <= xif_issue_if.issue_req.rs[1];
    rd  <= xif_issue_if.issue_req.instr[11:7];
    id  <= xif_issue_if.issue_req.id;
    */

endmodule

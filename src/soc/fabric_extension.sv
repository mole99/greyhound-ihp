`default_nettype none

module fabric_extension import cv32e40x_pkg::*;
(
    input  logic              clk_i,
    input  logic              rst_ni,

    cv32e40x_if_xif.coproc_compressed xif_compressed,
    cv32e40x_if_xif.coproc_issue      xif_issue,
    cv32e40x_if_xif.coproc_commit     xif_commit,
    cv32e40x_if_xif.coproc_mem        xif_mem,
    cv32e40x_if_xif.coproc_mem_result xif_mem_result,
    cv32e40x_if_xif.coproc_result     xif_result,
    
    output logic [31:0] fabric_rs1_o,
    output logic [31:0] fabric_rs2_o,
    input  logic [31:0] fabric_result_i,
);

    assign xif_compressed.compressed_ready       = '0;
    assign xif_compressed.compressed_resp.accept = '0;
    assign xif_compressed.compressed_resp.instr  = '0;

    assign xif_issue.issue_ready           = '1;
    assign xif_issue.issue_resp.accept     = match;
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

    assign xif_result.result_valid      = done;
    assign xif_result.result.id         = id_d;
    assign xif_result.result.data       = fabric_result_i;
    assign xif_result.result.rd         = rd_d;
    assign xif_result.result.we         = '0;
    assign xif_result.result.ecsdata    = '0;
    assign xif_result.result.ecswe      = '0;
    assign xif_result.result.exc        = '0;
    assign xif_result.result.exccode    = '0;
    assign xif_result.result.err        = '0;
    assign xif_result.result.dbg        = '0;

    // 0x0B, 0x2B, 0x5B and 0x7B
    // are free for custom use
    localparam OPCODE_XIF = 7'h5B;
    
    // Use GCC .insn pseudo directive:
    // R type: .insn r opcode7, func3, func7, rd, rs1, rs2
    
    // R-type instruction decoding
    logic [6:0] opcode;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode   = xif_issue.issue_req.instr[6:0];
    assign rs1      = xif_issue.issue_req.instr[19:15];
    assign rs2      = xif_issue.issue_req.instr[24:20];
    assign rd       = xif_issue.issue_req.instr[11:7];
    assign funct3   = xif_issue.issue_req.instr[14:12];
    assign funct7   = xif_issue.issue_req.instr[31:25];
    
    logic [31:0] rs1_d;
    logic [31:0] rs2_d;
    logic [3:0]  id_d;
    logic [3:0]  rd_d;
    
    logic [6:0] counter;
    logic       busy;
    logic       done;
    
    logic match;
    
    assign match = opcode == OPCODE_XIF;
    
    always @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            rs1_d   <= '0;
            rs2_d   <= '0;
            id_d    <= '0;
            rd_d    <= '0;
            counter <= '0;
            done    <= 1'b0;
            busy    <= 1'b0;
        end else begin
            done <= 1'b0;

            if (xif_issue.issue_valid && match && xif_issue.issue_req.rs_valid == 2'b11 && !busy) begin
                rs1_d <= xif_issue.issue_req.rs[0];
                rs2_d <= xif_issue.issue_req.rs[1];
                id_d  <= xif_issue.issue_req.id;
                rd_d  <= rd;
                
                busy    <= 1'b1;
                counter <= funct7;
            end
            
            if (busy && counter == '0) begin
                busy <= 1'b0;
                done <= 1'b1;
            end
            
            if (counter != '0) begin
                counter <= counter - 1;
            end
        end
    end
    
    assign fabric_rs1_o = rs1_d;
    assign fabric_rs2_o = rs2_d;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2025 16:41:40
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(input clk, rst,
input [31:0] pc_id,
input [31:0] rs1_data, rs2_data,
input  [31:0] imm_out,
input  [4:0]  rd,
input alu_src,
input [2:0] alu_op,
input regwrite,
input [4:0] rs1,rs2,
input memread,memwrite,memtoreg,
input [2:0] loadtype,strtype,
input load_hazard,
input branch_taken,

output reg [31:0] pc_ex,
output reg [31:0] rs1_data_ex, rs2_data_ex,
output reg [31:0] imm_out_ex,
output reg [4:0]  rd_ex,
output reg alu_src_ex,
output reg [2:0] alu_op_ex,
output reg regwrite_ex,
output reg [4:0] rs1_id_ex,rs2_id_ex,
output reg memread_id_ex,memwrite_id_ex,memtoreg_id_ex,
output reg [2:0] loadtype_id_ex,strtype_id_ex);


always@(posedge clk) begin
if(rst) begin
pc_ex <= 0;
{rs1_data_ex, rs2_data_ex} <= 0;
imm_out_ex <= 0;
rd_ex <= 0;
alu_src_ex <= 0;
alu_op_ex <= 0;
regwrite_ex <= 0;
{rs1_id_ex,rs2_id_ex} <= 0;
{memread_id_ex,memwrite_id_ex,memtoreg_id_ex} <= 0;
end

else if(branch_taken)  begin// insert NOP or Flush the instructions
regwrite_ex <= 0;
{memread_id_ex,memwrite_id_ex,memtoreg_id_ex} <= 0;
alu_src_ex <= 0;
alu_op_ex <= 0;
end

else if (load_hazard) begin
// Insert NOP stages
regwrite_ex <= 0;
{memread_id_ex,memwrite_id_ex,memtoreg_id_ex} <= 0;
alu_src_ex <= 0;
alu_op_ex <= 0;
end    


else begin
pc_ex <= pc_id;
{rs1_data_ex, rs2_data_ex} <={rs1_data, rs2_data} ;
imm_out_ex <= imm_out;
rd_ex <= rd;
alu_src_ex <= alu_src;
alu_op_ex <= alu_op;
regwrite_ex <= regwrite; 
{rs1_id_ex,rs2_id_ex} <= {rs1,rs2};
{memread_id_ex,memwrite_id_ex,memtoreg_id_ex} <={memread,memwrite,memtoreg} ;
{loadtype_id_ex,strtype_id_ex} <= {loadtype,strtype};
end

end
endmodule

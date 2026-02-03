`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2025 16:49:49
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(input clk,rst,
input  [31:0] alu_result_ex,
input  [4:0] rd_ex_out,
input regwrite_ex_out,
input [31:0] rs2_data_ex_out,
input memread_ex,memwrite_ex,memtoreg_ex,
input [2:0] loadtype_ex,strtype_ex,


output reg [31:0] alu_result_mem,
output reg [4:0] rd_mem_out,
output reg regwrite_mem_out,
output reg memread_ex_mem,memwrite_ex_mem,memtoreg_ex_mem,
output reg [2:0] loadtype_ex_mem,strtype_ex_mem,
output reg [31:0] rs2_data_ex_mem);


always@(posedge clk)begin
if(rst) begin
{alu_result_mem,rd_mem_out,regwrite_mem_out} <= 0;
{memread_ex_mem,memwrite_ex_mem,memtoreg_ex_mem} <= 0;
rs2_data_ex_mem <= 0;
loadtype_ex_mem <= 0;
strtype_ex_mem  <= 0;
end

else begin   
alu_result_mem <= alu_result_ex;
rd_mem_out <= rd_ex_out;
regwrite_mem_out <= regwrite_ex_out;
{memread_ex_mem,memwrite_ex_mem,memtoreg_ex_mem} <= {memread_ex,memwrite_ex,memtoreg_ex};
{loadtype_ex_mem,strtype_ex_mem} <= {loadtype_ex,strtype_ex};
rs2_data_ex_mem <=rs2_data_ex_out;

end
end
endmodule

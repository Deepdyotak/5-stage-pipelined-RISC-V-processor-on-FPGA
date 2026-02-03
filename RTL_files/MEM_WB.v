`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2025 17:26:43
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(input clk,rst,
input[31:0] alu_result_mem1,
input [4:0] rd_mem_out1, 
input regwrite_mem_out1,
input [31:0] mem_data_mem1,
input memtoreg_mem,
output reg [31:0] alu_result_wb,
output reg [4:0] rd_wb_out,
output reg regwrite_wb_out,
output reg [31:0] mem_data_mem_wb,
output reg memtoreg_mem_wb);
always@(posedge clk)begin
if(rst) begin 
alu_result_wb <= 0;
rd_wb_out <= 0; 
regwrite_wb_out <= 0;
mem_data_mem_wb <= 0;
memtoreg_mem_wb <= 0;
end
else begin   
alu_result_wb <= alu_result_mem1;
rd_wb_out <= rd_mem_out1;
regwrite_wb_out <= regwrite_mem_out1;
mem_data_mem_wb <= mem_data_mem1;
memtoreg_mem_wb <= memtoreg_mem;


end
end
endmodule

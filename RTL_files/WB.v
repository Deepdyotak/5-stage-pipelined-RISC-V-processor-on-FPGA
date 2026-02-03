`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2025 11:17:07
// Design Name: 
// Module Name: WB
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


module WB(input clk,rst,
input [31:0] alu_result_wb,
input [4:0] rd_wb_out,
input regwrite_wb_out,
input memtoreg_mem_wb,
input [31:0] mem_data_mem_wb,

output [31:0] wb_data,
output [4:0] wb_rd,
output wb_regwrite,
output reg [5:0] ledreg);

// WB only does a small number of things if memtoreg =1 then choose memdata else alu result

// Fpga implementation
always@(posedge clk) begin
if(rst) ledreg <=0;
else if(regwrite_wb_out && rd_wb_out == 5'd5 ) // yaha par bhi display output of 5th register of regfile
ledreg <= wb_data[5:0];
end

assign wb_data = memtoreg_mem_wb ? mem_data_mem_wb : alu_result_wb;
assign wb_rd = rd_wb_out;
assign wb_regwrite = regwrite_wb_out;


endmodule

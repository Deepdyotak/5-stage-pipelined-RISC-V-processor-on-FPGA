`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2025 17:03:16
// Design Name: 
// Module Name: MEM
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


module MEM(input clk,rst,
input[31:0] alu_result_mem,
input [4:0] rd_mem_out, 
input [31:0] rs2_data_ex_mem,
input regwrite_mem_out,
input memread_ex_mem,memwrite_ex_mem,memtoreg_ex_mem,
input [2:0] loadtype_ex_mem,strtype_ex_mem,
output  [31:0] alu_result_mem1,
output  [4:0] rd_mem_out1,
output regwrite_mem_out1,
output [31:0]mem_data_mem1,
output memtoreg_mem,
output reg[31:0] led); // this output led is for fpga mapping 



// Data Memory 
reg[31:0] datamem[0:31]; //32 words
// Initialising all values in datamem as 0
integer i ;
initial begin
  for(i=0; i<32;i= i+1) 
  datamem[i] = i;
end 
//Address allotment
wire [4:0]word_addr = alu_result_mem >> 2; // here word_addr is 5 bits because we have 32 words in datamem 

//STORE WORD
always@(posedge clk) begin
if(memwrite_ex_mem) begin
datamem[word_addr] <= rs2_data_ex_mem; // store word (for now skipping the str_type)
end   
end
// LOAD TYPE   logic  is COMBINATIONAL
reg [31:0] mem_data;

always@(*) begin
if(memread_ex_mem)
mem_data = datamem[word_addr];  
else
mem_data = 32'b0;
end
//for FPGA datamem[0] mapping 
always@(posedge clk)begin
if(rst) led <= 32'b0;
else if(memwrite_ex_mem && alu_result_mem==32'b0 ) // yaha alu_result_mem = 0 matlab datamem[0]
led <= rs2_data_ex_mem;
end

assign alu_result_mem1 = alu_result_mem;
assign rd_mem_out1 = rd_mem_out;
assign regwrite_mem_out1 = regwrite_mem_out;
assign mem_data_mem1 = mem_data;
assign memtoreg_mem = memtoreg_ex_mem;

endmodule


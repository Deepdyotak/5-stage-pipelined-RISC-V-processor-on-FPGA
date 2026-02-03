`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2025 17:07:43
// Design Name: 
// Module Name: EX
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


module EX(
input  [31:0] pc_ex,
input  [31:0] rs1_data_ex, rs2_data_ex,
input  [31:0] imm_out_ex,
input  [4:0]  rd_ex,
input  alu_src_ex,
input  [2:0] alu_op_ex,
//ID-EX  se rs1,rs2 as inputs 
input [4:0] rs1_id_ex,rs2_id_ex,
//ID-EX se memory signals as input 
input memread_id_ex,memwrite_id_ex,memtoreg_id_ex,
input [2:0] loadtype_id_ex,strtype_id_ex,

// EX-MEM reg k outputs as  inputs to EX (forwarding logic )
input [31:0] alu_result_mem,
input  [4:0] rd_mem_out,
input  regwrite_mem_out,
// MEM-WB reg k inputs (forwarding logic)
input [31:0] alu_result_wb,
input [4:0] rd_wb_out,
input  regwrite_wb_out,
input regwrite_ex,
input [31:0] wb_data,

output reg [31:0] alu_result_ex,
output reg [4:0] rd_ex_out,
output reg regwrite_ex_out,
output reg memread_ex,memwrite_ex,memtoreg_ex,
output reg [2:0]loadtype_ex,strtype_ex,
output reg [31:0]rs2_data_ex_out
);
wire [31:0] op_2;

//forwarding logic agar satisfy hua then the final registers 
reg [31:0] rs1_data_final;
reg [31:0] rs2_data_final;
// this is for rs1
always@(*) begin
if (regwrite_mem_out && rd_mem_out != 0 && rd_mem_out == rs1_id_ex ) // ex-mem to ex bypass
rs1_data_final =alu_result_mem ;
else if(regwrite_wb_out && rd_wb_out != 0 &&  rd_wb_out == rs1_id_ex )// mem-wb to ex bypass
rs1_data_final =  wb_data;
else 
rs1_data_final = rs1_data_ex;
end
// for rs2
always@(*) begin
if (regwrite_mem_out && rd_mem_out != 0 && rd_mem_out == rs2_id_ex )
rs2_data_final = alu_result_mem;
else if(regwrite_wb_out && rd_wb_out != 0 &&  rd_wb_out == rs2_id_ex )// mem-wb to ex bypass
rs2_data_final = wb_data;
else 
rs2_data_final = rs2_data_ex;
end
// Mux to select operand 2
assign op_2 = alu_src_ex ? imm_out_ex : rs2_data_final;
always@(*) begin  
case(alu_op_ex) 
3'd0: alu_result_ex = rs1_data_final + op_2;
3'd1: alu_result_ex = rs1_data_final - op_2;
3'd2: alu_result_ex = rs1_data_final  ^ op_2;
3'd3: alu_result_ex = rs1_data_final | op_2;
3'd4: alu_result_ex = rs1_data_final & op_2;
3'd7: alu_result_ex = rs1_data_final; 
endcase
end
always @(*) begin
rd_ex_out = rd_ex;
rs2_data_ex_out = rs2_data_final;   
regwrite_ex_out = regwrite_ex;
{memread_ex,memwrite_ex,memtoreg_ex} = {memread_id_ex,memwrite_id_ex,memtoreg_id_ex};
{loadtype_ex,strtype_ex} = {loadtype_id_ex,strtype_id_ex};
end

 endmodule

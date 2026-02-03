`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2025 17:05:14
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(input clk,rst,
input [31:0] pc,instr_out,
input stall,
input branch_taken,
output reg [31:0] pc_if,instr_out_if );
always@(posedge clk)begin
if(rst) {pc_if, instr_out_if} <=0;// ~load_hazard means only when load_hazard is 0 then only work normally else freeze 
// here we are freezing the current instruction

else if(branch_taken) begin
 instr_out_if <= 32'h00000013; // Forcing the instructions entered into pipeline to be NOP or flushing them 
 pc_if <= pc_if;
 end

else if(stall) ;  // this means when load hazard do nothing hold the prev value
else {pc_if, instr_out_if} <= {pc,instr_out};
end
endmodule

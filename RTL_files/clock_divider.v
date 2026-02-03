`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 11:45:06
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(input clkin,
output reg clk);
reg [27:0] counter = 28'd0;
parameter divisor = 28'd2; // the frequency with which u divide input freq means clkout = fin/divisor
always@(posedge(clkin)) begin
counter <= counter+1'b1;
if(counter >= divisor-1) counter<=28'd0;
clk <= ( counter < divisor >> 2 )? 1'b1 : 1'b0;   // this tells how much time clk out should be on and how much time it should be off.
end

endmodule

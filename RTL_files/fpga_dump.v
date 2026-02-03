`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 12:05:30
// Design Name: 
// Module Name: fpga_dump
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


module fpga_dump(
    input  clk,
    input  rst,
    output [3:0] ledfpga,
    output [5:0] ledregfpga
    
);

reg rst_ff1, rst_ff2;
always @(posedge clk) begin
    rst_ff1 <= rst;
    rst_ff2 <= rst_ff1;
end    



riscv_top cpu(
    .clk(clk),
    .rst(rst_ff2),
    .ledfpga(ledfpga),
    .ledregfpga(ledregfpga)
);

endmodule


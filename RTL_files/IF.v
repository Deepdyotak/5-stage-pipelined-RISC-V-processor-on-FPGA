`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2025 15:44:35
// Design Name: 
// Module Name: IF
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





// so stall is basically load_hazard or branch_hazard whatever it may be pc should freeze else load hazard was addressed but branch hazard was not getting addressed
// by branch hazard i mean as beq/bne is done in ID it was made stall 1 cycle to take the latest values hence even branch was made to stall and then a new stall signal was made which took OR of both load and branch hazards
module IF(input clk,rst,
input stall, // take load_hazard as input from ID register to freeze the PC or stop counting ,pause it for a moment
input branch_taken,
input  [31:0] branch_target,
output reg [31:0] pc,
output [31:0] instr_out); // pc point to the instruction to  be executed hence 32 bits

// PC- Program counter Block
always@(posedge clk) begin
if(rst) pc <= 0;
else if(branch_taken) pc <= branch_target;  // when ever branch is taken jump to branch_target
else if(stall) pc <= pc; //Hold dont make it 0      // Freeze PC during load hazard or stalling
else pc <= pc + 3'd4;   // else work normally
end

// Instruction Memory 
reg [31:0] instruction_mem[0:31];
//Instructions for now 
//lets initialise everything with 0
integer i;
initial begin
  for (i = 0; i < 32; i = i + 1)
    instruction_mem[i] = 32'h00000013; // NOP
end

initial begin
/*instruction_mem[0] = 32'h00300093; // addi x1, x0, 3
instruction_mem[1] = 32'h00700113; // addi x2, x0, 7
instruction_mem[2] = 32'h002081B3; // add  x3, x1, x2*/


//instruction_mem[0] = 32'h00A00093; // addi x1, x0, 10
//instruction_mem[1] = 32'h00508113; // addi x2, x1, 5
//instruction_mem[2] = 32'h001101B3; // add  x3, x2, x1
//instruction_mem[3] = 32'h00718213; // addi x4, x3, 7
//instruction_mem[4] = 32'h002202B3; // add  x5, x4, x2



//Combination of R,I,Load/store(U type)
//instruction_mem[0] = 32'h00500093; // addi x1, x0, 5
//instruction_mem[1] = 32'h00102023; // sw   x1, 0(x0)
//instruction_mem[2] = 32'h00002083; // lw   x1, 0(x0)
//instruction_mem[3] = 32'h00308113; // addi x2, x1, 3   <- hazard here

// Lad Store Dependancy , here also load store hazard verification takes place along with branch instruction execution
// beq
//instruction_mem[0]  = 32'h00500093; // addi x1, x0, 5
//instruction_mem[1]  = 32'h00500113; // addi x2, x0, 5
//instruction_mem[2]  = 32'h002081B3; // add  x3, x1, x2   -> x3 = 10
//instruction_mem[3]  = 32'h00302023; // sw   x3, 0(x0)
//instruction_mem[4]  = 32'h00002203; // lw   x4, 0(x0)
//instruction_mem[5]  = 32'h00120293; // addi x5, x4, 1   -> load-use stall, x5 = 11
//instruction_mem[6]  = 32'h00208463; // beq  x1, x2, +8  (TAKEN)
//instruction_mem[7]  = 32'h00100313; // addi x6, x0, 1   (FLUSHED)
//instruction_mem[8]  = 32'h00200393; // addi x7, x0, 2   (EXECUTES – delay slot)
//instruction_mem[9]  = 32'h00900413; // addi x8, x0, 9   (BRANCH TARGET)


//bne
//instruction_mem[0]  = 32'h00300093; // addi x1, x0, 3
//instruction_mem[1]  = 32'h00400113; // addi x2, x0, 4
//instruction_mem[2] = 32'h00209663; // bne x1, x2, +8 (TAKEN)
//instruction_mem[3]  = 32'h00100193; // addi x3, x0, 1    (FLUSHED)
//instruction_mem[4]  = 32'h00200213; // addi x4, x0, 2    (DELAY SLOT)

//instruction_mem[5]  = 32'h00700293; // addi x5, x0, 7    (BRANCH TARGET)

//this also bne
//instruction_mem[0]  = 32'h00300093; // addi x1, x0, 3
//instruction_mem[1]  = 32'h00400113; // addi x2, x0, 4
//instruction_mem[2]  = 32'h002081B3; // add  x3, x1, x2   -> x3 = 7
//instruction_mem[3]  = 32'h00302023; // sw   x3, 0(x0)
//instruction_mem[4]  = 32'h00002203; // lw   x4, 0(x0)
//instruction_mem[5]  = 32'h00120293; // addi x5, x4, 1   -> load-use stall, x5 = 8
//instruction_mem[6]  = 32'h00209463; // bne  x1, x2, +8  (STALL + TAKEN)
//instruction_mem[7]  = 32'h00100313; // addi x6, x0, 1   (FLUSHED)
//instruction_mem[8]  = 32'h00200393; // addi x7, x0, 2   (DELAY SLOT)
//instruction_mem[9]  = 32'h00900413; // addi x8, x0, 9   (BRANCH TARGET)

instruction_mem[0]  = 32'h00500093; // addi x1, x0, 5
instruction_mem[1]  = 32'h00500113; // addi x2, x0, 5
instruction_mem[2]  = 32'h00208463; // beq  x1, x2, +8  (TAKEN)
instruction_mem[3]  = 32'h00100193; // addi x3, x0, 1   (FLUSHED)
instruction_mem[4]  = 32'h00200213; // addi x4, x0, 2   (DELAY SLOT)
instruction_mem[5]  = 32'h00900293; // addi x5, x0, 9   (BRANCH TARGET)











//just to test load and store
//instruction_mem[0] = 32'h00F00093; // addi x1, x0, 15
//instruction_mem[1] = 32'hFFB08113; // addi x2, x1, -5

//instruction_mem[2] = 32'h00000013; // nop
//instruction_mem[3] = 32'h00000013; // nop

//instruction_mem[4] = 32'h00202023; // sw x2, 0(x0)



end

//IF outputs
assign instr_out = instruction_mem[pc >> 2];

endmodule





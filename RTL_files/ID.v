`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2025 17:35:44
// Design Name: 
// Module Name: ID
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

module ID(
    input clk, rst,
    input  [31:0] pc_if, instr_if,
    input  [4:0]  wb_rd,
    input  [31:0] wb_data,
    input         wb_regwrite,
    input memread_id_ex, //memread signal from next stage , if its high then prev instr was Load type hence a need to address hazard
    input [4:0]  rd_ex, // Take destination register from ID_EX stage to compare and address load hazards 
    input regwrite_ex,  // Take regwrite signal from id_ex stage to see if it was on for prev instr, basically to add stall for branch instructions
    
    output reg [31:0] pc_id,
    output reg [31:0] rs1_data, rs2_data,
    output reg [31:0] imm_out,
    output reg [4:0]  rd,
    output reg alu_src, // alu_src = 1 for R & I type , alu_src = 0 for LW & SW
output reg [2:0] alu_op,
output reg regwrite,
output reg [4:0] rs1, rs2,
output reg memread,memwrite,memtoreg,
output reg[2:0] loadtype,strtype,
output load_hazard,
output reg branch,
output reg branch_type,
output reg branch_taken,
output reg [31:0]branch_target,
output stall
);

    
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [11:0] imm;
    

    // Register file
    reg [31:0] regfile [31:0];
 
wire branch_data_hazard;


    // Decode logic (combinational)

  always @(*) begin
    // defaults
    rs1 = 0; rs2 = 0; rd = 0; imm = 0;
    funct3 = 0; funct7 = 0;
    alu_src = 0; alu_op = 3'd7; regwrite = 0;
    memread = 0;memwrite = 0; memtoreg = 0;
    branch = 0; branch_type = 0;

    case (instr_if[6:0])

    // R-TYPE 
    7'b0110011: begin
        rs1 = instr_if[19:15];
        rs2 = instr_if[24:20];
        rd  = instr_if[11:7];
        funct3 = instr_if[14:12];
        funct7 = instr_if[31:25];
        alu_src  = 1'b0;
        regwrite = 1'b1;

        case ({funct7, funct3})
            {7'b0000000,3'b000}: alu_op = 3'd0; // ADD
            {7'b0100000,3'b000}: alu_op = 3'd1; // SUB
            {7'b0000000,3'b100}: alu_op = 3'd2; // XOR
            {7'b0000000,3'b110}: alu_op = 3'd3; // OR
            {7'b0000000,3'b111}: alu_op = 3'd4; // AND
            default:             alu_op = 3'd7;
        endcase
    end

    //  I-TYPE
    7'b0010011: begin
        rs1 = instr_if[19:15];
        rd  = instr_if[11:7];
        funct3 = instr_if[14:12];
        imm = instr_if[31:20];
        alu_src  = 1'b1;
        regwrite = 1'b1;

        case (funct3)
            3'b000: alu_op = 3'd0; // ADDI
            3'b100: alu_op = 3'd2; // XORI
            3'b110: alu_op = 3'd3; // ORI
            3'b111: alu_op = 3'd4; // ANDI
            default: alu_op = 3'd7;
        endcase
    end
    
    7'b0000011: begin  // Load Instruction
        rs1 = instr_if[19:15];
        rd = instr_if[11:7]; 
        imm = instr_if [31:20];
        funct3 = instr_if [14:12];
         alu_src = 1; 
         alu_op = 3'd0; 
         regwrite = 1;
         memread = 1;memwrite = 0; memtoreg = 1;
         
         case(funct3)
         3'b000: loadtype = 3'd0; //Load Byte
         3'b001:loadtype = 3'd1;// Load Half word
         3'b010:loadtype = 3'd2;//Load Word
         endcase
         end
         
         
       7'b0100011: begin //Store word 
        rs1 = instr_if[19:15];
        rs2 = instr_if[24:20]; 
        imm = {instr_if[31:25],instr_if[11:7]};
        funct3 = instr_if [14:12];
         funct7 = 0;
         alu_src = 1; 
         alu_op = 3'd0; 
         regwrite = 0;// because u write into datamem not regfile
         memread = 0;memwrite = 1; memtoreg = 0;
         case(funct3)
         3'b000: strtype = 3'd0; //Store Byte
         3'b001:strtype = 3'd1;// store Half word
         3'b010:strtype = 3'd2;//store Word
         endcase
         end
         
         // Branch Type
         7'b1100011:begin  
         rs1 = instr_if[19:15];
         rs2 = instr_if[24:20]; 
         imm = {instr_if[31],instr_if[7],instr_if[30:25],instr_if[11:8],1'b0};
         funct3 = instr_if[14:12];
         branch = 1'b1;
          alu_src  = 1'b0;   
          regwrite = 1'b0;
          memread  = 1'b0;
          memwrite = 1'b0;
         case(funct3)
         3'b000: branch_type = 1'd0; // beq
         3'b001: branch_type = 1'd1; // bne
         endcase    
         end  
         
     
    
    
    

    default: begin
        alu_op = 3'd7;
    end

    endcase
end

    // Register file read (combinational) inside the wb block only
    


    // Register file write (WB stage) and also initialising it with all values as 0
 integer i;
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1)
            regfile[i] <= 32'b0;
    end
      else if (wb_regwrite && wb_rd != 0) begin
        regfile[wb_rd] <= wb_data;
    end
end
always @(*) begin
    if (wb_regwrite && wb_rd != 0 && wb_rd == rs1)
        rs1_data = wb_data;
    else
        rs1_data = regfile[rs1];

    if (wb_regwrite && wb_rd != 0 && wb_rd == rs2)
        rs2_data = wb_data;
    else
        rs2_data = regfile[rs2];
end

 

 // PC forward
always @(posedge clk) begin
if (rst)
pc_id <= 32'b0;
 else
 pc_id <= pc_if;
end

    // Immediate sign extension

always @(*) begin
imm_out = {{20{imm[11]}}, imm};
end

// Detect LOAD HAZARD
assign load_hazard = (((rs1 == rd_ex) || (rs2 == rd_ex)) && memread_id_ex && (rd_ex != 0) );
// Stalling due to control Hazard
assign branch_data_hazard = (branch && (regwrite_ex && rd_ex != 0) && (rd_ex == rs1 || rd_ex == rs2));

// Final Stall
assign stall = load_hazard || branch_data_hazard;
 
  //Detect   Control hazard or basically deciding branch_taken signal in ID stage to compensate penalties happening in EX stage
  always@(*) begin
if(branch) begin
    if(~branch_type)  // if branch_type = 0 its beq , if 1 then bne
            branch_taken = (rs1_data == rs2_data);
    else if(branch_type)
            branch_taken = (rs1_data != rs2_data);
    end
else branch_taken = 0;
end
always@(*) begin 
branch_target = pc_if + imm_out;
end 




endmodule


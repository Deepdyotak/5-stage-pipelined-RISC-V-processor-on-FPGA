`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Deep Dyotak Dash
// 
// Create Date: 27.12.2025 11:53:42
// Design Name: 
// Module Name: riscv_top
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


    module riscv_top(input clk,rst,
    output [3:0] ledfpga,
    output[5:0] ledregfpga);
    //IF - IF-ID reg
    wire [31:0] pc1;
    wire [31:0] instr_out1;
    // IF-ID reg - ID
    wire [31:0] pc_if,instr_out_if;
    //ID - ID-EX reg
    wire [31:0] pc_id;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] imm_out;
    wire [4:0]  rd;
    wire alu_src;
    wire [2:0] alu_op;
    wire regwrite;
    wire [4:0] rs1, rs2;
    wire memread,memwrite,memtoreg;
    wire [2:0] loadtype,strtype;
    wire load_hazard;
    wire branch;
    wire branch_type;
    wire branch_taken;
    wire [31:0]branch_target;
    wire stall;
    // ID-EX reg - EX
    wire  [31:0] pc_id1;
    wire [31:0] rs1_data_id, rs2_data_id;
    wire [31:0] imm_out_id;
    wire [4:0]  rd_id;
    wire alu_src_id;
    wire [2:0] alu_op_id;
    wire regwrite_id;
    wire regwrite_ex;
    wire [4:0] rs1_id_ex,rs2_id_ex;
    wire  memread_id_ex,memwrite_id_ex,memtoreg_id_ex;
    wire [2:0] loadtype_id_ex,strtype_id_ex;
    //EX - EX-MEM reg
    wire [31:0] alu_result_ex;
    wire  [4:0] rd_ex_out;
    wire  regwrite_ex_out;
    wire memread_ex,memwrite_ex,memtoreg_ex;
    wire [2:0]loadtype_ex,strtype_ex;
    wire  [31:0]rs2_data_ex_out;
    
    //EX-MEM reg - MEM 
    wire [31:0] alu_result_mem;
    wire [4:0] rd_mem_out;
    wire regwrite_mem_out;
    wire memread_ex_mem,memwrite_ex_mem,memtoreg_ex_mem;
    wire  [2:0] loadtype_ex_mem,strtype_ex_mem;
    wire [31:0] rs2_data_ex_mem;

    //MEM - MEM-WB reg
    wire [31:0] alu_result_mem1;
    wire  [4:0] rd_mem_out1;
    wire  regwrite_mem_out1;
    wire [31:0] mem_data_mem1;
    wire memtoreg_mem;
    wire [31:0] led;
    //MEM-WB reg - WB
    wire [31:0] alu_result_wb;
    wire  [4:0] rd_wb_out;
    wire  regwrite_wb_out;
    wire [31:0] mem_data_mem_wb;
    wire  memtoreg_mem_wb;
    //WB stage 
    wire [31:0] wb_data;
    wire  [4:0] wb_rd;
    wire wb_regwrite;
    wire [31:0] ledreg;
    
    IF if_unit(.clk(clk),
    .rst(rst),
    .pc(pc1),
    .stall(stall),
    .branch_taken(branch_taken),
     .branch_target(branch_target),
    .instr_out(instr_out1));
    assign ledfpga = led[3:0];
    assign ledregfpga = ledreg[5:0];


IF_ID if_id(.clk(clk),
.rst(rst),
.pc(pc1),
.instr_out(instr_out1),
.stall(stall),
.branch_taken(branch_taken),
.pc_if(pc_if),
.instr_out_if(instr_out_if)
);


ID id_unit(.clk(clk),
.rst(rst),
.pc_if(pc_if),
.instr_if(instr_out_if),
.wb_data(wb_data),
.wb_regwrite(wb_regwrite),
.wb_rd(wb_rd),
.rd_ex(rd_id),
.memread_id_ex(memread_id_ex),
.regwrite_ex(regwrite_id),
.pc_id(pc_id),
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.imm_out(imm_out),
.rd(rd),
.alu_src(alu_src),
.alu_op(alu_op),
.regwrite(regwrite),
.rs1(rs1),
.rs2(rs2),
.memread(memread),
.memwrite(memwrite),
.memtoreg(memtoreg),
.loadtype(loadtype),
.strtype(strtype),
.load_hazard(load_hazard),
.branch(branch),
.branch_type(branch_type),
.branch_taken(branch_taken),
.branch_target(branch_target),
.stall(stall));


ID_EX  id_ex(.clk(clk),
.rst(rst),
.pc_id(pc_id),
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.imm_out(imm_out),
.rd(rd),
.alu_src(alu_src),
.alu_op(alu_op),
.regwrite(regwrite),
.rs1(rs1),
.rs2(rs2),
.memread(memread),
.memwrite(memwrite),
.memtoreg(memtoreg),
.loadtype(loadtype),
.strtype(strtype),
.load_hazard(load_hazard),
.branch_taken(branch_taken),
.pc_ex(pc_id1),
.rs1_data_ex(rs1_data_id),
.rs2_data_ex(rs2_data_id),
.imm_out_ex(imm_out_id),
.rd_ex(rd_id),
.alu_src_ex(alu_src_id),
.alu_op_ex(alu_op_id),
.regwrite_ex(regwrite_id),
.rs1_id_ex(rs1_id_ex),
.rs2_id_ex(rs2_id_ex),
.memread_id_ex(memread_id_ex),
.memwrite_id_ex(memwrite_id_ex),
.memtoreg_id_ex(memtoreg_id_ex),
.loadtype_id_ex(loadtype_id_ex),
.strtype_id_ex(strtype_id_ex));


EX ex_unit(.pc_ex(pc_id1),
.rs1_data_ex(rs1_data_id),
.rs2_data_ex(rs2_data_id),
.imm_out_ex(imm_out_id),
.rd_ex(rd_id),
.memread_id_ex(memread_id_ex),
.memwrite_id_ex(memwrite_id_ex),
.memtoreg_id_ex(memtoreg_id_ex),
.loadtype_id_ex(loadtype_id_ex),
.strtype_id_ex(strtype_id_ex),
.alu_result_wb(alu_result_wb),
.rd_wb_out(rd_wb_out),
.regwrite_wb_out(regwrite_wb_out),
.wb_data(wb_data),
.alu_src_ex(alu_src_id),
.alu_op_ex(alu_op_id),
.rs1_id_ex(rs1_id_ex),
.rs2_id_ex(rs2_id_ex),
.alu_result_mem(alu_result_mem),
.rd_mem_out(rd_mem_out),
.regwrite_mem_out( regwrite_mem_out),
.regwrite_ex(regwrite_id),
.alu_result_ex(alu_result_ex),
.rd_ex_out(rd_ex_out),
.regwrite_ex_out(regwrite_ex_out),
.memread_ex(memread_ex),
.memwrite_ex(memwrite_ex),
.memtoreg_ex(memtoreg_ex),
.loadtype_ex(loadtype_ex),
.strtype_ex(strtype_ex),
.rs2_data_ex_out(rs2_data_ex_out)
);

EX_MEM ex_mem(.clk(clk),
.rst(rst),
.alu_result_ex(alu_result_ex),
.rd_ex_out(rd_ex_out),
.regwrite_ex_out(regwrite_ex_out),
.memread_ex(memread_ex),
.memwrite_ex(memwrite_ex),
.memtoreg_ex(memtoreg_ex),
.loadtype_ex(loadtype_ex),
.strtype_ex(strtype_ex),
.rs2_data_ex_out(rs2_data_ex_out),
.alu_result_mem(alu_result_mem),
.rd_mem_out(rd_mem_out),
.regwrite_mem_out( regwrite_mem_out),
.memread_ex_mem(memread_ex_mem),
.memwrite_ex_mem(memwrite_ex_mem),
.memtoreg_ex_mem(memtoreg_ex_mem),
.loadtype_ex_mem(loadtype_ex_mem),
.strtype_ex_mem(strtype_ex_mem),
.rs2_data_ex_mem(rs2_data_ex_mem)
);

MEM mem_unit(.clk(clk),
.rst(rst),
.alu_result_mem(alu_result_mem),
.rd_mem_out(rd_mem_out),
.regwrite_mem_out( regwrite_mem_out),
.memread_ex_mem(memread_ex_mem),
.memwrite_ex_mem(memwrite_ex_mem),
.memtoreg_ex_mem(memtoreg_ex_mem),
.loadtype_ex_mem(loadtype_ex_mem),
.strtype_ex_mem(strtype_ex_mem),
.rs2_data_ex_mem(rs2_data_ex_mem),
.alu_result_mem1(alu_result_mem1),
.rd_mem_out1(rd_mem_out1),
.regwrite_mem_out1(regwrite_mem_out1),
.mem_data_mem1(mem_data_mem1),
.memtoreg_mem(memtoreg_mem),
.led(led));



MEM_WB mem_wb(.clk(clk),
.rst(rst),
.alu_result_mem1(alu_result_mem1),
.rd_mem_out1(rd_mem_out1),
.regwrite_mem_out1(regwrite_mem_out1),
.mem_data_mem1(mem_data_mem1),
.memtoreg_mem(memtoreg_mem),
.alu_result_wb(alu_result_wb),
.rd_wb_out(rd_wb_out),
.regwrite_wb_out(regwrite_wb_out),
.mem_data_mem_wb(mem_data_mem_wb),
.memtoreg_mem_wb(memtoreg_mem_wb)
);


WB wb_unit(.clk(clk),
.rst(rst),
.alu_result_wb(alu_result_wb),
.rd_wb_out(rd_wb_out),
.regwrite_wb_out(regwrite_wb_out),
.mem_data_mem_wb(mem_data_mem_wb),
.memtoreg_mem_wb(memtoreg_mem_wb),
.wb_data(wb_data),
.wb_rd(wb_rd),
.wb_regwrite(wb_regwrite),
.ledreg(ledreg));
endmodule

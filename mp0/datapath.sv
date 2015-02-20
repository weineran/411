import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input pcmux_sel,
    input storemux_sel,
	 input marmux_sel,
	 input mdrmux_sel,
	 input regfilemux_sel,
	 input alumux_sel,
	 input load_regfile,
	 input load_pc,
	 input load_ir,
	 input load_mar,
	 input load_mdr,
	 input load_cc,
	 input lc3b_aluop aluop,
	 input lc3b_word mem_rdata,

    /* declare more ports here */
	 output lc3b_opcode opcode,
	 output lc3b_word mem_address,
	 output lc3b_word mem_wdata,
	 output logic branch_enable
	 
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word regfilemux_out;
lc3b_word alumux_out;
lc3b_word pc_out;
lc3b_word adj9_out;
lc3b_word adj6_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word aluop_out;
//lc3b_word ir_opcode_out;
lc3b_word regfile_sr1_out;
lc3b_word regfile_sr2_out;
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg storemux_out;
lc3b_offset6 ir_offset6_out;
lc3b_offset9 ir_offset9_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
);

mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

adj #(.width(9)) adj9
(
	.in(ir_offset9_out),
	.out(adj9_out)
);

adj #(.width(6)) adj6
(
	.in(ir_offset6_out),
	.out(adj6_out)
);

mux2 marmux
(
	.sel(marmux_sel),
	.a(aluop_out),
	.b(pc_out),
	.f(marmux_out)
);

mux2 mdrmux
(
	.sel(mdrmux_sel),
	.a(aluop_out),
	.b(mem_rdata),
	.f(mdrmux_out)
);

mux2 regfilemux
(
	.sel(regfilemux_sel),
	.a(aluop_out),
	.b(mem_wdata),
	.f(regfilemux_out)
);

mux2 alumux
(
	.sel(alumux_sel),
	.a(regfile_sr2_out),
	.b(adj6_out),
	.f(alumux_out)
);


register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

ir instr_reg
(
	.clk,
   .load(load_ir),
   .in(mem_wdata),
   .opcode(opcode),
   .dest(dest),
	.src1(sr1),
	.src2(sr2),
   .offset6(ir_offset6_out),
   .offset9(ir_offset9_out)
);

regfile the_regfile
(
	.clk,
   .load(load_regfile),
   .in(regfilemux_out),
   .src_a(storemux_out),
	.src_b(sr2),
	.dest(dest),
   .reg_a(regfile_sr1_out),
	.reg_b(regfile_sr2_out)
);

register mar
(
	.clk,
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

register mdr
(
	.clk,
	.load(load_mdr),
	.in(mdrmux_out),
	.out(mem_wdata)
);

adder br_adder
(
	.PC(pc_out),		// incremented PC
	.PCoffset(adj9_out),		// SEXT(offset9<<1)
	.address(br_add_out)		// sum -> pcmux
);

plus2 pc_incr
(
	.in(pc_out),
	.out(pc_plus2_out)
);

alu the_alu
(
	.aluop(aluop),
	.a(regfile_sr1_out),
	.b(alumux_out),
	.f(aluop_out)
);

gencc the_gencc
(
	.in(regfilemux_out),
	.out(gencc_out)
);

register #(.width (3)) cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

nzp_comp cccomp
(
	.nzp_stored(cc_out),
	.nzp_instr(dest),
	.should_branch(branch_enable)
);

endmodule : datapath

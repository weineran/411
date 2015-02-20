import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input logic [1:0] pcmux_sel,	// AW mp1.1 modified
    input storemux_sel,
	input [1:0] marmux_sel,			// mp1.2 mod
	input [1:0] mdrmux_sel,			// 1.2 mod
	input [1:0] regfilemux_sel,		// AW mp1.1 modified
	input pcoffmux_sel,				// AW mp1.2 added
	input destmux_sel,				// AW mp1.2 added
	input wdatamux_sel,				// mp1.2 added
	input [1:0] alumux_sel,			// mp1.2 modified
	input a_mux_sel,				// 1.2
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
	 output logic branch_enable,
	 output logic ir11, Abit, Dbit 				// AW mp1.2 added
	 
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pcoffmux_out;	// AW mp1.2 added
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word regfilemux_out;
lc3b_word alumux_out;
lc3b_word imm5mux_out;	// AW mp1.1 added
lc3b_word sext5_out;	// AW mp1.1 added
lc3b_word sext6_out;	// mp 1.2 added
lc3b_imm5 imm5_out;		// AW mp1.1 added
logic imm5mux_sel;		// AW mp1.1 added
lc3b_word pc_out;
lc3b_word zext8_out;	// mp1.2 added
lc3b_byte bytemux_out;	// mp1.2 added
lc3b_word wdatamux_out;	// mp1.2 added
lc3b_word trapvect16;	// mp1.2 added
lc3b_word a_mux_out;	// 1.2
lc3b_word zext4_out;	// 1.2
lc3b_word cpLtH_out;	// 1.2
lc3b_word adj9_out;
lc3b_word adj11_out;
lc3b_word adj6_out;
lc3b_word pcoff_add_out;
lc3b_word pc_plus2_out;
lc3b_word aluop_out;
//lc3b_word ir_opcode_out;
lc3b_word regfile_sr1_out;
lc3b_word regfile_sr2_out;
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg destmux_out;	// AW mp1.2 added
lc3b_reg storemux_out;
lc3b_offset6 ir_offset6_out;
lc3b_offset9 ir_offset9_out;
lc3b_offset11 ir_offset11_out;	// AW mp1.2 added
lc3b_trap8 ir_trapvect8_out;	// AW mp1.2 added
lc3b_imm4 ir_imm4_out;			// 1.2
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(pcoff_add_out),
    .c(regfile_sr1_out),	// AW mp1.1 added
	.d(mem_wdata),			// mp1.1 added; 1.2 modified
    .f(pcmux_out)
);

mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

// AW mp1.2 added
mux2 #(.width(3)) destmux
(
	.sel(destmux_sel),
	.a(dest),
	.b(3'b111),		// R7
	.f(destmux_out)
);

// AW mp1.2 added
mux2 pcoffmux
(
	.sel(pcoffmux_sel),
	.a(adj11_out),
	.b(adj9_out),
	.f(pcoffmux_out)
);
	

adj #(.width(9)) adj9
(
	.in(ir_offset9_out),
	.out(adj9_out)
);

// AW mp1.2 added
adj #(.width(11)) adj11
(
	.in(ir_offset11_out),
	.out(adj11_out)
);

adj #(.width(6)) adj6
(
	.in(ir_offset6_out),
	.out(adj6_out)
);

// mp1.2 mod
mux4 marmux
(
	.sel(marmux_sel),
	.a(aluop_out),
	.b(pc_out),
	.c(mem_wdata),
	.d(16'h0000),
	.f(marmux_out)
);

// 1.2 extended
mux4 mdrmux
(
	.sel(mdrmux_sel),
	.a(aluop_out),
	.b(mem_rdata),
	.c(cpLtH_out),				// 1.2
	.d(16'h0000),				// 1.2
	.f(mdrmux_out)
);

// 1.2
copyLowToHigh cpLtH
(
	.in(aluop_out),
	.out(cpLtH_out)
);

/* AW mp1.1 added */
mux2 imm5mux
(
	.sel(imm5mux_sel),
	.a(regfile_sr2_out),
	.b(sext5_out),
	.f(imm5mux_out)
);

// mp1.2 added
mux2 #(.width(8)) bytemux
(
	.sel(mem_address[0]),	// use LSB of address as select
	.a(mem_wdata[7:0]),
	.b(mem_wdata[15:8]),
	.f(bytemux_out)
);

// mp1.2 added
zext zext8
(
	.in(bytemux_out),
	.out(zext8_out)
);

// mp1.2 added
mux2 wdatamux
(
	.sel(wdatamux_sel),	
	.a(mem_wdata),
	.b(zext8_out),
	.f(wdatamux_out)
);

mux4 regfilemux
(
	.sel(regfilemux_sel),
	.a(aluop_out),
	.b(wdatamux_out),
	.c(pcmux_out),		// AW mp1.1 modified
	.d(pc_out),			// AW mp1.2 modified
	.f(regfilemux_out)
);

mux4 alumux
(
	.sel(alumux_sel),
	.a(imm5mux_out),	/* AW mp1.1 modified */
	.b(adj6_out),
	.c(sext6_out),		// mp1.2 added
	.d(zext4_out),		// mp1.2 added
	.f(alumux_out)
);

// 1.2
mux2 a_mux
(
	.sel(a_mux_sel),
	.a(regfile_sr1_out),
	.b(trapvect16),
	.f(a_mux_out)
);

/* AW mp1.1 added */
sext sext5
(
	.in(imm5_out),
	.out(sext5_out)
);

/* AW mp1.2 added */
sext #(.width(6)) sext6
(
	.in(ir_offset6_out),
	.out(sext6_out)
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
	.offset9(ir_offset9_out),
	.offset11(ir_offset11_out), // AW mp1.2 added
	.trapvect8(ir_trapvect8_out), // AW mp1.2 added
	.imm5_out(imm5_out),
	.imm4_out(ir_imm4_out),		// 1.2
	.imm5mux_sel(imm5mux_sel),
	.ir11(ir11),					// AW mp1.2 added
	.Abit(Abit),			// 1.2
	.Dbit(Dbit)			// 1.2
);

// 1.2
zext #(.width(4)) zext4
(
	.in(ir_imm4_out),
	.out(zext4_out)
);

// AW mp1.2 added
zadj #(.width(8)) zadj8
(
	.in(ir_trapvect8_out),
	.out(trapvect16)
);

regfile the_regfile
(
	.clk,
	.load(load_regfile),
	.in(regfilemux_out),
	.src_a(storemux_out),
	.src_b(sr2),
	.dest(destmux_out),
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

adder pcoff_adder
(
	.PC(pc_out),		// incremented PC
	.PCoffset(pcoffmux_out),		// SEXT(offset9<<1)
	.address(pcoff_add_out)		// sum -> pcmux
);

plus2 pc_incr
(
	.in(pc_out),
	.out(pc_plus2_out)
);

alu the_alu
(
	.aluop(aluop),
	.a(a_mux_out),
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

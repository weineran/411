import lc3b_types::*;

module mp0
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata	 
);

/* declare internal signals */
	 logic c_pcmux_sel;
	 logic c_storemux_sel;
	 logic c_marmux_sel;
	 logic c_mdrmux_sel;
	 logic c_regfilemux_sel;
	 logic c_alumux_sel;
	 logic c_load_regfile;
	 logic c_load_pc;
	 logic c_load_ir;
	 logic c_load_mar;
	 logic c_load_mdr;
	 logic c_load_cc;
	 lc3b_aluop c_aluop;
	 lc3b_opcode dp_opcode_out;
	 logic dp_branch_enable;

/* Instantiate MP 0 top level blocks here */

datapath the_datapath
(
	.clk,
	.pcmux_sel(c_pcmux_sel),
   .storemux_sel(c_storemux_sel),
	.marmux_sel(c_marmux_sel),
	.mdrmux_sel(c_mdrmux_sel),
	.regfilemux_sel(c_regfilemux_sel),
	.alumux_sel(c_alumux_sel),
	.load_regfile(c_load_regfile),
	.load_pc(c_load_pc),
	.load_ir(c_load_ir),
	.load_mar(c_load_mar),
	.load_mdr(c_load_mdr),
	.load_cc(c_load_cc),
	.aluop(c_aluop),
	.mem_rdata(mem_rdata),
	
	/* outputs */
	.opcode(dp_opcode_out),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.branch_enable(dp_branch_enable)
);

control the_control
(
	/* inputs */
	.clk,
	.opcode(dp_opcode_out),
	.branch_enable(dp_branch_enable),
	.mem_resp(mem_resp),
	
	/* outputs */
	.load_pc(c_load_pc),
	.load_ir(c_load_ir),
	.load_regfile(c_load_regfile),
	.load_mar(c_load_mar),
	.load_mdr(c_load_mdr),
	.load_cc(c_load_cc),
	.pcmux_sel(c_pcmux_sel),
	.storemux_sel(c_storemux_sel),
	.alumux_sel(c_alumux_sel),
	.regfilemux_sel(c_regfilemux_sel),
	.marmux_sel(c_marmux_sel),
	.mdrmux_sel(c_mdrmux_sel),
	.aluop(c_aluop),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable)
);

endmodule : mp0

import lc3b_types::*;

module mp2
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
	 logic [1:0] c_pcmux_sel;
	 logic c_storemux_sel;
	 logic c_pcoffmux_sel;		// added mp2.2
	 logic c_destmux_sel;		// added mp2.2
	 logic c_wdatamux_sel;		// added mp2.2
	 logic [1:0] c_marmux_sel;
	 logic [1:0] c_mdrmux_sel;	// 1.2 mod
	 logic [1:0] c_regfilemux_sel;
	 logic [1:0] c_alumux_sel;		// mp2.2 mod
	 logic c_a_mux_sel;				// 1.2
	 logic c_load_regfile;
	 logic c_load_pc;
	 logic c_load_ir;
	 logic c_load_mar;
	 logic c_load_mdr;
	 logic c_load_cc;
	 lc3b_aluop c_aluop;
	 lc3b_opcode dp_opcode_out;
	 logic dp_branch_enable;
	 logic dp_ir11;				// added mp2.2
	 logic dp_Abit;			// 1.2
	 logic dp_Dbit;			// 1.2

/* Instantiate MP 0 top level blocks here */

datapath the_datapath
(
	.clk,
	.pcmux_sel(c_pcmux_sel),
	.pcoffmux_sel(c_pcoffmux_sel), 		// added mp2.2
	.destmux_sel(c_destmux_sel), 		// added mp2.2
	.wdatamux_sel(c_wdatamux_sel),		// added mp2.2
	.storemux_sel(c_storemux_sel),
	.marmux_sel(c_marmux_sel),
	.mdrmux_sel(c_mdrmux_sel),
	.regfilemux_sel(c_regfilemux_sel),
	.alumux_sel(c_alumux_sel),
	.a_mux_sel(c_a_mux_sel),			// 1.2
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
	.branch_enable(dp_branch_enable),
	.ir11(dp_ir11),						// added mp2.2
	.Abit(dp_Abit),		// 1.2
	.Dbit(dp_Dbit)		// 1.2
);

control the_control
(
	/* inputs */
	.clk,
	.opcode(dp_opcode_out),
	.branch_enable(dp_branch_enable),
	.ir11(dp_ir11),						// added mp2.2
	.Abit(dp_Abit),					// 1.2
	.Dbit(dp_Dbit),					// 1.2
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
	.pcoffmux_sel(c_pcoffmux_sel),	// added mp2.2
	.destmux_sel(c_destmux_sel),	// added mp2.2
	.wdatamux_sel(c_wdatamux_sel),	// mp2.2 added
	.alumux_sel(c_alumux_sel),
	.a_mux_sel(c_a_mux_sel),		// 1.2
	.regfilemux_sel(c_regfilemux_sel),
	.marmux_sel(c_marmux_sel),
	.mdrmux_sel(c_mdrmux_sel),
	.aluop(c_aluop),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable)
);

endmodule : mp2

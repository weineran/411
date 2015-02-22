/* cache.sv
 *	The cache design. It contains the cache controller and cache datapath.
 */
 
import lc3b_types::*;

module cache
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

cpu the_cpu
(
	// inputs
	.clk,
	.mem_rdata(mem_rdata),
	.mem_resp(mem_resp),
	
	/* outputs */
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable)
);

cache the_cache
(
	/* inputs */
	.clk,
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.pmem_resp(pmem_resp),
	.pmem_rdata(pmem_rdata),
	
	/* outputs */
	.mem_resp(mem_resp),
	.mem_rdata(mem_rdata),
	.pmem_address(mem_address),
	.pmem_wdata(pmem_wdata),
	.pmem_write(pmem_write),
	.pmem_read(pmem_read)
);

endmodule : cache

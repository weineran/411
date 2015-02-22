/* mp2.sv
 * The MP 2 design. It contains the CPU and cache.
 */
 
import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input pmem_resp,
    input lc3b_line pmem_rdata,
    output pmem_read, pmem_write,
    output lc3b_word pmem_address,
    output lc3b_line pmem_wdata
);

/* declare internal signals */
	 lc3b_word mem_rdata, mem_wdata, mem_address
	 logic mem_resp, mem_read, mem_write,
	 lc3b_mem_wmask mem_byte_enable

/* Instantiate MP 2 top level blocks here */

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
	.pmem_address(?????),
	.pmem_wdata(pmem_wdata),
	.pmem_write(pmem_write),
	.pmem_read(pmem_read)
);

endmodule : mp2

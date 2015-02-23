/* cache.sv
 *	The cache design. It contains the cache controller and cache datapath.
 */
 
import lc3b_types::*;

module cache
(
    input clk,

    /* input from CPU */
     input mem_read, mem_write,
     input lc3b_mem_wmask mem_byte_enable,
     input lc3b_word mem_address, mem_wdata,

    /* output to CPU */
     output lc3b_word mem_rdata,
     output mem_resp,
    
    /* input from pmem */
     input pmem_resp,
     input lc3b_line pmem_rdata,

    /* output to pmem */
     output lc3b_word pmem_address,
     output lc3b_line pmem_wdata,
     output pmem_read, pmem_write
);

/* declare internal signals */
	 logic w_Data_en, w_Tag_en, w_Valid_en, w_Dirty_en, w_LRU_en;
	 logic is_hit_out, hit_sel_out, dirty_out, valid_out;
	 logic Dout_LRU, Din_LRU, Din_Valid, Din_Dirty;

/* Instantiate MP 0 top level blocks here */

cache_datapath the_c_datapath
(
	.clk,
	
	// inputs from cpu
	.mem_address(mem_address), .mem_wdata(mem_wdata), .mem_byte_enable(mem_byte_enable),

	// inputs from control
	.w_Data_en(w_Data_en), .w_Tag_en(w_Tag_en), .w_Valid_en(w_Valid_en), .w_Dirty_en(w_Dirty_en), .w_LRU_en(w_LRU_en), .Din_LRU(Din_LRU), .pmem_read(pmem_read),
	.Din_Valid(Din_Valid), .Din_Dirty(Din_Dirty),

	// inputs from pmem
	.pmem_rdata(pmem_rdata),

	// outputs to cpu
	.mem_rdata(mem_rdata),

	// outputs to control
	.is_hit_out(is_hit_out), .hit_sel_out(hit_sel_out), .dirty_out(dirty_out), .valid_out(valid_out), .Dout_LRU(Dout_LRU),

	// outputs to pmem
	.pmem_address(pmem_address), .pmem_wdata(pmem_wdata)

);

cache_control the_c_control
(
	.clk,

	// inputs from cpu
	.mem_read(mem_read), .mem_write(mem_write),

	// inputs from datapath
	.is_hit_out(is_hit_out), .hit_sel_out(hit_sel_out), .dirty_out(dirty_out), .valid_out(valid_out), .Dout_LRU(Dout_LRU),

	// inputs from pmem
	.pmem_resp(pmem_resp),

	// outputs to cpu
	.mem_resp(mem_resp),

	// outputs to datapath
	.w_Data_en(w_Data_en), .w_Tag_en(w_Tag_en), .w_Valid_en(w_Valid_en), .w_Dirty_en(w_Dirty_en), .w_LRU_en(w_LRU_en), .Din_LRU(Din_LRU),
	.Din_Valid(Din_Valid), .Din_Dirty(Din_Dirty),

	// outputs to pmem
	.pmem_read(pmem_read), .pmem_write(pmem_write)
);

endmodule : cache

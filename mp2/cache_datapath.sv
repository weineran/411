/* cache_datapath.sv
 * The cache datapath. It contains the data array, valid array, dirty array, tag array,
 * LRU array, comparators, muxes, logic gates, and so on.
 */

import lc3b_types::*;

module cache_datapath
(
    input clk,

    /* control signals */
    input [1:0] w_Data, w_Tag, w_Valid, w_Dirty, 		// 01 writes to array 0; 10 writes to array 1
    input  w_LRU,				// only 1 array, so just 1 bit

    /* declare more ports here */
	 input lc3b_word mem_address,
	 input lc3b_word mem_wdata,
	 input lc3b_line pmem_rdata,
	 input logic pmem_resp,
	 output lc3b_word pmem_address,
	 output lc3b_line pmem_wdata,
	 output logic pmem_read,
	 output logic pmem_write,
	 
);

/* declare internal signals */
lc3b_line Din_Data, Dout_Data0, Dout_Data1;		// 2.2 data input and output for Data arrays
lc3b_tag Din_Tag, Dout_Tag0, Dout_Tag1;			// 2.2 data input and output for Tag arrays
logic Din_Valid, Dout_Valid0, Dout_Valid1;		/* 2.2 data input and output for Valid arrays; 1 means valid, 0 means no; both arrays can share same
												 * data input b/c we have 2 write bits, allowing us to choose which array to write to
												 */
logic Din_Dirty, Dout_Dirty0, Dout_Dirty1;		// 2.2 data input and output for Dirty arrays; 1 means dirty, 0 means no; again, can share data input
logic Din_LRU, Dout_LRU;						// 2.2 data input and output for LRU array; 1 means array_1 is LRU, 0 means array_0 is LRU
lc3b_c_index c_index;							// 2.2 the index into the cache


// addrToIndex
addrToIndex addr_to_idx
(
	.address(mem_address),
	.c_index(c_index)
);

// addrToTag
addrToTag addr_to_tag
(
	.address(mem_address),
	.c_tag(Din_Tag)
);

// check_hit
checkHit check_hit
(
	
);

// data_0 Array
array data_0
(
	.clk(clk),
	.write(w_Data[0]),
	.index(c_index),
	.datain(Din_Data),
	.dataout(Dout_Data0)
);

// data_1 Array
array data_1
(
	.clk(clk),
	.write(w_Data[1]),
	.index(c_index),
	.datain(Din_Data),
	.dataout(Dout_Data1)
);

// tag_0 Array
array #(.width(10)) tag_0
(
	.clk(clk),
	.write(w_Tag[0]),
	.index(c_index),
	.datain(Din_Tag),
	.dataout(Dout_Tag0)
);

// tag_1 Array
array #(.width(10)) tag_1
(
	.clk(clk),
	.write(w_Tag[1]),
	.index(c_index),
	.datain(Din_Tag),
	.dataout(Dout_Tag1)
);

// valid_0 Array
array #(.width(1)) valid_0
(
	.clk(clk),
	.write(w_Valid[0]),
	.index(c_index),
	.datain(Din_Valid),
	.dataout(Dout_Valid0)
);

// valid_1 Array
array #(.width(1)) valid_1
(
	.clk(clk),
	.write(w_Valid[1]),
	.index(c_index),
	.datain(Din_Valid),
	.dataout(Dout_Valid1)
);

// dirty_0 Array
array #(.width(1)) dirty_0
(
	.clk(clk),
	.write(w_Dirty[0]),
	.index(c_index),
	.datain(Din_Dirty),
	.dataout(Dout_Dirty0)
);

// dirty_1 Array
array #(.width(1)) dirty_1
(
	.clk(clk),
	.write(w_Dirty[1]),
	.index(c_index),
	.datain(Din_Dirty),
	.dataout(Dout_Dirty1)
);

// LRU Array
array #(.width(1)) lru
(
	.clk(clk),
	.write(w_LRU),
	.index(c_index),
	.datain(Din_LRU),
	.dataout(Dout_LRU)
);



endmodule : cache_datapath

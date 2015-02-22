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
	 input lc3b_mem_wmask mem_byte_enable,
	 input logic cache_write,				// an enabling bit sent from cache_control
	 output lc3b_word mem_rdata,
	 output lc3b_word pmem_address,
	 output lc3b_line pmem_wdata,
	 output logic pmem_read, pmem_write,
	 output logic is_hit_out, hit_sel_out,
	 output logic dirty_out, valid_out
	 
);

/* declare internal signals */
lc3b_line Din_Data, Dout_Data0, Dout_Data1;		// 2.2 data input and output for Data arrays
lc3b_line hit_data;								// output from data_mux
lc3b_tag Din_Tag, Dout_Tag0, Dout_Tag1;			// 2.2 data input and output for Tag arrays
logic Din_Valid;								/* 2.2 data input for Valid arrays; 1 means valid, 0 means no; both arrays can share same
												 * data input b/c we have 2 write bits, allowing us to choose which array to write to
												 */
logic Din_Dirty;								// 2.2 data input for Dirty arrays; 1 means dirty, 0 means no; again, can share data input
logic Din_LRU, Dout_LRU;						// 2.2 data input and output for LRU array; 1 means array_1 is LRU, 0 means array_0 is LRU
logic Dout_Dirty0, Dout_Dirty1,
logic Dout_Valid0, Dout_Valid1,
lc3b_c_index c_index;							// 2.2 the index into the cache
lc3b_word word7, word6, word5, word4;			// outputs from line_to_words
lc3b_word word3, word2, word1, word0;
lc3b_word word7_in, word6_in, word5_in, word4_in;	// inputs to words_to_line
lc3b_word word3_in, word2_in, word1_in, word0_in;
lc3b_c_offset c_offset;							// offset into a line in the cache
logic [7:0] decoder_out;


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

// addrToOffset
addrToOffset addr_to_offset
(
	.address(mem_address),
	.c_offset(c_offset)
);

// check_hit
checkHit check_hit
(
	.tag0(Dout_Tag0),
	.tag1(Dout_Tag1),
	.tag_gold(Din_Tag),
	.is_hit(is_hit_out),
	.hit_sel(hit_sel_out)
);

mux2 #(.width(128)) data_mux
(
	.sel(hit_sel_out),
	.a(Dout_Data0),
	.b(Dout_Data1),
	.f(hit_data)
);

mux2 #(.width(1)) dirty_mux
(
	.sel(hit_sel_out),
	.a(Dout_Dirty0),
	.b(Dout_Dirty1),
	.f(dirty_out)
);

mux2 #(.width(1)) valid_mux
(
	.sel(hit_sel_out),
	.a(Dout_Valid0),
	.b(Dout_Valid1),
	.f(valid_out)
);

// lineToWords
lineToWords line_to_words
(
	.line(hit_data),
	.word7(word7),
	.word6(word6),
	.word5(word5),
	.word4(word4),
	.word3(word3),
	.word2(word2),
	.word1(word1),
	.word0(word0)
);

// word_mux
mux8 word_mux
(
	.sel(c_offset),
	.in0(word0), .in1(word1), .in2(word2), .in3(word3), .in4(word4), .in5(word5), .in6(word6), .in7(word7),
	.out(mem_rdata)
);

// word decoder
decoder8 word_decoder
(
	.sel(c_offset),
	.enable(cache_write),
	.out(decoder_out)
);

// word_in muxes
mux2 word0_in_mux
(
	.sel(decoder_out[0]),
	.a(word0), .b(word_in),
	.f(word0_in)
);

mux2 word1_in_mux
(
	.sel(decoder_out[1]),
	.a(word1), .b(word_in),
	.f(word1_in)
);

mux2 word2_in_mux
(
	.sel(decoder_out[2]),
	.a(word2), .b(word_in),
	.f(word2_in)
);

mux2 word3_in_mux
(
	.sel(decoder_out[3]),
	.a(word3), .b(word_in),
	.f(word3_in)
);

mux2 word4_in_mux
(
	.sel(decoder_out[4]),
	.a(word4), .b(word_in),
	.f(word4_in)
);

mux2 word5_in_mux
(
	.sel(decoder_out[5]),
	.a(word5), .b(word_in),
	.f(word5_in)
);

mux2 word6_in_mux
(
	.sel(decoder_out[6]),
	.a(word6), .b(word_in),
	.f(word6_in)
);

mux2 word7_in_mux
(
	.sel(decoder_out[7),
	.a(word7), .b(word_in),
	.f(word7_in)
);

// words_to_line
wordsToLine words_to_line
(
	.word0(word0_in), .word1(word1_in), .word2(word2_in), .word3(word3_in),
	.word4(word4_in), .word5(word5_in), .word6(word6_in), .word7(word7_in),
	.line(data_in)
);

mux2 #(.width(128)) data_in_mux
(
	.sel(pmem_read),
	.a(data_in), .b(pmem_rdata),
	.f(Din_Data)
);

// word_to_bytes
wordToBytes rdata_to_bytes
(
	.word_in(mem_rdata),
	.byte0_out(rdata_byte0), byte1_out(rdata_byte1)
);

wordToBytes wdata_to_bytes
(
	.word_in(mem_wdata),
	.byte0_out(wdata_byte0), byte1_out(wdata_byte1)
);

// mask muxes
mux2 #(.width(8)) mask1_mux
(
	.sel(mem_byte_enable[1]),
	.a(rdata_byte1), .b(wdata_byte1),
	.f(byte1_in)
);

mux2 #(.width(8)) mask0_mux
(
	.sel(mem_byte_enable[0]),
	.a(rdata_byte0), .b(wdata_byte0),
	.f(byte0_in)
);

// bytes_to_word
bytesToWord bytes_to_word
(
	.byte1_in(byte1_in), .byte0_in(byte0_in),
	.word_out(word_in)
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

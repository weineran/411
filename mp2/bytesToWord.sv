import lc3b_types::*;

module bytesToWord
(
	input lc3b_byte byte1_in, byte0_in,
	output lc3b_word word_out
);

always_comb
begin
	word_out[15:8] = byte1_in;
	word_out[7:0] = byte0_in;
end
	
endmodule : bytesToWord
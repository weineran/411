import lc3b_types::*;

module wordToBytes
(
	input lc3b_word word_in,
	output lc3b_byte byte1_out, byte0_out
);

always_comb
begin
	byte1_out = word_in[15:8];
	byte0_out = word_in[7:0];
end
	
endmodule : wordToBytes
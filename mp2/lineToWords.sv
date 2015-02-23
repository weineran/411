import lc3b_types::*;

module lineToWords
(
	input lc3b_line line,
	output lc3b_word word7, word6, word5, word4, word3, word2, word1, word0
);

always_comb
begin
	word7 = line[127:112];
	word6 = line[111:96];
	word5 = line[95:80];
	word4 = line[79:64];
	word3 = line[63:48];
	word2 = line[47:32];
	word1 = line[31:16];
	word0 = line[15:0];
end
	
endmodule : lineToWords
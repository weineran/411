import lc3b_types::*;

module wordsToLine
(
	input lc3b_word word7, word6, word5, word4, word3, word2, word1, word0,
	output lc3b_line line
);

always_comb
begin
	line[127:112] = word7;
	line[111:96] = word6;
	line[95:80] = word5;
	line[79:64] = word4;
	line[63:48] = word3;
	line[47:32] = word2;
	line[31:16] = word1;
	line[15:0] = word0;
end
	
endmodule : wordsToLine
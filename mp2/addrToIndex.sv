import lc3b_types::*;

module addrToIndex
(
	input lc3b_word address,
	output lc3b_c_index c_index
);

always_comb
begin
	c_index = address[6:4];
end
	
endmodule : addrToIndex
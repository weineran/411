import lc3b_types::*;

module addrToIndex
(
	input lc3b_word address,
	output lc3b_c_index c_index
);

always_comb
begin
	c_index = address[5:3];
end
	
endmodule : addrToIndex
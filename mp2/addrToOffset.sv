import lc3b_types::*;

module addrToOffset
(
	input lc3b_word address,
	output lc3b_c_offset c_offset
);

always_comb
begin
	c_offset = address[3:1];
end
	
endmodule : addrToOffset
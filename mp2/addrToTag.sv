import lc3b_types::*;

module addrToTag
(
	input lc3b_word address,
	output lc3b_tag c_tag
);

always_comb
begin
	c_tag = address[15:7];
end
	
endmodule : addrToTag
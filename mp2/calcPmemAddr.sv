import lc3b_types::*;

module calcPmemAddr
(
	input lc3b_tag c_tag,
	input lc3b_c_index c_index,
	output lc3b_word pmem_address
	
);

always_comb
begin
	/*
	pmem_address[15:7] = c_tag;
	pmem_address[6:4] = c_index;
	pmem_address[3:0] = 4'b0000;
	*/
	pmem_address = {c_tag, c_index, 4'b0000};
end
	
endmodule : calcPmemAddr
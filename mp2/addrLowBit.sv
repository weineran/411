import lc3b_types::*;

module addrLowBit
(
	input lc3b_word address,
	output logic low_bit
);

always_comb
begin
	low_bit = address[0];
end
	
endmodule : addrLowBit
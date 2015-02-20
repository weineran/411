import lc3b_types::*;

module adder
(
	input lc3b_word PC, PCoffset,
	output lc3b_word address
);

always_comb
begin
	address = PC + PCoffset;
end

endmodule : adder
import lc3b_types::*;

module nzp_comp
(
	input lc3b_nzp nzp_stored,
	input lc3b_nzp nzp_instr,
	output logic should_branch
);

always_comb
begin
	if (nzp_stored & nzp_instr)
		should_branch = 1;
	else
		should_branch = 0;
end

endmodule : nzp_comp
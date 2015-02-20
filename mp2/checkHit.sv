import lc3b_types::*;

module checkHit #(parameter width = 10)
(
	input lc3b_tag tag0, tag1, tag_gold,
	output logic is_hit, hit_sel
);

always_comb
begin
	if(tag0 == tag_gold)
	begin
		is_hit = 1;
		hit_sel = 0;
	end
	else if(tag1 == tag_gold)
	begin
		is_hit = 1;
		hit_sel = 1;
	end
	else
	begin
		is_hit = 0;
		hit_sel = 0;
	end

end
	
endmodule : checkHit
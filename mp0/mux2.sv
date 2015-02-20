/* first section declares the two-input mux module "mux2" 
   and its input and output ports. */
module mux2 #(parameter width = 16)
(
	input sel,
	input [width-1:0] a, b,
	output logic [width-1:0] f
);


/* The always_comb block specifies a section of code that will 
   always be executed and will synthesize as combinational logic */
always_comb
begin
	if (sel==0)
		f = a;
	else
		f = b;
end
	
endmodule : mux2
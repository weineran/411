/* AW mp2.1 added
   mux4 4:1 MUX 
 */

module mux4 #(parameter width = 16)
(
	input logic [1:0] sel,
	input [width-1:0] a, b, c, d,
	output logic [width-1:0] f
);


/* The always_comb block specifies a section of code that will 
   always be executed and will synthesize as combinational logic */
always_comb
begin
	case(sel)
		2'b00:
			f = a;
		2'b01:
			f = b;
		2'b10:
			f = c;
		2'b11:
			f = d;
		default: /* nothing */;
	endcase
end
	
endmodule : mux4
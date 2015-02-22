/* 
 *  mux8 8:1 MUX 
 */

module mux8 #(parameter width = 16)
(
	input logic [2:0] sel,
	input [width-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
	output logic [width-1:0] out
);


/* The always_comb block specifies a section of code that will 
   always be executed and will synthesize as combinational logic */
always_comb
begin
	case(sel)
		0:
			out = in0;
		1:
			out = in1;
		2:
			out = in2;
		3:
			out = in3;
		4:
			out = in4;
		5:
			out = in5;
		6:
			out = in6;
		7:
			out = in7;
		default:
			/* nothing */;
	endcase
end
	
endmodule : mux8
/* 
 *  decoder2	2-line decoder
 */

module decoder2
(
	input logic sel,
	input logic enable,
	output logic [1:0] out
);


/* The always_comb block specifies a section of code that will 
   always be executed and will synthesize as combinational logic */
always_comb
begin
	out = 0;
	if(enable) begin
		case(sel)
			0:
				out = 2'b01;
			1:
				out = 2'b10;
			default:
				/* nothing */;
		endcase
	end
end
	
endmodule : decoder2
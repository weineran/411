/* 
 *  decoder8	8-line decoder
 */

module decoder8
(
	input logic [2:0] sel,
	input logic enable,
	output logic [7:0] out
);


/* The always_comb block specifies a section of code that will 
   always be executed and will synthesize as combinational logic */
always_comb
begin
	out = 0;
	if(enable) begin
		case(sel)
			0:
				out = 8'b00000001;
			1:
				out = 8'b00000010;
			2:
				out = 8'b00000100;
			3:
				out = 8'b00001000;
			4:
				out = 8'b00010000;
			5:
				out = 8'b00100000;
			6:
				out = 8'b01000000;
			7:
				out = 8'b10000000;
			default:
				/* nothing */;
		endcase
	end
end
	
endmodule : decoder8
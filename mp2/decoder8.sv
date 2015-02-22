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
				out0 = 8'b00000001;
			1:
				out1 = 8'b00000001;
			2:
				out2 = 8'b00000001;
			3:
				out3 = 8'b00000001;
			4:
				out4 = 8'b00000001;
			5:
				out5 = 8'b00000001;
			6:
				out6 = 8'b00000001;
			7:
				out7 = 8'b00000001;
			default:
				/* nothing */;
		endcase
	end
end
	
endmodule : decoder8
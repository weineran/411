/* cache_control.sv
 * The cache controller. It is a state machine that controls the behavior of the cache.
 */

import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
    /* Input and output port declarations */
	 input clk,
	 input is_hit_out, hit_sel_out
	 input dirty_out, valid_out,
	 
	 /* Cache Datapath controls */
	 output logic [1:0] w_Data, w_Tag, w_Valid, w_Dirty,

	 
	 /* Memory signals */
	 input logic mem_read, mem_write,
	 output mem_resp, pmem_read, pmem_write, cache_write
);

enum int unsigned {
    /* List of states */
	 s_hit,
	 s_write_back,
	 s_replace

} state, next_states;

/* State Logic */
always_comb
begin : state_actions
    /* Default output assignments */
	 w_Data = 2'b00;
	 w_Tag = 2'b00;
	 w_Valid = 2'b00;
	 w_Dirty = 2'b00;
	 mem_resp = 1'b0;
	 pmem_write = 1'b0;
	 pmem_read = 1'b0;
	 cache_write = 1'b0;
	 
    /*********************** Actions for each state *********************************************/
	 unique case(state)
		s_hit: begin
			if(is_hit_out == 0)
			begin
				if(dirty_out == 0 || valid_out == 0)
				begin
					;	// replace
				end
				else if(dirty_out == 1 && valid_out == 1)
				begin
					;	// write_back
				end
			end
			else
			begin
				if(mem_read == 1)
				begin
					mem_resp = 1;		// hit = 1; mem_read =1; send data to cpu
				end
				else if(mem_write == 1)
				begin
					;	// write data, valid, dirty
				end
			end
		end
		
		s_write_back: begin
			pmem_write = 1;
		end
		
		s_replace: begin
			pmem_read = 1;
		end
		
		
		
		default: /* Do nothing */;
		
	 endcase
end

/************************ Next State logic ********************************************/
always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	next_states = state;
	case(state)
		s_hit: begin
			if(is_hit_out == 0)
			begin
				if(dirty_out == 0 || valid_out == 0)
				begin
					next_states = s_replace;	// replace
				end
				else if(dirty_out == 1 && valid_out == 1)
				begin
					next_states = s_write_back;	// write_back
				end
			end
			else
			begin
				next_states = s_hit;	// hit
			end
		end
		
		s_write_back: begin
			if(pmem_resp == 0)
				next_states = s_write_back;
			else
				next_states = s_replace;
		end
		
		s_replace: begin
			if(pmem_resp == 0)
				next_states = s_replace;
			else
				next_states = s_hit;
		end		
		
		default: /* do nothing */;
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_states;
end

endmodule : cache_control

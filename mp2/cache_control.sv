import lc3b_types::*; /* Import types defined in lc3b_types.sv */

/* cache_control.sv
 * The cache controller. It is a state machine that controls the behavior of the cache.
 */



module cache_control
(
	input clk,

    /* input from CPU */
	 input logic mem_read, mem_write,

    /* input from datapath */
	 input is_hit_out, hit_sel_out, dirty_out, valid_out, Dout_LRU,

	// input from pmem
	 input pmem_resp,
	 
	/* output to CPU */
	 output logic mem_resp,

	/* Output to datapath */
	 output logic w_Data_en, w_Tag_en, w_Valid_en, w_Dirty_en, w_LRU_en, Din_LRU, Din_Valid, Din_Dirty,

	/* output to pmem */
	//note: pmem_read also goes to cache_datapath
	 output logic pmem_read, pmem_write
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
	 w_Data_en = 0;
	 w_Tag_en = 0;
	 w_Valid_en = 0;
	 w_Dirty_en = 0;
	 w_LRU_en = 0;
	 mem_resp = 0;
	 pmem_write = 0;
	 pmem_read = 0;
	 Din_LRU = 0;		// better only write this when I want to!
	 Din_Valid = 0;
	 Din_Dirty = 0;
	 
    /*********************** Actions for each state *********************************************/
	 case(state)
		s_hit: begin
			if(mem_read == 1 || mem_write == 1)
			begin
				if(is_hit_out == 1 && valid_out == 1)
				begin
					if(mem_read == 1)
					begin
						mem_resp = 1;		// READ HIT: hit = 1, mem_read = 1, valid = 1; send data to cpu
					end
					else if(mem_write == 1)
					begin
						w_Data_en = 1;	// WRITE HIT: hit = 1, mem_write = 1, valid = 1; write data to data array
						mem_resp = 1;
					end

					Din_LRU = ~hit_sel_out;	// update LRU on either READ HIT and WRITE HIT
					w_LRU_en = 1;
				end
				else
				begin
					if(dirty_out == 0)
					begin
						;	// replace
					end
					else if(valid_out == 1)
					begin
						;	// write_back
					end
				end
			end
		end
		
		s_write_back: begin
			pmem_write = 1;
		end
		
		s_replace: begin
			pmem_read = 1;

			if(mem_read == 1)
			begin
				Din_Dirty = 0;
			end	
			else if(mem_write == 1)
			begin
				Din_Dirty = 1;
			end

			w_Dirty_en = 1;
			Din_Valid = 1;
			w_Valid_en = 1;
			w_Data_en = pmem_resp;
			w_Tag_en = 1;
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
			if(mem_read == 1 || mem_write == 1)
			begin
				if(is_hit_out == 1 && valid_out == 1)
				begin
					next_states = s_hit;
				end
				else
				begin
					if(dirty_out == 0)
					begin
						next_states = s_replace;	// replace
					end
					else if(valid_out == 1)
					begin
						next_states = s_write_back;	// write_back
					end
				end
			end
			else
				next_states = s_hit;
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

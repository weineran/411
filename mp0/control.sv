import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* Input and output port declarations */
	 input clk,
	 
	 /* Datapath controls */
	 input lc3b_opcode opcode,
	 input logic branch_enable,
	 output logic load_pc,
	 output logic load_ir,
	 output logic load_regfile,
	 output logic load_mar,
	 output logic load_mdr,
	 output logic load_cc,
	 output logic pcmux_sel,
	 output logic storemux_sel,
	 output logic alumux_sel,
	 output logic regfilemux_sel,
	 output logic marmux_sel,
	 output logic mdrmux_sel,
	 output lc3b_aluop aluop,
	 /*et cetera */
	 
	 /* Memory signals */
	 input mem_resp,
	 output logic mem_read,
	 output logic mem_write,
	 output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
	 fetch1,
	 fetch2,
	 fetch3,
	 decode,
	 s_add,
	 s_and,
	 s_not,
	 s_br,
	 s_br_taken,
	 s_calc_addr,
	 s_ldr1,
	 s_ldr2,
	 s_str1,
	 s_str2
} state, next_states;

always_comb
begin : state_actions
    /* Default output assignments */
	 load_pc = 1'b0;
	 load_ir = 1'b0;
	 load_regfile = 1'b0;
	 load_mar = 1'b0;
	 load_mdr = 1'b0;
	 load_cc = 1'b0;
	 pcmux_sel = 1'b0;
	 storemux_sel = 1'b0;
	 alumux_sel = 1'b0;
	 regfilemux_sel = 1'b0;
	 marmux_sel = 1'b0;
	 mdrmux_sel = 1'b0;
	 aluop = alu_add;
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 2'b11;
	 
    /* Actions for each state */
	 case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 1;
			load_mar = 1;
			
			/* PC <= PC + 2 */
			pcmux_sel = 0;
			load_pc = 1;
		end
		
		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 1;
			load_mdr = 1;
		end
		
		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end
		
		decode: /* Do nothing */;
		
		s_add: begin
			/* DR <= SRA + SRB */
			aluop = alu_add;
			load_regfile = 1;
			regfilemux_sel = 0;
			load_cc = 1;
		end
		
		s_and: begin
			/* DR <= A & B;*/
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_not: begin
			/* DR <= NOT(A) */
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_br: /* do nothing */ ;
		
		s_br_taken: begin
			/* PC <= PC + SEXT(IR[8:0] << 1) */
			pcmux_sel = 1;
			load_pc = 1;
		end
		
		s_calc_addr: begin
			/* MAR <= A + SEXT(IR[5:0] << 1) */
			alumux_sel = 1;
			aluop = alu_add;
			load_mar = 1;
		end
		
		s_ldr1: begin
			/* MDR <= M[MAR] */
			mdrmux_sel = 1;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_ldr2: begin
			/* DR <= MDR */
			regfilemux_sel = 1;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_str1: begin
			/* MDR <= SR */
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end
		
		s_str2: begin
			/* M[MAR] <= MDR */
			mem_write = 1;
		end
		
		default: /* Do nothing */;
		
	 endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	next_states = state;
	case(state)
		fetch1: begin
			next_states = fetch2;
		end
		
		fetch2: begin
		if(mem_resp == 1'b1)
				next_states = fetch3;
		end
		
		fetch3: begin
			next_states = decode;
		end
		
		decode: begin
			case(opcode)
				op_add: begin
					next_states = s_add;
				end
				op_and: begin
					next_states = s_and;
				end
				op_not: begin
					next_states = s_not;
				end
				op_ldr: begin
					next_states = s_calc_addr;
				end
				op_str: begin
					next_states = s_calc_addr;
				end
				op_br: begin
					next_states = s_br;
				end
				default: /* do nothing */ ;
			endcase
		end
		
		s_add: begin
			next_states = fetch1;
		end
		
		s_and: begin
			next_states = fetch1;
		end
		
		s_not: begin
			next_states = fetch1;
		end
		
		s_br: begin
			if(branch_enable == 1'b1)
				next_states = s_br_taken;
			else
				next_states = fetch1;
		end
		
		s_br_taken: begin
			next_states = fetch1;
		end
		
		s_calc_addr: begin
			if(opcode == op_ldr)
				next_states = s_ldr1;
			else if(opcode == op_str)
				next_states = s_str1;
			else
				/* do nothing */;
		end
		
		s_ldr1: begin
			if(mem_resp == 1'b1)
				next_states = s_ldr2;
		end
		
		s_ldr2: begin
			next_states = fetch1;
		end
		
		s_str1: begin
			next_states = s_str2;
		end
		
		s_str2: begin
			if(mem_resp == 1'b1)
				next_states = fetch1;
		end
		
		default: /* do nothing */;
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_states;
end

endmodule : control

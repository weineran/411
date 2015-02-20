import lc3b_types::*;

module ir
(
    input clk,
    input load,
    input lc3b_word in,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
    output lc3b_offset11 offset11,  // AW mp1.2 added
    output lc3b_trap8 trapvect8,    // 1.2
    output lc3b_imm5 imm5_out,       /* AW mp1.1 added */
    output lc3b_imm4 imm4_out,      // 1.2
    output logic imm5mux_sel,        // AW mp1.1 added
    output logic ir11,               // AW mp1.2 added
    output logic Abit, Dbit         // 1.2
);

lc3b_word data;

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data = in;
    end
end

always_comb
begin
    opcode = lc3b_opcode'(data[15:12]);

    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];

    offset6 = data[5:0];
    offset9 = data[8:0];
    offset11 = data[10:0];  // AW mp1.2 added
    trapvect8 = data[7:0]; // AW mp1.2 added

    imm5_out = data[4:0];   // AW mp1.1 added
    imm4_out = data[3:0];   // 1.2
    imm5mux_sel = data[5];  // AW mp1.1 added
    ir11 = data[11];        // AW mp1.2 added
    Abit = data[5];         // 1.2
    Dbit = data[4];         // 1.2
end

endmodule : ir

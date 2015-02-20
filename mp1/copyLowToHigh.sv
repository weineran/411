import lc3b_types::*;

/*
 * Copies the low byte into the high byte
 */
module copyLowToHigh
(
    input lc3b_word in,
    output lc3b_word out
);

always_comb
begin
    out = {in[7:0], in[7:0]};
end

endmodule : copyLowToHigh

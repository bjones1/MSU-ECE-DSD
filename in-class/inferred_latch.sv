// # `in-class.sv` - skeleton code for in-class exercises
//
// See also the [test bench](tb_in-class.sv).
module inferred_latch(
    input logic clk,
    input logic reset,
    input logic [15:0] a,
    input logic [15:0] b,
    input logic [15:0] c,
    output logic [15:0] x,
    output logic [15:0] y,
    output logic [15:0] z
);

    always_comb begin
        case (c)
            2'b00: x = a & b;
            2'b01: x = a | b;
            2'b10: x = a ^ b;
            2'b11: x = ~(a & b);
        endcase
    end

endmodule

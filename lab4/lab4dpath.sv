// # Lab 4
//
// Complete this Verilog module so that it implements the following schematic:
//
// <figure class="image"><img src="lab4dpath.png" alt="A 12x12 multiplier and summer"><figcaption>Figure 1: Schematic to implement.</figcaption></figure>
//
// Busses `k1`, `k2`, `k3` are the following constants::
//
// | Constant | 12-bit value in hex | Value in decimal (in 1.11 fixed point) |
// | -------- | ------------------- | -------------------------------------- |
// | `k1`     | C00                 | \-0.5                                  |
// | `k2`     | 500                 | 0.625                                  |
// | `k3`     | C00                 | \-0.5                                  |
module lab4dpath(
	input logic signed [9:0] x1,
	input logic signed [9:0] x2,
	input logic signed [9:0] x3,
	output logic signed [9:0] y
);

    // ## Implementation Hints
    //
    // - You may only use assignment statements or component instantiations, you
    //   may not use an always block (sequential statements).
    // - You will need to expand the input values by adding two LSbs with values
    //   of zero. This can be done using concatenation as follows:
    logic signed [11:0] v1;
    assign v1 = {x1, 2'b00};
    // When you have to drop bits, just choose which bits you want to keep by
    // the bus indices. For example, the following statement drops the two LSbs
    // of `s2` to form `y`.
    assign y = s2[11:2];
    // You may remove or edit these lines of code – they are only hints.

endmodule

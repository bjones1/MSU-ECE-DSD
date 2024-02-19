// # Lab 5
//
// Complete this Verilog module so that it implements the following schematic:
//
// <figure class="image"><img src="lab5datapath.png" alt="A 12x12 multiplier and summer"><figcaption>Figure 1: Schematic to implement.</figcaption></figure>
//
// Busses `k1`, `k2`, `k3` are the following constants:
//
// | Constant | 12-bit value in hex | Value in decimal (in 1.11 fixed point) |
// | -------- | ------------------- | -------------------------------------- |
// | `k1`     | C00                 | \-0.5                                  |
// | `k2`     | 500                 | 0.625                                  |
// | `k3`     | C00                 | \-0.5                                  |
module lab5dpath (
    input logic clk,
    input logic signed [9:0] x1, 
    input logic signed [9:0] x2,
    input logic signed [9:0] x3,
    output logic signed [9:0] y
);

endmodule

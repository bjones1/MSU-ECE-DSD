// # `satadd.v` - A Verilog module implementing lab 3, an (optionally) saturating adder.
module satadd(
    // The [addends](https://en.wiktionary.org/wiki/addend).
    input logic [11:0] a,
    input logic [11:0] b,
    // Adder mode:
    //
    // | Mode Input     | Output function                 |
    // | -------------- | ------------------------------- |
    // | `mode = 2'b00` | y = a + b (unsigned saturation) |
    // | `mode = 2'b01` | y = a + b (signed saturation)   |
    // | `mode = 2'b10` | y = a + b (normal addition)     |
    // | `mode = 2'b11` | y = a + b (normal addition)     |
    input logic [1:0] mode,
    // The resulting sum.
    output logic [11:0] y
);

// ## Implementation Guidance
//
// 1.  <span style="color: red;">All of this logic must be implemented using
//     assign statements; you may not use <code>always</code> blocks/sequential
//     statements.</span>
// 2.  Note the inputs of the adder are 12 bits wide, while the output is 13
//     bits wide. Bit `r[11]` of the adder output is the sign of the output
//     value, while bit `r[12]` is the carry out (Cout). If the carry out is 1,
//     then unsigned overflow occurred.
// 3.  The `vFlag` internal signal is 1 if a two's complement overflow occurs.
//     This is true if the sum of two positive numbers produces a negative
//     number or if the sum of two negative numbers produces a positive number.
//     The signs of the two inputs (`a[11]`, `b[11]`) are represented by the
//     signals `aSign`, `bSign` and the sign of the result (`r[11]`) by `rSign`.
//
// <figure class="image"><img title="Figure 1. Suggested architecture" src="suggested-architecture.png" alt="A schematic showing the suggested architecture for this module."><figcaption>Figure 1: Suggested architecture.</figcaption></figure>

endmodule

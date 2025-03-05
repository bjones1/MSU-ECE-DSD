module lab6dpath (
    input reset,
    input clk,
    // Asserted when `DIN` contains `X1`. It must contain `X2` the following
    // clock cycle, then X3 on the next clock.
    input logic irdy,
    // Asserted for one cycle when `DOUT` contains `Y`.
    output logic ordy,
    // Contains `X1`, `X2`, or `X3` based on `irdy`.
    input logic signed [9:0] din,
    // Provides the result when `ordy` is asserted.
    output logic signed [9:0] dout
);

endmodule

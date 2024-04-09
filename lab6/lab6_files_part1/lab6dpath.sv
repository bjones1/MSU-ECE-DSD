module lab6dpath (
    reset,
    clk,
    irdy,
    ordy,
    din,
    dout
);
    input reset, clk, irdy;
    input signed [9:0] din;
    output signed [9:0] dout;
    output ordy;

endmodule

// Generates the output pulse that is true for one clock period every PERIOD seconds.
module pulsegenMS
#(
    // how often in seconds that a pulse should be generated. Default to 15 ms.
    parameter PERIOD = 0.015,
    // The frequency of clk, in Hz. Default to 100 MHz.
    parameter CLK_FREQ = 100_000_000,
    // Use these to compute the max period. Use rtoi to convert this value from a floating-point number to an integer, which is
    // required for synthesis.
    localparam PERIOD_MAX = $rtoi((PERIOD * CLK_FREQ) - 1)
)
(
    input clk,
    output pulse
);

    // lets be lazy and use a 32 bit counter, unused bits will be optimized away
    reg [31:0] cntr;

    // this signal asserted to reset the counter.
    assign pulse = (cntr == PERIOD_MAX);

    always @(posedge clk) begin
        cntr <= pulse ? 0 : cntr + 1;
    end

endmodule

`timescale 1ns / 1ps

module timertop (
    output logic [6:0] LED,
    input logic [0:0] SW,
    input logic board_clk
);
    logic reset;
    logic clk_50mhz, clk;

    assign clk = clk_50mhz;

    // generate a 50 MHz clk
    clk_wiz clk_wiz0 (
        .clk_in1 (board_clk),
        .clk_out1(clk_50mhz)
    );

    logic swq1;

    // generate reset signal by synchronizing SW[0]
    always_ff @(posedge clk) begin
        swq1  <= SW[0];
        reset <= swq1;
    end

    // fill in the rest of this module.

endmodule

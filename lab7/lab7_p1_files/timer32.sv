`timescale 1ns / 1ps

module timer32 (
    input logic clk,
    input logic reset,
    input logic [31:0] din,
    output logic [31:0] dout,
    input logic wren,
    input logic rden,
    input logic [1:0] addr
);
    // must have this initial value
    parameter PERIOD = 32'h0000000F;
    parameter ENBIT = 1'b0;

endmodule

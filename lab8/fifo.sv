`timescale 1ns / 1ps

module fifo (
    input logic clk,
    input logic reset,
    input logic sclr,
    input logic wren,
    input logic rden,
    output logic full,
    output logic empty,
    input logic [7:0] din,
    output logic [7:0] dout
);

endmodule
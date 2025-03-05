`timescale 1ns / 1ps

module timer32bus (
    input logic clk,
    input logic reset,
    input logic [31:0] din,
    output logic [31:0] dout,
    input logic wren,
    input logic rden,
    input logic [23:0] addr
);
    // 20-bit decode, compare against addr[23:4]
    parameter TMR1_RANGE = 20'h9250A;
    parameter TMR2_RANGE = 20'h3C74D;

endmodule

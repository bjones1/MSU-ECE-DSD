`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name:    timer32
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module timer32 (
    clk,
    reset,
    din,
    dout,
    wren,
    rden,
    addr
);

    input clk, reset, wren, rden;
    input [31:0] din;
    output [31:0] dout;
    input [1:0] addr;

    parameter PERIOD = 32'h0000000F;  //must have this initial value
    parameter ENBIT = 1'b0;

endmodule

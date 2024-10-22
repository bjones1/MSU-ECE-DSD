`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:23 10/06/2014 
// Design Name: 
// Module Name:    uart 
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
module uart_tx(clk, reset, wren, rden, din, dout, txout, addr);
input clk, reset, wren, rden;
input [7:0] din;
output [7:0] dout;
output txout;       //serial data out
input [2:0] addr;

reg [7:0] dout;

parameter PERIOD = 8'h1A;  


endmodule

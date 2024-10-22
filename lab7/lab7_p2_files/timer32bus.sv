`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name:    timer32bus 
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
module timer32bus(
    clk,
    reset,
    din,
    dout,
    wren,
    rden,
    addr
);

    input clk, reset, wren,rden;
    input [31:0] din;
    output [31:0] dout;
    input [23:0] addr;    //24 bit address 
    
    //20-bit decode, compare against addr[23:4]
    parameter TMR1_RANGE = 20'h9250A;   //20 bit decode
    parameter TMR2_RANGE = 20'h3C74D;   //20 bit decode
    
endmodule


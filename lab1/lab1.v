`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:08:32 08/15/2014 
// Design Name: 
// Module Name:    lab1 
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
module lab1(
output [7:0] LED,
input [7:0] SW
    );

//this connects the first 8 switches to the first 8 LEDs 
//SW0 is the right most switch, and order is right to left
assign LED = SW; 

endmodule

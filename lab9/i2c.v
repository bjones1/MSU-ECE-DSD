`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:34:31 03/09/2015 
// Design Name: 
// Module Name:    i2c 
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
module i2c(clk, reset, din, dout, wren, rden, addr, sclk, sdout, sdin, dir); 
input clk, reset, wren, rden;
input [7:0] din;
output [7:0] dout;
input [1:0] addr;
output sclk;        //serial clock out
output sdout;       //serial data out
input sdin;         //serial data int
output dir; 


//control register
`define START_CONTROL_BIT 0
`define STOP_CONTROL_BIT 1
`define WRITE_EN_CONTROL_BIT 2
`define WRITE_ACK_STATUS_BIT 3
`define READ_EN_CONTROL_BIT 4
`define READ_ACK_BIT 5
`define RESET_CONTROL_BIT 6

`define PERIOD_REG	3'b000
`define TX_REG 		3'b001
`define RX_REG 		3'b010
`define STATUS_REG 	3'b011
`define I2CADDR_REG 	3'b100
 


endmodule

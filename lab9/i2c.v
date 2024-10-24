`timescale 1ns / 1ps
module i2c(clk, reset, din, dout, wren, rden, addr, sclk, sdout, sdin, dir);
    input clk, reset, wren, rden;
    input [7:0] din;
    output [7:0] dout;
    input [1:0] addr;
    // serial clock out
    output sclk;
    // serial data out
    output sdout;
    // serial data in
    input sdin;
    output dir;

    // control register
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

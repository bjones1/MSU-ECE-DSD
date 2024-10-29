`timescale 1ns / 1ps
module fifo(
	clk,
	reset,
	sclr,
	wren,
	rden,
	full,
	empty,
	din,
	dout
);

	input clk, reset, sclr, wren, rden;
	input [7:0] din;
	output full, empty;
	output [7:0] dout;

endmodule
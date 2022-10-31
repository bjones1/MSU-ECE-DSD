`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module timertop(LED,SW,board_clk);
output [6:0] LED;
input [0:0] SW;
input board_clk;

reg reset;
wire clk_50mhz, clk;


assign clk = clk_50mhz;

//generate a 50 MHz clk
clk_wiz clk_wiz0 (.clk_in1(board_clk), .clk_out1(clk_50mhz));

reg swq1;

//generate reset signal by synchronizing SW[0]
always @(posedge clk) begin
  swq1 <= SW[0];
  reset <= swq1;
end

//fill in the rest of this module.

										
endmodule

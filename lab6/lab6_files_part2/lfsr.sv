`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//16-bit Linear Feedback Shift Register
//////////////////////////////////////////////////////////////////////////////////
module lfsr(clk,ld,reset,dout);
input clk,ld,reset;
output [15:0] dout;

parameter INITIAL = 16'hACE1;  //initial value

reg [15:0] dout;

reg [15:0] dout_next;
reg nextbit;

//x^16 + X^14 + X^13 + X^11 + 1
//Fibonacci LSFR
//always @* begin
// nextbit = dout[0] ^ dout[2] ^ dout[3] ^ dout[5]; //feedback bit
// dout_next = {nextbit,dout[15:1]};
//end

//Galois LSFR
always @* begin
//  //default is rotate right
  dout_next = {dout[0],dout[15:1]};
  dout_next[13] = dout[14] ^ dout[0];
  dout_next[12] = dout[13] ^ dout[0];
  dout_next[10] = dout[11] ^ dout[0];
end

always @(posedge clk or posedge reset) begin
 if (reset) begin
   dout <= INITIAL;
 end else begin
  if (ld) begin
   dout <= dout_next;
  end
 end
end


endmodule


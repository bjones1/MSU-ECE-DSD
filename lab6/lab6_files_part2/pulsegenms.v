`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Generates a signal that is true for one clock period every MSPERIOD milliseconds.
//////////////////////////////////////////////////////////////////////////////////
module pulsegenMS(clk,pulse);
input clk;
output pulse;

//how often in milliseconds that pulse should be generated, random default value
parameter MSPERIOD = 15; 
//50000 is for 1 ms assuming 50 MHz clock
parameter PERIOD_MAX = (MSPERIOD * 50000) - 1; 

//lets be lazy and use a 32 bit counter, unused bits will be optimized away
reg [31:0]cntr;  

assign pulse = (cntr == PERIOD_MAX);  //this signal asserted to reset the counter.

always @(posedge clk) begin   
 if (pulse) cntr <= 0;
 else cntr <= cntr +1;
end

endmodule


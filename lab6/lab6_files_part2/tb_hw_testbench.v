`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

module tb_hw_testbench;

	// Inputs
	reg clk;
	reg sw_reset;
	
	wire [2:0] LED;
    wire [7:0] SSEG_CA;
    wire [3:0] SSEG_AN;
    
    
	// Instantiate the Unit Under Test (UUT)
	hw_testbench uut (.board_clk(clk),.SW(sw_reset),.LED(LED),.SSEG_CA(SSEG_CA),
	 .SSEG_AN(SSEG_AN));
	
	initial begin
	 clk = 0;
	 #100   //reset delay
     //100 MHZ clock
	 forever #5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs	
		#1
		sw_reset = 1;
		clk = 0;

		// wait 600 ns
		#600;
		sw_reset = 0;
        //now we just run forever		
		while (1) begin
		 @(negedge clk);  //run forever
		end
		    
	end
      
endmodule


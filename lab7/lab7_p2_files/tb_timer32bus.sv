`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   19:17:21 09/14/2014
// Design Name:   timer32bus
// Module Name:   C:/ece4743/projects/lab6_solution_part2/tb_timer32bus.v
// Project Name:  lab6_solution_part2
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: timer32bus
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_timer32bus;

	// Inputs
	logic clk;
	logic reset;
	logic [31:0] din;
	logic wren;
	logic rden;
	logic [23:0] addr;

	// Outputs
	logic [31:0] dout;

parameter TMR1_BASE = 24'h9250A0;   //24 bit address
parameter TMR2_BASE = 24'h3C74D0;   //24 bit address

parameter ERR_BASE = 24'h12345;   //24 bit address

parameter TMR_REG = 24'h000000;
parameter PER_REG = 24'h000001;
parameter CON_REG = 24'h000002;

`define PERIOD_INITIAL 32'h0000000F

	// Instantiate the Unit Under Test (UUT)
	timer32bus uut (
		.clk(clk),
		.reset(reset),
		.din(din),
		.dout(dout),
		.wren(wren),
		.rden(rden),
		.addr(addr)
	);

	initial begin
	 clk = 0;
	 #100   //reset delay
	 forever #20 clk = ~clk;
	end

	integer errors;

	initial begin
		// Initialize Inputs
		#1
		clk = 0;
		reset = 1;
		din = 0;
		wren = 0;
		rden = 0;
		addr = 0;
		errors = 0;

		// Wait 100 ns for global reset to finish
		#100;

		reset = 0;

		@(negedge clk);
		//write to t1 period register
		wren=1;
		addr = (TMR1_BASE+PER_REG);
		din  = 8;
		@(negedge clk);
		wren=0;
		rden=1;
		@(negedge clk);
		//read Period register
		if (dout != 8) begin
			$display("(%t)FAIL: Write/Read of T Period register failed, expected 8, got %d\n",$time(),dout);
			errors = errors + 1;
		end


		addr = (ERR_BASE+PER_REG);
		@(negedge clk);
		//this should be 0 for expected range
		if (dout != 0) begin
			$display("(%t)FAIL: Read of non-existent timer, expected 0, got %d\n",$time(),dout);
			errors = errors + 1;
		end

		//read T2 period register, should be initial value of
		addr = (TMR2_BASE+PER_REG);
		rden = 1;
		@(negedge clk);
		//this should be PERIOD_INITIAL for expected range
		if (dout != `PERIOD_INITIAL) begin
			$display("(%t)FAIL: Read of Timer2 period regisgter failed, expected %d, got %d\n",$time(),`PERIOD_INITIAL,dout);
			errors = errors + 1;
		end

		rden = 1;
		din = 20;
		wren = 1;  //write the period register
		@(negedge clk);
		//this should be 20 for expected range
		if (dout != 20) begin
			$display("(%t)FAIL: Write/Read of Timer2 period regisgter failed, expected %d, got %d\n",$time(),20,dout);
			errors = errors + 1;
		end
		wren = 1;
		//start timer 1
		addr = (TMR1_BASE+CON_REG);  //write to the control register
		din = 1;  //set the Timer Enable bit
		@(negedge clk);
		//read timer one
		wren = 0;
		rden = 1;
		addr = (TMR1_BASE+TMR_REG);  //read timer register
		@(negedge clk);
		if (dout != 1) begin
			$display("(%t)FAIL: Timer 1 read/count, Expected %d, got %d\n",$time(),1,dout);
			errors = errors + 1;
		end
		@(negedge clk);
		if (dout != 2) begin
			$display("(%t)FAIL: Timer 1 read/count, Expected %d, got %d\n",$time(),2,dout);
			errors = errors + 1;
		end
		@(negedge clk);
		if (dout != 3) begin
			$display("(%t)FAIL: Timer 1 read/count, Expected %d, got %d\n",$time(),3,dout);
			errors = errors + 1;
		end

		//change to reading non-existant timer
		addr = (ERR_BASE+TMR_REG);  //write to the control register
		@(negedge clk);
		if (dout != 0) begin
			$display("(%t)FAIL: Reading non-existent Timer, expected %d, got %d\n",$time(),0,dout);
			errors = errors + 1;
		end

		//enable timer 2
		wren = 1;
		//start timer 1
		addr = (TMR2_BASE+CON_REG);  //write to the control register
		din = 1;  //set the Timer Enable bit
		@(negedge clk);

		//read timer two
		wren = 0;
		rden = 1;
		addr = (TMR2_BASE+TMR_REG);  //read timer register
		@(negedge clk);
		if (dout != 1) begin
			$display("(%t)FAIL: Timer 2 read/count, Expected %d, got %d\n",$time(),1,dout);
			errors = errors + 1;
		end
		@(negedge clk);
		if (dout != 2) begin
			$display("(%t)FAIL: Timer 2 read/count, Expected %d, got %d\n",$time(),2,dout);
			errors = errors + 1;
		end
		@(negedge clk);
		if (dout != 3) begin
			$display("(%t)FAIL: Timer 2 read/count, Expected %d, got %d\n",$time(),3,dout);
			errors = errors + 1;
		end

		if (errors == 0) begin
			$display("(%t)PASSED: All vectors passed\n",$time());
		end else begin
		  $display("(%t)FAILED: %d vectors failed\n",$time(),errors);
		end
	end

endmodule

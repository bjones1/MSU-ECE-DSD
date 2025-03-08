`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:58 10/07/2014
// Design Name:   uart
// Module Name:   C:/ece4743/projects/lab8_solution/tb_uart.v
// Project Name:  lab8_solution
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_uart_tx;

	// Inputs
	logic clk;
	logic reset;
	logic wren;
	logic rden;
	logic [7:0] din;
	logic [2:0] addr;

	// Outputs
	logic [7:0] dout;
	logic txout;

parameter CLK_PERIOD=20;       //clock period in ns.  20 ns = 50 MHZ	
//parameter UUT_PERIOD=8'h1A;    //57600 baudrate
parameter UUT_PERIOD=8'h0C;    //115200 baudrate

parameter CLK16X_PERIOD=(CLK_PERIOD*(UUT_PERIOD+1)*2);
parameter CHARACTER_PERIOD = (CLK16X_PERIOD * 16 * 10);

	// Instantiate the Unit Under Test (UUT)
	uart_tx  uut (
		.clk(clk), 
		.reset(reset), 
		.wren(wren), 
		.rden(rden), 
		.din(din), 
		.dout(dout), 
		.txout(txout), 
		.addr(addr)
	);
	
	`define FSIZE 1024

	integer infifo[(`FSIZE-1):0];
	integer head,tail;
	
	integer errors;
	
	initial begin
	 clk = 0;
	 #100   //reset delay
	 forever #10 clk = ~clk;
	end
	
	logic [7:0] outdata;
	integer i;
	
	
	
	task getserialdata;
	 input [7:0] expecteddata;
	begin
	  outdata = 0;
	  if (txout === 1'b1) begin
			@(negedge txout);  //wait for startbit
	  end
	  
	  #(CLK16X_PERIOD*8)  //wait for middle of start bit
	  if (txout !== 0) begin
	   errors = errors + 1;
	    $display("%t: FAIL, expected startbit=0, found startbit =1!",$time);
	  end
	  i = 0;
	  while (i !== 8) begin
	   outdata = outdata >> 1;
	   #(CLK16X_PERIOD*16)  //wait for middle of  bit
		outdata[7] = txout;
		i = i + 1;
	  end  

     //now wait for middle of stop bit
	  #(CLK16X_PERIOD*16) 
	  if (txout !== 1) begin
	    errors = errors + 1;
	    $display("%t: FAIL, expected stopbit=1, found stopbit =1!",$time);
	  end
	  
	  if (outdata !== expecteddata) begin
	      errors = errors + 1;
			$display("%t: FAIL,expected serial out of %h, found: %h",$time,expecteddata,outdata);
		end else begin
		  $display("%t: Pass,got expected serial out of %h",$time,expecteddata);
		end
		
	 end
	endtask
	
	task checkTxDoneBit;
	 begin
	 
	  @(negedge clk);
	  addr = 8'h03;
	  rden = 1;
	  //wait until TXDONE bit is set
	  while (dout[1] !== 1'b1) begin
		@(negedge clk);
	  end
		$display("%t: PASS,found TXDONE = '1'",$time);
		  
	  //now clear the TXDONE bit
	  wren = 1;
	  din = 8'h00;
	  @(negedge clk);
	  wren = 0;
	  @(negedge clk);
	  @(posedge clk);
	  
	   if (dout[1] !== 1'b0) begin
		  errors = errors + 1;
	     $display("%t: FAIL,failed to clear TXDONE bit to 0",$time);
	   end else
	     $display("%t: PASS,cleared TXDONE bit",$time);
	 @(negedge clk);
     rden = 0;		
	  @(negedge clk);
	  
	 
	 end
	
   endtask
	
	
	task checkTxFullBit;
	 input expecteddata;
	 begin
	 
	  @(negedge clk);
	  addr = 8'h03;
	  rden = 1;
	  $display("Checking if FIFO FULL bit is %h",expecteddata);
	  @(negedge clk);
	  @(posedge clk); //full clock cycle
	  if (dout[0] !== expecteddata) begin
	     errors = errors + 1;
	     $display("%t: FAIL, TXFULL bit is: %h, expected: %h",$time,dout[0],expecteddata);
	  end else
	     $display("%t: PASS, TXFULL bit is expected value",$time);
	 @(negedge clk);
	 end
	endtask
	
	 logic checktrigger;
	 
	 
	task applydata;
	 input [7:0] val;	 
	begin	
	   @(negedge clk);
	   infifo[head] = val;
		head = head + 1;
		if (head === `FSIZE) head = 0;
		checktrigger = 1; //trigger output check process
		
	   din = val;   
		wren = 1;
		addr = 2'b01;
		@(negedge clk);
		wren = 0;
		checktrigger = 0;
		@(negedge clk);
		
   end
   endtask
	
	integer charcount;


   //sends data to UUT
	//sends a total of 23 bytes.
	initial begin
		// Initialize Inputs
		#1
		clk = 0;
		reset = 1;
		wren = 0;
		rden = 0;
		din = 0;
		addr = 0;
		head = 0;
		tail = 0;
		checktrigger = 0;
		errors = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		// Add stimulus here
		@(negedge clk);
		@(negedge clk);
		@(negedge clk);
		@(negedge clk);
		@(negedge clk);
		//first need to write the period register
		din = UUT_PERIOD;
		wren = 1;
		addr = 0;
		@(negedge clk);
		wren = 0;
		rden = 1;
		@(negedge clk);
		@(negedge clk);
		if (dout !== UUT_PERIOD) begin
	     errors = errors + 1;
	     $display("%t: FAIL, PERIOD register write/read failed: %h, expected: %h",$time,UUT_PERIOD,dout);
	   end else begin
	     $display("%t: PASS, Period register read/write",$time);
		end 
		rden = 0;
		@(negedge clk);
		
		applydata(8'h55); //alternating 1's and 0's
		
		#(CHARACTER_PERIOD*1);
	   #(CLK16X_PERIOD*3);		
			
		//check fifo action by dumping several bytes
		applydata(8'h1A); 
      applydata(8'hE2); 
      applydata(8'h39); 

		//wait for long enough for fifo to be empty
		#(CHARACTER_PERIOD*3);  
		#(CLK16X_PERIOD*3);
		
		//now need to check the FIFO full status
		//fifo full bit should be 0
		
		checkTxFullBit(0);
		
		//design can hold 18 FIFO bytes+ 1 byte in shift register.
		//write 19 bytes.
		charcount = 0;
		while (charcount !== 8) begin
		 applydata(charcount+48);
		 charcount = charcount + 1;		
		end
		//at this point, the FIFO should be full.
		checkTxFullBit(1);
		
		#(CHARACTER_PERIOD*19); 
		#(CLK16X_PERIOD*3);
		
		while (head !== tail) begin
		  @(negedge clk); //wait for all characters to be processed		
		end

		$display("%t: All vectors done.",$time);
		if (errors !== 0) 
		  $display("%t: FAIL, had %d errors during simulation.",$time,errors);
		else
		  $display("%t: PASS, no errors during simulation.",$time); 
		
	end  //end initial
	
	//timeout process
	initial begin
	
		#(CHARACTER_PERIOD*30);   //wait 30 characters

		if (head !== tail) begin		
		 $display("%t: TIMEOUT, not all characters processed.",$time);
		 $display("The timeout is probably due to the TXDONE bit never going high.");
	   end
	
	end
	
	
	
	logic [7:0] checkdata;
	always @(posedge checktrigger) begin
	//check output
	  while(head !== tail) begin
	    checkdata = infifo[tail];
		 tail = tail + 1;
		 if (tail === `FSIZE) tail = 0;
	    getserialdata(checkdata);
		 checkTxDoneBit(); 
			 
	  end
	end
			 
     
endmodule


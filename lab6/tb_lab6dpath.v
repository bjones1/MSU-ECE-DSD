`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

module tb_lab6dpath;

	// Inputs
	reg reset;
	reg clk;
	reg irdy;
	reg [9:0] din;

	// Outputs
	wire ordy;
	wire [9:0] dout;

	// Instantiate the Unit Under Test (UUT)
	lab6dpath uut (
		.reset(reset), 
		.clk(clk), 
		.irdy(irdy), 
		.ordy(ordy), 
		.din(din), 
		.dout(dout)
	);
	
	reg[8*100:1] aline;
	integer fd;
	integer count,status;
	integer i_a, i_b, i_c, i_result;
	integer errors;
       
	
	initial begin
	 clk = 0;
	 #100   //reset delay
	 forever #25 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		// Initialize Inputs
		#1
		reset = 1;
		clk = 0;
		irdy = 0;
		din = 0;
		count = 0;
		errors = 0;
		
		
		fd = $fopen("../../../../multadd_vectors.txt","r");
        if (fd == 0) begin
          //for post-route simulation, one directory deeper
          fd = $fopen("../../../../../multadd_vectors.txt","r");
        end
                
        if (fd == 0) begin
           $display("Cannot open vectors file 'multadd_vectors.txt', simulation exiting");
           $finish;
        end

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		@(negedge clk);
		while ($fgets(aline,fd)) begin
			status = $sscanf(aline,"%x %x %x %x",i_a, i_b, i_c, i_result);
			count = count + 1;	
			din = i_a;
			irdy = 1;
			@(negedge clk);
			irdy = 0;
			din = i_b;
			@(negedge clk);
			din = i_c;
			@(negedge clk);
			@(negedge clk);
			if (ordy != 1) begin
			 $display("FAIL: ORDY is not asserted\n");
			end else begin
			  if (dout == i_result) begin
			   $display("%d(%t): PASS, a: %d, b: %d, c: %d, dout: %d\n",count,$time,i_a,i_b,i_c,dout);
			  end else begin
			   $display("%d(%t): FAIL, a: %d, b: %d, c: %d, y (actual): %d, dout (expected): %d\n",count,$time,i_a,i_b,i_c,dout,i_result);
			   errors = errors + 1;
			   end
			end
			@(negedge clk);
			//ensure output is still valid
			if (ordy != 1) begin
			 $display("FAIL: ORDY is not asserted\n");
			end else begin
			if (dout == i_result) begin
			   $display("%d(%t): PASS, a: %d, b: %d, c: %d, dout: %d\n",count,$time,i_a,i_b,i_c,dout);
			  end else begin
			   $display("%d(%t): FAIL, a: %d, b: %d, c: %d, y (actual): %d, dout (expected): %d\n",count,$time,i_a,i_b,i_c,dout,i_result);
			   errors = errors + 1;
			  end
			end
			
			@(negedge clk);  //wait few clocks
			if (ordy != 1) begin
			 $display("FAIL: ORDY is not asserted\n");
			end else begin
				if (dout == i_result) begin
			      $display("%d(%t): PASS, a: %d, b: %d, c: %d, dout: %d\n",count,$time,i_a,i_b,i_c,dout);
			    end else begin
			       $display("%d(%t): FAIL, a: %d, b: %d, c: %d, y (actual): %d, dout (expected): %d\n",count,$time,i_a,i_b,i_c,dout,i_result);
			       errors = errors + 1;
			    end
			end
        
	    end
	    $display("Simulation finished.\n");
	    if (errors == 0) $display("PASS: All vectors passed.\n");
          else $display ("FAIL: %d vectors failed\n",errors);
	    
		end
      
endmodule


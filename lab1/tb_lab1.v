`timescale 1ns / 1ps

module tb_leds;

	// Inputs
	reg [7:0] sw;

	// Outputs
	wire [7:0] led;
	
	integer i;
	integer errors = 0;

	// Instantiate the Unit Under Test (UUT)
	lab1 uut (
		.LED(led), 
		.SW(sw)
	);

	initial begin
		// Initialize Inputs
		sw = 0;

		// Wait 100 ns for global reset to finish
		#100;
		$display("Applying Vectors\n");
		// Add stimulus here
		i = 0;
		errors = 0;
		while (i != 256) begin
			sw = i;  //assign i to switch input
			#50;		 //delay;
			if (led != i) begin
				errors = errors + 1;
			end //end if
			i = i + 1;
		end //end begin
		
		if (errors == 0) begin
			$display("PASS: All test vectors passed\n");
		end
		else begin
			$display("FAIL: %d errors occurred\n", errors);
		end
			

	end
      
endmodule

`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   18:39:12 09/13/2014
// Design Name:   timer32
// Module Name:   C:/ece4743/projects/lab6_solution/tb_timer32.v
// Project Name:  lab6_solution
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: timer32
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module tb_timer32;

    // Inputs
    logic clk;
    logic reset;
    logic [31:0] din;
    logic wren;
    logic rden;
    logic [1:0] addr;

    // Outputs
    logic [31:0] dout;

    `define PERIOD_INITIAL 32'h0000000F

    `define TMR_REG 2'b00
    `define PER_REG 2'b01
    `define CON_REG 2'b10

    // Instantiate the Unit Under Test (UUT)
    timer32 #(
        .PERIOD(`PERIOD_INITIAL),
        .ENBIT (0)
    ) uut (
        .clk  (clk),
        .reset(reset),
        .din  (din),
        .dout (dout),
        .wren (wren),
        .rden (rden),
        .addr (addr)
    );


    initial begin
        clk = 0;
        #100  //reset delay
        forever
        #20 clk = ~clk;
    end

    integer errors;

    initial begin
        // Initialize Inputs
        #1 clk = 0;
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
        rden = 1;
        addr = `TMR_REG;
        @(negedge clk);
        //read Timer register
        if (dout != 0) begin
            $display("(%t)FAIL: Timer not reset to zero\n", $time());
            errors = errors + 1;
        end
        addr = `PER_REG;
        @(negedge clk);
        //read Period register
        if (dout != `PERIOD_INITIAL) begin
            $display("(%t)FAIL: Period register not reset to initial parameter value\n", $time());
            errors = errors + 1;
        end
        addr = `CON_REG;
        @(negedge clk);
        //read Control register
        if (dout != 0) begin
            $display("(%t)FAIL: Control register not reset to zero\n", $time());
            errors = errors + 1;
        end


        addr = `PER_REG;
        din  = 32'h00000007;
        wren = 1;
        @(negedge clk);  //write

        //write Period register, read result
        if (dout != 32'h00000007) begin
            $display("(%t)FAIL: Period register write failed\n", $time());
            errors = errors + 1;
        end

        //enable the timer, write a '1' to the EN bit
        wren = 1;
        addr = `CON_REG;
        din  = 1;
        @(negedge clk);
        wren = 0;
        addr = `TMR_REG;
        @(negedge clk);
        //timer should have incremented
        if (dout != 1) begin
            $display("(%t)FAIL: Timer failed to increment\n", $time());
            errors = errors + 1;
        end
        @(negedge clk);
        //timer should have incremented
        if (dout != 2) begin
            $display("(%t)FAIL: Timer failed to increment\n", $time());
            errors = errors + 1;
        end
        @(negedge clk);  //timer=3
        @(negedge clk);  //timer=4
        @(negedge clk);  //timer=5
        @(negedge clk);  //timer=6
        @(negedge clk);  //timer=7

        //period register should cause the timer to reset
        @(negedge clk);  //timer=0
        if (dout != 0) begin
            $display("(%t)FAIL: Timer (%d) failed to be reset by period register\n", $time(), din);
            errors = errors + 1;
        end

        @(negedge clk);
        //change address
        addr = `CON_REG;


        @(posedge clk);  //timer =1
        //read the control register, all three bits should be set!
        //need to read on posedge because clear on read

        if (dout != 7) begin
            $display("(%t)FAIL: Expected Control register value of 7, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=2
        //read again, the timer flag bit should be cleared because of previous reead
        if (dout != 5) begin
            $display("(%t)FAIL: Expected Control register value of 5, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=3
        addr = `CON_REG;
        wren = 1;
        din  = 4;  //disable the timer, keep the toggle bit as '1' ('b100)
        //We are clearing the TMR enable bit to freeze the timer value
        @(negedge clk);  //timer=4, but should no longer increment
        addr = `TMR_REG;
        wren = 0;
        //cannot check DOUT here as we have just changed the address bus
        @(negedge clk);  //timer=4
        //Timer should be frozen at 4
        if (dout != 4) begin
            $display("(%t)FAIL: Expected Timer register value of 4, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        //lets renable the timer
        @(negedge clk);  //timer=4
        //Timer should be frozen at 4
        addr = `CON_REG;
        wren = 1;
        din  = 5;  //enable the timer, keep the toggle bit as '1' ('b100)
        @(negedge clk);  //timer=4
        addr = `TMR_REG;
        wren = 0;
        //Timer is 4, but should start counting again
        @(negedge clk);  //timer=5
        if (dout != 5) begin
            $display("(%t)FAIL: Expected Timer register value of 5, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=6
        if (dout != 6) begin
            $display("(%t)FAIL: Expected Timer register value of 6, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=7
        if (dout != 7) begin
            $display("(%t)FAIL: Expected Timer register value of 7, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=0
        if (dout != 0) begin
            $display("(%t)FAIL: Expected Timer register value of 0, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=1
        @(negedge clk);  //timer = 2
        //change address
        addr = `CON_REG;  //read the control register
        @(posedge clk);  //timer=2
        //the toggle bit should cleared, the TMR Flag, enable bits should be set
        //need to read on posedge since bit is cleared on read
        if (dout != 3) begin
            $display("(%t)FAIL: Expected Control register value of 3, got (%d)\n", $time(), din);
            errors = errors + 1;
        end
        @(negedge clk);  //timer=3
        //the toggle bit, TMR flag bits should cleared,the enable bits should be set
        if (dout != 1) begin
            $display("(%t)FAIL: Expected Control register value of 1, got (%d)\n", $time(), din);
            errors = errors + 1;
        end



        if (errors == 0) begin
            $display("(%t)PASSED: All vectors passed\n", $time());
        end else begin
            $display("(%t)FAILED: %d vectors failed\n", $time(), errors);
        end


    end

endmodule

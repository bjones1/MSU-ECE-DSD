// <h1>tb_memory.v - Test bench for the <code><a
//             href="memory.v">memory.v</a></code> module
// </h1>
`timescale 1ns / 1ps

module tb_adder_datapath;
    // <p>Inputs to UUT</p>
    reg [15:0] SW;
    reg [4:0] BTN;
    reg clk;
    // <p>Outputs from UUT</p>
    wire [15:0] LED;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;

    basys_memory uut(
        .SW(SW),
        .BTN(BTN),
        .CLK(clk),
        .LED(LED)
    );

    // <p>Create a 20 ns clock.</p>
    initial begin
        clk = 0;
        forever begin
            #10
            clk = ~clk;
        end
    end

    // <p>Main testbench code.</p>
    initial begin
        // <p>Define the inital value for all inputs.</p>
        SW = 16'h0000;
        BTN = 5'h00;

        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        #100;

        $display("Applying vectors...\n");
        i = 0;
        errors = 0;

        // <p>Apply a stimulus vector</p>
        // <p>Wait for the values to propagate.</p>
        
        // Do a write (up button pressed).
        SW = 16'h5555;
        BTN = 5'b00001;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        // Dp a read (left button pressed)
        BTN = 5'b00010;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        if (LED !== 16'h5555) begin
            errors = errors + 1;
        end

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

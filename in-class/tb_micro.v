// <h1>tb_adder-datapath.v - Test bench for the <code><a
//             href="adder-datapath.v">adder-datapath.v</a></code> module
// </h1>
`timescale 1ns / 1ps

module tb_micro;
    // <p>Inputs to UUT</p>
    reg clk, reset;
    // <p>Outputs from UUT</p>
    wire [12:0] inst;
    wire [7:0] pc, w, a, b, d;
    wire is_zero;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;

    micro uut (
        .clk(clk),
        .reset(reset),
        .w(w),
        .pc(pc),
        .inst(inst),
        .is_zero(is_zero),
        .a(a),
        .b(b),
        .d(d)
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
        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        reset = 1;
        #100;
        reset = 0;

        $display("Applying vectors...\n");
        i = 0;
        errors = 0;
        
        @(negedge clk);
        #1000;
        
        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
        $finish;
    end

endmodule

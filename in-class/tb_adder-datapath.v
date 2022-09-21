// <h1>tb_adder-datapath.v - Test bench for the <code><a
//             href="adder-datapath.v">adder-datapath.v</a></code> module
// </h1>
`timescale 1ns / 1ps

module tb_adder_datapath;
    // <p>Inputs to UUT</p>
    reg [15:0] a, b, c;
    reg clk;
    // <p>Outputs from UUT</p>
    wire [15:0] y;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;

    // <p><a
    //         href="https://www.chipverify.com/verilog/verilog-module-instantiations">Instantiate</a>
    //     the Unit Under Test (UUT). This means:</p>
    // <ul>
    //     <li>Place a copy of the <code>lab1</code> module here; name it
    //         <code>uut</code>.</li>
    //     <li>Connect <code>lab1</code>'s <code>LED</code> outputs to the
    //         wires (declared a few lines earlier in this file) named
    //         <code>led</code>.</li>
    //     <li>Likewise, connect <code>lab1</code>'s <code>SW</code> inputs
    //         to the registers named <code>sw</code> (also declared a few
    //         lines earlier in this file).</li>
    // </ul>
    adder_datapath uut (
        .clk(clk),
        .a(a),
        .b(b),
        .c(c),
        .y(y)
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
        clk = 0;
        a = 0;
        b = 0;
        c = 0;

        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        #100;
        

        $display("Applying vectors...\n");
        i = 0;
        errors = 0;
        
        // <p>Apply a stimulus vector</p>
        a = 12'h654;
        b = 12'h456;
        c = 12'h555;
        // <p>Wait for the values to propagate.</p>
        #100

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

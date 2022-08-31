// <h1>tb_in-class.v - Test bench for the <code><a
//             href="in-class.v">in-class.v</a></code> module</h1>
`timescale 1ns / 1ps

module tb_in_class;
    // <p>Inputs to UUT</p>
    reg a, b;
    // <p>Outputs from UUT</p>
    wire y;

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
    in_class uut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // <p>Define the inital value for all inputs.</p>
        a = 0;
        b = 0;

        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        #100;

        // <p>A <a
        //         href="https://www.chipverify.com/verilog/verilog-display-tasks">display</a>
        //     statement acts much like a <code>printf</code> statement in C or
        //     <code>cout</code> in C++ by printing output to the screen.</p>
        $display("Applying vectors...\n");

        // <p>To test the lab1 module, apply all possible inputs (the values 0 to
        //     255) and check that each output matches with the input.</p>
        // <p>Begin by initializing some variables.</p>
        i = 0;
        errors = 0;

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

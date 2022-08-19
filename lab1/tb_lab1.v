// <h1>tb_lab1.v - Test bench for the <code><a
//             href="lab1.v.html">lab1.v</a></code> module</h1>
// <p>This file provides a series of tests (called a test bench) to
//     verify that the <code><a href="lab1.v.html">lab1.v</a></code>
//     module works correctly. Because this file will not be synthesized,
//     it can contain any code, including code that cannot be
//     synthesized.</p>
// <p>The timescale <a
//         href="https://www.chipverify.com/verilog/verilog-timescale">compiler
//         directive</a> specifies the time unit and precision for one
//     time unit. Therefore, the <a href="#delay-100">#100 delay
//         statement</a> which appears later in this file specifies a
//     delay of 100 ns.</p>
`timescale 1ns / 1ps

// <p>In contrast to <code><a href="lab1.v.html">lab1.v</a></code>, this
//     module contains no inputs or outputs; therefore, the ports are
//     omitted.</p>
module tb_leds;

    // <p>For testing, make the switches a register. Like variables in
    //     traditional programming languages, <span
    //         style="text-decoration: underline;"><strong><code>reg</code></strong></span>isters
    //     may contain a value.</p>
    reg [7:0] sw;

    // <p>The outputs only need to be compared to the inputs, but don't need
    //     to store a value. Declare them as wires.</p>
    wire [7:0] led;

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
    lab1 uut (
        .LED(led),
        .SW(sw)
    );

    // <p>The <a
    //         href="https://www.chipverify.com/verilog/verilog-initial-block"><code>initial</code>
    //         block</a> defines what this module does starting at time 0;
    //     using <code>initial begin</code>...<code>end</code> allows that
    //     definition to include multiple statements. That is, Verilog's
    //     <code>begin</code>...<code>end</code> serves the same role a
    //     C/C++'s <code>{</code>...<code>}</code>.This block can only be
    //     used in simulation, not in synthesis.</p>
    initial begin
        // <p>Define the inital value for all inputs.</p>
        sw = 0;

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
        // <p>Use a <code>for</code> loop to check each possible value. Note that
        //     Verilog doesn't have the increment operator, so the expression
        //     <code>++i</code> is invalid. Likewise, it doesn't allow inplace
        //     addition, making <code>i += 1</code> invalid as well. Instead, use
        //     <code>i = i + 1</code>.</p>
        for (i = 0; i != 256; i = i + 1) begin
            // Assign i to the switch input.
            sw = i;
            // Delay, to allow for propoagation time.
            #50;
            // <p>Check that the output matches the input.</p>
            if (led != i) begin
                errors = errors + 1;
            end
        end

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

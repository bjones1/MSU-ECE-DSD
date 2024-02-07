// # tb_lab1.v - Test bench for the <code><a href="lab1.v">lab1.v</a></code> module
//
// This file provides a series of tests (called a test bench) to verify that the
// <code><a href="lab1.v">lab1.v</a></code> module works correctly. Because this
// file will not be synthesized, it can contain any code, including code that
// cannot be synthesized.
//
// The timescale
// [compiler directive](https://www.chipverify.com/verilog/verilog-timescale)
// specifies the time unit and precision for one time unit. Therefore, the
// [#100 delay statement](#delay-100) which appears later in this file specifies
// a delay of 100 ns.
`timescale 1ns / 1ps

// In contrast to <code><a href="lab1.v">lab1.v</a></code>, this module contains
// no inputs or outputs; therefore, the ports are omitted.
module tb_leds;

    // For testing, make the switches a register. Like variables in traditional
    // programming languages,
    // <span style="text-decoration: underline;"><strong><code>reg</code></strong></span>isters
    // may contain a value.
    logic [7:0] sw;

    // The outputs only need to be compared to the inputs, but don't need to
    // store a value. Declare them as wires.
    logic [7:0] led;

    // An `integer` is essentially a 32-bit register. It's a convenient way to
    // declare and use 32-bit values.
    integer i;
    integer errors = 0;

    // [Instantiate](https://www.chipverify.com/verilog/verilog-module-instantiations)
    // the Unit Under Test (UUT). This means:
    //
    // - Place a copy of the `lab1` module here; name it `uut`.
    // - Connect `lab1`'s `LED` outputs to the wires (declared a few lines
    //   earlier in this file) named `led`.
    // - Likewise, connect `lab1`'s `SW` inputs to the registers named `sw`
    //   (also declared a few lines earlier in this file).
    lab1 uut (
        .LED(led),
        .SW(sw)
    );

    // The
    // [`initial` block](https://www.chipverify.com/verilog/verilog-initial-block)
    // defines what this module does starting at time 0; using
    // `initial begin`...`end` allows that definition to include multiple
    // statements. That is, Verilog's `begin`...`end` serves the same role a
    // C/C++'s `{`...`}`.This block can only be used in simulation, not in
    // synthesis.
    initial begin
        // Define the inital value for all inputs.
        sw = 0;

        // <a id="delay-100"></a>Wait 100 ns for global reset to finish.
        #100;

        // A [display](https://www.chipverify.com/verilog/verilog-display-tasks)
        // statement acts much like a `printf` statement in C or `cout` in C++
        // by printing output to the screen.
        $display("Applying vectors...\n");

        // To test the lab1 module, apply all possible inputs (the values 0
        // to 255) and check that each output matches with the input.
        //
        // Begin by initializing some variables.
        i = 0;
        errors = 0;
        // Use a `for` loop to check each possible value. Note that Verilog
        // doesn't have the increment operator, so the expression `++i` is
        // invalid. Likewise, it doesn't allow inplace addition, making `i += 1`
        // invalid as well. Instead, use `i = i + 1`.
        for (i = 0; i !== 256; i = i + 1) begin
            // Assign i to the switch input.
            sw = i;
            // Delay, to allow for propoagation time.
            #50;
            // Check that the output matches the input.
            if (led !== i) begin
                errors = errors + 1;
            end
        end

        // Error check after the loop completes.
        if (errors === 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
        $finish;
    end

endmodule

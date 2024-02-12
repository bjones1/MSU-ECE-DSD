// # tb_in-class.v - Test bench for the <code><a href="in-class.v">in-class.sv</a></code> module
`timescale 1ns / 1ps

module tb_in_class;
    // Inputs to UUT
    logic clk, reset;
    logic [15:0] a, b, c;
    // Outputs from UUT
    logic [15:0] x, y, z;
    

    // An `integer` is essentially a 32-bit register. It's a convenient way to
    // declare and use 32-bit values.
    integer i, count;
    integer errors = 0;

    // [Instantiate](https://www.chipverify.com/verilog/verilog-module-instantiations)
    // the Unit Under Test (UUT). This means:
    //
    // - Place a copy of the `lab1` module here; name it `uut`.
    // - Connect `lab1`'s `LED` outputs to the wires (declared a few lines
    //   earlier in this file) named `led`.
    // - Likewise, connect `lab1`'s `SW` inputs to the registers named `sw`
    //   (also declared a few lines earlier in this file).
    in_class uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .y(y),
        .z(z)
    );

    // After 100 ns delay for reset, produce a 50 ns period clock.
    initial begin
        clk = 0;
        #100
        forever #25 clk = ~clk;
    end
    
    initial begin
        // Define the inital value for all inputs.
        a = 0;
        b = 0;
        c = 0;
        reset = 1;
        count = 0;

        // <a></a>Wait 100 ns for global reset to finish.
        #100;

        // A [display](https://www.chipverify.com/verilog/verilog-display-tasks)
        // statement acts much like a `printf` statement in C or `cout` in C++
        // by printing output to the screen.
        $display("Applying vectors...\n");

        // Begin by initializing some variables.
        i = 0;
        errors = 0;
        reset = 0;

        // Produce some data to use while testing.
        for (i = 0; i < 2**16; ++i) begin
            a = i;
            b = ~i;
            c = $urandom();
            #50;
            // A sample test, commented out.
            /**
            if (y === (a & b)) begin
                // The `$time` system function (see
                // [Section 17.7.1](verilog_standard_1364-2005.pdf#page=339))
                // returns the time, in units of the current timescale (1 ns for
                // this testbench).
                $display("%d(%t): PASS, a: 0x%x, b: 0x%x, c: 0x%x, y: 0x%x\n", count, $time, a, b, c, y);
            end else begin
                $display("%d(%t): FAIL, a: 0x%x, b: 0x%x, c: 0x%x, y (actual): 0x%x, y (expected): 0x%x\n", count, $time, a, b, c, y, a & b);
                errors = errors + 1;
            end
            count = count + 1;
            */
        end

        // Error check after the loop completes. (Uncomment and modify the
        // sample test above to make use of this feature.)
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

// # `tb_max3sint16b.v` - test bench for [max3sint16b.v](max3sint16b.v.html)
//
// Set the time scale for simulation to 1 ns.
`timescale 1ns / 1ps

module tb_max3sint16b;

    // Inputs
    logic signed [15:0] a, b, c;
    // Outputs
    logic signed [15:0] y;

    // A variable to hold a line of text (100 characters) read from a file. See
    // [section 3.6](../verilog_standard_1364-2005.pdf#page=42).
    string aline;
    // Store the file descriptor produced by opening a file.
    integer fd;
    // The number of tests run.
    integer count;
    // Input values for `a`, `b`, and `c`.
    integer i_a, i_b, i_c;
    // The expected result.
    integer i_result;
    // The number of errors detected.
    integer errors;

    // Instantiate the Unit Under Test (UUT).
    max3sint16b uut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        c = 0;
        // See `$fopen` in
        // [section 17.2.1](verilog_standard_1364-2005.pdf#page=317). Open a
        // file containing test vectors. A return value of 0 indicates the open
        // failed.
        fd = $fopen("../../../../max3sint16b_vectors.txt", "r");
        if (fd == 0) begin
            // For post-route simulation, this file is located one directory
            // deeper.
            fd = $fopen("../../../../../max3sint16b_vectors.txt", "r");
        end

        count = 1;

        // Wait 100 ns for global reset to finish.
        #100;

        // Add stimulus here
        errors = 0;
        // Use `$fgets` (see
        // [Section 17.2.4.2](verilog_standard_1364-2005.pdf#page=320)) to read
        // one line of the file. It returns the number of bytes read; a return
        // value of 0 therefore indicates that there's nothing more to read.
        while ($fgets(aline, fd)) begin
            // The `$sscanf` function (see
            // [Section 17.2.4.3](verilog_standard_1364-2005.pdf#page=321))
            // reads four signed decimal numbers (the `%d` conversion
            // specification) then stores them in the listed variables. It
            // returns the number of values read.
            if ($sscanf(aline, "%5d %5d %5d %5d", i_a, i_b, i_c, i_result) != 4) begin
                $display("FAIL: unable to read test vectors.\n");
                // Per
                // [Section 17.4.1](verilog_standard_1364-2005.pdf#page=332),
                // this causes the simulator to stop.
                $finish;
            end

            // Pass these inputs to the UUT.
            a = i_a;
            b = i_b;
            c = i_c;

            // Delay while it computes the answer.
            #50

            // Check that the actual result matches the expected result.
            if (i_result == y) begin
                // The `$time` system function (see
                // [Section 17.7.1](verilog_standard_1364-2005.pdf#page=339))
                // returns the time, in units of the current timescale (1 ns for
                // this testbench).
                $display("%d(%t): PASS, a: %d, b: %d, c: %d, y: %d\n",count, $time, a, b, c, y);
            end else begin
                $display("%d(%t): FAIL, a: %d, b: %d, c: %d, y (actual): %d, y (expected): %d\n", count, $time, a, b, c, y, i_result);
                errors = errors + 1;
            end
            count = count + 1;

        end

        if (errors == 0) begin
            $display("PASS: All vectors passed.\n");
        end else begin
            $display ("FAIL: %d vectors failed\n",errors);
        end
        $finish;
    end

endmodule

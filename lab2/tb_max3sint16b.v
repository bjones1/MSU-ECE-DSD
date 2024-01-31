// <h1><code>tb_max3sint16b.v</code> - test bench for <a
//         href="max3sint16b.v">max3sint16b.v</a></h1>
// <p>Set the time scale for simulation to 1 ns.</p>
`timescale 1ns / 1ps

module tb_max3sint16b;

    // <p>Inputs</p>
    reg signed [15:0] a, b, c;
    // <p>Outputs</p>
    wire signed [15:0] y;

    // <p>A variable to hold a line of text (100 characters) read from a
    //     file. See <a
    //         href="../verilog_standard_1364-2005.pdf#page=42">section
    //         3.6</a>.</p>
    reg [8*100:1] aline;
    // <p>Store the file descriptor produced by opening a file.</p>
    integer fd;
    // <p>The number of tests run.</p>
    integer count;
    // <p>Input values for <code>a</code>, <code>b</code>, and
    //     <code>c</code>.</p>
    integer i_a, i_b, i_c;
    // <p>The expected result.</p>
    integer i_result;
    // <p>The number of errors detected.</p>
    integer errors;

    // <p>Instantiate the Unit Under Test (UUT).</p>
    max3sint16b uut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );

    initial begin
        // <p>Initialize Inputs</p>
        a = 0;
        b = 0;
        c = 0;
        // <p>See <code>$fopen</code> in <a
        //         href="verilog_standard_1364-2005.pdf#page=317">section
        //         17.2.1</a>. Open a file containing test vectors. A return
        //     value of 0 indicates the open failed.</p>
        fd = $fopen("../../../../max3sint16b_vectors.txt", "r");
        if (fd == 0) begin
            // <p>For post-route simulation, this file is located one directory
            //     deeper.</p>
            fd = $fopen("../../../../../max3sint16b_vectors.txt", "r");
        end

        count = 1;

        // <p>Wait 100 ns for global reset to finish.</p>
        #100;

        // <p>Add stimulus here</p>
        errors = 0;
        // <p>Use <code>$fgets</code> (see <a
        //         href="verilog_standard_1364-2005.pdf#page=320">Section
        //         17.2.4.2</a>) to read one line of the file. It returns the
        //     number of bytes read; a return value of 0 therefore indicates that
        //     there's nothing more to read.</p>
        while ($fgets(aline, fd)) begin
            // <p>The <code>$sscanf</code> function (see <a
            //         href="verilog_standard_1364-2005.pdf#page=321">Section
            //         17.2.4.3</a>) reads four signed decimal numbers (the
            //     <code>%d</code> conversion specification) then stores them in the
            //     listed variables. It returns the number of values read.</p>
            if ($sscanf(aline, "%5d %5d %5d %5d", i_a, i_b, i_c, i_result) != 4) begin
                $display("FAIL: unable to read test vectors.\n");
                // <p>Per <a href="verilog_standard_1364-2005.pdf#page=332">Section
                //         17.4.1</a>, this causes the simulator to stop.</p>
                $finish;
            end

            // <p>Pass these inputs to the UUT.</p>
            a = i_a;
            b = i_b;
            c = i_c;

            // <p>Delay while it computes the answer.</p>
            #50

            // <p>Check that the actual result matches the expected result.</p>
            if (i_result === y) begin
                // <p>The <code>$time</code> system function (see <a
                //         href="verilog_standard_1364-2005.pdf#page=339">Section
                //         17.7.1</a>) returns the time, in units of the current
                //     timescale (1 ns for this testbench).</p>
                $display("%d(%t): PASS, a: %d, b: %d, c: %d, y: %d\n",count, $time, a, b, c, y);
            end else begin
                $display("%d(%t): FAIL, a: %d, b: %d, c: %d, y (actual): %d, y (expected): %d\n", count, $time, a, b, c, y, i_result);
                errors = errors + 1;
            end
            count = count + 1;

        end

        if (errors === 0) begin
            $display("PASS: All vectors passed.\n");
        end else begin
            $display ("FAIL: %d vectors failed\n",errors);
        end
        $finish;
    end

endmodule

// <h1><a href="lab5dpath.v">Lab 5</a> testbench</h1>
`timescale 1ns / 1ps

// <p>The number of clock cycles required by the <code>lab5dpath</code> module to produce a result. Modify this based on the pipelining of your design.</p>
`define LATENCY (2)

module tb_lab5dpath;

    // <p>Inputs</p>
    reg clk;
    reg [9:0] x1;
    reg [9:0] x2;
    reg [9:0] x3;

    // <p>Outputs</p>
    wire [9:0] y;

    // <p>Internal values</p>
    reg [8*100:1] aline;
    integer fd;
    integer i_a, i_b, i_c, i_result;
    integer errors;

    // <p>Instantiate the Unit Under Test (UUT)</p>
    lab5dpath uut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .clk(clk),
        .y(y)
    );

    // <p>After 100 ns delay for reset, produce a 50 ns period clock.</p>
    initial begin
        clk = 0;
        #100
        forever #25 clk = ~clk;
    end

    initial begin
        // <p>Initialize Inputs</p>
        x1 = 0;
        x2 = 0;
        x3 = 0;

        fd = $fopen("../../../../multadd_vectors.txt", "r");
        if (fd === 0) begin
          // <p>for post-route simulation, one directory deeper</p>
          fd = $fopen("../../../../../multadd_vectors.txt", "r");
        end

        if (fd === 0) begin
          $display("Cannot open vectors file 'multadd_vectors.txt', simulation exiting");
          $finish;
        end

        // <p>Wait 100 ns for global reset to finish</p>
        #100;

        // <p>Start a task to check each line in the simulus file.</p>
        errors = 0;
        while ($fgets(aline, fd)) begin
            if ($sscanf(aline, "%x %x %x %x", i_a, i_b, i_c, i_result) !== 4) begin
                $display("Error reading test vectors.");
                $finish;
            end
            @(negedge clk);
            check_mult(i_a, i_b, i_c, i_result);
        end

        // <p>Wait for the final few checks to complete.</p>
        pipeline_wait();
        if (errors === 0)
            $display("PASS: All vectors passed.\n");
        else
            $display("FAIL: %d vectors failed\n", errors);
        $finish;
    end

    // <p>Wait enough clocks for the pipelined multiply/add process to
    //     produce a result.</p>
    task pipeline_wait;
        integer i;
        begin
            for (i = 0; i < `LATENCY; i = i + 1) begin
                @(negedge clk);
            end
        end
    endtask

    // <p>Check if the output of the multiply/add agrees with the provided
    //     expected value.</p>
    task check_mult(
        input [9:0] a,
        input [9:0] b,
        input [9:0] c,
        input [9:0] y_expected
    );
        begin
            x1 = a;
            x2 = b;
            x3 = c;
            pipeline_wait();
            if (y_expected === y) begin
                $write("PASS %t: x1: %x, x2: %x, x3: %x, y: %x\n", $time, a, b, c, y);
            end else begin
                $write("FAIL %t: x1: %x, x2: %x, x3: %x, y actual: %x, y expected: %x\n", $time, a, b, c, y, y_expected);
                errors = errors + 1;
            end
        end
    endtask
endmodule

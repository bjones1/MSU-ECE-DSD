// # [Lab 5](lab5dpath.v) testbench
`timescale 1ns / 1ps

// The number of clock cycles required by the `lab5dpath` module to produce a
// result. Modify this based on the pipelining of your design.
`define LATENCY (2)

module tb_lab5dpath;

    // Inputs
    logic clk;
    logic [9:0] x1;
    logic [9:0] x2;
    logic [9:0] x3;

    // Outputs
    logic [9:0] y;

    // Internal values
    string aline;
    integer fd;
    integer i_a, i_b, i_c, i_result;
    integer errors;

    // Instantiate the Unit Under Test (UUT)
    lab5dpath uut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .clk(clk),
        .y(y)
    );

    // After 100 ns delay for reset, produce a 50 ns period clock.
    initial begin
        clk = 0;
        #100
        forever #25 clk = ~clk;
    end

    initial begin
        // Initialize Inputs
        x1 = 0;
        x2 = 0;
        x3 = 0;

        fd = $fopen("../../../../multadd_vectors.txt", "r");
        if (fd === 0) begin
          // for post-route simulation, one directory deeper
          fd = $fopen("../../../../../multadd_vectors.txt", "r");
        end

        if (fd === 0) begin
          $display("Cannot open vectors file 'multadd_vectors.txt', simulation exiting");
          $finish;
        end

        // Wait 100 ns for global reset to finish
        #100;

        // Start a task to check each line in the simulus file.
        errors = 0;
        while ($fgets(aline, fd)) begin
            if ($sscanf(aline, "%x %x %x %x", i_a, i_b, i_c, i_result) !== 4) begin
                $display("Error reading test vectors.");
                $finish;
            end
            @(negedge clk);
            check_mult(i_a, i_b, i_c, i_result);
        end

        // Wait for the final few checks to complete.
        pipeline_wait();
        if (errors === 0)
            $display("PASS: All vectors passed.\n");
        else
            $display("FAIL: %d vectors failed\n", errors);
        $finish;
    end

    // Wait enough clocks for the pipelined multiply/add process to produce a
    // result.
    task pipeline_wait;
        integer i;
        begin
            for (i = 0; i < `LATENCY; i = i + 1) begin
                @(negedge clk);
            end
        end
    endtask

    // Check if the output of the multiply/add agrees with the provided expected
    // value.
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

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
    logic [9:0] y_expected;
    integer errors;

    // Instantiate the Unit Under Test (UUT)
    lab5dpath uut (.*);

    // After 100 ns delay for reset, produce a 50 ns period clock.
    initial begin
        clk = 0;
        #100 forever #25 clk = ~clk;
    end

    // This property states that `y` should match `y_expected` `LATENCY` clocks later.
    property p1;
        logic [9:0] tmp;
        // On each falling clock edge,
        @(negedge clk)
        // Always
        (1,
        // remember `y_expected`,
        tmp = y_expected
        // then compare it with `y` `LATENCY` clocks later.
        ) ##(`LATENCY-1) (y ==? tmp);
    endproperty

    // Property p1 must hold.
    assert property (p1) begin
        // When it holds, report success.
        $write("PASS %t: x1: %x, x2: %x, x3: %x, y: %x %x\n", $time, x1, x2, x3, y, y_expected);
    end else begin
        // When it does not hold, report failure.
        $write("FAIL %t: x1: %x, x2: %x, x3: %x, y actual: %x, y expected: %x\n", $time, x1, x2,
               x3, y, y_expected);
        errors = errors + 1;
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

        // Start a task to check each line in the stimulus file.
        errors = 0;
        while ($fgets(
            aline, fd
        )) begin
            if ($sscanf(aline, "%x %x %x %x", x1, x2, x3, y_expected) !== 4) begin
                $display("Error reading test vectors.");
                $finish;
            end
            @(negedge clk);
        end

        // Wait for the final few checks to complete.
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        if (errors === 0) $display("PASS: All vectors passed.\n");
        else $display("FAIL: %d vectors failed\n", errors);
        $finish;
    end
endmodule

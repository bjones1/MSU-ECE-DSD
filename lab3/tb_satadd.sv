// # `tb_satadd.v` - testbench for <code><a href="satadd.v">satadd.v</a></code>
`timescale 1ns / 1ps

module tb_satadd;
    // Inputs to UUT
    logic [11:0] a;
    logic [11:0] b;
    logic [1:0] mode;

    // Outputs from UUT
    logic [11:0] y;

    // Testbench state
    string aline, comment;
    integer fd;
    integer count, status;
    integer i_a, i_b, i_mode, i_result;
    integer errors;

    // Instantiate the Unit Under Test (UUT)
    satadd uut (
        .a(a),
        .b(b),
        .mode(mode),
        .y(y)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        mode = 0;

        fd = $fopen("../../../../satadd_vectors.txt","r");
        if (fd == 0) begin
            // For post-route simulation, one directory deeper.
            fd = $fopen("../../../../../satadd_vectors.txt","r");
        end
        count = 1;

        // Wait 100 ns for global reset to finish
        #100;

        // Apply stimulus from test vector file.
        errors = 0;
        while ($fgets(aline,fd)) begin
            if ($sscanf(aline, "%x %x %x %x", i_mode, i_a, i_b, i_result) !== 4) begin
                $display("Error: unable to read data.");
                $finish;
            end
            // There's no way to read a string containing whitespace using `%s` in a `sscanf` or `fscanf`.
            // So, get the string from a specific character position in the file. Subtract two: omit the
            // newline (-1) and the string is zero-indedex (another -1).
            comment = aline.substr(14, aline.len() - 2);
            a = i_a;
            b = i_b;
            mode = i_mode;
            // Wait the outputs to propagate before testing them.
            #100
            if (i_result === y) begin
                $display("%d(%t): PASS, mode: %x, a: %x, b: %x, y: %x %s", count, $time, mode, a, b, y, comment);
            end else begin
                $display("%d(%t): FAIL, mode: %x, a: %x, b: %x, y (actual): %x, y (expected): %x %s", count, $time, mode, a, b, y, i_result, comment);
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

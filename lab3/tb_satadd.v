// <h1><code>tb_satadd.v</code> - testbench for <code><a
//             href="satadd.v">satadd.v</a></code></h1>
`timescale 1ns / 1ps

module tb_satadd;
    // <p>Inputs to UUT</p>
    reg [11:0] a;
    reg [11:0] b;
    reg [1:0] mode;

    // <p>Outputs from UUT</p>
    wire [11:0] y;

    // <p>Testbench state</p>
    reg [8*100:1] aline, comment;
    integer fd;
    integer count, status;
    integer i_a, i_b, i_mode, i_result;
    integer errors;

    // <p>Instantiate the Unit Under Test (UUT)</p>
    satadd uut (
        .a(a),
        .b(b),
        .mode(mode),
        .y(y)
    );

    initial begin
        // <p>Initialize Inputs</p>
        a = 0;
        b = 0;
        mode = 0;

        fd = $fopen("../../../../satadd_vectors.txt","r");
        if (fd == 0) begin
            // <p>For post-route simulation, one directory deeper.</p>
            fd = $fopen("../../../../../satadd_vectors.txt","r");
        end
        count = 1;

        // <p>Wait 100 ns for global reset to finish</p>
        #100;

        // <p>Apply stimulus from test vector file.</p>
        errors = 0;
        while ($fgets(aline,fd)) begin
            status = $sscanf(aline, "%x %x %x %x %s", i_mode, i_a, i_b, i_result, comment);
            a = i_a;
            b = i_b;
            mode = i_mode;
            // <p>Wait the outputs to propagate before testing them.</p>
            #100
            if (i_result == y) begin
                $display("%d(%t): PASS, mode: %x, a: %x, b: %x, y: %x %s\n", count, $time, mode, a, b, y, comment);
            end else begin
                $display("%d(%t): FAIL, mode: %x, a: %x, b: %x, y (actual): %x, y (expected): %x %s\n", count, $time, mode, a, b, y, i_result, comment);
                errors = errors + 1;
            end
            count = count + 1;
        end

        if (errors == 0) begin
            $display("PASS: All vectors passed.\n");
        end else begin
            $display ("FAIL: %d vectors failed\n",errors);
        end
    end

endmodule

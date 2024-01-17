// <h1>tb_adder-datapath.v - Test bench for the <code><a
//             href="adder-datapath.v">adder-datapath.v</a></code> module
// </h1>
`timescale 1ns / 1ps

module tb_micro;
    // <p>Inputs to UUT</p>
    reg clk, reset;
    // <p>Outputs from UUT</p>
    wire [12:0] inst;
    wire [7:0] pc, w, a, b, d;
    wire is_zero;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;
    integer fd;
    reg [7:0] i_w, i_pc, i_a, i_b, i_d;
    reg [12:0] i_inst;
    reg i_is_zero;
    reg [8*100:1] aline;

    micro uut (
        .clk(clk),
        .reset(reset),
        .w(w),
        .pc(pc),
        .inst(inst),
        .is_zero(is_zero),
        .a(a),
        .b(b),
        .d(d)
    );
    
    // <p>Create a 20 ns clock.</p>
    initial begin
        clk = 0;
        forever begin
            #10
            clk = ~clk;
        end
    end

    // <p>Main testbench code.</p>
    initial begin
        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        reset = 1;

        fd = $fopen("../../../../micro_vectors.txt", "r");
          // <p>for post-route simulation, one directory deeper</p>
        fd = fd ? fd : $fopen("../../../../../micro_vectors.txt", "r");

        if (fd === 0) begin
          $display("Cannot open vectors file 'micro_vectors.txt', simulation exiting");
          $finish;
        end

        #100;
        reset = 0;

        $display("Applying vectors...\n");
        i = 0;
        errors = 0;
        
        while ($fgets(aline, fd)) begin
            @(negedge clk);
            if ($sscanf(aline, "%x %x %x %x %x %x %x", i_pc, i_inst, i_w, i_is_zero, i_a, i_b, i_d) !== 7) begin
                $display("Error reading test vectors.");
                $finish;
            end
            if (i_w === w && i_pc === pc && i_inst === inst && i_is_zero === is_zero && i_a === a && i_b === b && i_d === d) begin
                $write("PASS");
            end else begin
                $write("FAIL");
                errors = errors + 1;
            end 
            $write(" - Actual: %x %x %x %x %x %x %x\n", pc, inst, w, is_zero, a, b, d);
            $write("     Expected: %x %x %x %x %x %x %x\n", i_pc, i_inst, i_w, i_is_zero, i_a, i_b, i_d);
        end
        
        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed");
        end else begin
            $display("FAIL: %d errors occurred", errors);
        end
        $finish;
    end

endmodule

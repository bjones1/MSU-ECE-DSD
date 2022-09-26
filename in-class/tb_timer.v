// <h1>tb_adder-datapath.v - Test bench for the <code><a
//             href="adder-datapath.v">adder-datapath.v</a></code> module
// </h1>
`timescale 1ns / 1ps

module tb_adder_datapath;
    // <p>Inputs to UUT</p>
    reg [15:0] din;
    reg clk, ld, cnt_en, aclr;
    // <p>Outputs from UUT</p>
    wire [15:0] dout;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;

    timer uut (
        .clk(clk),
        .din(din),
        .ld(ld),
        .cnt_en(cnt_en),
        .aclr(aclr),
        .dout(dout)
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
        // <p>Define the inital value for all inputs.</p>
        din = 0;
        ld = 0;
        cnt_en = 0;
        aclr = 0;

        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        #100;

        $display("Applying vectors...\n");
        i = 0;
        errors = 0;

        // <p>Apply a stimulus vector</p>
        // <p>Wait for the values to propagate.</p>
        #100

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

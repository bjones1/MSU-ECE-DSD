// <h1>tb_adder-datapath-control.v - Test bench for the <code><a
//             href="adder-datapath-control.v">adder-datapath-control.v</a></code>
//     module</h1>
`timescale 1ns / 1ps

module tb_adder_datapath_control;
    // <p>Inputs to UUT</p>
    reg [15:0] din;
    reg clk, reset, irdy;
    // <p>Outputs from UUT</p>
    wire [15:0] dout;
    wire ordy;

    // <p>An <code>integer</code> is essentially a 32-bit register. It's a
    //     convenient way to declare and use 32-bit values.</p>
    integer i;
    integer errors = 0;

    // <p><a
    //         href="https://www.chipverify.com/verilog/verilog-module-instantiations">Instantiate</a>
    //     the Unit Under Test (UUT). This means:</p>
    // <ul>
    //     <li>Place a copy of the <code>lab1</code> module here; name it
    //         <code>uut</code>.</li>
    //     <li>Connect <code>lab1</code>'s <code>LED</code> outputs to the
    //         wires (declared a few lines earlier in this file) named
    //         <code>led</code>.</li>
    //     <li>Likewise, connect <code>lab1</code>'s <code>SW</code> inputs
    //         to the registers named <code>sw</code> (also declared a few
    //         lines earlier in this file).</li>
    // </ul>
    adder_datapath_control uut (
        .clk(clk),
        .reset(reset),
        .din(din),
        .irdy(irdy),
        .dout(dout),
        .ordy(ordy)
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
        clk = 0;
        din = 0;
        irdy = 0;
        reset = 1;

        // <p><a id="delay-100"></a>Wait 100 ns for global reset to finish.</p>
        #100;


        $display("Applying vectors...\n");
        i = 0;
        errors = 0;

        // <p>Apply a stimulus vector</p>
        reset = 0;
        din = 16'h0001;
        irdy = 1;

        // <p>Wait 1 clock cycle for the values to propagate.</p>
        #20

        // <p>Apply more values.</p>
        din = 16'h0002;
        irdy = 0;

        #20
        din = 16'h0003;
        irdy = 0;

        // <p>Error check after the loop completes.</p>
        if (errors == 0) begin
            $display("PASS: All test vectors passed\n");
        end else begin
            $display("FAIL: %d errors occurred\n", errors);
        end
    end

endmodule

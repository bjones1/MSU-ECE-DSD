// <h1>An in-class exercise on datapaths</h1>
// <p>This module demonstrates various methods for adding three numbers.
// </p>
module adder_datapath(
    input clk,
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] y
);

// <h2>Simple solution</h2>
// <p>Comment out the following line to remove the simple solution from
//     this file. See <a
//         href="../verilog_standard_1364-2005.pdf#page=379">Compiler
//         directives</a>.</p>
`define SIMPLE
`ifdef SIMPLE
    // <p>The obvious approach to create an adder: just add everything
    //     together.
    assign y = a + b + c;

    // <p>Simulating this on the implemented design shows the
    //     worst-case delay:</p>
    // <figure class="image"><img src="adder-datapath-simple-sim.png" alt=""
    //         width="938" height="213">
    //     <figcaption>Figure 1: Post-implementation timing simulation of the
    //         simple adder.</figcaption>
    // </figure>
    // <p>However, the timing analysis shows that over half the delay comes
    //     from moving signals around the FPGA (net delay), not due to the
    //     time taken to add the numbers.</p>
    // <figure class="image"><img src="adder-datapath-simple-timing.png"
    //         alt="Timing results for a adder with no flip-flops"
    //         width="673" height="193">
    //     <figcaption>Table 1: Timing results from an adder with no
    //         sequential logic.</figcaption>
    // </figure>
    // <p>Note that the timing analysis shows a longer delay than the
    //     simulation &ndash; the simulation didn't happen to select
    //     worst-case inputs (such as a carry of every bit).</p>
`endif

// <h2>Register-based solution</h2>
// <p>Likewise -- comment out the following line to remove the registers
//     solution.</p>
//`define REGISTERS
`ifdef REGISTERS
    // <p>So, an obvious fix is to use registers to hold the inputs and
    //     outputs, reducing the net delay.</p>
    // <figure class="image"><img src="adder-datapath-registers.png"
    //         width="317" height="151">
    //     <figcaption>Figure 2: An adder with registers on the input and
    //         outputs.</figcaption>
    // </figure>
    reg [15:0] y;
    reg [15:0] aq, bq, cq;

    // <p>Include registers for the inputs. We don't need a reset, since this
    //     inputs will (eventually) overwrite them with correct values.</p>
    always @(posedge clk) begin
        aq <= a;
        bq <= b;
        cq <= c;
    end

    // <p>Compute the sum.</p>
    wire [15:0] sum;
    assign sum = aq + bq + cq;

    // <p>Then provide a register for the output.</p>
    always @(posedge clk) begin
        y <= sum;
    end

    // <p>This produces much better results:</p>
    // <figure class="image"><img src="adder-datapath-registers-timing.png"
    //         alt="" width="709" height="191">
    //     <figcaption>Table 2: Timing results when using registered at the
    //         inputs and outputs.</figcaption>
    // </figure>
    // <p>Now, the logic consumes about 60% of the total delay. However, the
    //     sum now requires several clock cycles to compute:</p>
    // <figure class="image"><img src="adder-datapath-registers-sim.png"
    //         alt="" width="567" height="307">
    //     <figcaption>Figure 3: Post-implementation timing simulation of the
    //         registered adder.</figcaption>
    // </figure>
`endif


endmodule

// <h1>An in-class exercise on datapaths with control</h1>
// <p>This module demonstrates adding three numbers from a single input.
//     The adder should:</p>
// <ol>
//     <li>Wait for <code>irdy</code> to be asserted.</li>
//     <li>Deassert <code>ordy</code>.</li>
//     <li>Add the values provided on <code>din</code> for the current
//         clock cycle and the next 2 clock cycles.</li>
//     <li>Output the sum on dout and assert <code>ordy</code>.</li>
// </ol>
module adder_datapath_control(
    input clk,
    input reset,
    input [15:0] din,
    input irdy,
    output reg [15:0] dout,
    output reg ordy
);

    // <h2>Datapath design</h2>
    // <p>To accomplish this, first design a datapath to add one number at a
    //     time:</p>
    // <figure class="image"><img src="adder-datapath-control-schematic.png"
    //         width="395" height="297">
    //     <figcaption>Figure 1: Schematic for the adder.</figcaption>
    // </figure>
    // <h2>Datapath implementation</h2>
    // <p>The mux and adder.</p>
    wire [15:0] Ad;
    reg set_ordy, clr_ordy, ldA, sel;
    assign Ad = sel ? dout + din : din;

    // <p>regA. Note that regA does not have a reset as we do not care about
    //     its value on power-up as it will be loaded with a value during the
    //     first computation.</p>
    always @(posedge clk) begin
        if (ldA) dout <= Ad;
    end

    // <p>The SR flip-flop. This has a reset, since its value must be 0 at
    //     power-up.</p>
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ordy <= 0;
        end else begin
            if (set_ordy) ordy <= 1;
            if (clr_ordy) ordy <= 0;
        end
    end

    // <h2>Control design</h2>
    // <p>To implement this design, the FSM is:</p>
    // <figure class="image"><img src="adder-datapath-control-fsm.svg">
    //     <figcaption>Figure 2: FSM to control the datapath.</figcaption>
    // </figure>
    // <h2>Control implementation</h2>
    // <p>Define the states.</p>
    // <!-- Render at http://viz-js.com/.
    // digraph datapath_fsm {
    //  rankdir = "LR";
    //  start [
    //      label = "INPUT_WAIT:\lset_ordy = 0\lclr_ordy = irdy\lldA = irdy\lsel = 0\l"
    //      shape = "doublecircle"
    //  ];
    //  sum1 [ label = "SUM1:\lset_ordy = 0\lclr_ordy = 0\lldA = 1\lsel = 1\l" ];
    //  start -> sum1 [ label = "irdy" ];
    //  start -> start [ label = "!irdy" ];
    //  sum2 [ label = "SUM2:\lset_ordy = 1\lclr_ordy = 0\lldA = 1\lsel = 1\l" ];
    //  sum1 -> sum2;
    //  sum2 -> start;
    // -->
`define STATE_INPUT_WAIT (2'b00)
`define STATE_SUM1       (2'b01)
`define STATE_SUM2       (2'b10)

    // <p>Define a two-bit flip-flop to store the state.</p>
    reg [1:0] pstate, nstate;
    always @(posedge clk or posedge reset) begin
        pstate <= reset ? `STATE_INPUT_WAIT : nstate;
    end

    // <p>Implement the FSM logic.</p>
    always @* begin
        case (pstate)
            `STATE_INPUT_WAIT: begin
                nstate = irdy ? `STATE_SUM1 : `STATE_INPUT_WAIT;
                set_ordy = 0;
                clr_ordy = irdy;
                ldA = irdy;
                sel = 0;
            end

            `STATE_SUM1: begin
                nstate = `STATE_SUM2;
                set_ordy = 0;
                clr_ordy = 0;
                ldA = 1;
                sel = 1;
            end

            `STATE_SUM2: begin
                nstate = `STATE_INPUT_WAIT;
                set_ordy = 1;
                clr_ordy = 0;
                ldA = 1;
                sel = 1;
            end
        endcase
    end
endmodule

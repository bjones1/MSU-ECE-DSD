`timescale 1ns / 1ps

// Tests the multiplier datapath FSM with generated vectors, sums results,
// displays on 7-seg display.
module hw_testbench (
    input logic board_clk,
    input logic [0:0] SW,
    output logic [2:0] LED,
    output logic [7:0] SSEG_CA,
    output logic [3:0] SSEG_AN
);

    logic reset;
    logic clk_50mhz, clk;
    logic debounceLoad;

    assign clk = clk_50mhz;

    assign LED[0] = reset;
    assign LED[1] = 1'b0;
    assign LED[2] = 1'b0;

    // generate a 50 MHz clk
    clk_wiz u0 (
        .clk_in1 (board_clk),
        .clk_out1(clk_50mhz)
    );

    // generate reset signal by synchronizing SW[0]
    logic swq1;
    always @(posedge clk) begin
        swq1  <= SW[0];
        reset <= swq1;
    end

    logic lfsr_ld;
    logic [15:0] lfsr_dout;

    logic [9:0] uut_dout;
    logic uut_irdy;
    logic uut_ordy;
    // high when vectors are done
    logic vectorsDone;

    // keeps track of number of test vectors generated
    logic [15:0] vector_count;
    logic [15:0] result_sum;
    // keeps track of our four states in UUT
    logic [1:0] state_counter;

    // load first three clock cycles
    assign lfsr_ld = (state_counter != 2'b11);
    // instantiate LSFR
    lfsr lfsr0 (
        .clk(clk),
        .ld(lfsr_ld),
        .reset(reset),
        .dout(lfsr_dout)
    );

    // instantiate UUT
    lab6dpath uut (
        .reset(reset),
        .clk  (clk),
        // irdy to datapath always asserted.
        .irdy (1'b1),
        .ordy (uut_ordy),
        .din  (lfsr_dout[9:0]),
        .dout (uut_dout)
    );
    // instantiate 7-seg display
    sevenseg sevenseg0 (
        .clk(clk),
        .reset(reset),
        .ld(vectorsDone),
        .din(result_sum),
        .dp(4'b1111),
        .SSEG_CA(SSEG_CA),
        .SSEG_AN(SSEG_AN)
    );

    // generate 1000 test vectors before stopping
    parameter NUM_VECTORS = 1000;

    assign vectorsDone = (vector_count == NUM_VECTORS);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            vector_count <= 0;
            result_sum <= 0;
            state_counter <= 0;
        end else begin
            if (uut_ordy && ~vectorsDone) vector_count <= vector_count + 1;
            // accumulate into 16-bit sum the 0 extended
            if (uut_ordy && ~vectorsDone) result_sum <= result_sum + {{6{1'b0}}, uut_dout};
            state_counter <= state_counter + 1;
        end
    end

endmodule

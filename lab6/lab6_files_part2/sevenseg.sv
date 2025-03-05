`timescale 1ns / 1ps
// # seven segment driver for Basys 3 board. Refreshes every 8 ms
module sevenseg (
    input logic clk,
    input logic reset,
    input logic ld,
    // 16-bit value to appear on display
    input logic [15:0] din,
    // four decimal points
    input logic [3:0] dp,
    output logic [7:0] SSEG_CA,
    output logic [3:0] SSEG_AN
);

    // input register
    logic [15:0] dinq;
    logic [ 3:0] dpq;

    // 2 bit counter for anode
    logic [ 1:0] anodeCounter;
    logic anondeChange;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dinq <= 0;
            dpq <= 0;
            anodeCounter <= 0;
        end else begin
            if (ld) begin
                dinq <= din;
                dpq  <= dp;
            end
            if (anondeChange) anodeCounter <= anodeCounter + 1;
        end
    end

    // switch between digits every 2ms, all four digits every 8 ms
    pulsegenMS #(
        .MSPERIOD(2)
    ) u0 (
        .clk  (clk),
        .pulse(anondeChange)
    );

    logic [3:0] digit;
    logic dpoint;

    // anode decode
    always_comb begin
        SSEG_AN = 4'b1111;
        digit   = dinq[3:0];
        case (anodeCounter)
            2'b00: begin
                SSEG_AN = 4'b1110;
                digit   = dinq[3:0];
                dpoint  = dpq[0];
            end
            2'b01: begin
                SSEG_AN = 4'b1101;
                digit   = dinq[7:4];
                dpoint  = dpq[1];
            end
            2'b10: begin
                SSEG_AN = 4'b1011;
                digit   = dinq[11:8];
                dpoint  = dpq[2];
            end
            2'b11: begin
                SSEG_AN = 4'b0111;
                digit   = dinq[15:12];
                dpoint  = dpq[3];
            end
        endcase
    end

    // cathode decode
    always_comb begin
        case (digit)
            0: SSEG_CA = {dpoint, 7'b1000000};
            1: SSEG_CA = {dpoint, 7'b1111001};
            2: SSEG_CA = {dpoint, 7'b0100100};
            3: SSEG_CA = {dpoint, 7'b0110000};
            4: SSEG_CA = {dpoint, 7'b0011001};
            5: SSEG_CA = {dpoint, 7'b0010010};
            6: SSEG_CA = {dpoint, 7'b0000010};
            7: SSEG_CA = {dpoint, 7'b1111000};
            8: SSEG_CA = {dpoint, 7'b0000000};
            9: SSEG_CA = {dpoint, 7'b0010000};
            10: SSEG_CA = {dpoint, 7'b0001000};
            11: SSEG_CA = {dpoint, 7'b0000011};
            12: SSEG_CA = {dpoint, 7'b1000110};
            13: SSEG_CA = {dpoint, 7'b0100001};
            14: SSEG_CA = {dpoint, 7'b0000110};
            15: SSEG_CA = {dpoint, 7'b0001110};
            default: SSEG_CA = 8'b11111111;
        endcase
    end

endmodule

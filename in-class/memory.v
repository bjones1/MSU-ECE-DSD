// <h1>An in-class exercise on datapaths</h1>
// <p>This module demonstrates various methods for adding three numbers.
// </p>
module basys_memory(
    input [15:0] SW,
    input [4:0] BTN,
    input CLK,
    output [15:0] LED
);

    wire [9:0] addra, addrb;
    assign addra = 9'h000; 
    assign addrb = 9'h000;
    wire en;
    assign en = 1'b1;
    mem blk_mem_gen_0(
        .dina(SW),
        .ena(ena),
        .wea(BTN[0]),
        .clka(CLK),
        .addra(addra),
        .clkb(CLK),
        .enb(en),
        .addrb(addrb),
        .doutb(LED)
    );
    
endmodule

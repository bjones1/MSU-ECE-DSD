// <h1>An in-class exercise on memory</h1>

// <p>Provide more readable names for the center/up/down/left/right gamepad
//     pushbutton buttons on the Basys-3 board.</p>
`define BTNC (BTN[4])
`define BTNU (BTN[0])
`define BTNL (BTN[1])
`define BTNR (BTN[2])
`define BTND (BTN[3])

// <p>This module asserts pressed for one cycle each time button is pressed. It
//     does not debounce button.</p>
module button_pulse(
    input button,
    input clk,
    output pressed
);
    // <p>Synchronize the pushbutton to the clock.</p>
    reg sync_button;
    always @(posedge clk) begin
        sync_button <= button;
    end

    // <p>Keep track of the current pushbutton state.</p>
    reg button_state = 1'b0;
    always @(posedge clk) begin
        button_state <= sync_button;
    end
    
    // <p>Assert pressed for one cycle when the button is pressed.</p>
    assign pressed = !button_state && sync_button;
endmodule


// <p>A module to increment or decrement a memory address, based on the
//     pushbuttons.</p>
module mem_addr(
    // <p>The button which increments the current address. It's not required to
    //     be syncronized to the clock.</p>
    input inc_button,
    // <p>The button which decrements the current address. It's not required to
    //     be syncronized to the clock.</p>
    input dec_button,
    input clk,
    // <p>Synchronous reset. This sets the address back to 0.</p>
    input reset,
    // <p>The current address.</p>
    output [9:0] addr,
    // <p>Asserted when the address increments or decrements.</p>
    output delta
);
    // <p>Process the inc and dec buttons.</p>
    wire addr_inc, addr_dec;
    button_pulse bp0(inc_button, clk, addr_inc);
    button_pulse bp1(dec_button, clk, addr_dec);
    
    // <p>Update the address based on reset/inc/dec.</p>
    reg [9:0] reg_addr = 10'h000;
    always @(posedge clk) begin
        if (reset) begin
            reg_addr <= 10'h000;
        end else if (addr_inc) begin
            reg_addr <= reg_addr + 1;
        end else if (addr_dec) begin
            reg_addr <= reg_addr - 1;
        end
    end

    // <p>Push internal state to outputs.</p>
    assign addr = reg_addr;
    assign delta = addr_inc | addr_dec;
endmodule


// <p>Root module: read/write memory on the Basys-3 board using the switches as
//     input and the pushbuttons as output. The gamepad pushbuttons allow
//     changing the read/write addresses.</p>
module basys_memory(
    // <p>Slide switches on the Basys-3 board.</p>
    input [15:0] SW,
    // <p>Gamepad pushbuttons on the Basys-3 board.</p>
    input [4:0] BTN,
    // <p>100 MHz clock provided by the Basys-3 board.</p>
    input CLK,
    // <p>LEDs on the Basys-3 board.</p>
    output [15:0] LED
);
    // <p>Use the center button for an async reset.</p>
    wire reset;
    button_pulse bp1(`BTNC, CLK, reset);
    
    // <p>Use the up/down buttons for the write address.</p>
    wire [9:0] waddr;
    wire do_write;
    mem_addr mem_addrw(`BTNU, `BTND, CLK, reset, waddr, do_write);
    
    // <p>Use the left/right buttons for the read address.</p>
    wire [9:0] raddr;
    wire do_read;
    mem_addr mem_addr(`BTNL, `BTNR, CLK, reset, raddr, do_read);
    
    // <p>Perform the read one cycle later:</p>
    // <ul>
    //     <li>On a write, do a read a cycle after the write, so that a write to
    //         the current address will be reflected one cycle later by the
    //         read.</li>
    //     <li>On a read, let the address update, then perform the read a cycle
    //         later, so that the data on the LEDs reflects a read of the
    //         address displayed on the <a
    //             href="https://digilent.com/reference/programmable-logic/basys-3/reference-manual#seven_segment_display">seven-segment
    //             display</a>.</li>
    // </ul>
    reg do_read_delayed = 1'b1;
    always @(posedge CLK) begin
        do_read_delayed <= do_read | do_write;
    end
    
    // <p>Connect memory in.</p>
    blk_mem_gen_0 mem(
        // <p>Write port.</p>
        .dina(SW),
        .ena(do_write),
        .wea(do_write),
        .clka(CLK),
        .addra(waddr),
        
        // <p>Read port.</p>
        .clkb(CLK),
        .enb(do_read_delayed0),
        .addrb(raddr),
        .doutb(LED)
    );
    
endmodule

// <h1>An in-class exercise on memory</h1>

// Provide more readable names for the center/up/down/left/right gamepad pushbutton buttons on the Basys-3 board. 
`define BTNC (BTN[4])
`define BTNU (BTN[0])
`define BTNL (BTN[1])
`define BTNR (BTN[2])
`define BTND (BTN[3])

// A module to debounce a pushbutton, emitting a single pulse on each button press.
module button_pulse(
    input button,
    input clk,
    output pressed
);
    // Synchronize the pushbutton to the clock.
    reg sync_button;
    always @(posedge clk) begin
        sync_button <= button;
    end

    // Keep track of the current pushbutton state.    
    reg button_state = 1'b0;
    always @(posedge clk) begin
        button_state <= sync_button;
    end
    
    // Assert pressed for one cycle when the button is pressed.
    assign pressed = !button_state && sync_button;
endmodule


// A module to increment or decrement a memory address, based on up and down buttons.
module mem_addr(
    // The button which increments the current address. It's not required to be syncronized clock.
    input inc_button,
    // The button which decrements the current address. It's not required to be syncronized clock.
    input dec_button,
    input clk,
    // Synchronous reset. This sets the address back to 0.
    input reset,
    // The current address.
    output [9:0] addr,
    // Asserted when the address increments or decrements.
    output delta
);
    // Debounce the inc and dec buttons.
    wire addr_inc, addr_dec;
    button_pulse bp0(inc_button, clk, addr_inc);
    button_pulse bp1(dec_button, clk, addr_dec);
    
    // Update the address based on reset/inc/dec.
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

    // Push internal state to outputs.
    assign addr = reg_addr;
    assign delta = addr_inc | addr_dec;
endmodule


// Root module: read/write memory on the Basys-3 board using the switches as input and the pushbuttons as output. The gamepad
// pushbuttons allow changing the read/write addresses.
module basys_memory(
    // Slide switches on the Basys-3 board.
    input [15:0] SW,
    // Gamepad pushbuttons on the Basys-3 board.
    input [4:0] BTN,
    // 100 MHz clock provided by the Basys-3 board.
    input CLK,
    // LEDs on the Basys-3 board.
    output [15:0] LED
);
    // Use the center button for an async reset.
    wire reset;
    button_pulse bp1(`BTNC, CLK, reset);
    
    // Use the up/down buttons for the write address.
    wire [9:0] waddr;
    wire do_write;
    mem_addr mem_addrw(`BTNU, `BTND, CLK, reset, waddr, do_write);
    
    // Use the left/right buttons for the read address.
    wire [9:0] raddr;
    wire do_read;
    mem_addr mem_addr(`BTNL, `BTNR, CLK, reset, raddr, do_read);
    
    // Connect memory in.
    blk_mem_gen_0 mem(
        // Write port.
        .dina(SW),
        .ena(do_write),
        .wea(do_write),
        .clka(CLK),
        .addra(waddr),
        
        // Read port.
        .clkb(CLK),
        .enb(1),
        .addrb(raddr),
        .doutb(LED)
    );
    
endmodule
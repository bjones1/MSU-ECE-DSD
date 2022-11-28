// <h1>An in-class exercise on a small microcontroller</h1>
//
// This microcontroller supports four opcode.
`define OP_LOAD (2'b00)
`define OP_STORE (2'b01)
`define OP_ADD (2'b10)
`define OP_SUB (2'b11)

module micro(
    input clk,
    input reset,
    output reg [7:0] pc,
    output reg [7:0] w,
    output reg [12:0] inst,
    output reg is_zero,
    output [7:0] a,
    output [7:0] b,
    output reg [7:0] d
);

    // Define the program counter.
    wire pc_ld;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Begin executing at memory location 0 after reset.
            pc <= 0;
        end else begin
            // If the current instruction doesn't load a new address in the pc, then move to the next instruction.
            pc <= pc_ld ? d : pc + 1;
        end
    end
    
    // Define the working register.
    wire w_ld;
    always @(posedge clk) begin
        w <= w_ld ? d : w;
    end
    
    // Instantiate program memory.
    always @* begin
        case (pc)
            //                op pc/w cond m/l addr
            // ; if (a == b) {
            // 00: load a, w  ; a is in memory location 0.
            8'd00: inst = 13'b00_0____0____1___00000000;
            // 01: sub b, w   ; b is in memory location 1.
            8'd01: inst = 13'b11_0____0____1___00000001; 
            // 02: load if Z, if_body, pc  ; if_body @ mem 2.
            8'd02: inst = 13'b00_1____1____1___00000010; 
            // 03: load else_body, pc ; else_body @ mem 3.
            8'd03: inst = 13'b00_1____0____1___00000011; 
            //   ; ++a;
            //   if_body:
            //   04: load a, w   ; a @ mem loc 0
            8'd04: inst = 13'b0;
            //   05: add one, w  ; one @ mem loc 4
            8'd05: inst = 13'b0;
            //   06: store w, a  ; a @ mem loc 0.
            8'd06: inst = 13'b0;
            //   07: load if_end, pc  ; if_end @ mem loc 5.
            8'd07: inst = 13'b0;
            // ; } else {
            //   ; ++b;
            //   else_body:
            //   08: load one, w  ; one @ mem loc 4.
            8'd08: inst = 13'b0;
            //   09: sub one, w  ; b @ mem loc 1,
            8'd09: inst = 13'b1;
            //   10: store w, b  ; b @ mem loc 1.
            8'd10: inst = 13'b0;
            // ; }
            // if_end:
            // ; Load a and b into W to show their final values.
            // 11: load a, w
            8'd11: inst = 13'b0;
            // 12: load b, w
            8'd12: inst = 13'b0;
            // loop_forever: goto loop_forever;
            // 11: load pc, loop_forever  ; loop_forever @ mem loc 6.
            8'd13: inst = 13'b0;
        endcase
    end
    
    // Instiantiate data memory.
    reg [7:0] data_mem [7:0];
    initial begin
        // Mem location 0: variable a, inital valu 10.
        data_mem[0] = 8'd10;
        // Mem loc 1: variable b.
        data_mem[1] = 8'd9;
    end
    // Perform an async read.
    wire mem_lit;
    assign a = mem_lit ? data_mem[inst[2:0]] : inst[7:0];
    wire mem_wr;
    // Perform a sync write.
    always @(posedge clk) begin
        if (mem_wr) begin
            data_mem[inst[7:0]] <= d;
        end
    end
    
    // Define control signals
    //
    // The opcode in this instruction
    wire [1:0] op;
    assign op = inst[12:11];
    // True if the source/dest is the PC; false if the source/dest is the working register.
    wire pc_w_;
    assign pc_w_ = inst[10];
    // True if this instruction should be executed conditionally; false if it should always be executed.
    wire cond;
    assign cond = ????;
    // True if the addr field is an address; false if it's a literal value.
    assign mem_lit = ????;
    // True is this is a store instruction; false otherwise.
    wire is_store;
    assign is_store = ???;
    // True if a value should be written to PC, W, or memory. This means the current instruction should be executed.
    wire do_write;
    assign do_write = ???;
    // True when one of the load signals (for PC, W, or memory) should be asserted.
    wire do_ld = ???;
    // True to load the PC (program counter).
    assign pc_ld = ???;
    // True to load the working register.
    assign w_ld = ???;
    // True to write to memory.
    assign mem_wr = ???; 
    
    // Define the ALU.
    assign b = pc_w_ ? pc : w;
    always @* begin
        case (op)
            // The value to load comes from memory, on input a.
            `OP_LOAD: d = a;
            // The value to store is PC/W, on input b.
            `OP_STORE: d = ???;
            `OP_ADD: d = ???;
            `OP_SUB: d = ???;
        endcase   
    end
    
    // Define the is_zero bit: it's true if the last value written to PC or W was zero.
    always @(posedge clk) begin
        is_zero <= ???;
    end

endmodule

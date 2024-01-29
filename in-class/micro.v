// # An in-class exercise on a small microcontroller
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
            // If the current instruction doesn't load a new address in the pc,
            // then move to the next instruction.
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
            // ; if (a == b) { 00: load a, w ; Address is a (memory location 0)
            // op pc/w cond m/l addr/lit
            8'd00: inst = 13'b00____0____0___1_00000000;
            // 01: sub b, w ; Address is b (memory location 1).
            8'd01: inst = 13'b11____0____0___1_00000001; 
            // 02: load if Z, if_body, pc ; Literal is if_body (instruction 04)
            8'd02: inst = 13'b00____1____1___0_00000100; 
            // 03: load else_body, pc ; Literal is else_body (instruction 08)
            8'd03: inst = 13'b00____1____0___0_00001000; 
            // ; ++a; if_body: 04: load a, w ; Address is a (memory location 0)
            8'd04: inst = 13'b00____0____0___1_00000000;
            // 05: add #1, w ; Literal is 1.
            8'd05: inst = 13'b10____0____0___0_00000001;
            // 06: store w, a ; Address is a (memory location 0)
            8'd06: inst = 13'b01____0____0___1_00000000;
            // 07: load if_end, pc ; Literal is if_end (instruction 11)
            8'd07: inst = 13'b00____1____0___0_00001011;
            // ; } else { ; ++b; else_body: 08: load #1, w ; Literal is 1.
            8'd08: inst = 13'b00____0____0___0_00000001;
            // 09: sub b, w ; Address is b (memory location 1).
            8'd09: inst = 13'b11____0____0___1_00000001;
            // 10: store w, b ; Address is b (memory location 1).
            8'd10: inst = 13'b01____0____0___1_00000001;
            // ; } if_end: ; Load a and b into W to show their final values. 11:
            // load a, w ; Address is a (memory location 0)
            8'd11: inst = 13'b00____0____0___1_00000000;
            // 12: load b, w ; Address is b (memory location 1)
            8'd12: inst = 13'b00____0____0___1_00000001;
            // loop_forever: goto loop_forever; 13: load pc, loop_forever ;
            // Literal is loop_forever (instruction 13).
            8'd13: inst = 13'b00____1____0___0_00001101;
            // For any other address, return a junk instruction.
            default: inst = 13'b0;
        endcase
    end
    
    // Instiantiate data memory.
    reg [7:0] data_mem [1:0];
    initial begin
        // Mem location 0: variable a, initial value is 10.
        data_mem[0] = 8'd10;
        // Mem loc 1: variable b, initial value is 9.
        data_mem[1] = 8'd9;
        // Everything else: fill with 0s.
        data_mem[2] = 0;
        data_mem[3] = 0;
    end
    // Perform an async read.
    wire mem_lit;
    assign a = mem_lit ? data_mem[inst[1:0]] : inst[7:0];
    wire mem_wr;
    // Perform a sync write.
    always @(posedge clk) begin
        if (mem_wr) begin
            data_mem[inst[2:0]] <= d;
        end
    end
    
    // Define control signals
    //
    // The opcode in this instruction
    wire [1:0] op;
    assign op = inst[12:11];
    // True if the source/dest is the PC; false if the source/dest is the
    // working register.
    wire pc_w_;
    assign pc_w_ = inst[10];
    // True if this instruction should be executed conditionally; false if it
    // should always be executed.
    wire cond;
    assign cond = inst[9];
    // True if the addr field is an address; false if it's a literal value.
    assign mem_lit = inst[8];
    // True is this is a store instruction; false otherwise.
    wire is_store;
    assign is_store = op == `OP_STORE;
    // True if a value should be written to PC, W, or memory. This means the
    // current instruction should be executed.
    wire do_write;
    assign do_write = !cond | is_zero;
    // True when one of the load signals (for PC, W, or memory) should be
    // asserted.
    wire do_ld = !is_store & do_write;
    // True to load the PC (program counter).
    assign pc_ld = do_ld & pc_w_;
    // True to load the working register.
    assign w_ld = do_ld & !pc_w_;
    // True to write to memory.
    assign mem_wr = is_store & do_write; 
    
    // Define the ALU.
    assign b = pc_w_ ? pc : w;
    always @* begin
        case (op)
            // The value to load comes from memory, on input a.
            `OP_LOAD: d = a;
            // The value to store is PC/W, on input b.
            `OP_STORE: d = b;
            `OP_ADD: d = a + b;
            `OP_SUB: d = a - b;
        endcase   
    end
    
    // Define the is_zero bit: it's true if the last value written to PC or W
    // was zero.
    always @(posedge clk) begin
        is_zero <= do_ld ? d == 0 : is_zero;
    end

endmodule

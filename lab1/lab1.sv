// # `lab1.v` - design source for lab 1
//
// See the lab instructions to use this file for simulation and for programming
// the Basys 3 board.
//
// This is a design source file, which means that all the "software" in this
// file will be synthesized into hardware, so that it can then be programmed on
// the FPGA. Therefore, make sure you understand what hardware lies behind each
// line of "code". In contrast, the simulation source file
// <code><a href="tb_lab1.v">tb_lab1.v</a></code> will not by synthesized, and
// can contain code that's not synthesizable.

// A Verilog [module](https://www.chipverify.com/verilog/verilog-modules)
// defines a component in a typical schematic.
// [Ports](https://www.chipverify.com/verilog/verilog-ports), which consist of
// inputs and/or outputs, allow the module to connect to external devices. The
// top-level module in a Xilinx design connects directly to pins on the FPGA;
// the <code><a href="Basys3_Master.xdc">Basys3_Master.xdc</a></code> file maps
// these names (`LED` and `SW`) to physical pins on the FPGA.
module lab1(
    // This defines outputs from the module: an array of 8 wires. (All ports are
    // wires by default).
    output logic [7:0] LED,
    // This defines inputs to the module, also an array of 8 wires.
    input logic [7:0] SW
);

    // The [assign](https://www.chipverify.com/verilog/verilog-assign-statement)
    // statement makes a wire-like connection. In this case, it connects the
    // first 8 switches to the first 8 LEDs. SW0 is the right-most switch on the
    // Basys 3 board; the order is right to left. The equivalent schematic is:
    //
    // ![](lab1_assign_schematic.png)
    assign LED = SW;

// Every module must contain this statement.
endmodule

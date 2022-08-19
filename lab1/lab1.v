// <h1><code>lab1.v</code> - design source for lab 1</h1>
// <p>See the lab instructions to use this file for simulation and for
//     programming the Basys 3 board.</p>
// <p>This is a design source file, which means that all the "software"
//     in this file will be synthesized into hardware, so that it can
//     then be programmed on the FPGA. Therefore, make sure you
//     understand what hardware lies behind each line of "code". In
//     contrast, the simulation source file <code><a
//             href="tb_lab1.v.html">tb_lab1.v</a></code> will not by
//     synthesized, and can contain code that's not synthesizable.</p>

// <p>A Verilog <a
//         href="https://www.chipverify.com/verilog/verilog-modules">module</a>
//     defines a component in a typical schematic. <a
//         href="https://www.chipverify.com/verilog/verilog-ports">Ports</a>,
//     which consist of inputs and/or outputs, allow the module to
//     connect to external devices. The top-level module in a Xilinx
//     design connects directly to pins on the FPGA; the <code><a
//             href="Basys3_Master.xdc.html">Basys3_Master.xdc</a></code>&nbsp;file
//     maps these names (<code>LED</code> and <code>SW</code>) to
//     physical pins on the FPGA.&nbsp;</p>
module lab1(
    // <p>This defines outputs from the module: an array of 8 wires. (All
    //     ports are wires by default).</p>
    output [7:0] LED,
    // <p>This defines inputs to the module, also an array of 8 wires.</p>
    input [7:0] SW
);

// <p>The <a
//         href="https://www.chipverify.com/verilog/verilog-assign-statement">assign</a>
//     statement makes a wire-like connection. In this case, it connects
//     the first 8 switches to the first 8 LEDs. SW0 is the right-most
//     switch on the Basys 3 board; the order is right to left.</p>
assign LED = SW;

// <p>Every module must contain this statement.</p>
endmodule

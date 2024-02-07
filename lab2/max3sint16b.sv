// # `max3sint16b.v` - Output the maximum of three signed, 16-bit inputs
//
// ## Procedure
//
// 1.  Use the template file from Lab 1, and this Verilog design file and the
//     associated testbench `tb_max3sint16b.v` to the project. You do not have
//     to add a constraints file. Also copy the test vector file
//     `max3sint16b_vectors.txt` into the same directory as your project.
// 2.  This [YouTube video](http://youtu.be/mN_34Ugtmlw) discusses this design.
//     The Verilog file has errors, and the video shows how to find the errors
//     and correct them. Repeat the steps in this video with your project.  As
//     you progress in the video, answer the questions in the `lab2_report.docx`
//     file. This report file also has you capture some screen shots as well.
// 3.  To capture screenshots, only capture the relevant portion of the screen,
//     do not just capture the entire screen. There are several utilities that
//     can do that, including the built-in Windows 10 Snip & sketch tool.
//
// ## Design overview
//
// This implements the following schematic:
//
// ![](max3.png)
module max3sint16b(
    input logic signed [15:0] a,
    input logic signed [15:0] b,
    input logic signed [15:0] c,
    output logic signed [15:0] y
)

    logic u1_lt;
    assign u1_lt = (a < b);

    logic max_ab;
    assign max_ab = u1_lt ? b : a;

    logic u2_lt;
    assign u2_lt = (c < max_ab)

    assign max = u2_lt ? c : max_ab;
endmodule

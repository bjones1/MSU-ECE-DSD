// <h1>Lab 5</h1>
// <p>Complete this Verilog module so that it implements the following
//     schematic:</p>
// <figure class="image"><img src="lab5datapath.png"
//         alt="A 12x12 multiplier and summer">
//     <figcaption>Figure 1: Schematic to implement.</figcaption>
// </figure>
// <p>Busses <code>k1</code>, <code>k2</code>, <code>k3</code> are the
//     following constants:</p>
// <table style="border-collapse: collapse;" border="1">
//     <tbody>
//         <tr>
//             <td>Constant</td>
//             <td>12-bit value in hex</td>
//             <td>Value in decimal (in 1.11 fixed point)</td>
//         </tr>
//         <tr>
//             <td><code>k1</code></td>
//             <td>C00</td>
//             <td>-0.5</td>
//         </tr>
//         <tr>
//             <td><code>k2</code></td>
//             <td>500</td>
//             <td>0.625</td>
//         </tr>
//         <tr>
//             <td><code>k3</code></td>
//             <td>C00</td>
//             <td>-0.5</td>
//         </tr>
//     </tbody>
// </table>
module lab5dpath(
    input clk,
	input signed [9:0] x1,
	input signed [9:0] x2,
	input signed [9:0] x3,
	output signed [9:0] y
);

endmodule

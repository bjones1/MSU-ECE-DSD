// <h1><code>satadd.v</code> - A Verilog module implementing lab 3, an
//     (optionally) saturating adder.</h1>
module satadd(
    // <p>The <a href="https://en.wiktionary.org/wiki/addend" target="_blank"
    //         rel="noopener">addends</a>.</p>
    input [11:0] a,
    input [11:0] b,
    // <p>Adder mode:</p>
    // <table style="border-collapse: collapse;" border="1">
    //     <tbody>
    //         <tr>
    //             <td>Mode Input</td>
    //             <td>Output function</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b00</code></td>
    //             <td>y = a + b (unsigned saturation)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b01</code></td>
    //             <td>y = a + b (signed saturation)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b10</code></td>
    //             <td>y = a + b (normal addition)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b11</code></td>
    //             <td>y = a + b (normal addition)</td>
    //         </tr>
    //     </tbody>
    // </table>
    input [1:0] mode,
    // <p>The resulting sum.</p>
    output [11:0] y
);

// <h2>Implementation Guidance</h2>
// <ol>
//     <li><span style="color: red;">All of this logic must be
//             implemented using assign statements; you may not use
//             <code>always</code> blocks/sequential statements.</span>
//     </li>
//     <li>Note the inputs of the adder are 12 bits wide, while the
//         output is 13 bits wide. Bit <code>r[11]</code> of the adder
//         output is the sign of the output value, while bit
//         <code>r[12]</code> is the carry out (Cout). If the carry out
//         is 1, then unsigned overflow occurred.</li>
//     <li>The <code>vFlag</code> internal signal is 1 if a two's
//         complement overflow occurs. This is true if the sum of two
//         positive numbers produces a negative number or if the sum of
//         two negative numbers produces a positive number. The signs of
//         the two inputs (<code>a[11]</code>, <code>b[11]</code>) are
//         represented by the signals <code>aSign</code>,
//         <code>bSign</code> and the sign of the result
//         (<code>r[11]</code>) by <code>rSign</code>.</li>
// </ol>
// <figure class="image"><img title="Figure 1. Suggested architecture"
//         src="suggested-architecture.png"
//         alt="A schematic showing the suggested architecture for this module.">
//     <figcaption>Figure 1: Suggested architecture.</figcaption>
// </figure>

endmodule

// <p><code>satadd.v</code> - A Verilog module implementing lab 3, an
//     (optionally) saturating adder.</p>
module satadd(
    // <p>The addends</p>
    input [11:0] a,
    input [11:0] b,
    // <p>Adder mode:</p>
    // <table
    //     style="border-collapse: collapse; width: 18.3187%; height: 90px;"
    //     border="1">
    //     <colgroup>
    //         <col style="width: 32.2581%;">
    //         <col style="width: 67.7419%;">
    //     </colgroup>
    //     <tbody>
    //         <tr>
    //             <td>Mode Input</td>
    //             <td>Output function</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b00</code></td>
    //             <td>y = a + b &nbsp; (unsigned saturation)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b01</code></td>
    //             <td>y = a + b &nbsp; (signed saturation)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b10</code></td>
    //             <td>y = a + b &nbsp; (normal addition)</td>
    //         </tr>
    //         <tr>
    //             <td><code>mode = 2'b11</code></td>
    //             <td>y = a + b &nbsp; (normal addition)</td>
    //         </tr>
    //     </tbody>
    // </table>
    input [1:0] mode,
    // <p>The resulting sum.</p>
    output [11:0] y
);

endmodule

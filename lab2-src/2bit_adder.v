`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2024 09:47:25
// Design Name: 
// Module Name: 2bit_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_2bits_adder(
    input [1:0] A,
    input [1:0] B,
    input C0,
    output [1:0] S,
    output C2
    );
    
    wire C1;
    
    my_1bit_adder adder_A (A[0], B[0], C0, S[0], C1);
    my_1bit_adder adder_B (A[1], B[1], C1, S[1], C2);
endmodule

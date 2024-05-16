`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2024 10:00:33
// Design Name: 
// Module Name: my_4bits_adder
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


module my_4bits_adder(
    input [3:0] A,
    input [3:0] B,
    input C0,
    output [3:0] S,
    output C3  
    );
    
    wire C1,C2;
    
    my_2bits_adder adder1 (A[1:0], B[1:0], C0, S[1:0], C1);
    my_1bit_adder adder2 (A[2], B[2], C1, S[2], C2);
    my_1bit_adder adder3 (A[3], B[3], C2, S[3], C3);
endmodule

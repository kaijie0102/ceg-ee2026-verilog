`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2024 09:33:40
// Design Name: 
// Module Name: lab_1_adders
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
//    output [0:0] C

module my_1bit_adder(
    input A, B, CIN, output S, COUT
    );
    
    assign S = A ^ B ^ CIN;
    assign COUT = (A & B) | (CIN & (A ^ B)); 
    
endmodule
                    
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2024 12:55:36
// Design Name: 
// Module Name: four_bits_adder
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


module four_bits_adder(
    input [3:0] first_bin,
    input [3:0] second_bin,
    output [3:0] S,
    output cout   
    );
    
    wire c1, c2, c3;
    
    full_adder f0(.a(first_bin[0]), .b(second_bin[0]), .cin(0), .cout(c1), .s(S[0]) ); // no cin so cin=0
    full_adder f1(.a(first_bin[1]), .b(second_bin[1]), .cin(c1), .cout(c2), .s(S[1]) );
    full_adder f2(.a(first_bin[2]), .b(second_bin[2]), .cin(c2), .cout(c3), .s(S[2]) );
    full_adder f3(.a(first_bin[3]), .b(second_bin[3]), .cin(c3), .cout(cout), .s(S[3]) );
    
    
endmodule



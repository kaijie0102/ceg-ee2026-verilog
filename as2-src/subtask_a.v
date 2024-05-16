`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2024 15:57:55
// Design Name: 
// Module Name: seven_bits_adder_subtaskA
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


module seven_bits_adder_subtaskA(
    input [6:0] a,
    input [6:0] b,
    output [6:0] s
    );
    
    wire c1;
    
    // Four bits adder for LSB
    four_bits_adder four_add(.first_bin(a[3:0]), .second_bin(b[3:0]), .S(s[3:0]), .cout(c1));
    
    // Three bits adder for MSB
    three_bits_adder three_add(.first_bin(a[6:4]), .second_bin(b[6:4]), .cin(c1), .S(s[6:4]));
    
    
    
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2024 10:26:21
// Design Name: 
// Module Name: init
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


module init(
    input [6:0]swA, [6:0]swB,
    input btnR,
    output [6:0]ledS, [3:0]ledT,
    output [3:0] an,
    output [6:0] seg
    );
    
    
    // second right most digit: 6
    assign an[3:0] = 4'b0000; // anodes are active low, 0 is high
    assign seg[6:0] = 7'b0110111; // make d and g low for pd to form
    
    // subtask B
    assign ledT[3:0] = btnR ? 4'b1111 : 4'b0000;
    
    // subtask C    
    wire [6:0] DR;
        
    seven_bits_adder_subtaskA adder(.a(swA), .b(swB), .s(DR));
    assign ledS[6:4] = DR[6:4];
    assign ledS[3:0] = ~DR[3:0];
//    assign ledS[3] = ~DR[3];
    //assign ledS = 7'b1111111; 
    
    
    
    
endmodule

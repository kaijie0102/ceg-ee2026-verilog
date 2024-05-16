`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 06:58:09
// Design Name: 
// Module Name: clk6p25m
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


module clk6p25m(
    input clk, output reg clk6p25_bit = 0
    );
    
    // 16x6.25 = 100M flip every 8 cycles
    reg [3:0]counter_4bits = 1;
    
    always @(posedge clk)
    begin
        counter_4bits <= (counter_4bits == 8 - 1) ? 0 : counter_4bits + 1;
        
        clk6p25_bit <= (counter_4bits == 0) ? ~clk6p25_bit : clk6p25_bit;
    end
endmodule
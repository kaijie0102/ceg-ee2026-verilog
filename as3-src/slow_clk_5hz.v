`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 09:20:59
// Design Name: 
// Module Name: slow_clk_5hz
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


module slow_clk_5hz(
    input clk,
    output reg slow_clk5 = 0
    );
    
    // 24-bits counter for 5Hz: 100MHz -> 5Hz --> 20M cycles --> flip every 10M cycles
    reg [23:0]counter_24bits = 1;
    
    always @(posedge clk)
    begin
        counter_24bits <= (counter_24bits == 10_000_000 - 1 ) ? 0: counter_24bits + 1;
        
        slow_clk5 <= (counter_24bits  == 0) ? ~slow_clk5 : slow_clk5;
    end 
endmodule

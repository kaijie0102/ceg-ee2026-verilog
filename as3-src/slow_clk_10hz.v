`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 10:32:04
// Design Name: 
// Module Name: slow_clk_10hz
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

// 100MHz -> 10 Hz => 10M --> flip every 5M 
module slow_clk_10hz(
    input clk, output reg slow_clk10 = 0
    );
    
    // 23 bits counter
    reg [22:0]counter_23bits = 1;
    
    always @(posedge clk)
    begin
        counter_23bits <= (counter_23bits == 5_000_000 - 1) ? 0 : counter_23bits + 1;
        
        slow_clk10 <= (counter_23bits == 0) ? ~slow_clk10 : slow_clk10; 
    end
endmodule

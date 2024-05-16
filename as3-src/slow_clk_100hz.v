`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 10:32:04
// Design Name: 
// Module Name: slow_clk_100hz
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

// 100MHz -> 100Hz => 1M cycles => flip every 500k cycles
module slow_clk_100hz(
    input clk, output reg slow_clk100 = 0
    );
    
    // 19bits counter
    reg [18:0]counter_19bits = 1;
    
    always @(posedge clk)
    begin
        counter_19bits <= (counter_19bits == 500_000 - 1) ? 0 : counter_19bits + 1;
        
        slow_clk100 <= (counter_19bits == 0 ) ? ~slow_clk100 : slow_clk100;
    end
endmodule

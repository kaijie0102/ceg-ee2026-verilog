`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 10:32:04
// Design Name: 
// Module Name: slow_clk_1hz
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

// 100MHz -> 1Hz --> 100M cycles --> 50M cycle flip
module slow_clk_1hz(
    input clk, output reg slow_clk1 = 0
    );
    
    // 50M cycle --> 26 bits
    reg [25:0]counter_26bits = 1;
    
    always @(posedge clk)
    begin
        counter_26bits <= (counter_26bits == 50_000_000 - 1) ? 0 : counter_26bits + 1;
        
        slow_clk1 <= (counter_26bits == 0) ? ~slow_clk1 : slow_clk1;
    end
endmodule

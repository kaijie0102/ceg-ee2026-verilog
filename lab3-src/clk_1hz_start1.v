`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2024 22:49:05
// Design Name: 
// Module Name: clk_1hz_start1
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

// 100MHz -> 1Hz: 100 000 000 beats -> 50 000 000 counts
module clk_1hz_start1(
    input clk,
    output reg slow_clk = 1
    );
    
    // 26 bits counter 
    reg [25:0]counter_26bits = 1;
    
    always @(posedge clk)
    begin
        counter_26bits <= (counter_26bits == 50000000) ? 0 : counter_26bits + 1;
        
        slow_clk <= (counter_26bits == 0) ? ~slow_clk : slow_clk;
    end
endmodule

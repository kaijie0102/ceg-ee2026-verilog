`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2024 19:09:15
// Design Name: 
// Module Name: slow_clk_3s
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


module slow_clk_3s(
    input clk, output reg slow_clk3s = 0
    );
    
    // 150M cycle --> 30 bits
    reg [29:0]counter_30bits = 1;
    
    always @(posedge clk)
    begin
        counter_30bits <= (counter_30bits == 150_000_000 - 1) ? 0 : counter_30bits + 1;
        
        slow_clk3s <= (counter_30bits == 0) ? ~slow_clk3s : slow_clk3s;
    end
endmodule

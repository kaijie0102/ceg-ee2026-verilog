`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 10:20:58
// Design Name: 
// Module Name: clk_20hz
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


module clk_20hz(
    input clk,
    output reg slow_clk = 0
    );
    
    // 20 Hz: Period = 5,000,000 * 10ns  = 2,500,000 counts to invert
    reg [21:0] count = 0;
    
    always @(posedge clk)
    begin
    
        count <= (count == 2_500_000-1) ? 0 : count + 1;
        
        slow_clk <= (count == 0) ? ~slow_clk : slow_clk;
    end
    
endmodule

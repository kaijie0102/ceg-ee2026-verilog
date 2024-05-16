`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 10:20:58
// Design Name: 
// Module Name: clk_5hz
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


module clk_5hz(
    input clk,
    output reg slow_clk = 0
    );
    
    // 5 Hz = 20 000 000 counts for a period -> 10 000 000 counts to invert
    reg [23:0] count = 24'b0000_0000_0000_0000_0000_0001;
    
    always @(posedge clk)
    begin
        count <= (count == 10000000) ? 0 : count + 1;
        slow_clk <= (count == 0) ? ~slow_clk : slow_clk;
    end
endmodule

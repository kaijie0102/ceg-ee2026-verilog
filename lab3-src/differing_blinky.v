`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 10:19:38
// Design Name: 
// Module Name: differing_blinky
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


module differing_blinky(
    input clk,
    input [2:0] sw,
    output reg [15:15] led = 0
    );
    
    clk_1hz clk1(clk, slow_clk1);
    clk_5hz clk2(clk, slow_clk5);
    clk_20hz clk3(clk, slow_clk20);
    
    always @(posedge clk)
    begin
        if (sw == 3'b000)
            led[15] = 0;
        else if (sw == 3'b001)
            led[15]= slow_clk20;
        else if (sw == 3'b011)
            led[15] = slow_clk5;
        else if (sw == 3'b111)
            led[15] = slow_clk1;
            
            
    end
endmodule

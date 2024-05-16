`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 09:38:57
// Design Name: 
// Module Name: slow_blinky
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


module slow_blinky(
    input clk,
    output reg slow_clk = 0
    );
    
    reg [3:0] count = 4'b0000;
    
    // posedge refers to rising edge of clock signal
    always @(posedge clk)
    begin
//        count <= count + 1; // deferred assignment: only executed after "end" is hit
        
        count <= (count == 4'b1000) ? 0 : count + 1; // force to 0 at 8th count
        
        // slow_clk is inverted everytime an overflow happens from 1111(15) to 0000(0)
        // 1 period fast = 10ns -> 1 period slow = 320ns = 3.125 MHz 
        slow_clk <= (count == 4'b0000) ? ~slow_clk : slow_clk;  
    end
    
   
endmodule

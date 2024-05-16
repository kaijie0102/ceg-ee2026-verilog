`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 10:20:58
// Design Name: 
// Module Name: clk_1hz
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


// 1 Hz = (100 MHz / 100,000,000) -> invert every 50,000,000 counts
module clk_1hz(
    input clk,
    output reg slow_clk = 0
//    output reg [0:0] led
    );
   
    reg [25:0] count = 0;
    
    
    always @(posedge clk)
    begin
        count <= (count == 50000000-1) ? 0 : count + 1;
        
        slow_clk <= (count == 0) ? ~slow_clk : slow_clk;
//        led[0] <= slow_clk;
    end
    
endmodule

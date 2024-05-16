`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 10:21:28
// Design Name: 
// Module Name: initialise_subtaskD
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


module initialise_subtaskD(
input notReset,
    input clk,
    input [15:0] sw,
    input btnC,
    output reg DTrigger
    );
    
    wire clk_6p25;
    slow_clock clock_25M(clk, 8, clk_6p25);
    reg isJustTriggered = 0;
    always @ (posedge clk_6p25)
    begin
        //reset values when switch turns off
        if (sw[4] == 0)
        begin
            DTrigger = 0;
            isJustTriggered = 0;
        end
        
        //when reset and button not pressed
        if (notReset == 0 && isJustTriggered == 0 && btnC == 0)
        begin
            DTrigger = 0;
        end
        
        //when reset and button pressed
        else if (notReset == 0 && isJustTriggered == 0 && btnC == 1)
        begin
            DTrigger = 1;
            isJustTriggered = 1;
        end
        
    end
endmodule

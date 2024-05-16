`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 04:25:15
// Design Name: 
// Module Name: subtask_4pA3_timer
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


module subtask_4pA3_timer(
    input clk,
    input [15:0] sw,
    input BTNC,
    input BTND,
    output reg [2:0] x,
    output reg shapeTrigger = 0,
    output reg [2:0] shapeState = 0, //0 - no shape, 1:3 - different shapes
    output reg isOrangeBorder = 0
    );
    
    reg [31:0] count1 = 0;
    reg [31:0] count2 = 0;
    reg [31:0] debouncer_count = 0;
    
    always@ (posedge clk)
    begin

    
        if (BTNC == 1)
            isOrangeBorder <= 1;
        else if (sw[1] == 0) //reset if sw turns off
        begin
            isOrangeBorder <= 0;
            shapeState = 0;
        end
        
        if (isOrangeBorder == 1) //counter for green borders to appear
         begin
            count1 <= (count1 == 550000000) ? 0 : count1 + 1;
            if (count1 == 200000000)
                x <= 1;
            if (count1 == 350000000)
                x <= 2;
            if (count1 == 450000000)
                x <= 3;
            if (count1 == 550000000)
                x <= 0;
        end else
        begin
            count1 <= 0;
            x <= 0;
        end
        
        //when down button is pressed, change shape
        if (BTND)
        begin
            shapeTrigger <= 1;     
        end
            
        
        if (shapeTrigger == 1)
        begin
            if (debouncer_count < 20000000)
            begin
                debouncer_count <= debouncer_count + 1;
            end else
            begin
                debouncer_count <= 0;
                shapeTrigger <= 0;
                if (isOrangeBorder == 1)
                    shapeState <= (shapeState == 3) ? 1 : shapeState + 1;
            end
        end
        
    end


endmodule

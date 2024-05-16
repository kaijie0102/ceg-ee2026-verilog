`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2024 16:17:40
// Design Name: 
// Module Name: moving_blinky
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


module moving_blinky(
    input clk,
    output reg [3:0] led = 0
    );
    reg [1:0] count_up_1hz = 0;
    
    clk_1hz counter_1hz(clk, clock_1hz); 
    always @(posedge clock_1hz)
    begin
        count_up_1hz <= count_up_1hz + 1;
    end
    
    always @(posedge clk)
    begin
        if (count_up_1hz == 2'b00)
            led[3:0] = 4'b0001;
        else if (count_up_1hz == 2'b01)
            led[3:0] = 4'b0010;
        else if (count_up_1hz == 2'b10)
            led[3:0] = 4'b0100;
        else if (count_up_1hz == 2'b11)
            led[3:0] = 4'b1000;
    end
endmodule

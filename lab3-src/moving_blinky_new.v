`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2024 17:43:52
// Design Name: 
// Module Name: moving_blinky_sim
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


module moving_blinky_new(
    input clk, output reg [3:0]led = 4'b0001
    );
    
    reg [1:0] increment_counter = -1;
    
    clk_1hz counter_1hz(clk, clock_1hz);
    
    always @(posedge clock_1hz)
    begin
        increment_counter <= increment_counter + 1;
    end
    
    always @(posedge clk)
    begin
        if (increment_counter == 2'b00)
            led[3:0] <= 4'b0001;
        else if (increment_counter == 2'b01)
            led[3:0] <= 4'b0010;
        else if (increment_counter == 2'b10)
            led[3:0] <= 4'b0100;
        else if (increment_counter == 2'b11)
            led[3:0] <= 4'b1000;
    end
endmodule

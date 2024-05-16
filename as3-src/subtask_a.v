`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 08:58:26
// Design Name: 
// Module Name: main
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


module subtask_a_archive(
    input clk,
    input [2:0]sw,
    output reg [14:0] led = 0
    );
    
    // 1st rightmost = 0: 0.20s --> 5Hz. led0 to led14. Counter to count up to 15
    reg [3:0] counter_4bits = -1;
    
    slow_clk_1hz c1(clk, slow_clock_1hz);
    slow_clk_5hz c5(clk, slow_clock_5hz);
    slow_clk_10hz c10(clk, slow_clock_10hz);
    slow_clk_100hz c100(clk, slow_clock_100hz);
    
    // count to 15 and stop
    always @(negedge slow_clock_5hz)
    begin
        counter_4bits <= counter_4bits + 1;
    end
    
    always @(posedge clk)
    begin
        // after all leds light up
        if (led[14:3] == 12'b1111_1111_1111) begin
            if (sw[2] == 1'b1) begin// == (sw = 3'b1xx)
                led[2] = slow_clock_100hz;
                led[1] <= 1;
                led[0] <= 1;
            end
            else if (sw[1] == 1'b1) begin
                led[1] = slow_clock_10hz;
                led[2] <= 1;
                led[0] <= 1;
            end
            else if (sw[0] == 1'b1) begin
                led[0] = slow_clock_1hz;
                led[1] <= 1;
                led[2] <= 1;
            end
        end
        
        // to light up led incrementally
        else if (counter_4bits == 4'b0000)
            led[0] <= 1;
        else if (counter_4bits == 4'b0001)
            led[1] <= 1;
        else if (counter_4bits == 4'b0010)
            led[2] <= 1;
        else if (counter_4bits == 4'b0011)
            led[3] <= 1;
        else if (counter_4bits == 4'b0100)
            led[4] <= 1;
        else if (counter_4bits == 4'b0101)
            led[5] <= 1;
        else if (counter_4bits == 4'b0110)
            led[6] <= 1;
        else if (counter_4bits == 4'b0111)
            led[7] <= 1;
        else if (counter_4bits == 4'b1000)
            led[8] <= 1;
        else if (counter_4bits == 4'b1001)
            led[9] <= 1;
        else if (counter_4bits == 4'b1010)
            led[10] <= 1;
        else if (counter_4bits == 4'b1011)
            led[11] <= 1;
        else if (counter_4bits == 4'b1100)
            led[12] <= 1;
        else if (counter_4bits == 4'b1101)
            led[13] <= 1;
        else if (counter_4bits == 4'b1110 && led[13] == 1) // make sure led14 only turns on after led 13
            led[14] <= 1;
    end
    
   
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 02:20:38
// Design Name: 
// Module Name: subtask_b
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

module subtask_b(
    input start_new,
    input clk,
    input [15:0] sw,
    input btnL,
    input btnR,
    input btnC,
    input [12:0] pixel_index,
    output [15:0] pixel_data_B
);

    wire clk_6p25M;
    wire clk_25M;
    
    wire B2_trigger;

    slow_clock clock_25M(clk, 2, clk_25M);
    slow_clock clock_6p25M(clk, 8, clk_6p25M);
    //////////////////////// Task B2 /////////////////////////////
    counter_4s counter_4_sec(clk_25M, sw, B2_trigger); //clk_25M
    assign_pixel_index(start_new, clk, clk_6p25M, pixel_index, B2_trigger, btnL, btnR, btnC, pixel_data_B);
endmodule

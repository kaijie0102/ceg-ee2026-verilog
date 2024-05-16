`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 11:26:32
// Design Name: 
// Module Name: slow_clock
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


module slow_clock(
    input clk, 
    input [31:0] max_counts,
    output reg new_clk = 0
    );
    
    // Formula for converting frequency to max_counts. Max Counts = 100M / required_frequency / 2 
    // Eg. 6.25MHz: (100M/6.25M) / 2 = 16/2 = 8 --> max_count = 8
    
    reg [31:0]counter_32bits = 1;
    
    always @(posedge clk)
    begin
        counter_32bits <= (counter_32bits == max_counts - 1) ? 0 : counter_32bits + 1;
        new_clk <= (counter_32bits == 0) ? ~new_clk : new_clk;
    end
endmodule

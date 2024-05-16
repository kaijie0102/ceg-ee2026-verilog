`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2024 11:04:35
// Design Name: 
// Module Name: fpga_add
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


module fpga_add(
    input [7:0]sw,
    output reg [15:0]led
    );
    
    wire [3:0]S;
    wire COUT;
    
    my_4bits_adder adder (sw[3:0], sw[7:4], 0, S[3:0], COUT); // sw[3:0] represents 4 bit number A, sw[7:4] represents B
   
    always @ (*)
    begin
        led[7:0] = sw[7:0];
        led[14:11] = S[3:0];
        if (COUT == 1'b1)
            led[15] = 1;
        else
            led[15] = 0;
    end
endmodule

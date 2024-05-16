`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 02:25:53
// Design Name: 
// Module Name: counter_4s
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


module counter_4s(
input clk_25M,
    input [15:0] sw,
    output reg B2_trigger
    );
    
    reg [31:0] count = 0;
    
    always @ (posedge clk_25M)
    begin
        if (sw[2] == 0 || sw[0] == 0) begin
            B2_trigger = 0;
            count = 0;
        end
        
        else begin
            
            if (count != 100_000_000 - 1) begin
                count = count + 1;
                B2_trigger = 0;
            end
            
            else begin
                B2_trigger = 1;
            end
                 
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 05:46:42
// Design Name: 
// Module Name: exclaimation_mark
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


module exclaimation_mark(
    input clock,
//    output [7:0] JC, 
//    inout PS2Clk, PS2Data,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data_success
);



// Define color parameters
parameter RED_COLOR = 16'b11111_000000_00000;
parameter GREEN_COLOR = 16'b00000_111111_00000;

// Define missing ports or signals
wire frame_begin, send_pixel, sample_pixel, clk_6p25m;   
wire [6:0] x_pix, y_pix;
//wire [12:0] pixel_index;
//reg [15:0] oled_data = 0;

slow_clock my_clk625M (clock, 8, clk_6p25m);


assign x_pix = (pixel_index % 96);
assign y_pix = pixel_index / 96;


// Check for red line and green dot simultaneously
always @(posedge clk_6p25m) begin
    
    if ((x_pix >= 38) && (x_pix < 40) && (y_pix >= 15) && (y_pix < 39)) begin
    pixel_data_success = RED_COLOR | GREEN_COLOR; // Combine red and green colors
    end
    // Horizontal stroke of the H
    else if ((y_pix >= 25 && y_pix < 26) && (x_pix >= 40) && (x_pix < 42)) begin
        pixel_data_success = RED_COLOR | GREEN_COLOR; // Combine red and green colors
    end
    
    else if ((x_pix >= 42) && (x_pix < 44) && (y_pix >= 15) && (y_pix < 39)) begin
    pixel_data_success = RED_COLOR | GREEN_COLOR; // Combine red and green colors
    end
    // Vertical stroke of the i
    else if ((x_pix >= 46) && (x_pix < 48) && (y_pix >= 15) && (y_pix < 39)) begin
        pixel_data_success = RED_COLOR | GREEN_COLOR; // Combine red and green colors
    end
    else if (((x_pix >= 50) && (x_pix < 54) && (y_pix >= 15) && (y_pix < 35)) ||
             ((x_pix == 51 || x_pix == 52) && ((y_pix >= 15 && y_pix < 35) || (y_pix >= 37 && y_pix < 39)))) begin
        pixel_data_success = RED_COLOR | GREEN_COLOR; // Combine red and green colors
    end
    else begin
        pixel_data_success = 16'b0;
    end
end


endmodule

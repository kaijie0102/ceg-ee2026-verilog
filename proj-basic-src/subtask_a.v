`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 04:18:22
// Design Name: 
// Module Name: subtask_a
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


module subtask_a(
    input notReset,
    input clk,
    input [15:0] sw,
    input BTNC,
    input BTND,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data_A
    );
   
    wire clk_6p25m;
    wire [2:0] x;
    wire y;
    wire [2:0] shapeState;
    wire isOrangeBorder;
    
    
    wire [6:0] x_pix = (pixel_index % 96);
    wire [6:0] y_pix = pixel_index / 96;
    parameter RED_COLOR = 16'b1111100000000000; 
    parameter ORANGE_COLOR = 16'b11111_110110_00000; 
    parameter GREEN_COLOR = 16'b00000_111111_00000; 
    reg [5:0] center_x = 47; // X-coordinate of the center of the display
    reg [4:0] center_y = 31; // Y-coordinate of the center of the display
    
    slow_clock my_clk625M (clk, 8, clk_6p25m);
    subtask_4pA3_timer(clk, sw, BTNC, BTND, x, y, shapeState, isOrangeBorder);
    

    reg ATrigger = 0;
    
    always @(posedge clk_6p25m)
    begin
        //if switch off, reset trigger
        if (sw[1] == 0)
        begin
            ATrigger = 0;
        end
        
        //if sw turns on and button pressed
        else if (notReset == 0 && BTNC == 1)
        begin
            ATrigger = 1;
        end
    
        
        //red border shows all the time
        if ((x_pix >= 5 && x_pix < 6 && y_pix >= 5 && y_pix < 58) 
        || (x_pix >= 89 && x_pix < 90 && y_pix >= 5 && y_pix < 58) 
        || (x_pix >= 5 && x_pix < 90 && y_pix >= 5 && y_pix < 6) 
        || (x_pix >= 5 && x_pix < 90 && y_pix >= 57 && y_pix < 58))
        begin
            pixel_data_A <= RED_COLOR;
        end
        else
        begin
            pixel_data_A <= 16'b00000_000000_00000;
        end
        
        if (isOrangeBorder == 1 && ATrigger == 1)
        begin
            if (((x_pix >= 7 && x_pix < 10 && y_pix >= 7 && y_pix < 55) 
            || (x_pix >= 84 && x_pix < 87 && y_pix >= 7 && y_pix < 55) 
            || (x_pix >= 7 && x_pix < 87 && y_pix >= 7 && y_pix < 10) 
            || (x_pix >= 7 && x_pix < 87 && y_pix >= 52 && y_pix < 55)))
            begin
                pixel_data_A <= ORANGE_COLOR;
            end
            
            if (x == 1 && ATrigger == 1)
            begin
                if ((x_pix >= 12 && x_pix < 13  && y_pix >= 12 && y_pix <50 ) 
                || (x_pix >= 80 && x_pix < 81 && y_pix >= 12 && y_pix < 50) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 12 && y_pix < 13) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 49 && y_pix < 50))
                begin
                    pixel_data_A <= GREEN_COLOR;
                end
            end
            
            if (x == 2 && ATrigger == 1)
            begin
                if (
                ((x_pix >= 12 && x_pix < 13  && y_pix >= 12 && y_pix <50 ) 
                || (x_pix >= 80 && x_pix < 81 && y_pix >= 12 && y_pix < 50) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 12 && y_pix < 13) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 49 && y_pix < 50))
                                
                || ((x_pix >= 14 && x_pix < 16 && y_pix >= 15 && y_pix < 48) 
                || (x_pix >= 77 && x_pix < 79 && y_pix >= 15 && y_pix < 48) 
                || (x_pix >= 14 && x_pix < 79 && y_pix >= 14 && y_pix < 16) 
                || (x_pix >= 14 && x_pix < 79 && y_pix >= 46 && y_pix < 48))
                )
                begin
                    pixel_data_A <= GREEN_COLOR;
                end
            end
            
            if (x == 3 && ATrigger == 1)
            begin
                if (
                ((x_pix >= 12 && x_pix < 13  && y_pix >= 12 && y_pix <50 ) 
                || (x_pix >= 80 && x_pix < 81 && y_pix >= 12 && y_pix < 50) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 12 && y_pix < 13) 
                || (x_pix >= 12 && x_pix < 81 && y_pix >= 49 && y_pix < 50))
                                
                || ((x_pix >= 14 && x_pix < 16 && y_pix >= 15 && y_pix < 48) 
                || (x_pix >= 77 && x_pix < 79 && y_pix >= 15 && y_pix < 48) 
                || (x_pix >= 14 && x_pix < 79 && y_pix >= 14 && y_pix < 16) 
                || (x_pix >= 14 && x_pix < 79 && y_pix >= 46 && y_pix < 48))
                
                || ((x_pix >= 17 && x_pix< 20 && y_pix >= 18 && y_pix < 45) 
                || (x_pix >= 73 && x_pix<76  && y_pix >= 18 && y_pix < 45) 
                || (x_pix >= 17 && x_pix< 76 && y_pix >= 17 && y_pix < 20) 
                || (x_pix >= 17 && x_pix< 76 && y_pix >= 42 && y_pix < 45)))
                begin
                    pixel_data_A <= GREEN_COLOR;
                end
            end
        end
        
        
        if (shapeState == 1 && ATrigger == 1)
        begin
            if (x_pix >= 42 && x_pix <= 53 && y_pix >= 26 && y_pix <= 36)
            begin
                pixel_data_A <= RED_COLOR;
            end
        end
        
        if (shapeState == 2 && ATrigger == 1)
        begin
            //orange circle
            if ((x_pix - center_x)**2 + (y_pix - center_y)**2 < 25)
            begin
                pixel_data_A <= ORANGE_COLOR;
            end
        end
        
        if (shapeState == 3 && ATrigger == 1) 
        begin
            //green triangle
            // x: 47, y: 48
            if (x_pix >= 47 && x_pix <= 47 && y_pix >= 24 && y_pix <= 24
                || x_pix >= 47-1 && x_pix <= 47+1 && y_pix >= 25 && y_pix <= 25
                || x_pix >= 47-2 && x_pix <= 47+2 && y_pix >= 26 && y_pix <= 26
                || x_pix >= 47-3 && x_pix <= 47+3 && y_pix >= 27 && y_pix <= 27
                || x_pix >= 47-4 && x_pix <= 47+4 && y_pix >= 28 && y_pix <= 28
                || x_pix >= 47-5 && x_pix <= 47+5 && y_pix >= 29 && y_pix <= 29
                || x_pix >= 47-6 && x_pix <= 47+6 && y_pix >= 30 && y_pix <= 30
                || x_pix >= 47-7 && x_pix <= 47+7 && y_pix >= 31 && y_pix <= 31
                || x_pix >= 47-8 && x_pix <= 47+8 && y_pix >= 32 && y_pix <= 32
                || x_pix >= 47-9 && x_pix <= 47+9 && y_pix >= 33 && y_pix <= 33)
            begin
                pixel_data_A <= GREEN_COLOR;
            end
        end
    end


endmodule

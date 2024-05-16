`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 02:36:54
// Design Name: 
// Module Name: assign_pixel_index
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


module assign_pixel_index(
    input notReset,
    input clk,
    input clk_6p25M,
    input [12:0] pixel_index,
    input B2_trigger,
    input btnL,
    input btnR,
    input btnC,
    output reg [15:0] oled_data
    );
    
    reg reset_done = 0;
    wire [7:0] x = (pixel_index % 96);
    wire [6:0] y = pixel_index / 96;
    
    //localparam PERIOD = 18;
    parameter PERIOD = 18;
    parameter WHITE = 16'b1111111111111111;
    parameter RED = 16'b11111_000000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    parameter BLUE = 16'b00000_000000_11111;
    reg [15:0] color = WHITE;
    reg [3:0] boarder_pos = 4; //boarders 0 to 4
    wire clk_1000;
    
    ///////////////////////// TASK B3 ////////////////////////////////
    slow_clock clock_1000(clk, 50000, clk_1000); //1ms, 1000Hz
    reg button_pushed = 0;
    reg [7:0] count = 1;
    always @ (posedge clk_1000)
    begin
        //when sw[2] turns on, reset color to white
        if (notReset == 0 && reset_done == 0) // not started ensures reset once only
        begin 
            color = WHITE;
            boarder_pos = 4;
            reset_done = 1;
        end
         //when sw[2] turns off, reset value
        else if (notReset == 1)
        begin
            reset_done = 0;
        end
        
        // if btnL pressed, move green boarder to the left
        if (btnL == 1 && boarder_pos > 0 && button_pushed == 0)
        begin
            boarder_pos <= boarder_pos - 1;
            button_pushed = 1;
        end
        
        // if btnR pressed, move green boarder to the right
        else if (btnR == 1 && boarder_pos < 4 && button_pushed == 0)
        begin
            boarder_pos <= boarder_pos + 1;
            button_pushed = 1;
        end
        
        // if btnC pushed, change color of squares
        else if (btnC == 1 && button_pushed == 0)
        begin
            case (color)
                WHITE: color = RED;
                RED: color = GREEN;
                GREEN: color = BLUE;
                BLUE: color = WHITE;
            endcase
            button_pushed = 1;
        end
        
        // debouncing counter
        if (button_pushed == 1)
        begin
            count <= (count == 200 - 1) ? 0 : count + 1;
            button_pushed <= (count == 0) ? 0 : 1;
        end
    end
    
    
    /////////////////////// TASK B2 //////////////////////////////
    always @ (posedge clk_6p25M) 
    begin
        //One middle green boarder if sw[0] not on for 4s
        if (B2_trigger == 0
            && ((((x >= 5 + (2 * PERIOD) && x <= 7 + (2 * PERIOD)) //x value for left vertical line 
            ||(x >= 16 + (2 * PERIOD) && x <= 18 + (2 * PERIOD)))  //x value for right vertical line 
            && (y >= 25 && y <= 38)) //y value for vertical line
            || (((y >= 25 && y <=27) || (y >= 36 && y <= 38)) // y value for top and bottom horizontal line
            && (x >= 8 + (2 * PERIOD) && x <= 15 + (2 * PERIOD)))
            ))
        begin
            oled_data = GREEN;
            //color = WHITE; //reset square color to white
        end
        
        //when sw[0] on for > 4s
        //5 white squares 6x6
        else if (B2_trigger == 1
                && (x % PERIOD >= 9 && x % PERIOD <= 14) && y >= 29 && y <= 34) 
        begin
            oled_data = color;
        end
        
        // green boarder
        else if (B2_trigger == 1 
                && ((((x >= 5 + (boarder_pos * PERIOD) && x <= 7 + (boarder_pos * PERIOD)) //x value for left vertical line 
                ||(x >= 16 + (boarder_pos * PERIOD) && x <= 18 + (boarder_pos * PERIOD)))  //x value for right vertical line 
                && (y >= 25 && y <= 38)) //y value for vertical line
                || (((y >= 25 && y <=27) || (y >= 36 && y <= 38)) // y value for top and bottom horizontal line
                && (x >= 8 + (boarder_pos * PERIOD) && x <= 15 + (boarder_pos * PERIOD)))
                ))
        begin
            oled_data = GREEN;
        end
        
        
        else begin
          oled_data = 0;
        end
    end
endmodule
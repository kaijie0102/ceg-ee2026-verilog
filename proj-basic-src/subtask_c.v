`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 23:13:21
// Design Name: 
// Module Name: subtask_c
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

module subtask_c(
    input start_new, 
    input clock,
    input [15:0] sw,
    input btnD, 
    inout PS2Clk, 
    inout PS2Data, 
    input [12:0] pixel_index,
    output reg [15:0] pixel_data_C
    );
    
    integer red = 16'hF800;
    integer green = 16'h07E0;

    wire frame_begin, send_pixel, sample_pixel, clock_1, clock_10, clock_20, clock_6p25M, clock_12p5M, clock_25M;
    wire [6:0] x, y;
    reg [6:0] y_down = 4;
    reg [6:0] x_right = 51;
    reg [6:0] y_up = 31;
    reg [6:0] x_left = 62;

//    wire [12:0] pixel_index;
    
//    reg [15:0] oled_data = 0;

    slow_clock clock_1_module (clock, 49999999, clock_1);
    slow_clock clock_10_module (clock, 4999999, clock_10);
    slow_clock clock_20_module (clock, 2499999, clock_20);
    slow_clock clock_6p25m_module (clock, 7, clock_6p25M);
    slow_clock clock_12p5m_module (clock, 3, clock_12p5M);
    slow_clock clock_25m_module (clock, 1, clock_25M);
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
       
    reg button_pressed = 0; 
    reg start = 0;
    reg hold = 0; 
    
    reg CTrigger = 0;
    reg notReset = 0;
    
    always @ (posedge clock)
    begin  
        //if switch off, reset trigger
        if (sw[3] == 0)
        begin
            CTrigger = 0;
        end
        
        //if sw turns on and button pressed
        else if (notReset == 0 && btnD == 1)
        begin
            CTrigger = 1;
        end
        
        if (btnD) begin
            start <= 1;
            button_pressed <= 1;
        end
        
        if (x_left == 47 && y_up == 0) begin 
            button_pressed <= 0;
            hold <= 1;
        end
        
        
        if (start == 0 || CTrigger == 0) begin //initial red square
            if (x >= 47 && x <= 51 && y >= 0 && y <= 5)
                pixel_data_C <= red;
            else
                pixel_data_C <= 0;
                
        end else if (CTrigger == 1 && button_pressed == 0) begin //default after button pressed once
            if (x >= 47 && x <= 51 && y >= 0 && y <= 5) 
                pixel_data_C <= red;
            else if ((x >= 47 && x <= 51 && y >= 0 && y <= 35) || (x > 47 && x <= 66 & y >= 31 && y <= 35))
                pixel_data_C <= green;
            else
                pixel_data_C <= 0;
                
        end else begin //move red and green line when button pressed
            if (CTrigger == 1 
                && (((x >= x_left && x <= 66 && y >= 31 && y <= 35) 
                ||(x_left == 47 && x >= 47 && x <= 51 && y >= y_up && y <= 35)) 
                && (y_down >= 35 && x_right >= 66))) begin
                pixel_data_C <= green;
            end else if (CTrigger == 1 && ((x >= 47 && x <= 51 && y >= 0 && y <= y_down) ||
                    (y_down == 35 && x >= 47 && x <= x_right && y >= 31 && y <= 35))) begin
                pixel_data_C <= red;
            end else if (CTrigger == 1 && hold == 1) begin
                if ((x >= 47 && x <= 66 && y >= 31 && y <= 35) || (x >= 47 && x <= 51 && y >= 0 && y <= 35)) begin
                    pixel_data_C <= green;
                end else
                    pixel_data_C <= 0;
            end else
                pixel_data_C <= 0;
        end
    end

    always @ (posedge clock_20) begin
        if (button_pressed) begin
            if (y_down >= 35)
                y_down = y_down;
            else
                y_down = y_down + 1;
        end
        if (y_down >= 35) begin
            if (x_right >= 66)
                x_right = x_right;
            else
                x_right = x_right + 1;
        end
        if (button_pressed == 0) begin
            y_down = 4;
            x_right = 51;
        end
    end


    always @ (posedge clock_10) begin
        if (x_right >= 66 && y_down >= 35) begin
            if (x_left >= 48)
                x_left = x_left - 1;
            else
                x_left = x_left;
        end
        if (x_left == 47) begin
            if (y_up >= 1)
                y_up = y_up - 1;
            else
                y_up = y_up;
        end
        if (button_pressed == 0) begin
            y_up = 31;
            x_left = 62;
        end
    end


//    Oled_Display unit_oled(.clk(clock_6p25M), .reset(0), .frame_begin(frame_begin), .sending_pixels(send_pixel), .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
endmodule

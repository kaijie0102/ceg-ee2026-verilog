`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 07:29:51
// Design Name: 
// Module Name: subtask_d
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


module subtask_d(
    input start_new,
    input clk, 
    input btnC, 
    input btnL, 
    input btnR, 
    input btnU, 
    input [15:0] sw,
//    output [7:0]JC,
    input [12:0] pix_index,
    output reg [15:0] pixel_data_D
    );
    
    // OLED
    wire frame_beg;
    wire send_pix;
    wire sample_pix;
//    wire [12:0] pix_index;
    reg [15:0] oled_data;
    reg [12:0] x_axis;
    reg [12:0] y_axis;
   
    // flags 
    reg start_flag = 0;
    reg reset_flag = 0;
    reg btnc_flag = 0;
    reg btnr_flag = 0;
    reg btnl_flag = 0;
    reg btnu_flag = 0; 
    reg left_edge_flag = 0; // box at left edge: flag = 1
    reg right_edge_flag = 0; // box at right edge: flag = 1
    reg top_edge_flag = 0; // box at top edge: flag = 1
    
    // useful variables
    reg [12:0] x_position = 0;
    reg [12:0] y_position = 0;
    reg [3:0] speed_store = 1; // 0: 90px/s 1: 45 px/s 2: 30px/sec 5: 15px/sec
    reg [3:0] speed_counter = 0;
    
    // movement constants
    parameter X_POS_START = 44;
    parameter Y_POS_START = 55;
    parameter RIGHT_EDGE = 93; // right most x pixel reg[12:0] right_edge
    parameter LEFT_EDGE = 3; // left most x pixel
    parameter TOP_EDGE = 3; // top most y pixel
    
    // colours constant
    parameter WHITE = 16'b11111_111111_11111;
    parameter CYAN = 16'h07FF;

    // clocks
    wire [31:0] max_counts_6p25MHz = 8;
    slow_clock slow_clock_6p25MHz(.clk(clk), .max_counts(max_counts_6p25MHz), .new_clk(clock_6p25M));
    wire [31:0] max_counts_90pix = 555_556;
    slow_clock slow_clock_90pixPerSec(.clk(clk), .max_counts(max_counts_90pix), .new_clk(clock_90pix));
    wire [31:0] max_counts_45pix = 1111_111;
    slow_clock slow_clock_45pixPerSec(.clk(clk), .max_counts(max_counts_45pix), .new_clk(clock_45pix));
    wire [31:0] max_counts_30pix = 1666_667;
    slow_clock slow_clock_30pixPerSec(.clk(clk), .max_counts(max_counts_30pix), .new_clk(clock_30pix));
    wire [31:0] max_counts_15pix = 3333_333;
    slow_clock slow_clock_15pixPerSec(.clk(clk), .max_counts(max_counts_15pix), .new_clk(clock_15pix));

    
    
    initial begin
        x_position = X_POS_START; // x-pos of top-left of 5x5 box
        y_position = Y_POS_START; // y-pos of top-left of 5x5 box
    end
    // Initialise blue square when reset
    wire DTrigger;
    initialise_subtaskD initialiseD (start_new, clk, sw, btnC, DTrigger);
    
    
    always @(posedge clock_90pix) begin
        if (reset_flag) begin
            x_position = X_POS_START; // x-pos of top-left of 5x5 box
            y_position = Y_POS_START; // y-pos of top-left of 5x5 box
        end
        
        // setting the speed of the moving box
        if (~sw[0]) begin
            speed_store <= 1; // count 1 beats to make frequency 90px/s -> 45px/s 
        end
        else if (btnu_flag && sw[0]) begin
            speed_store <= 5;  // count 5 beats to make frequency 90px/s -> 15px/s 
        end
        else begin
            speed_store <= 2; // count one beat to make frequency 90px/s -> 30px/s when btnl or btnr is pressed
        end
        
        // moving the box
        // if (~sw[0]) begin
        if (speed_counter == 0)begin
            if (btnl_flag && ~left_edge_flag) begin // if switch[0] is off, left button is pressed and box is not at extreme left
                x_position <= x_position - 1; // moving the box left
            end
            if (btnr_flag && ~right_edge_flag) begin // if switch[0] is off, right button is pressed and box is not at extreme right
                x_position <= x_position + 1; // moving the box right
            end
            if (btnu_flag && ~top_edge_flag) begin // if switch[0] is off, up button is pressed and box is not at extreme top
                y_position <= y_position - 1; // moving the box up
            end
        end
        speed_counter <= (speed_counter == speed_store) ? 0 : speed_counter + 1;
    end

    // for oled display  
    always @(posedge clock_6p25M) begin
        x_axis = pix_index % 12'd96;
        y_axis = pix_index / 12'd96;
        
        // initial pos
        if( DTrigger == 0 
            && (x_axis >= 2 && x_axis < 7)
            && (y_axis >= 2 && y_axis < 7)
            //&& (btnc_flag == 0) && (btnr_flag == 0) && (btnl_flag == 0 && (btnu_flag == 0) && (start_flag == 0))
        ) begin
            pixel_data_D <= CYAN;
            
        end 
        
        // starting pos after centre button is pressed
        else if(btnc_flag && (x_axis >= 44 && x_axis < 49 ) // 44 and 49
                            && (y_axis >= 55 && y_axis < 60) && DTrigger == 1
        ) begin
            start_flag <= 1;
            pixel_data_D <= WHITE;
        end
        
        // moving left by updating x_position
        else if((start_flag && btnl_flag)
            && (x_axis >= x_position && x_axis < (x_position + 5)) 
            && (y_axis >= y_position && y_axis < (y_position + 5)) 
            && DTrigger == 1
        ) begin
            pixel_data_D <= WHITE;
            
        end
         
        // moving right by updating y_position
        else if((start_flag && btnr_flag)
            && (x_axis >= x_position && x_axis < (x_position + 5)) 
            && (y_axis >= y_position && y_axis < (y_position + 5)) 
            && DTrigger == 1
        ) begin
            pixel_data_D <= WHITE;
        end
        
        // moving up
        else if((start_flag && btnu_flag)
            && (x_axis >= x_position && x_axis < (x_position + 5))
            && (y_axis >= y_position && y_axis < (y_position + 5))
            && DTrigger == 1
        ) begin
            pixel_data_D <= WHITE;
        end
        
        else begin
           pixel_data_D <= 16'd0;
        end
        
        
    end

    always @(posedge clk) begin
        // BUTTONS: detection of button presses
        if (btnC == 1) begin // reset to original pos
            btnc_flag <= 1;
            btnr_flag <= 0;
            btnl_flag <= 0;
            btnu_flag <= 0;
            left_edge_flag <= 0;
            right_edge_flag <= 0;
            top_edge_flag <= 0;
            reset_flag <= 1;
        end
            
        // moving
        else if (btnR == 1 && start_flag) begin // move right after start state is triggered
            btnc_flag <= 0;
            btnr_flag <= 1;
            btnl_flag <= 0;
            btnu_flag <= 0;
            if (x_position != LEFT_EDGE) begin
                left_edge_flag <= 0;
            end
            if (y_position != TOP_EDGE) begin
                top_edge_flag <= 0;
            end
            reset_flag <= 0;
        end
        else if (btnL == 1 && start_flag) begin // move left after start state is triggered
//        else if (btnL == 1) begin // move left after start state is triggered
            btnc_flag <= 0;
            btnr_flag <= 0;
            btnl_flag <= 1;
            btnu_flag <= 0;
            if (x_position != (RIGHT_EDGE -5)) begin
                right_edge_flag <= 0;
            end
            if (y_position != TOP_EDGE) begin
                top_edge_flag <= 0;
            end
            reset_flag <= 0;
        end
        else if (btnU == 1 && start_flag) begin // move up after start state is triggered
            btnc_flag <= 0;
            btnr_flag <= 0;
            btnl_flag <= 0;
            btnu_flag <= 1;
            
            if (x_position != LEFT_EDGE) begin
                left_edge_flag <= 0;
            end
            if (x_position != (RIGHT_EDGE - 5)) begin
                right_edge_flag <= 0;
            end
            reset_flag <= 0;
        end

        // edge detection
        else if (btnl_flag == 1 && x_position == LEFT_EDGE) begin
            left_edge_flag <= 1;
        end
        else if (btnr_flag == 1 && x_position == (RIGHT_EDGE - 5)) begin
            right_edge_flag <= 1;
        end
        else if (btnu_flag == 1 && y_position == TOP_EDGE) begin
            top_edge_flag <= 1;
        end

    end

    
   
//    Oled_Display oled(
//        .clk(clock_6p25M), 
//        .reset(0), 
//        .frame_begin(frame_beg), 
//        .sending_pixels(send_pix),
//        .sample_pixel(sample_pix), 
//        .pixel_index(pix_index), 
//        .pixel_data(oled_data), 
//        .cs(JC[0]), 
//        .sdin(JC[1]), 
//        .sclk(JC[3]), 
//        .d_cn(JC[4]), 
//        .resn(JC[5]), 
//        .vccen(JC[6]),
//        .pmoden(JC[7])
//    );  

endmodule

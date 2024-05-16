`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 22:46:08
// Design Name: 
// Module Name: mux_4_to_1
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


module mux_4_to_1(
    input clk,
    input [15:0] sw,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    inout PS2Clk,
    inout PS2Data,
    input [12:0] pixel_index,
    output reg [15:0] led,
    output reg [15:0] pixel_data = 16'b0,
    output reg [7:0] seg,
    output reg [3:0] an
    );
    
    
    wire clk_6p25M;
    wire clk_25M;
    wire clk_12p5M;
    wire clk_1;
    wire clk_20;
    wire clk_480;
    
    reg [31:0] max_counts_6p25MHz = 8;
    slow_clock slow_clock_6p25MHz(.clk(clk), .max_counts(max_counts_6p25MHz), .new_clk(clk_6p25M));
    reg [31:0] max_counts_25MHz = 2;
    slow_clock slow_clock_25MHz(.clk(clk), .max_counts(max_counts_25MHz), .new_clk(clk_25M));
    reg [31:0] max_counts_12p5MHz = 4;
    slow_clock slow_clock_12p5MHz(.clk(clk), .max_counts(max_counts_12p5MHz), .new_clk(clk_12p5M));
    reg [31:0] max_counts_1Hz = 50_000_000;
    slow_clock slow_clock_1Hz(.clk(clk), .max_counts(max_counts_1Hz), .new_clk(clk_1));
    reg [31:0] max_counts_20Hz = 2_500_000;
    slow_clock slow_clock_20Hz(.clk(clk), .max_counts(max_counts_20Hz), .new_clk(clk_20));
    reg [31:0] max_counts_480Hz = 104167;
    slow_clock slow_clock_480Hz(.clk(clk), .max_counts(max_counts_480Hz), .new_clk(clk_480));
    
    wire [15:0] pixel_data_A;
    wire [15:0] pixel_data_B;
    wire [15:0] pixel_data_C;
    wire [15:0] pixel_data_D;
    wire [15:0] pixel_data_success;
    wire [15:0] pixel_data_paint;
    // make students basic task start from top
    reg start_A = 1;
    reg start_C = 1;
    reg start_B = 1;
    reg start_D = 1;
    
    // useful flags
    reg btnC_pressed = 0;
    reg success = 0;
    
    // mouse & paint
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    wire [7:0] seg1;
    wire led1;
    
    MouseCtl my_mouse (clk, 0, xpos, ypos, zpos, left, middle, right, new_event, 0, 0, 0, 0, 0, PS2Clk, PS2Data);
    paint my_paint (clk, clk_25M, clk_12p5M, clk_6p25M, clk_1, left, right, 1, xpos, ypos, pixel_index, led1, seg1, pixel_data_paint);
    subtask_a my_task_A (start_A, clk, sw, btnC, btnD, pixel_index, pixel_data_A);
    subtask_b my_task_B (start_B, clk, sw, btnL, btnR, btnC, pixel_index, pixel_data_B);
    subtask_c my_task_C (start_C, clk, sw, btnD, PS2Clk, PS2Data, pixel_index, pixel_data_C);
    subtask_d my_task_D (start_D, clk, btnC, btnL, btnR, btnU, sw, pixel_index, pixel_data_D);
    exclaimation_mark my_pixel_success (clk, pixel_index, pixel_data_success);
    
    // 7-segment display
    reg [1:0] an_count = 0;
    
    reg [7:0] an0 = 8'b1111_1001; // 1
    reg [7:0] an1 = 8'b1100_0000; // 0
    reg [7:0] an2 = 8'b0010_0100; // 1.
    reg [7:0] an3 = 8'b1001_0010; // 5
    
    reg oled_display_on = 0;
    
    always @(posedge clk) begin
        if (success) begin
            pixel_data <= pixel_data_success;
        end
        // sw5=group task, sw1=subtask a, sw2=subtask b, sw3=subtask c, sw4 = subtask d
        else if (sw[5]) begin // switches 15 14 13 are switches off before starting group task
            
            led <= 16'b0000_0000_0001_0000;
            oled_display_on <= 1;
            if (sw[15]) begin // switch 15 is on, detected digit output at an1
                pixel_data <= pixel_data_paint;
                an1 <= seg1;
                an1[7] <= 1;
            end
            else if (sw[14]) begin // switch 14 is on, detected digit output at an0
                pixel_data <= pixel_data_paint;
                an0 <= seg1;
                an0[7] <= 1;
            end
            else if (sw[13]) begin // switch 13 is on, clear AN0 and AN1
                an0 <= 8'b1111_1111;
                an1 <= 8'b1111_1111;
            end
            else begin // reset the display to 01
                an0 = 8'b1111_1001;
                an1 = 8'b1100_0000; 
            end
        end
        else if (sw[1]) begin // student task a, ld0 is on   
            led <= 16'b0000_0000_0000_0001;
            pixel_data <= pixel_data_A;
            oled_display_on <= 1;
            start_A <= 0;
            start_B <= 1;
            start_C <= 1;
            start_D <= 1; // stop "restarting" module D
        end
        else if (sw[2]) begin // student task b, ld1 is on   
            led <= 16'b0000_0000_0000_0010;
            pixel_data <= pixel_data_B;
            oled_display_on <= 1;
            start_A <= 1;
            start_B <= 0;
            start_C <= 1;
            start_D <= 1; // stop "restarting" module D
        end
        else if (sw[3]) begin // student task c, ld2 is on   
            led <= 16'b0000_0000_0000_0100;
            pixel_data <= pixel_data_C;
            start_A <= 1;
            start_B <= 1;
            start_C <= 0;
            start_D <= 1; // stop "restarting" module D
            oled_display_on <= 1;
        end
        else if (sw[4]) begin // student task d, ld3 is on
            led <= 16'b0000_0000_0000_1000;
            start_A <= 1;
            start_B <= 1;
            start_C <= 1;
            start_D <= 0; // stop "restarting" module D
            pixel_data <= pixel_data_D;
            oled_display_on <= 1;
        end
        else if (~sw) begin // all switched off
            // reset        
            oled_display_on <= 0;
            led <= 0;
            start_A <= 1;
            start_B <= 1;
            start_C <= 1;
            start_D <= 1;
            pixel_data <= 16'b0;
        end
        else begin
            pixel_data <= 16'b0;
        end
        
//        if (btnC) begin
//            btnC_pressed <= 1;
//        end 
        
        if (btnC && an0 == 8'b1111_1001 && an1 == 8'b1100_0000 && sw[5]) begin
            success <= 1;
        end
        if ( success && (sw[1] || sw[2] || sw[3] || sw[4]) ) begin
            success <= 0;
            // reset if a basic task is selected 
            an0 <= 8'b1111_1001;
            an1 <= 8'b1100_0000;
            an2 <= 8'b0010_0100;
            an3 <= 8'b1001_0010;
        end
    end
   
    // display 4 diff numbers
    always @ (posedge clk_480) begin
        if (sw[5]) begin // 7segment display starts when switch 5 is activated
            an_count <= (an_count == 3) ? 0 : an_count + 1;
            case (an_count)
            0: begin 
                seg <= an0;
                an <= 4'b1110;
            end
            1: begin 
                seg <= an1;
                an <= 4'b1101;
            end
            2: begin 
                an <= 4'b1011;
                seg <= an2;
            end
            3: begin 
                an <= 4'b0111;
                seg <= an3;
            end
            default: begin
                an <= 0;
            end
            endcase
        end else begin
            an <= 4'b1111;
        end
    end
    
endmodule

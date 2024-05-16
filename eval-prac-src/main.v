`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2024 19:07:08
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input [15:0] sw,
    input btnU,btnD, btnL, btnR, btnC,
    
    output reg [6:0] seg,
    output reg [15:0] led,
    output reg [3:0] an,
    output reg dp
    );
    
    initial begin
        // all off
        an[3:0] = 4'b1111;
        seg[6:0] = 7'b1111111;
    end
        
    wire clk_5hz;
    slow_clock clock_5hz(.clk(clk), .max_counts(10_000_000), .new_clk(clk_5hz));
    
    wire clk_1hz;
    slow_clock clock_1hz(.clk(clk), .max_counts(50_000_000), .new_clk(clk_1hz));
    
    wire clk_10hz;
    slow_clock clock_10hz(.clk(clk), .max_counts(5_000_000), .new_clk(clk_10hz));
    
    wire clk_100hz;
    slow_clock clock_100hz(.clk(clk), .max_counts(500_000), .new_clk(clk_100hz));
    
    reg [3:0] counterA = -1;
    
    reg [2:0] stateB = 0;
    reg unlocked =0;
    
    reg [31:0]max_cycle_7segment = 0;
    reg [31:0]counter_7segment_1 = 1;
    reg [31:0]counter_7segment_10 = 1;
    reg [31:0]counter_7segment_100 = 1;
    
    // subtask D
    reg interrupt;
    reg [1:0] counter_3sec;
    
    always @ (posedge clk)
    begin
        if (counterA == 0) begin
            led = 16'b0000_0000_0000_0001;
        end
        else if (counterA == 1) begin
            led = 16'b0000_0000_0000_0011;
        end
        else if (counterA == 2) begin
            led = 16'b0000_0000_0000_0111;
        end
        else if (counterA == 3) begin
            led = 16'b0000_0000_0000_1111;
        end
        else if (counterA == 4) begin
            led = 16'b0000_0000_0001_1111;
        end
        else if (counterA == 5) begin
            led = 16'b0000_0000_0011_1111;
        end
        else if (counterA == 6) begin
            led = 16'b0000_0000_0111_1111;
        end
        else if (counterA == 7) begin
            led = 16'b0000_0000_1111_1111;
        end
        else if (counterA == 8) begin
            led = 16'b0000_0001_1111_1111;
        end
        else if (counterA == 9) begin
            led = 16'b0000_0011_1111_1111;
        end
        else if (counterA == 10) begin
            led = 16'b0000_0111_1111_1111;
        end
        else if (counterA == 11) begin
            led = 16'b0000_1111_1111_1111;
        end
        else if (counterA == 12) begin
            led = 16'b0001_1111_1111_1111;
        end
        else if (counterA == 13) begin
            led = 16'b0011_1111_1111_1111;
        end
        else if (counterA == 14 && unlocked) begin
            led = 16'b1111_1111_1111_1111;
        end
        else if (counterA == 14) begin
            led = 16'b0111_1111_1111_1111;
        end
        
        // switch logic
        if (sw[2]) begin
            // blink ld2 at 100Hz
            led[2] = clk_100hz;
            if (unlocked) begin // change state using switch
                max_cycle_7segment <= 500_000;
                counter_7segment_100 <= (counter_7segment_100 == max_cycle_7segment - 1) ? 0 : counter_7segment_100 + 1;
                if (counter_7segment_100 == (max_cycle_7segment - 1)) begin
                     stateB = (stateB == 2) ? 0 : stateB + 1;
                end
            end
        end
        else if (sw[1]) begin
            // blink ld1 at 10Hz
            led[1] = clk_10hz;
            if (unlocked) begin
                max_cycle_7segment <= 5_000_000;
                counter_7segment_10 <= (counter_7segment_10 == max_cycle_7segment - 1) ? 0 : counter_7segment_10 + 1;
                if (counter_7segment_10 == (max_cycle_7segment - 1)) begin
                     stateB = (stateB == 2) ? 0 : stateB + 1;
                end
            end
        end
        else if (sw[0]) begin
            // blink ld0 at 1Hz
            led[0] = clk_1hz;
            if (unlocked) begin
                max_cycle_7segment <= 50_000_000;
                counter_7segment_1 <= (counter_7segment_1 == max_cycle_7segment - 1) ? 0 : counter_7segment_1 + 1;
                if (counter_7segment_1 == (max_cycle_7segment - 1)) begin
                     stateB = (stateB == 2) ? 0 : stateB + 1;
                end
            end
        end
        else if (unlocked) begin
            // pause the movement
            max_cycle_7segment = 0;
            
        end
        
//        if (unlocked && max_cycle_7segment > 0) begin
//           counter_7segment <= (counter_7segment == max_cycle_7segment - 1) ? 0 : counter_7segment + 1;
//           if (counter_7segment == (max_cycle_7segment - 1)) begin
//                stateB <= (stateB == 2) ? 0 : stateB + 1;
//           end
           
//        end
        
        // subtask B - change state using buttons
        if (stateB == 0 && btnL && ~unlocked) begin
            stateB <= 1;
        end
        else if (stateB == 1 && btnD && ~unlocked) begin
            stateB <= 2;
        end
        else if (stateB == 2 && btnC && ~unlocked) begin
            stateB <= 0; // back to 0 if last button is pressed
            unlocked <= 1; // turn on ld15
        end
        
        // subtask B - 7segment display
        if (counterA == 14 && stateB == 0) begin // all lights on, begin
            // letter L pos 0
            an[3:0] <= 4'b1110;
            seg[6:0] <= 7'b1001111;
        end
        else if (counterA == 14 && stateB == 1) begin 
            // letter D pos 1
           an[3:0] <= 4'b1101;
           seg[6:0] <= 7'b0100001;
        end
        else if (counterA == 14 && stateB == 2) begin 
           // letter C pos 2
           an[3:0] <= 4'b1011;
           seg[6:0] <= 7'b0100111;
        end
        else begin
            an[3:0] <= 4'b1111;
            seg[6:0] <= 7'b1111111;
        end
        
    end
    
    always @ (posedge clk_5hz)
    begin
        counterA <= (counterA == 14) ? counterA : counterA + 1; 
    end
    
    always @ (posedge clk_1hz)
    begin
        if (sw[15]) begin
            counter_3sec <= (counter_3sec == 3) ? counter_3sec : counter_3sec + 1;
            if (counter_3sec == 3) begin
                interrupt = 1;
            end 
        end 
        else counter_3sec = 0; // reset 3 seconds timer
    end
                
endmodule

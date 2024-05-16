`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 08:41:54
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
    output reg [15:0] led=0,
    output reg [3:0] an,
    output reg dp
    );
    
    
    initial begin
        // how the led segments will look on start
        an[3:0] = 4'b1111;
        seg[6:0] = 7'b1111111;
    end
    

    wire clk_2p25hz;
    slow_clock clock_2p25hz(.clk(clk), .max_counts(2222_2222), .new_clk(clk_2p25hz));
    
    wire clk_3hz;
    slow_clock clock_3hz(.clk(clk), .max_counts(1666_6666), .new_clk(clk_3hz));

    wire clk_1hz;
    slow_clock clock_1hz(.clk(clk), .max_counts(50_000_000), .new_clk(clk_1hz));
    wire clk_2hz;
    slow_clock clock_2hz(.clk(clk), .max_counts(25_000_000), .new_clk(clk_2hz));
    
    reg [3:0] state = 0;
    reg active = 0;
    reg btn_pressed = 0;
    reg ready = 0;
    
    reg [1:0] stateC = 0;
    reg moving_right = 0 ;    
    
    
    always @ (posedge clk)
    begin
        //subtask A
        if (btnU && btnD) begin
            an[3:0] = 4'b0000;
            seg = 7'b101_0010;
            dp = 1;
        end
        else if (btnU) begin
            an[3:0] = 4'b1100;
            seg = 7'b101_0010;
            dp = 1;
        end
        else if (btnD) begin
            an[3:0] = 4'b0011;
            seg = 7'b101_0010;
            dp = 1;
        end
        else begin
            an[3:0] = 4'b1111;
            seg[6:0] = 7'b1111111;
            dp = 1;
        end
            
        // subtask B
        if (sw[0] && sw[7] && sw[8] && sw[15]) begin
           active = 1;     
        end
        else begin
            active = 0;
        end
        
        if (btnR) btn_pressed = 1; // flag to start the infinite loop
        
        if (active) begin
            if (state == 0) begin
                // base set up
                led[11:0] = 12'b111_011100_111; 
            end
            else if (state == 1) begin
                // base set up
                led[11:0] = 12'b111_001110_111;
            end
            else if (state == 2) begin
                // base set up
                led[11:0] = 12'b111_000111_111;
            end
            else if (state == 3) begin
                // base set up
                led[11:0] = 12'b111_001110_111;
            end
            else if (state == 4) begin
                // base set up
                led[11:0] = 12'b111_011100_111;
            end
            else if (state == 5) begin
                // base set up
                led[11:0] = 12'b111_111000_111;
            end
        end
        else led = 0; //turn off all led
        
        // subtask C
        if (btnC) begin
            led[12] = clk_2p25hz;
            led[15] = clk_2p25hz;
            
            if (stateC == 0) begin
                an[3:0] = 4'b1110;
                seg[6:0] = 7'b1110110;
                if (~(btnU || btnD))dp = 0;
            end
            else if (stateC == 1) begin
                an[3:0] = 4'b1101;
                seg[6:0] = 7'b1110110;
                if (~(btnU || btnD)) dp = 0;
            end
            else if (stateC == 2) begin
                an[3:0] = 4'b1011;
                seg[6:0] = 7'b1110110;
                if (~(btnU || btnD)) dp = 0;
            end
            else if (stateC == 3) begin
                an[3:0] = 4'b0111;
                seg[6:0] = 7'b1110110;
                if (~(btnU || btnD)) dp = 0;
            end
        end
        else begin
            led[12] = 0;
            led[15] = 0;
        end
    end
    
    // change state at a rate of 0.5s
    always @ (posedge clk_2hz)
    begin
        // move at 0.5s
        if (active && btn_pressed && (state == 0 || state == 1 || state == 5)) begin
            moving_right <= 1;
            state <= (state == 5) ? 0: state + 1;
        end
        else begin
            moving_right <= 0;
            // state is 2 3 4
            if (active && btn_pressed && ready) begin
                state <= (state == 5) ? 0: state + 1;
            end
            ready <= ~ready;
            
        end
    end
    
    always @ (posedge clk_3hz) begin
        // if led moving right,  counter clockwise
        if (moving_right) begin
            stateC <= (stateC == 0) ? 3 : stateC - 1;
        end 
        else begin // led moving left, clockwise
            stateC <= (stateC == 3) ? 0 : stateC + 1;
        end
    end
    
endmodule

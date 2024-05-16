`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2024 16:56:06
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
    input [2:0]sw, 
    input sw15,
    input btnL, btnD, btnC,
    
    output reg [15:0] led = 0,
    output reg [3:0] an = 4'b1111,
    output reg [6:0] seg = 7'b1111111
    );
    
    // 1st rightmost = 0: 0.20s --> 5Hz. led0 to led14. Counter to count up to 15
    reg [3:0] counter_4bits = -1;
    
    // registers for moving 7 segment
    reg [1:0] rotation_state = 0;
    reg [25:0]counter_7segment = 1; // subtask C posedge of 1Hz, 10Hz, 100Hz
    reg [25:0]max_cycle_7segment = 1; // 50M, 5M, 500k
    
    // slow clocks
    slow_clk_1hz c1(clk, slow_clock_1hz);
    slow_clk_5hz c5(clk, slow_clock_5hz);
    slow_clk_10hz c10(clk, slow_clock_10hz);
    slow_clk_100hz c100(clk, slow_clock_100hz);
    slow_clk_3s c3s(clk, slow_clk_3sec);
    
    // subtask D
    reg [1:0]counterA = 0;
    reg interrupt = 0;
    reg is_rotate = 0;
    reg alphabet_ready = 0;
    reg resume_program = 0;
    reg activated = 0;
    reg [29:0]counter_30bits = 1;

    
    always @(negedge slow_clock_5hz)
    begin
        counter_4bits <= counter_4bits + 1;
    end
    
    always @(posedge clk)
    begin
        if (interrupt) begin
            counter_30bits <= ( counter_30bits == 300_000_000 - 1) ? 0 : counter_30bits + 1;
            if (counter_30bits == 0) begin 
                alphabet_ready = 1;
            end
        end
        else begin 
            alphabet_ready = 0;
            counter_30bits = 1;
        end
            
        // after all leds light up
        if (led[14:3] == 12'b1111_1111_1111) begin
            //////// buttons logic ////////
            // light up the first character, 2nd rightmost = 6 : l -> d -> c
            if (counterA == 2'b00 && ~is_rotate) begin
                // letter L pos 1, counterA = 0
                an[3:0] = 4'b1110;
                seg[6:0] = 7'b1001111;
                
                if ( btnL && ~led[15] )begin // if display letter L, press buttonL, change to display letter D
                    an[3:0] = 4'b1101;
                    seg[6:0] = 7'b0100001;
                    counterA = counterA + 1;
                end
            end
            // moving display with buttons
            else if ( counterA == 2'b01 && ~is_rotate) begin
                // letter D pos 2, counterA = 1
                an[3:0] = 4'b1101;
                seg[6:0] = 7'b0100001;
                if ( (btnD) && led[15]==0 )begin
                    // change to c pos 3
                    an[3:0] = 4'b1011;
                    seg[6:0] = 7'b0100111;
                    counterA = counterA + 1;
                end
            end
            else if ( counterA == 2'b10 && ~is_rotate) begin // if display letter D, press buttonD, change to display letter C
                // letter C pos 3, letter_state = 2
                if (led[15] == 0) begin
                    an[3:0] = 4'b1011;
                    seg[6:0] = 7'b0100111;
                end
                if ( (btnC)) begin
                    // letter L pos 1
                    an[3:0] = 4'b1110;
                    seg[6:0] = 7'b1001111;
                    counterA = 0; // make it rollover to 0, so display L
                    led[15] = 1;
                    activated = 1;
                end
            end
            
            //////// switch controlling frequency logic + activated mode ////////
            if (sw[2] == 1'b1) begin// == (sw = 3'b1xx)
                led[2] = slow_clock_100hz;
                led[1] <= 1;
                led[0] <= 1;
                resume_program = 0;
                
                if (led[15]) begin // in activated mode
                    is_rotate = 1;
                    max_cycle_7segment = 500_000; // 5M cycles for 10Hz signal
                    if (rotation_state == 2'b00) begin
                        // letter L pos 1
                        an[3:0] = 4'b1110;
                        seg[6:0] = 7'b1001111;
                    end 
                    else if (rotation_state == 2'b01) begin
                        // letter D pos 2
                        an[3:0] = 4'b1101;
                        seg[6:0] = 7'b0100001;
                    end
                    else if (rotation_state == 2'b10) begin
                        // letter C pos 3
                        an[3:0] = 4'b1011;
                        seg[6:0] = 7'b0100111;;
                    end
                    
                end
                
            end
            else if (sw[1] == 1'b1) begin
                led[1] = slow_clock_10hz;
                led[2] <= 1;
                led[0] <= 1;
                resume_program = 0;
                
                if (led[15]) begin // in activated mode
                    is_rotate = 1;
                    max_cycle_7segment = 5_000_000; // 5M cycles for 10Hz signal
                    if (rotation_state == 2'b00) begin
                        // letter L pos 1
                        an[3:0] = 4'b1110;
                        seg[6:0] = 7'b1001111;
                    end 
                    else if (rotation_state == 2'b01) begin
                        // letter D pos 2
                        an[3:0] = 4'b1101;
                        seg[6:0] = 7'b0100001;
                    end
                    else if (rotation_state == 2'b10) begin
                        // letter C pos 3
                        an[3:0] = 4'b1011;
                        seg[6:0] = 7'b0100111;;
                    end
                    
                end
                                
            end
            else if (sw[0] == 1'b1) begin
                led[0] = slow_clock_1hz;
                led[1] <= 1;
                led[2] <= 1;
                resume_program = 0;
                
                if ((led[15] == 1'b1)) begin // in activated mode
                    is_rotate = 1;
                    
                    max_cycle_7segment = 50_000_000; // 50M cycles for 1Hz signal
                    if (rotation_state == 2'b00) begin
                        // letter L pos 1
                        an[3:0] = 4'b1110;
                        seg[6:0] = 7'b1001111;
                    end 
                    else if (rotation_state == 2'b01) begin
                        // letter D pos 2
                        an[3:0] = 4'b1101;
                        seg[6:0] = 7'b0100001;
                    end
                    else if (rotation_state == 2'b10) begin
                        // letter C pos 3
                        an[3:0] = 4'b1011;
                        seg[6:0] = 7'b0100111;;
                    end
                    
                end

            end
            
            else if (sw == 3'b000) begin
                led[0] <= 1;
                led[1] <= 1;
                led[2] <= 1;
                if (resume_program && activated) begin
                    if (rotation_state == 2'b00) begin
                        // letter L pos 1
                        an[3:0] = 4'b1110;
                        seg[6:0] = 7'b1001111;
                    end 
                    else if (rotation_state == 2'b01) begin
                        // letter D pos 2
                        an[3:0] = 4'b1101;
                        seg[6:0] = 7'b0100001;
                    end
                    else if (rotation_state == 2'b10) begin
                        // letter C pos 3
                        an[3:0] = 4'b1011;
                        seg[6:0] = 7'b0100111;;
                    end
                end
                if (led[15] == 1) begin
                   
                    max_cycle_7segment = 0; // pause display when all switches are off
                end
            end
            
        end
        
        // Logic light up led incrementally
        else if (counter_4bits == 4'b0000 && ~sw15)
            led[0] <= 1;
        else if (counter_4bits == 4'b0001 && ~sw15)
            led[1] <= 1;
        else if (counter_4bits == 4'b0010 && ~sw15)
            led[2] <= 1;
        else if (counter_4bits == 4'b0011 && ~sw15)
            led[3] <= 1;
        else if (counter_4bits == 4'b0100 && ~sw15)
            led[4] <= 1;
        else if (counter_4bits == 4'b0101 && ~sw15)
            led[5] <= 1;
        else if (counter_4bits == 4'b0110 && ~sw15)
            led[6] <= 1;
        else if (counter_4bits == 4'b0111 && ~sw15)
            led[7] <= 1;
        else if (counter_4bits == 4'b1000 && ~sw15)
            led[8] <= 1;
        else if (counter_4bits == 4'b1001 && ~sw15)
            led[9] <= 1;
        else if (counter_4bits == 4'b1010 && ~sw15)
            led[10] <= 1;
        else if (counter_4bits == 4'b1011 && ~sw15)
            led[11] <= 1;
        else if (counter_4bits == 4'b1100 && ~sw15)
            led[12] <= 1;
        else if (counter_4bits == 4'b1101 && ~sw15)
            led[13] <= 1;
        else if (counter_4bits == 4'b1110 && led[13] == 1 && ~sw15) // make sure led14 only turns on after led 13
            led[14] <= 1;
            
        // Subtask C: activated mode, moving 7 segment display
        if ( (led[15] == 1) && (max_cycle_7segment > 0) ) begin
            // counter for moving 7segment 
            counter_7segment <= (counter_7segment == max_cycle_7segment - 1) ? 0 : counter_7segment + 1;
            if (counter_7segment == 0 && ~resume_program) begin
                if (rotation_state == 2'b10)
                    rotation_state = rotation_state + 2; // 3 possible states, 0, 1, 2. When 2, roll over to 1
                else
                    rotation_state = rotation_state + 1;
            end
        end
        
        // Subtask D
        if (sw15) begin
            interrupt = 1;
            // subtask d - show 54460 for led and J for all 4
            if ( alphabet_ready ) begin
                led[15:0] <= 16'b0000_0000_0111_0001;
                an[3:0] <= 4'b0000;
                seg[6:0] <= 7'b1100001;
            end
        end
        else if (~sw15 && interrupt) begin
            interrupt = 0;
            resume_program = 1;
            
            if (activated)
                led[15:0] <= 16'b1111_1111_1111_1111;
            else
                led[14:0] <= 15'b1111_1111_1111_111;
        end
        
    end
   
    
   
endmodule

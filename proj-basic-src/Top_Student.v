`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Manimaran Pradeep 
//  STUDENT B NAME: Charlyn Kwan
//  STUDENT C NAME: Nikhil Babu
//  STUDENT D NAME: Leow Kai Jie 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    input btnC, btnU, btnL, btnR, btnD,
    inout PS2Clk,
    inout PS2Data,
    output [15:0] led,
    output [7:0] JC,
    output [7:0] seg,
    output [3:0] an
);
    // OLED display
    wire [31:0] max_counts_6p25MHz = 8;
    slow_clock slow_clock_6p25MHz(.clk(clk), .max_counts(max_counts_6p25MHz), .new_clk(clock_6p25M));
    wire frame_beg, send_pix, sample_pix;
    wire [15:0] pix_data;
    
    wire [12:0] pix_index;
    
    // main code
    mux_4_to_1 my_mux (clk, sw, btnC, btnU, btnL, btnR, btnD, PS2Clk, PS2Data, pix_index, led, pix_data, seg, an);
    
    
    Oled_Display oled(
        .clk(clock_6p25M), 
        .reset(0), 
        .frame_begin(frame_beg), 
        .sending_pixels(send_pix),
        .sample_pixel(sample_pix), 
        .pixel_index(pix_index), 
        .pixel_data(pix_data), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    


endmodule
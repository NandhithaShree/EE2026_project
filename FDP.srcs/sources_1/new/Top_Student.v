`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input basys_clock,
    output [7:0] JB
);

    wire clock_6p25MHz;
    wire clock_25MHz;
            
    Clock slow_clock_6p25MHz (basys_clock, 7, clock_6p25MHz);
    Clock slow_clock_25MHz (basys_clock, 2, clock_25MHz);
    
    wire fb;
    wire [12:0] pixel_index;
    wire sending_pixel;
    wire sample_pixel;

    reg [15:0] oled_data = 16'b11111_000000_00000;

    Oled_Display oled (
        .clk(clock_6p25MHz), 
        .reset(0), 
        .frame_begin(fb), 
        .sending_pixels(sending_pixel),
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index),
        .pixel_data(oled_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]),
        .pmoden(JB[7])
    );

endmodule
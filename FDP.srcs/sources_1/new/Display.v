`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:03:20 PM
// Design Name: 
// Module Name: Display
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


module Display(
    input basys_clock,
    input [15:0] oled_data,
    output [6:0] x, y,
    output [7:0] JB,
    output hsync, vsync,
    output [11:0] vga_data
);
//    wire clock_6p25MHz;
//    Clock slow_clock_6p25MHz (basys_clock, 7, clock_6p25MHz);
    
//    wire fb, sending_pixel, sample_pixel;
    
//    wire [12:0] pixel_index;
//    Pixel_Coordinates coords(pixel_index, x, y);
    
//    Oled_Display oled (
//        .clk(clock_6p25MHz), 
//        .reset(0), 
//        .frame_begin(fb), 
//        .sending_pixels(sending_pixel),
//        .sample_pixel(sample_pixel), 
//        .pixel_index(pixel_index),
//        .pixel_data(oled_data), 
//        .cs(JB[0]), 
//        .sdin(JB[1]), 
//        .sclk(JB[3]), 
//        .d_cn(JB[4]), 
//        .resn(JB[5]), 
//        .vccen(JB[6]),
//        .pmoden(JB[7])
//    );
        
    
    
    wire video_on, p_tick;
    wire [9:0] vga_x, vga_y;
    
    assign x = vga_x / 7;
    assign y = (vga_y - 20) / 7;

    VGA_Sync vga_sync_unit (
       .clk(basys_clock),
       .reset(0),
       .hsync(hsync),
       .vsync(vsync),
       .video_on(video_on),
       .p_tick(p_tick),
       .x(vga_x),
       .y(vga_y)
    );

    wire [11:0] rgb_mapped; //map colour
    VGA_colour_mapping colour_mapper (
        .oled_data(oled_data),
        .vga_data(rgb_mapped)
    );

    assign vga_data = video_on ? rgb_mapped : 12'h000; //assign 
    

endmodule

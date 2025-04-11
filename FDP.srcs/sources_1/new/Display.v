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


module VGA_Display(
    input basys_clock,
    input [15:0] oled_data,
    output [6:0] x, y,
    output hsync, vsync,
    output [11:0] vga_data
);    
    wire video_on, p_tick;
    wire [9:0] vga_x, vga_y;
    
    assign x = vga_x / 7;
    assign y = (vga_y - 1) / 7;

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

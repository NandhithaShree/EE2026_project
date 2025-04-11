`timescale 1ns / 1ps
`include "Constants.vh"

module Dead_Piece_Display (
    input basys_clock,
    // Captured pieces counters
    input [3:0] W_dead_pawns,
    input [3:0] B_dead_pawns,
    input [3:0] W_dead_queens,
    input [3:0] B_dead_queens,
    input [3:0] W_dead_rooks,
    input [3:0] B_dead_rooks,
    input [3:0] W_dead_bishops,
    input [3:0] B_dead_bishops,
    input [3:0] W_dead_knights,
    input [3:0] B_dead_knights,
    // OLED display interface
    output [7:0] JC
);
    // Generate 6.25MHz clock for OLED operation
    wire clock_6p25MHz;
    Clock slow_clock_6p25MHz (basys_clock, 7, clock_6p25MHz);
    
    // OLED control signals
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [6:0] pixel_x, pixel_y;
    wire in_bounds;
    wire [15:0] oled_data;
    
    // Convert pixel_index to x,y coordinates for rendering
    Pixel_Coordinates pixel_coords_inst(
        .pixel_index(pixel_index),
        .x(pixel_x),
        .y(pixel_y)
    );
    
    // OLED display signal generation - connects to JC port
    Oled_Driver oled_display_inst (
        .clk(clock_6p25MHz), 
        .reset(0), 
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index),
        .pixel_data(oled_data), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    // Dead pieces rendering module
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (
        .x(pixel_x), 
        .y(pixel_y), 
        .grid_x(grid_x), 
        .grid_y(grid_y)
    );
    
    // Main render module for dead pieces
    Dead_Piece_Render dead_pieces_renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .W_dead_pawns(W_dead_pawns),
        .B_dead_pawns(B_dead_pawns),
        .W_dead_queens(W_dead_queens),
        .B_dead_queens(B_dead_queens),
        .W_dead_rooks(W_dead_rooks),
        .B_dead_rooks(B_dead_rooks),
        .W_dead_bishops(W_dead_bishops),
        .B_dead_bishops(B_dead_bishops),
        .W_dead_knights(W_dead_knights),
        .B_dead_knights(B_dead_knights),
        .oled_data(oled_data)
    );
    
endmodule
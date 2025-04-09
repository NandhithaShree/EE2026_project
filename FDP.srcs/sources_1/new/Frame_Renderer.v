`timescale 1ns / 1ps
`include "Constants.vh"

module Frame_Renderer (
    input [6:0] pixel_x, pixel_y,
    input [3071:0] FRAME,
    output reg [15:0] oled_data        
);
    
    localparam H_START = 16;  // Starting X position (centered on 96-pixel wide display)
    localparam V_START = 0;   // Starting Y position
    localparam SCALE = 2;     // Each bit of the frame is displayed as 2x2 pixels
    
    // Determine if pixel is within the display area
    wire in_bounds = (pixel_x >= H_START && pixel_x < H_START + 32*SCALE && 
                     pixel_y < 32*SCALE);
                     
    // Calculate scaled indices for the 32x32 FRAME
    wire [4:0] scaled_x = (pixel_x - H_START) / SCALE;
    wire [4:0] scaled_y = pixel_y / SCALE;
    
    // Calculate the frame index with horizontal flip
    wire [9:0] frame_index = (31 - scaled_y) * 32 + (31 - scaled_x);   
        
    always @(pixel_x, pixel_y) begin 
        if (in_bounds) begin
            oled_data = (FRAME[frame_index*3+:3] == B) ? BLACK:
                        (FRAME[frame_index*3+:3] == W) ? WHITE:
                        (FRAME[frame_index*3+:3] == G) ? LIGHT_GREEN:
                        (FRAME[frame_index*3+:3] == P) ? LIGHT_PINK:
                        (FRAME[frame_index*3+:3] == R) ? DIRT_RED:
                        GREY;
        end
    end
endmodule
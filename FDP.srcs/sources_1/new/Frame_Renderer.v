`timescale 1ns / 1ps
`include "Constants.vh"

module Frame_Renderer (
    input [6:0] pixel_x, pixel_y,
    input [3071:0] FRAME,
    input hover_restart,
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
    wire [10:0] frame_index = ((31 - scaled_y) * 32 + (31 - scaled_x)) * 2;  
    wire [1:0] pixel_color = FRAME[frame_index +: 3];
        
    always @(pixel_x, pixel_y) begin 
        if (in_bounds)
            case (pixel_color)
                B: oled_data = BLACK;
                W: oled_data = WHITE;
                G: oled_data = LIGHT_GREEN;
                P: oled_data = LIGHT_PINK;
                R: oled_data = DIRT_RED;
                S: oled_data = GREY;
                H: oled_data = hover_restart ? LIGHT_BROWN : WHITE;
                default: oled_data = BLACK;  // fallback
            endcase
        else
            oled_data = BLACK;
    end
endmodule
`timescale 1ns / 1ps
`include "Constants.vh"

module Frame_Renderer (
    input [6:0] pixel_x, pixel_y,
    input [4095:0] FRAME,
    input hover,
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
    wire [3:0] pixel_color = FRAME[frame_index*4 +: 4];   
        
    always @(pixel_x, pixel_y) begin 
        if (in_bounds)
            case (pixel_color)
                B: oled_data = BLACK;
                W: oled_data = WHITE;
                G: oled_data = LIGHT_GREEN;
                P: oled_data = LIGHT_PINK;
                R: oled_data = DIRT_RED;
                S: oled_data = GREY;
                H: oled_data = hover ? DARK_BROWN_SCREEN_VGA : WHITE;
                LG: oled_data = LIGHT_GREEN_SCREEN;
                DG: oled_data = DARK_GREEN_SCREEN;
                GG: oled_data = GREEN_GREEN_SCREEN;
                DB: oled_data = DARK_BROWN_SCREEN;
                LB: oled_data = LIGHT_BROWN_SCREEN;
                default: oled_data = BLACK;  // fallback
            endcase
        else
            oled_data = BLACK;
    end
endmodule
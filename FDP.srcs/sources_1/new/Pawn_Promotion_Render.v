`timescale 1ns / 1ps

module Promotion_Renderer(
    input [6:0] pixel_x, pixel_y,
    input [1:0] selected_promotion_piece,
    output reg [15:0] oled_data
);

    parameter W = 2'b00;
    parameter B = 2'b01;
    parameter G = 2'b10;
    
    parameter WHITE = 16'hFFFF;
    parameter BLACK = 16'h0000;
    parameter GREEN = 16'h07E0;     

    parameter [2047:0] PAWN_PROMOTION = {
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, B, B, B, B, W, W, B, B, W, W, B, W, W, W, B, W, B, W, W, W, B, W, W, W, W, W, 
        W, W, W, W, W, W, B, W, W, B, W, B, W, W, B, W, B, W, W, W, B, W, B, B, W, W, B, W, W, W, W, W, 
        W, W, W, W, W, W, B, B, B, B, W, B, B, B, B, W, B, W, B, W, B, W, B, W, B, W, B, W, W, W, W, W, 
        W, W, W, W, W, W, B, W, W, W, W, B, W, W, B, W, B, B, W, B, B, W, B, W, W, B, B, W, W, W, W, W, 
        W, W, W, W, W, W, B, W, W, W, W, B, W, W, B, W, B, W, W, W, B, W, B, W, W, W, B, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, B, B, B, B, W, B, B, B, W, W, B, B, B, W, B, W, W, W, B, W, B, B, B, W, B, B, B, W, B, B, W, 
        W, B, W, W, B, W, B, W, W, B, W, B, W, B, W, B, B, W, B, B, W, B, W, B, W, W, B, W, W, B, W, W, 
        W, B, B, B, B, W, B, B, B, W, W, B, W, B, W, B, W, B, W, B, W, B, W, B, W, W, B, W, W, B, B, W, 
        W, B, W, W, W, W, B, W, B, W, W, B, W, B, W, B, W, W, W, B, W, B, W, B, W, W, B, W, W, B, W, W, 
        W, B, W, W, W, W, B, W, W, B, W, B, B, B, W, B, W, W, W, B, W, B, B, B, W, W, B, W, W, B, B, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        G, B, G, B, B, G, B, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, 
        G, G, B, B, B, B, G, G, G, B, G, B, B, G, B, G, G, G, G, B, B, G, G, G, G, G, B, B, B, B, G, G, 
        G, G, B, B, B, B, G, G, G, B, B, B, B, B, B, G, G, G, B, B, B, B, G, G, G, B, B, B, B, B, B, G, 
        G, G, G, B, B, G, G, G, G, G, B, B, B, B, G, G, G, G, G, B, B, G, G, G, G, G, G, B, B, B, B, G, 
        G, G, G, B, B, G, G, G, G, G, B, B, B, B, G, G, G, G, G, B, B, G, G, G, G, G, B, B, B, B, G, G, 
        G, G, B, B, B, B, G, G, G, B, B, B, B, B, B, G, G, G, G, B, B, G, G, G, G, B, B, B, B, B, B, G, 
        G, B, B, B, B, B, B, G, G, B, B, B, B, B, B, G, G, G, B, B, B, B, G, G, G, B, B, B, B, B, B, G, 
        G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, 
        W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W
    };
    
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
    wire [1:0] pixel_color = PAWN_PROMOTION[frame_index +: 2];
    
    wire [2:0] x, y;
    assign x = (pixel_x / 8) - 2;
    assign y = pixel_y / 8;
        
    always @ (pixel_x, pixel_y) begin 
        if (in_bounds)
            case (pixel_color)
                B: oled_data = BLACK;
                W: oled_data = WHITE;
                G: begin
                    if ((x == 0 || x == 1) && selected_promotion_piece == 2'b00) oled_data = GREEN;
                    else if ((x == 2 || x == 3) && selected_promotion_piece == 2'b01) oled_data = GREEN;
                    else if ((x == 4 || x == 5) && selected_promotion_piece == 2'b10) oled_data = GREEN;
                    else if ((x == 6 || x == 7) && selected_promotion_piece == 2'b11) oled_data = GREEN;
                    else oled_data = LIGHT_BROWN;
                end
                default: oled_data = BLACK;  // fallback
            endcase
        else
            oled_data = BLACK;
    end

endmodule
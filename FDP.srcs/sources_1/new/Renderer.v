`timescale 1ns / 1ps
`include "Constants.vh"

module Renderer(
    input basys_clock,
    input [6:0] pixel_x, pixel_y,
    input [6:0] selected_x, selected_y,
    input [6:0] current_x, current_y,
    input [3:0] piece,
    output reg [15:0] oled_data
);
    wire is_piece;

    Piece_Render (
        .basys_clock(basys_clock),
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece)
    );
    
    wire [15:0] bg_oled;
    
    Background_Render background_render_inst (
        .basys_clock(basys_clock),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .oled_data(bg_oled)
    );
    
    wire [4:0] grid_x, grid_y;
    wire out_of_bounds;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y, out_of_bounds);
    
    always @ (posedge basys_clock) begin
       if (is_piece) begin
            if (piece[3] == 1)
                oled_data <= WHITE;
            else
                oled_data <= BLACK;
        end else begin
            oled_data <= bg_oled;
        end
    end
endmodule

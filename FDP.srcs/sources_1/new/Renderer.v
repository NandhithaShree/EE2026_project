`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 21:21:41
// Design Name: 
// Module Name: Renderer
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

`include "Constants.vh"

module Renderer(
    input basys_clock,
    input [255:0] board,
    input [63:0] moves,
    input [6:0] pixel_x, pixel_y,
    input [3:0] selected_x, selected_y,
    input [3:0] current_x, current_y,
    input [3:0] king_piece,
    input is_threatening_king,
    input is_promotion,
    input [1:0] selected_promotion_piece,
    output reg [15:0] oled_data
);

    wire is_piece;
    wire [3:0] piece;
    Piece_Render piece_render_inst (
        .basys_clock(basys_clock),
        .board(board),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece),
        .piece(piece)
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
    
    wire [15:0] promotion_selection_oled;
    Pawn_Promotion_Render (
        .basys_clock(basys_clock),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_promotion_piece(selected_promotion_piece),
        .oled_data(promotion_selection_oled)
    );
    
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    wire [3:0] x_pos, y_pos;
    assign x_pos = pixel_x % 8;
    assign y_pos = pixel_y % 8;
    
    always @ (posedge basys_clock) begin
        if (is_promotion)
            oled_data = promotion_selection_oled;
        else if (grid_x != NULL) begin
            if (is_piece) begin
                if (piece[3] == 1)
                    oled_data <= WHITE;
                else
                    oled_data <= BLACK;
            end else begin
                if (moves[grid_y * 8 + grid_x]) begin
                    if ((x_pos - 3) ** 2 + (y_pos - 3) ** 2 <= 6)
                        oled_data <= BLUE;
                    else
                        oled_data <= bg_oled;
                end else begin
                    if (piece == king_piece && is_threatening_king)
                        oled_data <= RED;
                    else
                        oled_data <= bg_oled;
                end
            end
        end else begin
            oled_data <= BLACK;
        end
    end

endmodule

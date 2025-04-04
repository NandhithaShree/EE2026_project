`timescale 1ns / 1ps
`include "Constants.vh"

module Renderer(
    input [255:0] board,
    input [63:0] moves,
    input [6:0] pixel_x, pixel_y,
    input [3:0] selected_x, selected_y,
    input [3:0] current_x, current_y,
    input [1:0] selected_promotion_piece,
    input [2:0] state,
    output reg [15:0] oled_data
);
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    wire [15:0] game_oled;
    Game_Renderer (
        .board(board),
        .moves(moves),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .oled_data(game_oled)
    );
    wire [15:0] promotion_oled;
    Promotion_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_promotion_piece(selected_promotion_piece),
        .oled_data(promotion_oled)
    );

    wire [15:0] start_oled;

    wire [15:0] end_oled;

    always @ (*) begin
        if (grid_x == NULL || grid_y == NULL) begin
            oled_data = BLACK;
        end
        else begin
            case(state)
                START_GAME: oled_data = game_oled;
                GAME: oled_data = game_oled;
                PROMOTION: oled_data = promotion_oled;
                REMOTE_MOVE: oled_data = game_oled;
                END_GAME: oled_data = game_oled;
            endcase
        end
    end
endmodule

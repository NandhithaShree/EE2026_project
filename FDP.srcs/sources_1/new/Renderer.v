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
    output reg [15:0] oled_data
);
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    wire [15:0] game_oled;
    Game_Renderer (
        .board(board),
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
        . oled_data(game_oled)
    );

    wire [15:0] start_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(GAME_START),
        .oled_data(start_oled)
    );
    
    wire [15:0] white_win_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(WHITE_WINS),
        .oled_data(white_win_oled)
    );
    
    
    wire [15:0] black_win_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(BLACK_WINS),
        .oled_data(black_win_oled)
    );
    

    always @ (*) begin
        if (grid_x == NULL || grid_y == NULL) begin
            oled_data = BLACK;
        end
        else begin
            case(state)
                START_GAME: oled_data = white_win_oled;//start_oled;
                PLAYER_TURN, ENEMY_TURN: oled_data = black_win_oled;//start_oled;
                PROMOTION: oled_data = game_oled;
                WHITE_WIN: oled_data = white_win_oled;
                BLACK_WIN: oled_data = black_win_oled;
            endcase
        end
    end
endmodule

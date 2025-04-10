`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 15:41:45
// Design Name: 
// Module Name: oled_render
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


`timescale 1ns / 1ps
`include "Constants.vh"

module oled_Renderer(
    input [255:0] board,
    input [63:0] moves,
    input [11:0] mouse_xpos, mouse_ypos,
    input hover_start,
    input hover_restart,
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
    oled_Game_Renderer (
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
        .oled_data(game_oled)
    );
    
//    wire [15:0] promotion_oled;
//    Promotion_Renderer (
//        .pixel_x(pixel_x),
//        .pixel_y(pixel_y),
//        .selected_promotion_piece(selected_promotion_piece),
//        .oled_data(promotion_oled)
//    );

    wire [15:0] start_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(GAME_START),
        .hover(hover_start),
        .oled_data(start_oled)
    );
    
    wire [15:0] white_win_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(WHITE_WINS),
        .hover(hover_restart),
        .oled_data(white_win_oled)
    );
    
    
    wire [15:0] black_win_oled;
    Frame_Renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(BLACK_WINS),
        .hover(hover_restart),
        .oled_data(black_win_oled)
    );
    
    wire [15:0] mouse_oled;
    Mouse_Renderer (
        .xpos(mouse_xpos),
        .ypos(mouse_ypos),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .oled_data(mouse_oled)
    );
    

    always @ (*) begin
        if (grid_x == NULL || grid_y == NULL) begin
            oled_data = BLACK;
        end
        else if (mouse_oled != 16'h0001) begin
            oled_data = mouse_oled;
        end
        else begin
            case(state)
                START_GAME: oled_data = start_oled;//start_oled;
                PLAYER_TURN, ENEMY_TURN: oled_data = game_oled;
                PROMOTION: oled_data = game_oled;
                WHITE_WIN: oled_data = white_win_oled;
                BLACK_WIN: oled_data = black_win_oled;
            endcase
        end
    end
endmodule

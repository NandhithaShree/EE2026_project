`timescale 1ns / 1ps
`include "Constants.vh"

module Dead_Piece_Render (
    input [6:0] pixel_x, pixel_y,
    input [3:0] grid_x, grid_y,
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
    reg [5:0] i, w_idx, b_idx;
    reg [255:0] dead_board;
    
    // Create a board representation of dead pieces
    always @(*) begin
       w_idx = 0;
       // Index for black (fills from 0 up)  
       b_idx = 63;
       dead_board = {64{EMPTY}};
       
       // Black Pawns
       for (i = 0; i < 8; i = i + 1) begin
           if (i < B_dead_pawns) begin
               dead_board[(b_idx*4) +: 4] = B_PAWN;
               b_idx = b_idx - 1;
           end
       end
       
       // Black Bishops
       for (i = 0; i < 2; i = i + 1) begin
           if (i < B_dead_bishops) begin
               dead_board[(b_idx*4) +: 4] = B_BISHOP;
               b_idx = b_idx - 1;
           end
       end
       
       // Black Rooks
       for (i = 0; i < 2; i = i + 1) begin
           if (i < B_dead_rooks) begin
               dead_board[(b_idx*4) +: 4] = B_ROOK;
               b_idx = b_idx - 1;
           end
       end
       
       // Black Knights
       for (i = 0; i < 2; i = i + 1) begin
           if (i < B_dead_knights) begin
               dead_board[(b_idx*4) +: 4] = B_KNIGHT;
               b_idx = b_idx - 1;
           end
       end
       
       // Black Queens
       for (i = 0; i < 1; i = i + 1) begin
           if (i < B_dead_queens) begin
               dead_board[(b_idx*4) +: 4] = B_QUEEN;
               b_idx = b_idx - 1;
           end
       end

       // White pawns
       for (i = 0; i < 8; i = i + 1) begin
           if (i < W_dead_pawns) begin
               dead_board[(w_idx*4) +: 4] = W_PAWN;
               w_idx = w_idx + 1;
           end
       end
       // White bishops
       for (i = 0; i < 2; i = i + 1) begin
           if (i < W_dead_bishops) begin
               dead_board[(w_idx*4) +: 4] = W_BISHOP;
               w_idx = w_idx + 1;
           end
       end
       // White rooks
       for (i = 0; i < 2; i = i + 1) begin
           if (i < W_dead_rooks) begin
               dead_board[(w_idx*4) +: 4] = W_ROOK;
               w_idx = w_idx + 1;
           end
       end
       // White knights
       for (i = 0; i < 2; i = i + 1) begin
           if (i < W_dead_knights) begin
               dead_board[(w_idx*4) +: 4] = W_KNIGHT;
               w_idx = w_idx + 1;
           end
       end
       // White queens
       for (i = 0; i < 1; i = i + 1) begin
           if (i < W_dead_queens) begin
               dead_board[(w_idx*4) +: 4] = W_QUEEN;
               w_idx = w_idx + 1;
           end
       end
    end
    
    wire is_piece;
    wire [3:0] piece;
    Piece_Render piece_render_inst (
        .board(dead_board),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece),
        .piece(piece)
    );
    

    wire [15:0] bg_oled;
    Frame_Renderer frame_render_inst (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .FRAME(DEAD_SCREEN),
        .hover(1'b0),
        .oled_data(bg_oled)
    );
    
    always @(*) begin
        if (pixel_x != NULL) begin
            if (is_piece) begin
                if (piece[3] == 1) begin
                    oled_data = WHITE;
                end
                else begin
                    oled_data = BLACK;
                end
            end
            else begin
                    oled_data = bg_oled;
            end
        end else begin
            oled_data = BLACK;
        end
    end
endmodule
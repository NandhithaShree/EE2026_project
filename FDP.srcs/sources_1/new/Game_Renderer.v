`timescale 1ns / 1ps
`include "Constants.vh"

module Game_Renderer (
    input [255:0] board,
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
    integer i, idx;
    reg [255:0] dead_board;
    
    always @(*) begin
       // Initialize dead_board with EMPTYs
       dead_board = {64{EMPTY}};
       // Index for black (fills from 0 up)  
       idx = 56;  
       for (i = 0; i < B_dead_pawns; i = i + 1) begin  
           dead_board[(idx*4) +: 4] = B_PAWN;
           if(idx == 63) begin
                idx = 47;
           end  
           idx = idx + 1;  
       end  
       for (i = 0; i < B_dead_bishops; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = B_BISHOP;
           if(idx == 63) begin
                idx = 47;
           end     
           idx = idx + 1;   
       end   
       for (i = 0; i < B_dead_rooks; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = B_ROOK;
           if(idx == 63) begin
                idx = 47;
           end     
           idx = idx + 1;   
       end   
       for (i = 0; i < B_dead_knights; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = B_KNIGHT;  
           if(idx == 63) begin
                idx = 47;
           end   
           idx = idx + 1;   
       end   
       for (i = 0; i < B_dead_queens; i = i + 1) begin
           dead_board[(idx*4) +: 4] = B_QUEEN;
           if(idx == 63) begin
                idx = 47;
           end     
           idx = idx + 1;   
       end   
       // Index for white (fills from 63 down)   
       idx = 8;  
       for (i = 0; i < W_dead_pawns; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = W_PAWN;
           if(idx == 15) begin
                idx = -1;
           end   
           idx = idx + 1;   
       end   
       for (i = 0; i < W_dead_bishops; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = W_BISHOP;
           if(idx == 15) begin
                idx = -1;
           end    
           idx = idx + 1;   
       end   
       for (i = 0; i < W_dead_rooks; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = W_ROOK;
           if(idx == 15) begin
                idx = -1;
           end    
           idx = idx + 1;   
       end   
       for (i = 0; i < W_dead_knights; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = W_KNIGHT;
           if(idx == 15) begin
                idx = -1;
           end    
           idx = idx + 1;   
       end   
       for (i = 0; i < W_dead_queens; i = i + 1) begin   
           dead_board[(idx*4) +: 4] = W_QUEEN;
           if(idx == 15) begin
                idx = -1;
           end    
           idx = idx + 1;   
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
    Background_Render background_render_inst (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
//        .selected_x(selected_x),
//        .selected_y(selected_y),
//        .current_x(current_x),
//        .current_y(current_y),
        .oled_data(bg_oled)
    );
    
    always @(*) begin
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
    end
endmodule



//always @(*) begin
//       // Initialize dead_board with EMPTYs
//       dead_board = {64{EMPTY}};
//       // Index for black (fills from 0 up)  
//       idx = 15;  
//       for (i = 0; i < W_dead_pawns; i = i + 1) begin  
//           dead_board[(idx*4) +: 4] = W_PAWN;  
//           idx = idx - 1;  
//       end  
//       for (i = 0; i < W_dead_bishops; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = W_BISHOP;   
//           idx = idx - 1;   
//       end   
//       for (i = 0; i < W_dead_rooks; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = W_ROOK;   
//           idx = idx - 1;   
//       end   
//       for (i = 0; i < W_dead_knights; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = W_KNIGHT;   
//           idx = idx - 1;   
//       end   
//       for (i = 0; i < W_dead_queens; i = i + 1) begin
//           dead_board[(idx*4) +: 4] = W_QUEEN;   
//           idx = idx - 1;   
//       end   
//       // Index for white (fills from 63 down)   
//       idx = 48;  
//       for (i = 0; i < B_dead_pawns; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = B_PAWN; //changed to test!   
//           idx = idx + 1;   
//       end   
//       for (i = 0; i < B_dead_bishops; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = B_BISHOP;   
//           idx = idx + 1;   
//       end   
//       for (i = 0; i < B_dead_rooks; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = B_ROOK;   
//           idx = idx + 1;   
//       end   
//       for (i = 0; i < B_dead_knights; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = B_KNIGHT;   
//           idx = idx + 1;   
//       end   
//       for (i = 0; i < B_dead_queens; i = i + 1) begin   
//           dead_board[(idx*4) +: 4] = B_QUEEN;   
//           idx = idx + 1;   
//       end   
//    end

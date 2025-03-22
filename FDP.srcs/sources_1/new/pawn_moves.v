`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 14:10:30
// Design Name: 
// Module Name: pawn_moves
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

module pawn_moves (
    input basys_clock,
    input [255:0] board,
    input [3:0] grid_x, grid_y,
    input is_white,
    output reg [63:0] moves
);

    wire [3:0] piece_forward1, piece_forward2;
    wire [3:0] forward1_x, forward1_y, forward2_x, forward2_y;
    wire [3:0] piece_left_diag, piece_right_diag;
    wire [3:0] left_diag_x, right_diag_x, diag_y;
    
    assign forward1_x = grid_x;
    assign forward1_y = is_white ? (grid_y - 1) : (grid_y + 1);
    
    assign forward2_x = grid_x;
    assign forward2_y = is_white ? (grid_y - 2) : (grid_y + 2);
    
    assign left_diag_x  = grid_x - 1;
    assign right_diag_x = grid_x + 1;
    assign diag_y = is_white ? (grid_y - 1) : (grid_y + 1);

    // Check if the square in front is occupied
    Current_Piece piece_check1 (
        .board(board),
        .x(forward1_x),
        .y(forward1_y),
        .piece(piece_forward1)
    );

    // Check if the double move square is occupied
    Current_Piece piece_check2 (
        .board(board),
        .x(forward2_x),
        .y(forward2_y),
        .piece(piece_forward2)
    );
    
    // Check if diagonal left contains an opponent piece
    Current_Piece piece_check_left_diag (
        .board(board),
        .x(left_diag_x),
        .y(diag_y),
        .piece(piece_left_diag)
    );

    // Check if diagonal right contains an opponent piece
    Current_Piece piece_check_right_diag (
        .board(board),
        .x(right_diag_x),
        .y(diag_y),
        .piece(piece_right_diag)
    );

    always @(posedge basys_clock) begin
        moves = 64'b0;

        if (grid_y > 0 && grid_y < 7) begin
            // Normal forward move
            if (piece_forward1 == EMPTY)
                moves[forward1_y * 8 + forward1_x] = 1'b1;
                
            // Double forward move if in starting position
            if ((is_white && grid_y == 6) || (!is_white && grid_y == 1)) begin
                if (piece_forward1 == EMPTY && piece_forward2 == EMPTY) 
                    moves[forward2_y * 8 + forward2_x] = 1'b1;
            end
            
            // Diagonal captures
            if (left_diag_x >= 0 && piece_left_diag != EMPTY && piece_left_diag[3] != is_white)
                moves[diag_y * 8 + left_diag_x] = 1'b1;
                
            if (right_diag_x < 8 && piece_right_diag != EMPTY && piece_right_diag[3] != is_white)
                moves[diag_y * 8 + right_diag_x] = 1'b1;
        end
    end
endmodule

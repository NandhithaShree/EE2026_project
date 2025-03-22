`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 14:08:26
// Design Name: 
// Module Name: game_logic_mux
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


module Game_Logic(
    input basys_clock,
    input [255:0] board,
    input [3:0] grid_x, grid_y,
    output reg [63:0] moves
);

    wire [3:0] selected_piece;
    Current_Piece (board, grid_x, grid_y, selected_piece);

    wire [63:0] pawn_moves_out;
    wire [63:0] knight_moves_out;
    wire [63:0] bishop_moves_out;
    wire [63:0] rook_moves_out;
    wire [63:0] queen_moves_out;
    wire [63:0] king_moves_out;
    
    pawn_moves pawn (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .is_white(selected_piece[3]),
        .moves(pawn_moves_out)
    );
    
    knight_moves knight (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .moves(knight_moves_out),
        .selected_piece(selected_piece)
    );

    bishop_moves bishop (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .moves(bishop_moves_out),
        .selected_piece(selected_piece)
    );

    rook_moves rook (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .moves(rook_moves_out),
        .selected_piece(selected_piece)
    );

    queen_moves queen (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .moves(queen_moves_out),
        .selected_piece(selected_piece)
    );

//    king_moves king (
//        .board(board),
//        .grid_x(grid_x),
//        .grid_y(grid_y),
//        .moves(king_moves_out)
//    );

    always @ (posedge basys_clock) begin
        case (selected_piece[2:0])
            3'b001: moves = pawn_moves_out;   // Pawn
            3'b010: moves = knight_moves_out; // Knight
            3'b011: moves = bishop_moves_out; // Bishop
            3'b100: moves = rook_moves_out;   // Rook
            3'b101: moves = queen_moves_out;  // Queen
            3'b110: moves = king_moves_out;   // King
            default: moves = 64'b0;            // No moves for an empty square
        endcase
    end

endmodule

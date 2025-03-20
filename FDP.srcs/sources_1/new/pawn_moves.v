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


module pawn_moves (
    input basys_clock,
    input [255:0] board,
    input [3:0] grid_x, grid_y,
    input is_white,
    output reg [63:0] moves
);

    wire piece_forward1, piece_forward2;
    wire [3:0] forward1_x, forward1_y, forward2_x, forward2_y;
    
    assign forward1_x = grid_x;
    assign forward1_y = is_white ? (grid_y - 1) : (grid_y + 1);
    
    assign forward2_x = grid_x;
    assign forward2_y = is_white ? (grid_y - 2) : (grid_y + 2);

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

    always @(posedge basys_clock) begin
        moves = 64'b0;

        if (grid_y > 0 && grid_y < 7) begin
            if (!piece_forward1)
                moves[forward1_y * 8 + forward1_x] = 1'b1;
            if ((is_white && grid_y == 6) || (!is_white && grid_y == 1)) begin
                if (!piece_forward1 && !piece_forward2) 
                    moves[forward2_y * 8 + forward2_x] = 1'b1;
            end
        end
    end
endmodule

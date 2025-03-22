`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2025 18:58:11
// Design Name: 
// Module Name: queen_moves
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


module queen_moves(
    input basys_clock,
    input [255:0] board,
    input [4:0] grid_x, grid_y,
    input [3:0] selected_piece,
    output [63:0] moves
    );
    wire [63:0] moves_bishop;
    wire [63:0] moves_rook;
    rook_moves rook_inst(basys_clock,  board,  grid_x, grid_y, selected_piece, moves_bishop);
    bishop_moves bishop_inst(basys_clock,  board,  grid_x, grid_y, selected_piece, moves_rook);
    assign moves = moves_bishop | moves_rook;
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 21:26:57
// Design Name: 
// Module Name: Piece_Render
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


module Piece_Render(
    input basys_clock,
    input [255:0] board,
    input [6:0] pixel_x, pixel_y,
    output is_piece,
    output [3:0] piece
);

    Piece_Mux piece_mux_inst (
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece),
        .basys_clock(basys_clock)
    );
    
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    Current_Piece (board, grid_x, grid_y, piece);

endmodule

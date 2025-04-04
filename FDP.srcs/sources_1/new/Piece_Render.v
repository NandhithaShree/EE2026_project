`timescale 1ns / 1ps

module Piece_Render(
    input [255:0] board,
    input [6:0] pixel_x, pixel_y,
    output is_piece,
    output [3:0] piece
);

    Piece_Mux piece_mux_inst (
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece)
    );
    
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    Current_Piece (board, grid_x, grid_y, piece);

endmodule

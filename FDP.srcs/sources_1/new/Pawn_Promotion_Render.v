`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 10:30:25
// Design Name: 
// Module Name: Pawn_Promotion_Render
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

module Pawn_Promotion_Render(
    input basys_clock,
    input [6:0] pixel_x, pixel_y,
    input [1:0] selected_promotion_piece,
    output reg [15:0] oled_data
);

    wire [2:0] x, y;
    assign x = pixel_x / 16;
    assign y = pixel_y / 8;

    reg [3:0] piece;
    always @ (posedge basys_clock) begin
        if (y == 3'd4 || y == 3'd5) begin
            case (x - 1)
                3'b000: piece = B_QUEEN;
                3'b001: piece = B_ROOK;
                3'b010: piece = B_BISHOP;
                3'b011: piece = B_KNIGHT;
                default: piece = EMPTY;
            endcase
        end
        else
            piece = EMPTY;
    end
    
    wire is_piece;
    Piece_Mux # (.GRID_SIZE(16))(
        .basys_clock(basys_clock),
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece)
    );

    always @ (posedge basys_clock) begin
        if (x == 0 || y == 0 || x == 5 || y == 7)
            oled_data = BLACK;
        else if ((y == 4 || y == 5) && (x >= 1 && x <= 4)) begin
            if (is_piece)
                oled_data = BLACK;
            else if (x - 1 == {1'b0, selected_promotion_piece})
                oled_data = GREEN;
            else
                oled_data = DARK_BROWN;
        end
        else
            oled_data = LIGHT_BROWN;
    end

endmodule

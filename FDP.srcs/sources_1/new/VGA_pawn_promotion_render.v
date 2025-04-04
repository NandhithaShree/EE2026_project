`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 21:38:01
// Design Name: 
// Module Name: VGA_pawn_promotion_render
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


module VGA_pawn_promotion_render(
    input basys_clock,
    input [6:0] pixel_x, pixel_y,
    input [1:0] selected_promotion_piece,
    output reg [11:0] data
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
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece)
    );

    always @ (posedge basys_clock) begin
        if (x < 5 && y < 8) begin 
        if (x == 0 || y == 0 || x == 5 || y == 7)
            data = BLACK_VGA;
        else if ((y == 4 || y == 5) && (x >= 1 && x <= 4)) begin
            if (is_piece)
                data = BLACK_VGA;
            else if (x - 1 == {1'b0, selected_promotion_piece})
                data = GREEN_VGA;
            else
                data = DARK_BROWN_VGA;
        end
        else
            data = LIGHT_BROWN_VGA;
        end else 
            data = BLACK_VGA;
    end

endmodule


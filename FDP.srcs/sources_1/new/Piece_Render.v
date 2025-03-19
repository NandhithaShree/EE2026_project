`timescale 1ns / 1ps

module Piece_Render(
    input basys_clock,
    input [3:0] piece,
    input [6:0] pixel_x, pixel_y,
    output reg is_piece = 0
);
    always @ (posedge basys_clock) begin                            
        case (piece[2:0])
            PAWN: begin 
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 3 )| pixel_y % 8 == 6)| 
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 2 && pixel_y % 8 <= 5))
                begin
                    is_piece = 1;
                end
            end
            
            KNIGHT: begin
                // Simple knight shape
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 1 | pixel_y % 8 == 4)) |
                    (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && (pixel_y % 8 == 2 | pixel_y % 8 == 5 | pixel_y % 8 == 6)) |
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 6 && pixel_y % 8 == 3) |
                    (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && pixel_y % 8 == 4))
                begin
                    is_piece = 1;
                end
            end
            
            BISHOP: begin // Bishop
                // Simple bishop shape
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 2 )| pixel_y % 8 == 6)| 
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 1 && pixel_y % 8 <= 5)) 
                begin
                    is_piece = 1;
                end
            end
            
            ROOK: begin // Rook
                // Simple rook shape
                if (((pixel_x % 8 == 1 | pixel_x % 8 == 3 | pixel_x % 8 == 4 | pixel_x % 8 == 6) && pixel_y == 1) |
                        (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 == 2) |
                        (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && pixel_y % 8 >= 3 && pixel_y % 8 <= 4) |
                        (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 >= 5 && pixel_y % 8 <= 6))
                begin
                    is_piece = 1;
                end
            end
            
            QUEEN: begin // Queen
                // Simple queen shape
                if (((pixel_x % 8 == 1 | pixel_x % 8 == 3 | pixel_x % 8 == 4 | pixel_x % 8 == 6) && pixel_y == 0) |
                    (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 == 6) |
                    (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 2 | pixel_y % 8 == 5 | pixel_y % 8 == 1 )) |
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 3 && pixel_y % 8 <= 4)) 
                begin
                    is_piece = 1;
                end
            end
            
            KING: begin // King
                // Simple king shape
                if ((pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 0 && pixel_y % 8 <= 4) |
                    (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 1 | pixel_y % 8 == 5)) |
                    (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 == 6)) 
                begin
                    is_piece = 1;
                end
            end
            
            default:
                is_piece = 0;
        endcase
    end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 16:14:35
// Design Name: 
// Module Name: piece_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies:%%%%%
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Piece_Mux(
    input basys_clock,
    input [3:0] piece,
    input [6:0] pixel_x,
    input [6:0] pixel_y,
    output reg is_piece = 0
    );
        always @ (posedge basys_clock) begin 
        is_piece = 0;
//    if(pixel_x % 8 == 7) begin
//          oled_data = piece_colour;   
//    end                              
        case (piece[2:0])
            3'b001: begin // Pawn
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 3 )| pixel_y % 8 == 6)| 
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 2 && pixel_y % 8 <= 5))
                begin
                    is_piece = 1;
                end
            end
            
            3'b010: begin // Knight
                // Simple knight shape
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 1 | pixel_y % 8 == 4)) |
                   (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && (pixel_y % 8 == 2 | pixel_y % 8 == 5 | pixel_y % 8 == 6)) |
                   (pixel_x % 8 >= 3 && pixel_x % 8 <= 6 && pixel_y % 8 == 3) |
                   (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && pixel_y % 8 == 4))
                begin
                    is_piece = 1;
                end
            end
            
            3'b011: begin // Bishop
                // Simple bishop shape
                if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 2 )| pixel_y % 8 == 6)| 
                    (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 1 && pixel_y % 8 <= 5)) 
                begin
                    is_piece = 1;
                end
            end
            
            3'b100: begin // Rook
                // Simple rook shape
                if (((pixel_x % 8 == 1 | pixel_x % 8 == 3 | pixel_x % 8 == 4 | pixel_x % 8 == 6) && pixel_y == 1) |
                      (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 == 2) |
                      (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && pixel_y % 8 >= 3 && pixel_y % 8 <= 4) |
                      (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 >= 5 && pixel_y % 8 <= 6))
                begin
                    is_piece = 1;
                end
            end
            
            3'b101: begin // Queen
                // Simple queen shape
                if (((pixel_x % 8 == 1 | pixel_x % 8 == 3 | pixel_x % 8 == 4 | pixel_x % 8 == 6) && pixel_y == 0) |
                   (pixel_x % 8 >= 1 && pixel_x % 8 <= 6 && pixel_y % 8 == 6) |
                   (pixel_x % 8 >= 2 && pixel_x % 8 <= 5 && (pixel_y % 8 == 2 | pixel_y % 8 == 5 | pixel_y % 8 == 1 )) |
                   (pixel_x % 8 >= 3 && pixel_x % 8 <= 4 && pixel_y % 8 >= 3 && pixel_y % 8 <= 4)) 
                begin
                    is_piece = 1;
                end
            end
            
            3'b110: begin // King
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

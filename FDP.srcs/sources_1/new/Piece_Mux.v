`timescale 1ns / 1ps

module Piece_Mux #(parameter GRID_SIZE = 8)(
    input [3:0] piece,
    input [6:0] pixel_x,
    input [6:0] pixel_y,
    output reg is_piece = 0
);
    always @ (*) begin 
        is_piece = 0;
                            
        case (piece[2:0])
            3'b001: begin // Pawn
                if ((pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                    (pixel_y % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 4 * GRID_SIZE / 8) |
                    (pixel_y % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8)) |
                    (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 6 * GRID_SIZE / 8))
                begin
                    is_piece = 1;
                end
            end

            
            3'b010: begin // Knight
                // Simple knight shape
                if ((pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                   ((pixel_y % GRID_SIZE >= GRID_SIZE / 8 && pixel_y % GRID_SIZE < 2 * GRID_SIZE / 8) | 
                    (pixel_y % GRID_SIZE >= 4 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 5 * GRID_SIZE / 8))) |
                
                    (pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                   ((pixel_y % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 3 * GRID_SIZE / 8) | 
                    (pixel_y % GRID_SIZE >= 5 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 6 * GRID_SIZE / 8) | 
                    (pixel_y % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8))) |
                
                    (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 4 * GRID_SIZE / 8) |
                
                    (pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 4 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 5 * GRID_SIZE / 8))
                begin
                    is_piece = 1;
                end
            end
            
            
            3'b011: begin // Bishop
                // Simple bishop shape
                if ((pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                    (pixel_y % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 3 * GRID_SIZE / 8) |
                    (pixel_y % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8)) |
                    (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= GRID_SIZE / 8 && pixel_y % GRID_SIZE < 6 * GRID_SIZE / 8))
                begin
                    is_piece = 1;
                end
            end

            
            3'b100: begin // Rook
                // Simple rook shape
                if ((((pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 2 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 4 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 4 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8)) && 
                      (pixel_y % GRID_SIZE >= GRID_SIZE / 8 && pixel_y % GRID_SIZE < 2 * GRID_SIZE / 8)) |
                      
                    (pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                    (pixel_y % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 3 * GRID_SIZE / 8)) |
                     
                    (pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 5 * GRID_SIZE / 8) |
                     
                    (pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 5 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8))
                begin
                    is_piece = 1;
                end
            end

            
            3'b101: begin // Queen
                // Simple queen shape
                if ((((pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 2 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 4 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 4 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8) | 
                      (pixel_x % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8)) && 
                      (pixel_y % GRID_SIZE >= 0 && pixel_y % GRID_SIZE < GRID_SIZE / 8)) |
                      
                    (pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                    (pixel_y % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8)) |
                   
                    (pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                   ((pixel_y % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 3 * GRID_SIZE / 8) | 
                    (pixel_y % GRID_SIZE >= 5 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 6 * GRID_SIZE / 8) | 
                    (pixel_y % GRID_SIZE >= GRID_SIZE / 8 && pixel_y % GRID_SIZE < 2 * GRID_SIZE / 8) )) |
                   
                   (pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8 && 
                    pixel_y % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 5 * GRID_SIZE / 8)) 
                begin
                    is_piece = 1;
                end
            end

            
            3'b110: begin // King
                // Simple king shape
                if ((pixel_x % GRID_SIZE >= 3 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 5 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 0 && pixel_y % GRID_SIZE < 5 * GRID_SIZE / 8) |
                     
                    (pixel_x % GRID_SIZE >= 2 * GRID_SIZE / 8 && pixel_x % GRID_SIZE < 6 * GRID_SIZE / 8 && 
                    (pixel_y % GRID_SIZE >= GRID_SIZE / 8 && pixel_y % GRID_SIZE < 2 * GRID_SIZE / 8 | 
                    
                     pixel_y % GRID_SIZE >= 5 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 6 * GRID_SIZE / 8)) |
                    (pixel_x % GRID_SIZE >= GRID_SIZE / 8 && pixel_x % GRID_SIZE < 7 * GRID_SIZE / 8 && 
                     pixel_y % GRID_SIZE >= 6 * GRID_SIZE / 8 && pixel_y % GRID_SIZE < 7 * GRID_SIZE / 8))
                begin
                    is_piece = 1;
                end
            end
            
            default:
                is_piece = 0;
        endcase
      end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 16:14:24
// Design Name: 
// Module Name: bishop_moves
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


module bishop_moves(
    input basys_clock,
    input [255:0] board,
    input [4:0] grid_x, grid_y,
    output reg [63:0] moves
);

    integer i;
    
    wire piece_detected;
    Current_Piece piece_check (
         .board(board),
         .x(grid_x + i), //plus two removed assuming current_piece is changed
         .y(grid_y + i),
         .piece(piece_detected)
    );
    
    always @(posedge basys_clock) begin
        moves = 64'b0;
        
        // Check all four diagonal directions
        for (i = 1; i < 8; i = i + 1) begin
            if (grid_x + i < 8 && grid_y + i < 8) begin
 
                if (piece_detected) begin
                    disable loop_label;
                end
                else if(grid_y + i <= 7 && grid_x + i <= 7) begin
                    moves[(grid_y + i) * 8 + (grid_x + i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8; i = i + 1) begin
            if (grid_x >= i && grid_y + i < 8) begin
                if (piece_detected) begin
                    disable loop_label;
                end
                else if(grid_y + i <= 7 && grid_x - i >= 0) begin
                    moves[(grid_y + i) * 8 + (grid_x - i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8; i = i + 1) begin
            if (grid_x + i < 8 && grid_y >= i) begin
                if (piece_detected) begin
                    disable loop_label;
                end
                else if(grid_y - i >= 0 && grid_x + i <= 7) begin
                    moves[(grid_y - i) * 8 + (grid_x + i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8; i = i + 1) begin
            if (grid_x >= i && grid_y >= i) begin
                if (piece_detected) begin
                    disable loop_label;
                end
                else if(grid_y - i >= 0 && grid_x - i >= 0) begin
                    moves[(grid_y - i) * 8 + (grid_x - i)] = 1'b1;
                end
            end
        end
    end
    
endmodule

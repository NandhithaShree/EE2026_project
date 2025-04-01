`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2025 19:15:20
// Design Name: 
// Module Name: king_moves
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


module king_moves(
    input basys_clock,
    input [255:0] board,  // 8x8 grid, each cell is 4 bits representing a piece
    input [4:0] grid_x, grid_y,  // Coordinates of the grid to check
    input [3:0] selected_piece,  // The piece that is currently selected
    output reg [63:0] moves  // 64-bit output representing threatened squares
);
    reg [4:0] new_x, new_y;

    always @(posedge basys_clock) begin
        moves = 64'b0;
        
        // Check horizontally
        new_x = grid_x + 1;
        if (new_x >= 0 && new_x < 8) begin
            if (board[(((7 - grid_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - grid_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(grid_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(grid_y) * 8 + new_x] = 1'b1;
            end
        end

        new_x = grid_x - 1;
        if (new_x >= 0 && new_x < 8) begin
            if (board[(((7 - grid_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - grid_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(grid_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(grid_y) * 8 + new_x] = 1'b1;
            end
        end
        
        // Check vertically
        new_y = grid_y + 1;
        if (new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + grid_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + grid_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + grid_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + grid_x] = 1'b1;
            end
        end

        new_y = grid_y - 1;
        if (new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + grid_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + grid_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + grid_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + grid_x] = 1'b1;
            end
        end

        // Check diagonally (top-right)
        new_x = grid_x + 1;
        new_y = grid_y + 1;
        if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + new_x] = 1'b1;
            end
        end
        
        // Check diagonally (top-left)
        new_x = grid_x - 1;
        new_y = grid_y + 1;
        if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + new_x] = 1'b1;
            end
        end

        // Check diagonally (bottom-right)
        new_x = grid_x + 1;
        new_y = grid_y - 1;
        if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + new_x] = 1'b1;
            end
        end

        // Check diagonally (bottom-left)
        new_x = grid_x - 1;
        new_y = grid_y - 1;
        if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
            if (board[(((7 - new_y) * 8 + new_x) * 4) +: 4] != EMPTY) begin
                if (selected_piece[3] != board[(((7 - new_y) * 8 + new_x) * 4) + 3]) begin
                    moves[(new_y) * 8 + new_x] = 1'b1;
                end
            end
            else begin
                moves[(new_y) * 8 + new_x] = 1'b1;
            end
        end
    end
endmodule

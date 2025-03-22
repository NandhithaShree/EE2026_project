`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2025 18:53:27
// Design Name: 
// Module Name: rook_moves
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


module rook_moves(
    input basys_clock,
    input [255:0] board,
    input [4:0] grid_x, grid_y,
    input [3:0] selected_piece,
    output reg [63:0] moves
);

    integer i;
    reg piece_found_right, piece_found_left, piece_found_up, piece_found_down;
    reg piece_found_right_before, piece_found_left_before, piece_found_up_before, piece_found_down_before;
    reg [4:0] new_x, new_y;
    
    always @(posedge basys_clock) begin
        moves = 64'b0;
        
        piece_found_right = 0;
        piece_found_left = 0;
        piece_found_up = 0;
        piece_found_down = 0;
        piece_found_right_before = 0;
        piece_found_left_before = 0;
        piece_found_up_before = 0;
        piece_found_down_before = 0;
        
        // Move Right
        for (i = 1; i < 8 && !piece_found_right; i = i + 1) begin
            new_x = grid_x + i;
            new_y = grid_y;
            
            if (new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_right_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_right_before == 1) begin
                        piece_found_right = 1;
                    end else begin
                        piece_found_right_before = 1;
                        moves[(grid_y * 8) + grid_x + i] = 1'b1;
                    end
                end else begin
                    moves[(grid_y * 8) + grid_x + i] = 1'b1;
                end
            end
        end
        
        // Move Left
        for (i = 1; i < 8 && !piece_found_left; i = i + 1) begin
            new_x = grid_x - i;
            new_y = grid_y;
            
            if (grid_x - i >= 0 && grid_x - i < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_left_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_left_before == 1) begin
                        piece_found_left = 1;
                    end else begin
                        piece_found_left_before = 1;
                        moves[(grid_y * 8) + grid_x - i] = 1'b1;
                    end
                end else begin
                    moves[(grid_y * 8) + grid_x - i] = 1'b1;
                end
            end
        end
        
        // Move Up
        for (i = 1; i < 8 && !piece_found_up; i = i + 1) begin
            new_x = grid_x;
            new_y = grid_y + i;
            
            if (new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_up_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_up_before == 1) begin
                        piece_found_up = 1;
                    end else begin
                        piece_found_up_before = 1;
                        moves[((grid_y + i) * 8) + grid_x] = 1'b1;
                    end
                end else begin
                    moves[((grid_y + i) * 8) + grid_x] = 1'b1;
                end
            end
        end
        
        // Move Down
        for (i = 1; i < 8 && !piece_found_down; i = i + 1) begin
            new_x = grid_x;
            new_y = grid_y - i;
            
            if (new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_down_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_down_before == 1) begin
                        piece_found_down = 1;
                    end else begin
                        piece_found_down_before = 1;
                        moves[((grid_y - i) * 8) + grid_x] = 1'b1;
                    end
                end else begin
                    moves[((grid_y - i) * 8) + grid_x] = 1'b1;
                end
            end
        end
    end
    
endmodule


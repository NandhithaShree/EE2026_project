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
    input [3:0] selected_piece,
    output reg [63:0] moves
);

    integer i;
    reg piece_found_tr, piece_found_tl, piece_found_br, piece_found_bl, 
        piece_found_tr_before, piece_found_tl_before, piece_found_br_before, piece_found_bl_before;
    reg [4:0] new_x, new_y;
    
    always @(posedge basys_clock) begin
        moves = 64'b0;
        
        piece_found_tr = 0;
        piece_found_tl = 0;
        piece_found_br = 0;
        piece_found_bl = 0;
        piece_found_tr_before = 0;
        piece_found_tl_before = 0;
        piece_found_br_before = 0;
        piece_found_bl_before = 0;
        
        // Check all four diagonal directions
        for (i = 1; i < 8 && !piece_found_tr; i = i + 1) begin
            new_x = grid_x + i;
            new_y = grid_y + i;
            
            if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_tr_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_tr_before == 1) begin
                        piece_found_tr = 1;
                    end
                    else begin
                        piece_found_tr_before = 1;
                        moves[(grid_y + i) * 8 + (grid_x + i)] = 1'b1;
                    end
                end
                else begin
                    moves[(grid_y + i) * 8 + (grid_x + i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8 && !piece_found_tl; i = i + 1) begin
            new_x = grid_x - i;
            new_y = grid_y + i;
            
            if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_tl_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_tl_before == 1) begin
                        piece_found_tl = 1;
                    end
                    else begin
                        piece_found_tl_before = 1;
                        moves[(grid_y + i) * 8 + (grid_x - i)] = 1'b1;
                    end
                end
                    
                else begin
                    moves[(grid_y + i) * 8 + (grid_x - i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8 && !piece_found_br; i = i + 1) begin
            new_x = grid_x + i;
            new_y = grid_y - i;
            
            if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_br_before == 1) begin
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_br_before == 1) begin
                        piece_found_br = 1;
                    end
                    else begin
                        piece_found_br_before = 1;
                        moves[(grid_y - i) * 8 + (grid_x + i)] = 1'b1;
                    end
                end
                else begin
                    moves[(grid_y - i) * 8 + (grid_x + i)] = 1'b1;
                end
            end
        end
        
        for (i = 1; i < 8  && !piece_found_bl; i = i + 1) begin
            new_x = grid_x - i;
            new_y = grid_y - i;
            
            if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] != EMPTY || piece_found_bl_before == 1) begin 
                    if(selected_piece[3] == board[(((7 - new_y) * 8 + new_x) * 4) + 3] || piece_found_bl_before == 1) begin
                        piece_found_bl = 1;
                    end
                    else begin
                        piece_found_bl_before = 1;
                        moves[(grid_y - i) * 8 + (grid_x - i)] = 1'b1;
                    end
                end
                else
                    moves[(grid_y - i) * 8 + (grid_x - i)] = 1'b1;
            end
        end
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 09:17:04
// Design Name: 
// Module Name: knight_moves
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

module knight_moves(
    input basys_clock,
    input [255:0] board,
    input [3:0] grid_x, grid_y,
    input [3:0] selected_piece,
    output reg [63:0] moves
);

    reg signed [4:0] dx [0:7];
    reg signed [4:0] dy [0:7];
    initial begin
        dx[0] = -2; dy[0] = 1;
        dx[1] = -1; dy[1] = 2;
        dx[2] = 1;  dy[2] = 2;
        dx[3] = 2;  dy[3] = 1;
        dx[4] = 2;  dy[4] = -1;
        dx[5] = 1;  dy[5] = -2;
        dx[6] = -1; dy[6] = -2;
        dx[7] = -2; dy[7] = -1;
    end
    
    integer i;

    reg [4:0] new_x, new_y;
    
    always @ (posedge basys_clock) begin
        moves = 64'b0;
        for (i = 0; i < 8; i = i + 1) begin
            new_x = grid_x + dx[i];
            new_y = grid_y + dy[i];
            if (new_x >= 0 && new_x < 8 && new_y >= 0 && new_y < 8) begin
                if (board[(((7 - new_y) * 8 + new_x) * 4)+:4] == EMPTY)
                    moves[new_y * 8 + new_x] = 1'b1;
                else if (selected_piece[3] != board[(((7 - new_y) * 8 + new_x) * 4) + 3])
                    moves[new_y * 8 + new_x] = 1'b1;
            end
        end
    end

endmodule


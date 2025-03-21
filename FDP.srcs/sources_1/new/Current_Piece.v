`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 21:27:38
// Design Name: 
// Module Name: Current_Piece
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


module Current_Piece(
    input [255:0] board,
    input [3:0] x, y,
    output [3:0] piece
);
    wire [7:0] idx;
    assign idx = ((7-y) * 8 + x) * 4; // Convert grid coords to bit position
    assign piece = board[idx+:4];  // Get 4 bits at calculated index
endmodule

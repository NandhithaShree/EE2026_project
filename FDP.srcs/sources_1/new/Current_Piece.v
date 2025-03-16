`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 07:21:30 PM
// Design Name: 
// Module Name: Selected_Piece
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
    input [4:0] x,y,
    output [3:0] piece
    );
     wire [7:0] idx;
     assign idx = (7-y) * 32 + (x-2) * 4; // Convert grid coords to bit position
     assign piece = board[idx+:4];  // Get 4 bits at calculated index
endmodule

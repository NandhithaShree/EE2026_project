`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 09:10:56 PM
// Design Name: 
// Module Name: Pixel_Coordinates
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


module Pixel_Coordinates(
        input [12:0] pixel_index,
        output [6:0] x,y
    );
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule

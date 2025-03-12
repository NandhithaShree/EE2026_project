`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 07:39:44 PM
// Design Name: 
// Module Name: Grid_Coordinates
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


module Grid_Coordinates(
        input [6:0] x,y,
        output [4:0] grid_x,grid_y
    );
        assign grid_x = x / 8;
        assign grid_y = y / 8;
endmodule

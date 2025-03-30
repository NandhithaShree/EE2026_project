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

`include "Constants.vh"

module Grid_Coordinates(
        input [6:0] x, y,
        output [3:0] grid_x, grid_y
    );
        wire in_bounds;
        assign in_bounds = (x >= 2*8 && x < 10*8);
        assign grid_x = in_bounds ? (x / 8) - 2 : NULL;
        assign grid_y = y / 8;
endmodule

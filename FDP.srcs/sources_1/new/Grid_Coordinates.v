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
        input  [6:0] x, y,
        output [4:0] grid_x, grid_y,
        output out_of_bounds
    );
        parameter LOWER_X = 16;
        parameter UPPER_X = 80;
        parameter GRID_SIZE = 8;
        
        assign out_of_bounds = (x < LOWER_X || x >= UPPER_X);
        assign grid_x = out_of_bounds ? x / GRID_SIZE : (x - LOWER_X) / GRID_SIZE;
        assign grid_y = y / GRID_SIZE;
endmodule

`timescale 1ns / 1ps

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

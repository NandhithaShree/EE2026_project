`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 13:24:40
// Design Name: 
// Module Name: VGA_Background_Render
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

module VGA_Background_Render(
    input basys_clock,
    input [6:0] pixel_x, pixel_y,
    input [6:0] selected_x, selected_y,
    input [6:0] current_x, current_y,
    output reg [11:0] data
);
    
    wire [4:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    
    always @ (posedge basys_clock) begin
        if (grid_x == selected_x && grid_y == selected_y)
            data = BLUE_VGA;
        else if (grid_x == current_x && grid_y == current_y)
            data = GREEN_VGA;
        else if ((grid_x + grid_y) % 2) 
            data = LIGHT_BROWN_VGA;  
        else 
            data = DARK_BROWN_VGA;
    end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 09:51:33
// Design Name: 
// Module Name: Background_Render
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

module Background_Render(
    input basys_clock,
    input [6:0] pixel_x, pixel_y,
    input [6:0] selected_x, selected_y,
    input [6:0] current_x, current_y,
    output reg [15:0] oled_data
);
    
    wire [4:0] grid_x, grid_y;
    wire out_of_bounds;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y, out_of_bounds);
    
    always @ (posedge basys_clock) begin
        if (grid_x == selected_x && grid_y == selected_y)
            oled_data = BLUE;
        else if (grid_x == current_x && grid_y == current_y)
            oled_data = GREEN;
        else if ((grid_x + grid_y) % 2) 
            oled_data <= LIGHT_BROWN;  
        else 
            oled_data <= DARK_BROWN;
    end
endmodule
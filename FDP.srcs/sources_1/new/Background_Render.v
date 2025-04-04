`timescale 1ns / 1ps
`include "Constants.vh"

module Background_Render(
    input [6:0] pixel_x, pixel_y,
    input [3:0] selected_x, selected_y,
    input [3:0] current_x, current_y,
    output reg [15:0] oled_data
);
    
    wire [3:0] grid_x, grid_y;
    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    
    always @ (*) begin
        if (grid_x == selected_x && grid_y == selected_y)
            oled_data = BLUE;
        else if (grid_x == current_x && grid_y == current_y)
            oled_data = GREEN;
        else if ((grid_x + grid_y) % 2) 
            oled_data = LIGHT_BROWN;  
        else 
            oled_data = DARK_BROWN;
    end
endmodule

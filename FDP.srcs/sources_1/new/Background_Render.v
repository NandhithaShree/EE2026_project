`timescale 1ns / 1ps
`include "Constants.vh"

module Background_Render(
    input [6:0] pixel_x, pixel_y,
//    input [3:0] selected_x, selected_y,
//    input [3:0] current_x, current_y,
    output [15:0] oled_data
);
    
//    wire [3:0] grid_x, grid_y;
//    Grid_Coordinates grid_coordinates_inst (pixel_x, pixel_y, grid_x, grid_y);
    
//    always @ (*) begin
//        if (grid_y >= 0 && grid_y <= 1) begin
//            oled_data = WHITE;
//        end
//        else begin
//            oled_data = BLACK;
//        end
//    end

Frame_Renderer (pixel_x, pixel_y, DEAD_SCREEN, oled_data);
endmodule

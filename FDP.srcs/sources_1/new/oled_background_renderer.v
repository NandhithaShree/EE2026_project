`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 15:46:44
// Design Name: 
// Module Name: oled_background_renderer
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

module oled_Background_Render(
    input [6:0] pixel_x, pixel_y,
    output [15:0] oled_data
);

Frame_Renderer (pixel_x, pixel_y, DEAD_SCREEN, 0, oled_data);
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 23:13:47
// Design Name: 
// Module Name: VGA_colour_mapping
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

module VGA_colour_mapping (
    input [15:0] oled_data,
    output reg [11:0] vga_data
);

    always @(*) begin 
        case (oled_data)
            WHITE:                vga_data = WHITE_VGA;
            BLACK:                vga_data = BLACK_VGA;
            LIGHT_BROWN:          vga_data = LIGHT_BROWN_VGA;
            DARK_BROWN:           vga_data = DARK_BROWN_VGA;
            GREEN:                vga_data = GREEN_VGA;
            BLUE:                 vga_data = BLUE_VGA;
            LIGHT_BROWN_SCREEN:   vga_data = LIGHT_BROWN_SCREEN_VGA;
            DARK_BROWN_SCREEN:    vga_data = DARK_BROWN_SCREEN_VGA;
            GREEN_GREEN_SCREEN:   vga_data = GREEN_GREEN;
            LIGHT_GREEN_SCREEN:   vga_data = LIGHT_GREEN_VGA;
            DARK_GREEN_SCREEN:    vga_data = DARK_GREEN_VGA;
            default:              vga_data = 12'h000;  // fallback to black
        endcase
    end

endmodule

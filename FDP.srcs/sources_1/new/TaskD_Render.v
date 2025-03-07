`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:38:09 PM
// Design Name: 
// Module Name: TaskD_Render
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

module TaskD_Render (
    input clock,
    input [6:0] green_x,
    input [5:0] green_y,
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_data
);
    parameter GREEN_SIZE = 10;
    parameter RED_SIZE = 30;
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_OFFSET = 5;
    
    parameter RED_X = SCREEN_WIDTH - RED_SIZE - SCREEN_OFFSET;
    parameter RED_Y = SCREEN_OFFSET;

    wire clock_25MHz;
    Clock slow_clock_25MHz (clock, 2, clock_25MHz);
    
    always @(posedge clock_25MHz) begin
        if ((x >= green_x && x < green_x + GREEN_SIZE) && (y >= green_y && y < green_y + GREEN_SIZE))
            oled_data = 16'b00000_111111_00000; 
        else if ((x >= RED_X && x < RED_X + RED_SIZE) && (y >= RED_Y && y < RED_Y + RED_SIZE))
            oled_data = 16'b11111_000000_00000; 
        else
            oled_data = 16'b00000_000000_00000; 
    end
endmodule

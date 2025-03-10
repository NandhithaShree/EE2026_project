`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 20:38:33
// Design Name: 
// Module Name: TaskA_Render
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


module TaskA_Render (
    input wire clock_25MHz,
    input wire show_taskA,
    input wire [6:0] x,
    input wire [6:0] y,
    input wire [6:0] inner_diameter,
    output reg [15:0] oled_data
);

    parameter BORDER_COLOR = 16'b11111_000000_00000;
    parameter CIRCLE_COLOR = 16'b00000_111111_00000;
    parameter BACKGROUND_COLOR = 16'b00000_000000_00000;
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    parameter BORDER_THICKNESS = 3;
    parameter BORDER_OFFSET = 2;
    parameter CIRCLE_X = 47;
    parameter CIRCLE_Y = 31;

    always @ (posedge clock_25MHz) begin
        if ((x >= BORDER_OFFSET && x < SCREEN_WIDTH - BORDER_OFFSET - 1 && 
            (y >= BORDER_OFFSET && y < BORDER_OFFSET + BORDER_THICKNESS || 
            y >= SCREEN_HEIGHT - BORDER_OFFSET - BORDER_THICKNESS - 1 && y < SCREEN_HEIGHT - BORDER_OFFSET - 1)) ||
            (y >= BORDER_OFFSET && y < SCREEN_HEIGHT - BORDER_OFFSET - 1 && 
            (x >= BORDER_OFFSET && x < BORDER_OFFSET + BORDER_THICKNESS || 
            x >= SCREEN_WIDTH - BORDER_OFFSET - BORDER_THICKNESS - 1 && x < SCREEN_WIDTH - BORDER_OFFSET - 1)))
            oled_data <= BORDER_COLOR;
        else if (!show_taskA) 
            oled_data <= BACKGROUND_COLOR;
        else begin
            if ((x - CIRCLE_X) ** 2 + (y - CIRCLE_Y) ** 2 >= (inner_diameter / 2) ** 2 &&
                (x - CIRCLE_X) ** 2 + (y - CIRCLE_Y) ** 2 <= ((inner_diameter + 5) / 2) ** 2)
                oled_data <= CIRCLE_COLOR;
            else
                oled_data <= BACKGROUND_COLOR;
        end
    end
    
endmodule


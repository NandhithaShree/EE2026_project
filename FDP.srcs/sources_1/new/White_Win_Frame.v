`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 22:12:12
// Design Name: 
// Module Name: White_Win_Frame
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

module White_Win_Frame(
    input frame_rate,
    input [6:0] pixel_x, pixel_y,
    output reg [15:0] oled_data
);

    reg [15:0] frame_count = 1;
    parameter picture_total_count = 1;
    
    always @ (posedge frame_rate) begin
        frame_count <= (frame_count == picture_total_count - 1) ? 0 : frame_count + 1;
    end
   
    always @ (frame_rate) begin
        if (frame_count == 0) begin
            if ((pixel_x - 48) ** 2 + (pixel_y - 32) ** 2 <= 100) oled_data = GREEN;
            else oled_data = WHITE;
        end
    end

endmodule

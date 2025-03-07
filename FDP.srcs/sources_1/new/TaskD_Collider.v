`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:40:34 PM
// Design Name: 
// Module Name: TaskD_Collider
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


module TaskD_Collider(
    input [6:0] green_x, red_x,
    input [5:0] green_y, red_y,
    output reg collision
);
    parameter GREEN_SIZE = 10;
    parameter RED_SIZE = 30;

    always @(*) begin
        if (green_x + GREEN_SIZE > red_x && green_x < red_x + RED_SIZE &&
            green_y + GREEN_SIZE > red_y && green_y < red_y + RED_SIZE) 
            collision = 1;
        else
            collision = 0;
    end
endmodule

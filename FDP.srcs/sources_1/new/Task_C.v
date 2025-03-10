`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 19:08:09
// Design Name: 
// Module Name: Task_C
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


module Task_C (
    input CLOCK, 
    input btnC, 
    input [12:0] pixel_index, 
    output [15:0] pixel_data_output
);
    wire [6:0] x_output;
    wire [5:0] y_output;
    wire fast_start;
    wire slow_start;
    wire reset_trail; // NEW: Clears trail when animation resets

    // Control the animation steps
    AnimationController animCtrl(CLOCK, btnC, fast_start, slow_start, x_output, y_output, reset_trail);

    // Render the animation on OLED
    pixel_render_TaskC renderer(CLOCK, pixel_index, x_output, y_output, reset_trail, pixel_data_output);
endmodule

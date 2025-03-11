`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 20:34:13
// Design Name: 
// Module Name: TaskA
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


module TaskA (
    input reset,
    input basys_clock,
    input btn_center, btn_up, btn_down,
    input [6:0] x,
    input [5:0] y,
    output [15:0] oled_data
);
    wire clock_1KHz, clock_25MHz;
    Clock slow_clock_1KHz (basys_clock, 99999, clock_1KHz);
    Clock slow_clock_25MHz (basys_clock, 1, clock_25MHz);
    
    wire [6:0] inner_diameter;
    wire show_taskA;
    
    TaskA_Controller controller (
        reset,
        basys_clock,
        clock_1KHz,
        btn_center, btn_up, btn_down,
        inner_diameter,
        show_taskA
    );

    TaskA_Render render (
        clock_25MHz,
        show_taskA,
        x,
        y,
        inner_diameter,
        oled_data
    );

endmodule

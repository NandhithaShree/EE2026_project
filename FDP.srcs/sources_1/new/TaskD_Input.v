`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 10:46:57 AM
// Design Name: 
// Module Name: TaskD_Input
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


module TaskD_Input(
    input reset,
    input basys_clock, 
    input btn_left, btn_right, btn_up, btn_down,
    output reg [2:0] move_dir = 0
);
    
    wire clock;
    Clock slow_clock(basys_clock, 50_000, clock);
     
    always @(posedge clock) begin
        if (reset) move_dir <= 0;
        if (btn_right) move_dir <= 1;
        if (btn_left) move_dir <= 2;
        if (btn_up) move_dir <= 3;
        if (btn_down) move_dir <= 4;
    end
endmodule

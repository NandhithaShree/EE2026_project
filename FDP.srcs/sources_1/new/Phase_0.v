`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:34:36
// Design Name: 
// Module Name: Phase_0
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


module Phase_0(
    input clk_45Hz, 
    input start_phase,
    input [6:0] x, 
    input [5:0] y, 
    output reg [15:0] oled_data
);
    always @(*) begin
        oled_data = (x >= 84 && x <= 95 && y >= 0 && y <= 10) ? 16'b11111_100000_00000 : 0;
    end
endmodule

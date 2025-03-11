`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:34:36
// Design Name: 
// Module Name: Button_Debounce
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


module Debounce(
    input CLOCK,   // System Clock
    input btn,     // Raw Button Input
    output reg btn_clean // One-cycle pulse output
);
    reg btn_prev = 0; // Stores previous button state

    always @(posedge CLOCK) begin
        btn_clean <= (btn & ~btn_prev); // ? Rising edge detection (btn goes from 0 ? 1)
        btn_prev <= btn; // ? Store previous button state
    end
endmodule

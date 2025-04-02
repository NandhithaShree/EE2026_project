`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 19:40:49
// Design Name: 
// Module Name: ChessTimer
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


module ChessTimer(
    input wire clock_1hz,          // 1Hz clock signal from Clock module
    input [1:0] game_state,          // Reset button
    input wire player,         // Player turn (0 = Player 1, 1 = Player 2)
    output reg [5:0] min1, sec1, // Player 1 time (MM:SS)
    output reg [5:0] min2, sec2  // Player 2 time (MM:SS)
);

    always @(posedge clock_1hz) begin
        if (game_state == 2'b00) begin
            min1 <= 6'd5; // Set initial time (e.g., 5 minutes)
            sec1 <= 6'd0;
            min2 <= 6'd5;
            sec2 <= 6'd0;
        end else if (player == 1) begin
            // Player 1 (white) timer
            if (sec1 == 0) begin
                if (min1 > 0) begin
                    min1 <= min1 - 1;
                    sec1 <= 6'd59;
                end
            end else begin
                sec1 <= sec1 - 1;
            end
        end else begin
            // Player 2 (black) timer
            if (sec2 == 0) begin
                if (min2 > 0) begin
                    min2 <= min2 - 1;
                    sec2 <= 6'd59;
                end
            end else begin
                sec2 <= sec2 - 1;
            end
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 11:39:33 PM
// Design Name: 
// Module Name: Chess_Timer
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


module Chess_Timer(
    input wire basys_clock,          // 1Hz clock signal from Clock module
    input [2:0] game_state,          // Reset button
    output reg [5:0] min, sec,
    output reg timeout = 0
);
    wire clock_1hz;
    Clock (basys_clock, 50_000_000, clock_1hz);

    always @(posedge clock_1hz) begin
        case(game_state)
            START_GAME, WHITE_WINS, BLACK_WINS: begin
                min <= 6'd5;
                sec <= 6'd0;
                timeout <= 0;
            end
            PLAYER_TURN: begin
                if (sec == 0) begin
                    if (min == 0) begin
                        timeout <= 1;    
                    end else begin
                        min <= min -1;
                        sec <= 6'd59;
                    end
                end else begin
                    sec <= sec - 1;
                end
            end
        endcase
    end
endmodule
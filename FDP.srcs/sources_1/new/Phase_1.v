`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:34:36
// Design Name: 
// Module Name: Phase_1
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


module Phase_1(
    input CLOCK, 
    input start, 
    input [6:0] x, 
    input [5:0] y, 
    input reset, 
    output reg done, 
    output [15:0] oled_data
);
    reg [5:0] y_output;
    
    initial begin 
        y_output = 10;
        done = 0;
    end
    
    always @(posedge CLOCK) begin 
        if (!start) begin  // ? Reset FIRST to clear all values
            y_output <= 10; // Reset y_output when phase stops
            done <= 0; // Reset done when the phase stops
        end 
        else if (start) begin // ? Only start if reset is NOT active
            if (y_output < 63) begin 
                y_output <= y_output + 1;
            end 
            if (y_output == 63) begin  // Ensure done is set exactly once
                done <= 1;
            end
        end
    end

 assign oled_data = (x >= 84 && x <= 95 && y >= 0 && y <= y_output) ? 16'b11111_100000_00000 : 0;

    
endmodule

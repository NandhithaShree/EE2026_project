`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:34:36
// Design Name: 
// Module Name: Phase_4
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


module Phase_4(
    input CLOCK, 
    input start, 
    input [6:0] x, 
    input [5:0] y, 
    input reset,
    output reg done, 
    output [15:0] oled_data
);
    reg [6:0] x_output;

    initial begin 
        x_output = 59;
        done = 0;
    end
    
    always @(posedge CLOCK) begin 
        if (!start) begin  // ? Reset should come first
            x_output <= 59;
            done <= 0;
        end 
        else if (start) begin  // ? Start logic only runs if reset is NOT active
            if (x_output < 73) begin 
                x_output <= x_output + 1;
            end 
            else if (x_output == 73) begin 
                done <= 1; // Phase completed
            end
        end
    end 
    
 assign oled_data = (x >= 59 && x < x_output && y >= 30 && y <= 41) ? 16'b11111_100000_00000 : 
                        (x >= 48 && x <= 59 && y >= 30 && y <= 51) ? 16'b11111_100000_00000 :  // Quarter line from middle x
                        (x >= 48 && x <= 83 && y >= 52 && y <= 63) ? 16'b11111_100000_00000 : // Bottom line
                        (x >= 84 && x <= 95 && y >= 0 && y <= 63) ? 16'b11111_100000_00000 : 0; // Right straight line

    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:34:36
// Design Name: 
// Module Name: Phase_5
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


module Phase_5(
    input CLOCK, 
    input start, 
    input [6:0] x, 
    input [5:0] y, 
    input reset,
    output reg done, 
    output  [15:0] oled_data
);
    reg [5:0] y_output;

    initial begin 
        y_output = 29;
        done = 0;
    end
    
    always @(posedge CLOCK) begin 
        if (!start) begin  // ? Reset first to clear phase state
            y_output <= 29; 
            done <= 0;
        end 
        else if (start) begin  // ? Only execute start logic if reset is NOT active
            if (y_output > 0) begin 
                y_output <= y_output - 1;
            end 
            else if (y_output == 0) begin 
                done <= 1; // Phase completed
            end
        end
    end 
    
 assign oled_data = (x >= 62 && x <= 73 && y >= y_output && y <= 29) ? 16'b11111_100000_00000 : 
                        (x >= 59 && x <= 73 && y >= 30 && y <= 41) ? 16'b11111_100000_00000 : // Right from middle of screen
                        (x >= 48 && x <= 59 && y >= 30 && y <= 51) ? 16'b11111_100000_00000 :  // Quarter line from middle x
                        (x >= 48 && x <= 83 && y >= 52 && y <= 63) ? 16'b11111_100000_00000 : // Bottom line
                        (x >= 84 && x <= 95 && y >= 0 && y <= 63) ? 16'b11111_100000_00000 : 0; // Right straight line

    
endmodule

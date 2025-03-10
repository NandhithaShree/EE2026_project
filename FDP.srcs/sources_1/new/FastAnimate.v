`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 13:18:13
// Design Name: 
// Module Name: SlowAnimate
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


module FastAnimate (
    input CLOCK_45p, 
    input start,
    output reg [6:0] x_output,
    output reg [5:0] y_output,
    output reg done
);
    reg [6:0] step_count = 0;

    initial begin 
        x_output = 85;
        y_output = 0;
        done = 0;
    end
    
    always @(posedge CLOCK_45p) begin
        if (start) begin
            if (step_count < 53) begin
                y_output <= y_output + 1; // Move down  
            end else if (step_count < 90) begin
                x_output <= x_output - 1; // Move left
            end 
            
            if (step_count == 90) begin
                done <= 1; // Animation finished
            end else begin
                step_count <= step_count + 1;
            end
        end 
        else begin
            done <= 0;
            step_count <= 0;
            x_output = 85;
            y_output = 0;
        end
    end
endmodule

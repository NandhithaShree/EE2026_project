`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 19:09:59
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


module SlowAnimate (
    input CLOCK_15p, 
    input start,
    output reg [6:0] x_output,
    output reg [5:0] y_output,
    output reg done
);
    reg [5:0] step_count = 0;
    reg [2:0] steps = 0;
    
    initial begin 
          x_output = 48;
          y_output = 53;
          done = 0;
        end

    always @(posedge CLOCK_15p) begin
        if (start) begin
            if (steps == 0) begin
                if (y_output > 32) begin 
                    y_output <= y_output - 1; // Move up
                end else begin 
                    steps = 1;
                end
            end else if (steps == 1) begin
                if(x_output < 72) begin
                    x_output <= x_output + 1; // Move right
                end else begin 
                    steps = 2;
                end
            end else if (steps == 2) begin
                if (y_output > 0) begin 
                    y_output <= y_output - 1; // Move up
                end else begin 
                    steps = 3;
                end
            end else if (steps == 3) begin
                if(x_output < 85) begin
                    x_output <= x_output + 1; // Move right (back to start)
                end else begin 
                    steps = 4;
                end
            end else if (steps == 4) begin 
                done <= 1;
            end
                  
        end else begin //when start become 0, go to this idle state
            done <= 0;
            steps <= 0;
            step_count <= 0;
            x_output = 37;
            y_output = 53;
        end
    end
endmodule

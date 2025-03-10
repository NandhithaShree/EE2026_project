`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 19:12:02
// Design Name: 
// Module Name: pixel_render_TaskC
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


module pixel_render_TaskC (
    input CLOCK,
    input [6:0] x, 
    input [5:0] y,
    input [6:0] x_output,
    input [5:0] y_output,
    input reset_trail,
    output reg [15:0] pixel_data_output
);
    integer i, j;

    // Trail memory to store previous positions
    reg [95:0] trail_map [63:0]; // 96x64 memory, stores 1 if pixel was occupied

    always @(posedge CLOCK) begin
        if (reset_trail) begin
            // Clear trail when reset signal is active
            for (i = 0; i < 96; i = i + 1) begin
                for (j = 0; j < 64; j = j + 1) begin
                    trail_map[i][j] <= 0;
                end
            end
        end else begin
            // Mark trail where the square was
            if (x_output < 96 && y_output < 64) begin
                trail_map[x_output][y_output] <= 1;
            end
        end

        // Display the current square OR the trail
        if ((x >= x_output && x < x_output + 11) && (y >= y_output && y < y_output + 11)) begin
            pixel_data_output = 16'b11111_101000_00000; // Orange square
        end else if (trail_map[x][y]) begin
            pixel_data_output = 16'b11111_101000_00000; // Dimmed Orange trail
        end else begin
            pixel_data_output = 16'b00000_000000_00000; // Black background
        end
    end
endmodule

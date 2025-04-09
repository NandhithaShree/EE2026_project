`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 23:31:49
// Design Name: 
// Module Name: tone_generator
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


module tone_generator(
    input wire clk,
    input wire enable,
    input wire [31:0] frequency,
    output reg out
);
    reg [31:0] counter = 0;
    reg [31:0] half_period = 1;

    always @(posedge clk) begin
        if (enable && frequency != 0) begin
            half_period <= 100_000_000 / (2 * frequency); // For 100MHz clock
            if (counter >= half_period) begin
                counter <= 0;
                out <= ~out;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            out <= 0;
        end
    end
endmodule


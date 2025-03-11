`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 09:47:17 PM
// Design Name: 
// Module Name: TaskX
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


module TaskX(
    input basys_clk,
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_data
);
    wire created25Mhz;
    Clock (basys_clk, 1, created25Mhz); 
    always @ (posedge created25Mhz) begin
        oled_data = 16'b00000_000000_00000;
        if(x >= 28 && x <= 38 && y >= 5 && y <= 55) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 48 && x <= 68 && y >= 5 && y <= 15) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 48 && x <= 55 && y >= 15 && y <= 25) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 48 && x <= 55 && y >= 15 && y <= 25) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 48 && x <= 68 && y >= 25 && y <= 35) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 61 && x <= 68 && y >= 35 && y <= 45) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 61 && x <= 68 && y >= 35 && y <= 45) begin
            oled_data = 16'b11111_111111_11111;
        end
        if(x >= 48 && x <= 68 && y >= 45 && y <= 55) begin
            oled_data = 16'b11111_111111_11111;
        end
    end  
endmodule

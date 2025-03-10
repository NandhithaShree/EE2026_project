`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 09:39:12 PM
// Design Name: 
// Module Name: Task_Multiplexer
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


module Task_Multiplexer(
    input [2:0] state, 
    input [15:0] oled_0, 
    input [15:0] oled_a, 
    input [15:0] oled_b, 
    input [15:0] oled_c, 
    input [15:0] oled_d, 
    output reg [15:0] oled_data
);
    
    always @(*) begin 
        case (state)
            3'b000: oled_data = oled_a;
            3'b001: oled_data = oled_b;
            3'b010: oled_data = oled_c;
            3'b011: oled_data = oled_d;
            default: oled_data = oled_0; 
        endcase
    end

endmodule

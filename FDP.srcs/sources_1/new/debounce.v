`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 16:10:04
// Design Name: 
// Module Name: debounce
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


module debounce (
    input clk,
    input btn,
    output reg btn_out
);

    reg [19:0] counter = 0;
    reg btn_prev = 0;

    always @(posedge clk) begin
        if (btn != btn_prev) begin
            counter <= 0;  // Reset counter on button change
        end else if (counter < 1_000_000) begin
            counter <= counter + 1;
        end else begin
            btn_out <= btn;  // Confirm stable button press
        end
        btn_prev <= btn;
    end
endmodule



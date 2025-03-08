`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:20:50
// Design Name: 
// Module Name: flexible_clock_divider
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


module flexible_clock_divider(
    input basys_clock,
    input [31:0] m,
    output reg slow_clock
    );
    
    reg [31:0] count = 0;
        
    initial begin
        slow_clock = 0;
    end
       
    always @ (posedge basys_clock) begin
        count = (count == m) ? 0 : count + 1;
        slow_clock = (count == 0) ? ~slow_clock : slow_clock;
    end
endmodule

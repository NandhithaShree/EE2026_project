`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:26:27
// Design Name: 
// Module Name: flexible_clock_divider_test
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


module flexible_clock_divider_test(

    );
    
    reg basys_clock;
    reg [31:0] m;
    wire slow_clock;
    
    flexible_clock_divider dut(basys_clock, m, slow_clock);
    
    initial begin
        basys_clock = 0;
        m = 32'd7;
    end
        
    always begin
        #5; basys_clock = ~basys_clock;
    end
    
endmodule

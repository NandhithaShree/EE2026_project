`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 02:42:35 PM
// Design Name: 
// Module Name: Clock_Sim
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


module Clock_Sim(

    );
    
    reg sim_clk;
    wire [7:0] JC;
    
    Clock clk(sim_clk, JC);
    
    initial begin
        sim_clk = 0;
    end
    
    always begin
        #5 sim_clk = ~sim_clk;
    end
    
endmodule

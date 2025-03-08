`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 20:49:04
// Design Name: 
// Module Name: TaskA_Controller
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


module TaskA_Controller (
    input wire basys_clock,
    input wire clock_1KHz,
    input wire btnC, btnU, btnD,
    output reg [6:0] inner_diameter = 25,
    output reg show_taskA = 0
);

    parameter MAX_DIAMETER = 40;
    parameter MIN_DIAMETER = 10;
    parameter DIAMETER_STEP = 5;
    parameter DEBOUNCE_TIME = 200;
    
    reg [7:0] debounce_counter = 0;
    reg last_btnU, last_btnD;
    
    always @ (posedge clock_1KHz) begin
        if (debounce_counter > 0)
            debounce_counter <= debounce_counter - 1;
            
        last_btnU <= btnU;
        last_btnD <= btnD;
        
        if (!debounce_counter) begin
            if (btnU && !last_btnU && inner_diameter <= MAX_DIAMETER) begin
                inner_diameter <= inner_diameter + DIAMETER_STEP;
                debounce_counter <= DEBOUNCE_TIME;
            end
            else if (btnD && !last_btnD && inner_diameter >= MIN_DIAMETER) begin
                inner_diameter <= inner_diameter - DIAMETER_STEP;
                debounce_counter <= DEBOUNCE_TIME;
            end
        end
    end
    
    always @ (posedge basys_clock) begin
        if (btnC && !show_taskA) show_taskA <= 1;
    end
    
endmodule

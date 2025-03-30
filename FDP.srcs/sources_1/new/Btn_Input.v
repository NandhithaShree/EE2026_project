`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 21:20:22
// Design Name: 
// Module Name: Btn_Input
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


module Btn_Input(
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    output reg [4:0] curr_x = 3, curr_y = 1,
    output reg confirm = 0
);

    parameter DEBOUNCE_LIMIT = 1_000_000;  // ~10ms debounce period

    reg [19:0] debounce_cnt = 0;
    reg btn_pressed = 0;  // Tracks whether a button is currently pressed
    reg btnC_prev = 0;    // Stores previous state of btnC

    always @(posedge basys_clock) begin
        // Detect if any button is pressed
        if (btnU || btnD || btnC || btnL || btnR) begin
            if (debounce_cnt < DEBOUNCE_LIMIT) begin
                debounce_cnt <= debounce_cnt + 1;
            end else if (!btn_pressed) begin
                btn_pressed <= 1; // Register the button press after debounce
                
                // Handle movement
                if (btnU && curr_y > 0) curr_y <= curr_y - 1;
                if (btnD && curr_y < 7) curr_y <= curr_y + 1;
                if (btnL && curr_x > 2) curr_x <= curr_x - 1;
                if (btnR && curr_x < 9) curr_x <= curr_x + 1;
                
                // Generate a single-cycle confirm pulse when btnC is first pressed
                confirm <= (btnC && !btnC_prev);  // Set confirm to 1 for one clock cycle
                btnC_prev <= btnC;  // Store previous state of btnC
            end
        end else begin
            debounce_cnt <= 0;
            btn_pressed <= 0; // Reset debounce when no button is pressed
        end
    end
endmodule

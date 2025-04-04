`timescale 1ns / 1ps

module Btn_Input(
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    input is_promotion,
    output reg [1:0] selected_promotion_piece = 2'b00,
    output reg [3:0] curr_x = 1, curr_y = 2,
    output reg confirm = 0
);

    parameter DEBOUNCE_LIMIT = 1_000_000;  // ~10ms debounce period
    parameter COUNTER_1HZ = 100_000_000;

    reg [19:0] debounce_cnt = 0;
    reg btn_pressed = 0;  // Tracks whether a button is currently pressed

    reg [31:0] promotion_cnt = 0;
    reg [3:0] promotion_wait = 0;

    always @ (posedge basys_clock) begin
        // Detect if any button is pressed
        if (btnU || btnD || btnC || btnL || btnR) begin
            if (debounce_cnt < DEBOUNCE_LIMIT) begin
                debounce_cnt <= debounce_cnt + 1;
            end else if (!btn_pressed) begin
                btn_pressed <= 1; // Register the button press after debounce
                
                if (!is_promotion) begin
                    // Handle movement
                    if (btnU && curr_y > 0) curr_y <= curr_y - 1;
                    if (btnD && curr_y < 7) curr_y <= curr_y + 1;
                    if (btnL && curr_x > 0) curr_x <= curr_x - 1;
                    if (btnR && curr_x < 7) curr_x <= curr_x + 1;
                end else begin
                    // Handle selection of pawn promotion piece
                   if (btnL) selected_promotion_piece <= selected_promotion_piece - 1;
                   if (btnR) selected_promotion_piece <= selected_promotion_piece + 1;
                end

                if (btnC) confirm <= 1;
            end
        end else begin
            confirm <= 0;
            debounce_cnt <= 0;
            btn_pressed <= 0; 
        end
        
        if (is_promotion) begin
            promotion_cnt <= promotion_cnt + 1;
            if (promotion_cnt == COUNTER_1HZ) begin
                promotion_cnt <= 0;
                promotion_wait <= promotion_wait + 1;
            end
            if (promotion_wait >= 4'd5) begin
                selected_promotion_piece <= 2'd00;
                confirm <= 1;
            end
        end else begin
            promotion_cnt <= 0;
            promotion_wait <= 0;
        end
    end
endmodule

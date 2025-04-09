`timescale 1ns / 1ps

module Mouse_Input(
    input basys_clock,
    input left,
    input [11:0] xpos, ypos,
    input is_promotion,
    output reg [1:0] selected_promotion_piece = 2'b00,
    output reg [3:0] curr_x = 1, curr_y = 2,
    output reg confirm = 0
);

    parameter COUNTER_1HZ = 100_000_000;


    reg [31:0] promotion_cnt = 0;
    reg [3:0] promotion_wait = 0;

    always @ (posedge basys_clock) begin
        curr_x = (xpos / 8) - 2;
        curr_y = ypos / 8;
        
        if (left) confirm <= 1;
        else confirm <= 0;
        
        if (is_promotion && (curr_y == 4 || curr_y == 5)) begin
            if (curr_x == 0 || curr_x == 1) selected_promotion_piece <= 2'b00;
            else if (curr_x == 2 || curr_x == 3) selected_promotion_piece <= 2'b01;
            else if (curr_x == 4 || curr_x == 5) selected_promotion_piece <= 2'b10;
            else if (curr_x == 6 || curr_x == 7) selected_promotion_piece <= 2'b11;
        end
        
        if (is_promotion) begin
            promotion_cnt <= promotion_cnt + 1;
            if (promotion_cnt == COUNTER_1HZ) begin
                promotion_cnt <= 0;
                promotion_wait <= promotion_wait + 1;
            end
            if (promotion_wait >= 4'd10) begin
                selected_promotion_piece <= 2'b00;
                confirm <= 1;
            end
        end else begin
            promotion_cnt <= 0;
            promotion_wait <= 0;
        end
    end

endmodule

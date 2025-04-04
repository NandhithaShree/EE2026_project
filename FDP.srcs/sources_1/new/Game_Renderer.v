`timescale 1ns / 1ps
`include "Constants.vh"

module Game_Renderer (
        input [255:0] board,
        input [63:0] moves,
        input [6:0] pixel_x, pixel_y,
        input [3:0] grid_x, grid_y,
        input [3:0] selected_x, selected_y,
        input [3:0] current_x, current_y,
        output reg [15:0] oled_data
    );
    
    wire is_piece;
    wire [3:0] piece;
    Piece_Render piece_render_inst (
        .board(board),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_piece(is_piece),
        .piece(piece)
    );
    
    wire [15:0] bg_oled;
    Background_Render background_render_inst (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .oled_data(bg_oled)
    );
    
    wire [3:0] x_pos, y_pos;
 
    assign x_pos = pixel_x % 8;
    assign y_pos = pixel_y % 8;
    
    always @(*) begin
        if (is_piece) begin
            if (piece[3] == 1)
                oled_data = WHITE;
            else
                oled_data = BLACK;
        end else if (moves[grid_y * 8 + grid_x]) begin
            if ((x_pos - 3) ** 2 + (y_pos - 3) ** 2 <= 6)
                oled_data = BLUE;
            else
                oled_data = bg_oled;
        end else begin
            oled_data = bg_oled;
        end
    end
endmodule

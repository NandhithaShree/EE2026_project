`timescale 1ns / 1ps

module Mouse_Renderer(
    input [11:0] xpos, ypos,
    input [6:0] pixel_x, pixel_y,
    output reg [15:0] oled_data
);

    integer dx, dy;

    always @(*) begin
        // Relative coordinates from cursor origin
        dx = pixel_x - xpos[6:0];
        dy = pixel_y - ypos[6:0];
    
        if ((dx == 0 && dy == 0) || 
            (dx == 0 && dy == 1) || 
            (dx == 0 && dy == 2) || 
            (dx == 0 && dy == 3) || 
            (dx == 0 && dy == 4) || 
            (dx == 0 && dy == 5) || 
            (dx == 0 && dy == 6) || 
            (dx == 1 && dy == 0) || 
            (dx == 1 && dy == 6) || 
            (dx == 2 && dy == 1) || 
            (dx == 2 && dy == 5) || 
            (dx == 3 && dy == 2) || 
            (dx == 3 && dy == 4) || 
            (dx == 3 && dy == 5) || 
            (dx == 3 && dy == 6) || 
            (dx == 4 && dy == 3) || 
            (dx == 4 && dy == 4) || 
            (dx == 4 && dy == 6) || 
            (dx == 4 && dy == 7)) begin
            oled_data <= 16'h0000; // Black border
    
        end else if ((dx == 1 && dy == 1) ||
                     (dx == 1 && dy == 2) ||
                     (dx == 1 && dy == 3) ||
                     (dx == 1 && dy == 4) ||
                     (dx == 1 && dy == 5) ||
                     (dx == 2 && dy == 2) ||
                     (dx == 2 && dy == 3) ||
                     (dx == 2 && dy == 4) ||
                     (dx == 3 && dy == 3)) begin
            oled_data <= 16'hFFFF; // White fill
        end else begin
            oled_data <= 16'h0001; // Background
        end
    end
endmodule

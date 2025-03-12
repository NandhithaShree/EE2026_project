module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    output [7:0] JB
);

    //Colours
    parameter WHITE = 16'hFFFF;     
    parameter BLACK = 16'h0000;     
    parameter LIGHT_BROWN = 16'hD69A; 
    parameter DARK_BROWN = 16'h8410;  
    parameter GREEN = 16'h07E0;     
    
    //Piece bits
    parameter EMPTY = 4'b0000;
    parameter W_PAWN = 4'b1001;
    parameter W_KNIGHT = 4'b1010;
    parameter W_BISHOP = 4'b1011;
    parameter W_ROOK = 4'b1100;
    parameter W_QUEEN = 4'b1101;
    parameter W_KING = 4'b1110;
    parameter B_PAWN = 4'b0001;
    parameter B_KNIGHT = 4'b0010;
    parameter B_BISHOP = 4'b0011;
    parameter B_ROOK = 4'b0100;
    parameter B_QUEEN = 4'b0101;
    parameter B_KING = 4'b0110;
    
    parameter INITIAL_BOARD = {
        // 8th row (black pieces) - 32 bits
        B_ROOK, B_KNIGHT, B_BISHOP, B_QUEEN, B_KING, B_BISHOP, B_KNIGHT, B_ROOK,
        // 7th row (black pawns) - 32 bits
        B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN,
        // 6th row (empty) - 32 bits
        EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
        // 5th row (empty) - 32 bits
        EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
        // 4th row (empty) - 32 bits
        EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
        // 3rd row (empty) - 32 bits
        EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
        // 2nd row (white pawns) - 32 bits
        W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN,
        // 1st row (white pieces) - 32 bits
        W_ROOK, W_KNIGHT, W_BISHOP, W_QUEEN, W_KING, W_BISHOP, W_KNIGHT, W_ROOK
    };

    reg [15:0] oled_data;
    
    wire [6:0] pixel_x, pixel_y;
    wire [4:0] grid_x, grid_y, curr_x, curr_y;
    reg  [4:0] hover_x = 2, hover_y = 7;

    Grid_Coordinates (pixel_x, pixel_y, grid_x, grid_y);
    
    reg [255:0] board = INITIAL_BOARD;
    reg [3:0] piece;
    reg [15:0] piece_colour;
    
    function [3:0] get_piece;
        input [4:0] x, y;
        integer idx;
        begin
            // Calculate index in the board register (4 bits per square)
            idx = (7-y) * 32 + (x-2) * 4; // Convert grid coords to bit position
            get_piece = board[idx+:4];  // Get 4 bits at calculated index
        end
    endfunction
    
    reg [22:0] btn_counter = 0;
    parameter BTN_DELAY = 5_000_000; // ~0.1 second with 50MHz clock
    
    
    always @(posedge basys_clock) begin
        // Increment counter for timing
        btn_counter <= btn_counter + 1;
        
        // Check for button presses at a reduced rate (debouncing)
        if (btn_counter == BTN_DELAY) begin
            btn_counter <= 0;
            
            // Fixed button logic with proper coordinate assignments
            if (btnU && hover_y > 0) hover_y <= hover_y - 1;
            if (btnD && hover_y < 7) hover_y <= hover_y + 1;
            if (btnL && hover_x > 2) hover_x <= hover_x - 1; 
            if (btnR && hover_x < 9) hover_x <= hover_x + 1;
        end
    end
    
    
    always @(posedge basys_clock) begin
        if (grid_x >= 2 && grid_x <= 9 && grid_y <= 7) begin
            piece = get_piece(grid_x, grid_y);
            
            //Layer 1: First, draw background based on the game state
            
            if (grid_x == hover_x && grid_y == hover_y) 
                oled_data = GREEN;  
            else if ((grid_x + grid_y) % 2) 
                oled_data = LIGHT_BROWN;  
            else 
                oled_data = DARK_BROWN; 
            
            //Layer 2: If the pixel belongs to a piece, overwrite the background with the piece colour
            //With this priority rendering approach, we can actually "paint" multiple times on the same pixel without multi-driving :)
            
            if (piece != EMPTY) begin

                if (piece[3]) 
                    piece_colour = WHITE;
                else
                    piece_colour = BLACK;
                
                case (piece[2:0])
                    3'b001: begin // Pawn
                        if (((pixel_x % 8 - 4) * (pixel_x % 8 - 4) + (pixel_y % 8 - 2) * (pixel_y % 8 - 2) <= 4) || 
                            (pixel_y % 8 >= 3 && pixel_y % 8 <= 5 && pixel_x % 8 >= 3 && pixel_x % 8 <= 5))  
                        begin
                            oled_data = piece_colour;
                        end
                    end
                    
                    3'b010: begin // Knight
                        // Simple knight shape
                        if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 4 && pixel_y % 8 >= 1 && pixel_y % 8 <= 5) || 
                            (pixel_x % 8 >= 4 && pixel_x % 8 <= 6 && pixel_y % 8 >= 3 && pixel_y % 8 <= 5))
                        begin
                            oled_data = piece_colour;
                        end
                    end
                    
                    3'b011: begin // Bishop
                        // Simple bishop shape
                        if ((pixel_x % 8 - 4) * (pixel_x % 8 - 4) + (pixel_y % 8 - 2) * (pixel_y % 8 - 2) <= 3 || 
                            (pixel_y % 8 >= 3 && pixel_y % 8 <= 5 && pixel_x % 8 >= 3 && pixel_x % 8 <= 5))
                        begin
                            oled_data = piece_colour;
                        end
                    end
                    
                    3'b100: begin // Rook
                        // Simple rook shape
                        if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 6 && pixel_y % 8 >= 4 && pixel_y % 8 <= 6) || 
                            ((pixel_x % 8 == 2 || pixel_x % 8 == 4 || pixel_x % 8 == 6) && 
                             pixel_y % 8 >= 1 && pixel_y % 8 <= 3))
                        begin
                            oled_data = piece_colour;
                        end
                    end
                    
                    3'b101: begin // Queen
                        // Simple queen shape
                        if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 6 && pixel_y % 8 >= 4 && pixel_y % 8 <= 6) || 
                            ((pixel_x % 8 == 2 || pixel_x % 8 == 4 || pixel_x % 8 == 6) && 
                             pixel_y % 8 >= 1 && pixel_y % 8 <= 3))
                        begin
                            oled_data = piece_colour;
                        end
                    end
                    
                    3'b110: begin // King
                        // Simple king shape
                        if ((pixel_x % 8 >= 2 && pixel_x % 8 <= 6 && pixel_y % 8 >= 4 && pixel_y % 8 <= 6) || 
                            (pixel_x % 8 == 4 && pixel_y % 8 >= 1 && pixel_y % 8 <= 3) || 
                            (pixel_x % 8 >= 3 && pixel_x % 8 <= 5 && pixel_y % 8 == 2))
                        begin
                            oled_data = piece_colour;
                        end
                    end
                endcase
            end
        end
        else begin
            oled_data = BLACK; // Off-board area
        end
    end
    
    Display (basys_clock, oled_data, pixel_x, pixel_y, JB);
endmodule
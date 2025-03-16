`include "Constants.vh"

module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    output [7:0] JB
);
    reg [255:0] board = INITIAL_BOARD;
    reg [15:0] piece_colour;

    reg [15:0] oled_data;
    wire [6:0] pixel_x, pixel_y;
    Display (basys_clock, oled_data, pixel_x, pixel_y, JB);

    wire [4:0] grid_x, grid_y;
    Grid_Coordinates (pixel_x, pixel_y, grid_x, grid_y);

    wire [3:0] piece;
    Current_Piece (board, grid_x, grid_y, piece);

    wire [4:0] curr_x, curr_y;
    wire confirm;
    Btn_Input (basys_clock, btnU, btnC, btnD, btnL, btnR, curr_x, curr_y, confirm);    
    
    reg [4:0] selected_x, selected_y;
    integer from_index, to_index;

    always @(posedge confirm) begin
        // Case 1: Deselect if clicking on already selected square
        if (selected_x == curr_x && selected_y == curr_y) begin
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 2: Move piece if one is already selected
        else if (selected_x != NULL && selected_y != NULL) begin
            from_index = ((7 - selected_y) * 8 + (selected_x - 2)) * 4;
            to_index = ((7 - curr_y) * 8 + (curr_x - 2)) * 4;
            // Move the piece in the board array
            board[to_index +: 4] <= board[from_index +: 4];  // Copy piece to new position
            board[from_index +: 4] <= 4'b0000;  // Clear old position

            // Deselect after moving
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 3: Select current square if no piece is selected
        else begin 
            selected_x <= curr_x;
            selected_y <= curr_y;
        end
    end

    // RENDER LOGIC:

    always @(posedge basys_clock) begin
        if (grid_x >= 2 && grid_x <= 9 && grid_y <= 7) begin            
            //Layer 1: First, draw background based on the game state
            if (grid_x == selected_x && grid_y == selected_y)
                oled_data = BLUE;
            else if (grid_x == curr_x && grid_y == curr_y) 
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
endmodule
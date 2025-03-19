`include "Constants.vh"

module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    output [7:0] JB
);    
    reg [255:0] board = INITIAL_BOARD; 

    wire [15:0] oled_data;
    wire [6:0] pixel_x, pixel_y;        
    Display (basys_clock, oled_data, pixel_x, pixel_y, JB);
    
    wire [4:0] grid_x, grid_y;
    wire out_of_bounds;
    Grid_Coordinates (pixel_x, pixel_y, grid_x, grid_y, out_of_bounds);
    
    wire [3:0] piece;
    Current_Piece (board, grid_x, grid_y, piece);

    wire [6:0] current_x, current_y;
    wire confirm;
    Btn_Input (basys_clock, btnU, btnC, btnD, btnL, btnR, current_x, current_y, confirm);

    reg [6:0] selected_x, selected_y;    
    integer from_index, to_index;

    always @(posedge confirm) begin
        // Case 1: Deselect if clicking on already selected square
        if (selected_x == current_x && selected_y == current_y) begin
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 2: Move piece if one is already selected
        else if (selected_x != NULL && selected_y != NULL) begin
            from_index = ((7 - selected_y) * 8 + (selected_x - 2)) * 4;
            to_index = ((7 - current_y) * 8 + (current_x - 2)) * 4;
            // Move the piece in the board array
            board[to_index +: 4] <= board[from_index +: 4];  // Copy piece to new position
            board[from_index +: 4] <= 4'b0000;  // Clear old position

            // Deselect after moving
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 3: Select current square if no piece is selected
        else begin 
            selected_x <= current_x;
            selected_y <= current_y;
        end
    end
    
    
    Renderer renderer_inst (
        .basys_clock(basys_clock),
        .piece(piece),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .out_of_bounds(out_of_bounds),
        .oled_data(oled_data)
    );
endmodule
`include "Constants.vh"

module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    output reg [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JB
);  

    wire [15:0] oled_data;
    wire [6:0] pixel_x, pixel_y;
    Display (basys_clock, oled_data, pixel_x, pixel_y, JB);

    wire [3:0] grid_x, grid_y;
    wire [3:0] current_x, current_y;    
    reg  [3:0] selected_x = NULL, selected_y = NULL;
    Grid_Coordinates (pixel_x, pixel_y, grid_x, grid_y);   

    reg  [255:0] board = INITIAL_BOARD; 
    wire [63:0] moves;
   
    wire [3:0] current_piece;
    Current_Piece (board, current_x, current_y, current_piece); 
    
    Game_Logic (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(selected_x),
        .grid_y(selected_y),
        .moves(moves)
    );

    
    
    reg player = 1; // White starts the game
    
    // Get King grid coordinates of current player
    // ----------------------------------------------------------------------------------------
//    reg [3:0] king_x, king_y;
    wire [3:0] king_piece;
    assign king_piece[2:0] = 3'b110;
    assign king_piece[3] = player;
//    integer i;
//    always @(posedge basys_clock) begin
//        // Default to no piece found
//        king_x = 4'b0000;
//        king_y = 4'b0000;

//        // Loop through each of the 64 squares (16 bits = 4 bits per square * 64 squares)
//        for (i = 0; i < 64; i = i + 1) begin
//            // Check if the piece matches
//            if (board[(i * 4) +: 4] == king_piece) begin
//                king_x = i % 8;  // x-coordinate (column)
//                king_y = i / 8;  // y-coordinate (row)
//            end
//        end
//    end
    wire is_threatening_king = 1;
    //Is_Threatening_King (basys_clock, board, king_x, king_y, player, is_threatening_king);
    // ----------------------------------------------------------------------------------------
    
    integer from_index, to_index;
    reg promotion_wait = 0; // Flag to pause until a promotion piece is selected
    wire [1:0] selected_promotion_piece;
    reg [3:0] promotion_x, promotion_y;
    reg [23:0] promotion_timer; // Timer for auto selection
    
    wire confirm;
    Btn_Input (
        .basys_clock(basys_clock),
        .btnU(btnU),
        .btnC(btnC),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .is_promotion(promotion_wait),
        .selected_promotion_piece(selected_promotion_piece),
        .curr_x(current_x),
        .curr_y(current_y),
        .confirm(confirm)
    );

    always @(posedge confirm) begin
        led[0] = player;
        led[1] = promotion_wait;
        led[15:12] = sw[15:12];
    
        // Wait for player to select promotion piece
        if (promotion_wait) begin
            to_index = ((7 - promotion_y) * 8 + (promotion_x)) * 4;
            
            case (selected_promotion_piece)
                2'b00: board[to_index +: 4] = player ? W_QUEEN : B_QUEEN;
                2'b01: board[to_index +: 4] = player ? W_ROOK : B_ROOK;
                2'b10: board[to_index +: 4] = player ? W_BISHOP : B_BISHOP;
                2'b11: board[to_index +: 4] = player ? W_KNIGHT : B_KNIGHT;
            endcase
            
            promotion_wait <= 0;  // Resume game
            player <= ~player; // Invert the player
        end
            
    
        // Case 1: Deselect if clicking on already selected square
        else if (selected_x == current_x && selected_y == current_y) begin
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 2: Move piece if one is already selected
        else if (selected_x != NULL && selected_y != NULL && moves[current_y * 8 + current_x] == 1) begin
            from_index = ((7 - selected_y) * 8 + (selected_x)) * 4;
            to_index = ((7 - current_y) * 8 + (current_x)) * 4;
            
            // Move the piece in the board array
            board[to_index +: 4] <= board[from_index +: 4];  // Copy piece to new position
            board[from_index +: 4] <= EMPTY;  // Clear old position
            
            // Check if Pawn promotion
            if ((board[from_index +: 4] == W_PAWN && selected_y == 1) || 
                (board[from_index +: 4] == B_PAWN && selected_y == 6)) begin
                // Pawn Promotion
                promotion_x <= current_x;
                promotion_y <= current_y;
                promotion_wait <= 1;
                promotion_timer <= 0;
            end else begin
                player <= ~player; // Invert the player
            end
            
            // Deselect after moving
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 3: Select current square if no piece is selected
        else if (current_piece != EMPTY && current_piece[3] == player) begin
            selected_x <= current_x;
            selected_y <= current_y;
        end
    end
    
    Renderer (
        .basys_clock(basys_clock),
        .board(board),
        .moves(moves),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .king_piece(king_piece),
        .is_threatening_king(is_threatening_king),
        .is_promotion(promotion_wait),
        .selected_promotion_piece(selected_promotion_piece),
        .oled_data(oled_data)
    );
    
endmodule
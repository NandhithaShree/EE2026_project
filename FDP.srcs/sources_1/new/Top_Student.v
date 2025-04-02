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

    reg  [255:0] board = INITIAL_BOARD; 
    wire [63:0] moves;
    reg player = 1; // White starts the game
    reg [1:0] game_state = 2'b00;
    
    // Create 1s clock for timer
    wire clock_1hz;
    Clock (basys_clock, 50_000_000, clock_1hz);

    // Oled data required for displaying in oled screen
    wire [15:0] oled_data;
    wire [6:0] pixel_x, pixel_y;
    Display (basys_clock, oled_data, pixel_x, pixel_y, JB);

    // Get grid coordinates of cursor and selected cell
    wire [3:0] grid_x, grid_y;
    wire [3:0] current_x, current_y; 
    wire [3:0] current_piece;   
    reg  [3:0] selected_x = NULL, selected_y = NULL;
    Grid_Coordinates (pixel_x, pixel_y, grid_x, grid_y);   
    Current_Piece (board, current_x, current_y, current_piece); 
    
    // Get King grid coordinates of current player
    // ----------------------------------------------------------------------------------------
    wire [3:0] king_piece;
    assign king_piece[2:0] = 3'b110;
    assign king_piece[3] = player;
    wire is_threatening_king = 1;
    //Is_Threatening_King (basys_clock, board, king_x, king_y, player, is_threatening_king);
    // ----------------------------------------------------------------------------------------
    
    integer from_index, to_index;
    reg promotion_wait = 0; // Flag to pause until a promotion piece is selected
    wire [1:0] selected_promotion_piece;
    reg [3:0] promotion_x, promotion_y;
    reg [23:0] promotion_timer; // Timer for auto selection
    
    wire [5:0] min1, sec1, min2, sec2;
    
    wire confirm;
    reg prev_confirm;
    always @ (posedge basys_clock) begin
        prev_confirm <= confirm; // Store previous state of confirm
    end
        
    always @ (posedge basys_clock) begin
        if (confirm) begin
            case(game_state)
                2'b00: game_state <= 2'b11;
                2'b01: game_state <= 2'b00;
                2'b10: game_state <= 2'b00;
                default: game_state <= 2'b11;
            endcase
        end
        else if (min1 == 0 && sec1 == 0) begin // player 2 wins (black) Red circle
            game_state <= 2'b10;
        end
        else if (min2 == 0 && sec2 == 0) begin // player 1 wins (white) Green circle
            game_state <= 2'b01;
        end
    end

    always @(posedge confirm) begin
        if (game_state == 2'b00) begin
            board[255:0] <= INITIAL_BOARD;
            player <= 1;
        end
    
        // Wait for player to select promotion piece
        else if (promotion_wait) begin
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
    
    Game_Logic (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(selected_x),
        .grid_y(selected_y),
        .moves(moves)
    );
    
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
    
    Renderer (
        .basys_clock(basys_clock),
        .board(board),
        .moves(moves),
        .game_state(game_state),
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
    
    ChessTimer (
        .clock_1hz(clock_1hz),
        .game_state(game_state),
        .player(player),
        .min1(min1),
        .sec1(sec1),
        .min2(min2),
        .sec2(sec2)
    );
    
    DisplayTimer (
        .basys_clock(basys_clock),
        .min1(min1),
        .sec1(sec1),
        .min2(min2),
        .sec2(sec2),
        .player(player),
        .an(an),
        .seg(seg)
    );
endmodule
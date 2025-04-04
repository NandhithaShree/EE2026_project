`include "Constants.vh"

module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    input rx,
    output reg [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JB,
    output tx,
    output [11:0] vga,
    output hsync, vsync
);  
    reg [2:0] state = GAME;

    wire [15:0] oled_data;
    wire [6:0] pixel_x, pixel_y;
    Display display_inst (
        .basys_clock(basys_clock), 
        .oled_data(oled_data), 
        .x(pixel_x), 
        .y(pixel_y), 
        .JB(JB)
    );

    wire [3:0] grid_x, grid_y;
    wire [3:0] current_x, current_y;    
    reg [3:0] selected_x = NULL, selected_y = NULL;
    
    Grid_Coordinates grid_coord_inst (
        .x(pixel_x), 
        .y(pixel_y), 
        .grid_x(grid_x), 
        .grid_y(grid_y)
    );   

    reg [255:0] board = INITIAL_BOARD;
    wire [63:0] moves;
   
    wire [3:0] current_piece;
    Current_Piece current_piece_inst (
        .board(board), 
        .x(current_x), 
        .y(current_y), 
        .piece(current_piece)
    ); 
    
    Game_Logic game_logic_inst (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(selected_x),
        .grid_y(selected_y),
        .moves(moves)
    );
    
    reg player = 1; // White starts the game
    reg player_turn = 1; // Track whose turn it is (1 for local player, 0 for remote)

    wire [3:0] king_piece;
    assign king_piece[2:0] = 3'b110;
    assign king_piece[3] = player;
    wire is_threatening_king = 1;
    
    integer from_index, to_index;
    integer remote_from_index, remote_to_index;
    
    wire [1:0] selected_promotion_piece;
    reg [3:0] promotion_x, promotion_y;
    
    wire confirm;
    Btn_Input btn_input_inst (
        .basys_clock(basys_clock),
        .btnU(btnU),
        .btnC(btnC),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .is_promotion(state == PROMOTION),
        .selected_promotion_piece(selected_promotion_piece),
        .curr_x(current_x),
        .curr_y(current_y),
        .confirm(confirm)
    );
    
    // Edge detection for button and signals
    reg confirm_prev = 0;
    wire confirm_pressed = confirm && !confirm_prev;
    
    reg data_ready_prev = 0;
    reg data_ready_edge;
    
    //UART components
    reg [31:0] tx_data;
    wire [31:0] rx_data;
    reg start_tx = 0;
    wire data_ready;
    
    Uart_TX uart_tx_inst (
        .basys_clock(basys_clock),
        .data_in(tx_data),
        .trigger_tx(start_tx),
        .tx(tx)
    );
    
    Uart_RX uart_rx_inst (
        .basys_clock(basys_clock),
        .rx(rx),
        .data_out(rx_data),
        .data_ready(data_ready)
    );
    
    // Extract move coordinates from received data
    wire [3:0] remote_selected_x = rx_data[15:12];
    wire [3:0] remote_selected_y = rx_data[11:8];
    wire [3:0] remote_current_x = rx_data[7:4];
    wire [3:0] remote_current_y = rx_data[3:0];

    // Single process FSM for both state transitions and actions
    always @(posedge basys_clock) begin
        // Edge detection updates
        confirm_prev <= confirm;
        data_ready_prev <= data_ready;
        data_ready_edge <= data_ready && !data_ready_prev;
        
        // Default reset for transient signals
        start_tx <= 0;
        
        // Main FSM logic
        case (state)
            GAME: begin
                if (confirm_pressed) begin
                    if (player_turn) begin
                        // Player's turn actions
                        if (selected_x == NULL && selected_y == NULL) begin
                            // Case 1: No piece selected yet - select a piece
                            if (current_piece != EMPTY && current_piece[3] == player) begin
                                selected_x <= current_x;
                                selected_y <= current_y;
                            end
                        end
                        else if (selected_x == current_x && selected_y == current_y) begin
                            // Case 2: Deselect if clicking on already selected square
                            selected_x <= NULL;
                            selected_y <= NULL;
                        end
                        else if (moves[current_y * 8 + current_x] == 1) begin
                            // Case 3: Move piece if valid
                            from_index = ((7 - selected_y) * 8 + (selected_x)) * 4;
                            to_index = ((7 - current_y) * 8 + (current_x)) * 4;
                            
                            // Move the piece in the board array
                            board[to_index +: 4] <= board[from_index +: 4];
                            board[from_index +: 4] <= EMPTY;
                            
                            // Check if pawn promotion is needed
                            if ((board[from_index +: 4] == W_PAWN && selected_y == 1) || 
                                (board[from_index +: 4] == B_PAWN && selected_y == 6)) begin
                                // Pawn Promotion
                                promotion_x <= current_x;
                                promotion_y <= current_y;
                                state <= PROMOTION;
                            end else begin
                                // Normal move completion
                                player_turn <= 0; // Switch to opponent's turn
                                tx_data <= {selected_x, selected_y, current_x, current_y};
                                start_tx <= 1;
                            end
                            
                            // Deselect after moving
                            selected_x <= NULL;
                            selected_y <= NULL;
                        end
                    end
                    else if (!player_turn && sw[0]) begin
                        // Debug: Manual player turn switch with switch[0]
                        player_turn <= 1;
                    end
                end
                
                // Handle incoming remote moves (when it's not player's turn)
                if (!player_turn && data_ready_edge) begin
                    state <= REMOTE_MOVE;
                end
            end
            
            PROMOTION: begin
                if (confirm_pressed) begin
                    to_index = ((7 - promotion_y) * 8 + (promotion_x)) * 4;
                    
                    case (selected_promotion_piece)
                        2'b00: board[to_index +: 4] <= player ? W_QUEEN : B_QUEEN;
                        2'b01: board[to_index +: 4] <= player ? W_ROOK : B_ROOK;
                        2'b10: board[to_index +: 4] <= player ? W_BISHOP : B_BISHOP;
                        2'b11: board[to_index +: 4] <= player ? W_KNIGHT : B_KNIGHT;
                    endcase
                    
                    player_turn <= 0; // Switch to opponent's turn
                    tx_data <= {selected_x, selected_y, promotion_x, promotion_y};
                    start_tx <= 1;
                    state <= GAME;
                end
            end
            
            REMOTE_MOVE: begin
                // Calculate board indices for the remote move
                remote_from_index = ((7 - remote_selected_y) * 8 + remote_selected_x) * 4;
                remote_to_index = ((7 - remote_current_y) * 8 + remote_current_x) * 4;
                
                // Execute the move if valid coordinates
                if (remote_selected_x != NULL && remote_selected_y != NULL && 
                    remote_current_x < 8 && remote_current_y < 8) begin
                    
                    // Move the piece in the board array
                    board[remote_to_index +: 4] <= board[remote_from_index +: 4];
                    board[remote_from_index +: 4] <= EMPTY;
                    player_turn <= 1; // Switch back to player's turn
                end
                
                state <= GAME;
            end
            
            END_GAME: begin
                // Future implementation for game over state
                if (confirm_pressed) begin
                    // Reset game
                    board <= INITIAL_BOARD;
                    player <= 1;
                    player_turn <= 1;
                    selected_x <= NULL;
                    selected_y <= NULL;
                    state <= GAME;
                end
            end
        endcase
    end
    
    Renderer renderer_inst (
        .board(board),
        .moves(moves),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .state(state),  
        .selected_promotion_piece(selected_promotion_piece),
        .oled_data(oled_data)
    );
endmodule
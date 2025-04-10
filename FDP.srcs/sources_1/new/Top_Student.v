`include "Constants.vh"

module Top_Student (
    input basys_clock,   
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    input rx,
    inout PS2Clk, PS2Data,
    output reg [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JB,
    output tx,
    output [11:0] vga,
    output hsync, vsync,
    output DIN,         // Audio out to PmodAMP2
    output wire GAIN,       // Gain control
    output wire SD  
);  
    reg [2:0] state = START_GAME;
    parameter player = 1;  // 1 is white, 0 is black
    reg [3:0] W_dead_pawns = 0;
    reg [3:0] B_dead_pawns = 0;
    reg [3:0] W_dead_queens = 0;
    reg [3:0] B_dead_queens = 0;
    reg [3:0] W_dead_rooks = 0;
    reg [3:0] B_dead_rooks = 0;
    reg [3:0] W_dead_bishops = 0;
    reg [3:0] B_dead_bishops = 0;
    reg [3:0] W_dead_knights = 0;
    reg [3:0] B_dead_knights = 0;

    wire [15:0] oled_data;
    wire [15:0] real_oled_data;
    wire [6:0] pixel_x, pixel_y;
    Display display_inst (
        .basys_clock(basys_clock),
        .real_oled_data(real_oled_data),
        .oled_data(oled_data), 
        .x(pixel_x), 
        .y(pixel_y), 
        .JB(JB),
        .hsync(hsync),
        .vsync(vsync),
        .vga_data(vga)
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
    
    integer from_index, to_index;
    integer remote_from_index, remote_to_index;
    
    wire [1:0] selected_promotion_piece;
    reg [3:0] promotion_x, promotion_y;
    
    wire confirm;
    
//    wire btn_confirm;
//    Btn_Input btn_input_inst (
//        .basys_clock(basys_clock),
//        .btnU(btnU),
//        .btnC(btnC),
//        .btnD(btnD),
//        .btnL(btnL),
//        .btnR(btnR),
//        .is_promotion(state == PROMOTION),
//        .selected_promotion_piece(selected_promotion_piece),
//        .curr_x(current_x),
//        .curr_y(current_y),
//        .confirm(btn_confirm)
//    );
    
    reg reset;
    reg [11:0] value;
    reg setx, sety, setmax_x = 0, setmax_y = 0;
    
    wire [11:0] mouse_xpos, mouse_ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    reg [1:0] setMouseMax = 2'b00;
    always @(posedge basys_clock) begin
        case (setMouseMax)
            2'b00: begin
                value <= 12'd559; //value is here
                setmax_x <= 1;
                setmax_y <= 0;
                setMouseMax = setMouseMax + 1;
            end
            2'b01: begin
                value <= 12'd447;
                setmax_y = 1;
                setmax_x = 0;
                setMouseMax = setMouseMax + 1;
            end
            default: begin
                setmax_x = 0;
                setmax_y = 0;
            end
        endcase
    end
    
    MouseCtl(
        .clk(basys_clock),
        .rst(0),
        .value(value),
        .setx(0),
        .sety(0),
        .setmax_x(setmax_x),
        .setmax_y(setmax_y),
        .xpos(mouse_xpos),
        .ypos(mouse_ypos),
        .zpos(zpos),
        .left(left),
        .middle(middle),
        .right(right),
        .new_event(new_event),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data)
    );
    
    wire mouse_confirm;
    Mouse_Input mouse_input_inst (
        .basys_clock(basys_clock),
        .left(left),
        .xpos(mouse_xpos),
        .ypos(mouse_ypos),
        .is_promotion(state == PROMOTION),
        .selected_promotion_piece(selected_promotion_piece),
        .curr_x(current_x),
        .curr_y(current_y),
        .confirm(mouse_confirm)
    );
    
    wire hover_start, hover_restart;
    assign hover_start = mouse_xpos >= 26 && mouse_xpos <= 69 && mouse_ypos >= 42 && mouse_ypos <= 57;
    assign hover_restart = mouse_xpos >= 2 && mouse_xpos <= 61 && mouse_ypos >= 42 && mouse_ypos <= 57;
    assign confirm = mouse_confirm;
    
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
    
    wire [5:0] min, sec;
    wire timeout;
    
    Chess_Timer (
        .basys_clock(basys_clock),
        .game_state(state),
        .min(min),
        .sec(sec),
        .timeout(timeout)
    );
    
    Display_Timer (
        .basys_clock(basys_clock),
        .min(min),
        .sec(sec),
        .an(an),
        .seg(seg)
    );
    
    reg [2:0] sound; //start with start
   

    // Single process FSM for both state transitions and actions
    always @(posedge basys_clock) begin
        // Edge detection updates
        confirm_prev <= confirm;
        data_ready_prev <= data_ready;
        data_ready_edge <= data_ready && !data_ready_prev;
        
        // Default reset for transient signals
        start_tx <= 0;
        sound <= IDLE;
        
        // Main FSM logic
        case (state)
            PLAYER_TURN: begin
                if (timeout) begin
                    state <= player ? BLACK_WIN : WHITE_WIN;
                end else if (confirm_pressed) begin
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
                        
                        //If the captured is king, end the game
                        if (board[to_index +: 4] == W_KING) begin
                            state <= BLACK_WIN;
                        end
                        else if (board[to_index +: 4] == B_KING) begin
                            state <= WHITE_WIN;
                        end
                        else begin
                        
                            if (board[to_index +: 4] != EMPTY) begin 
                                sound <= PLAY_EAT; //if it is eating a piece play
                            end else begin 
                                sound <= PLAY_MOVE;
                            end
                                 
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
                                // Normal move completion - transition to ENEMY_TURN
                                tx_data <= {selected_x, selected_y, current_x, current_y};
                                start_tx <= 1;
                                state <= ENEMY_TURN;
                            end
                            // Deselect after moving
                            selected_x <= NULL;
                            selected_y <= NULL;
                        end
                    end
                end
            end
            
            ENEMY_TURN: begin
                // When we receive data from remote player, process it
                if (data_ready_edge) begin
                    // Calculate board indices for the remote move
                    remote_from_index = ((7 - remote_selected_y) * 8 + remote_selected_x) * 4;
                    remote_to_index = ((7 - remote_current_y) * 8 + remote_current_x) * 4;
                    
                    // Execute the move if valid coordinates
                    if (remote_selected_x != NULL && remote_selected_y != NULL && 
                        remote_current_x < 8 && remote_current_y < 8) begin
                        
                        // Move the piece in the board array
                        board[remote_to_index +: 4] <= board[remote_from_index +: 4];
                        board[remote_from_index +: 4] <= EMPTY;
                        
                        if (board[remote_to_index +: 4] != EMPTY) begin 
                            sound <= PLAY_EAT;
                        end else begin 
                            sound <= PLAY_MOVE;
                        end
                        
                        //If the captured is king, end the game
                        if (board[remote_to_index +: 4] == W_KING) begin
                            state <= BLACK_WIN;
                        end
                        else if (board[remote_to_index +: 4] == B_KING) begin
                            state <= WHITE_WIN;
                        end
                        else begin
                            state <= PLAYER_TURN;
                        end
                    end
                    else begin
                        state <= PLAYER_TURN;
                    end
                end
                // Debug: Allow manual transition back with switch
                else if (sw[0]) begin
                    state <= PLAYER_TURN;
                end
            end
            
            PROMOTION: begin
                if (confirm_pressed) begin
                    to_index = ((7 - promotion_y) * 8 + (promotion_x)) * 4;
                    sound <= PLAY_PROMOTION; //Play sound when pressed
                    
                    case (selected_promotion_piece)
                        2'b00: board[to_index +: 4] <= player ? W_QUEEN : B_QUEEN;
                        2'b01: board[to_index +: 4] <= player ? W_ROOK : B_ROOK;
                        2'b10: board[to_index +: 4] <= player ? W_BISHOP : B_BISHOP;
                        2'b11: board[to_index +: 4] <= player ? W_KNIGHT : B_KNIGHT;
                    endcase
                    
                    // After promotion, send move data and switch to enemy turn
                    tx_data <= {selected_x, selected_y, promotion_x, promotion_y};
                    start_tx <= 1;
                    state <= ENEMY_TURN;
                end
            end
            
            START_GAME: begin 
                sound <= PLAY_START; //when game start, play sound
                if (confirm_pressed) begin
                     board <= INITIAL_BOARD;
                     selected_x <= NULL;
                     selected_y <= NULL;
                     state <= PLAYER_TURN; // Start with player's turn
                end
            end
            
            WHITE_WIN,
            BLACK_WIN: begin
                sound <= PLAY_END;
                if (confirm_pressed && hover_restart) begin
                    state <= START_GAME;
                end
            end
            
        endcase
    end
    
    Renderer renderer_inst (
        .board(board),
        .moves(moves),
        .mouse_xpos(mouse_xpos),
        .mouse_ypos(mouse_ypos),
        .hover_start(hover_start),
        .hover_restart(hover_restart),
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
    
    oled_Renderer renderer_inst_oled (
        .board(board),
        .moves(moves),
        .mouse_xpos(mouse_xpos),
        .mouse_ypos(mouse_ypos),
        .hover_start(hover_start),
        .hover_restart(hover_restart),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .state(state),  
        .selected_promotion_piece(selected_promotion_piece),
        .W_dead_pawns(W_dead_pawns),
        .B_dead_pawns(B_dead_pawns),
        .W_dead_queens(W_dead_queens),
        .B_dead_queens(B_dead_queens),
        .W_dead_rooks(W_dead_rooks),
        .B_dead_rooks(B_dead_rooks),
        .W_dead_bishops(W_dead_bishops),
        .B_dead_bishops(B_dead_bishops),
        .W_dead_knights(W_dead_knights),
        .B_dead_knights(B_dead_knights),
        .oled_data(real_oled_data)
    );
    
    PMOD PMOD_Inst (
        .clk(basys_clock),
        .sound(sound),
        .DIN(DIN),
        .GAIN(GAIN),
        .SD(SD)
    );

endmodule
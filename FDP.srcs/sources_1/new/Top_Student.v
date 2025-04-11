module Top_Student (
    input basys_clock,   
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    input rx,
    inout PS2Clk, PS2Data,
    output reg [15:0] led,
    output [3:0] an,
    output [7:0] seg,
    output [7:0] JC,
    output tx,
    output [11:0] vga,
    output hsync, vsync,
    output DIN,         // Audio out to PmodAMP2
    output wire GAIN,       // Gain control
    output wire SD  
);  
    reg [2:0] state = START_GAME;
    wire player; 
    assign player = sw[15];  // 1 is white, 0 is black
    
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


    // Define packet type constants for clarity
    parameter PKT_TYPE_START = 2'b00;
    parameter PKT_TYPE_PROMOTION = 2'b01;
    parameter PKT_TYPE_TIMEOUT = 2'b10;
    parameter PKT_TYPE_MOVE = 2'b11;

    wire [15:0] oled_data;
    wire [15:0] vga_data;
    wire [6:0] pixel_x, pixel_y;
    
    VGA_Display display_inst (
        .basys_clock(basys_clock), 
        .oled_data(vga_data), 
        .x(pixel_x), 
        .y(pixel_y), 
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
    
//    wire confirm;
    
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
//        .confirm(confirm)
//    );
    
    reg reset;
    reg [11:0] value;
    reg setx, sety, setmax_x = 0, setmax_y = 0;
    
    wire [11:0] temp_mouse_xpos, mouse_xpos, mouse_ypos;
    assign mouse_xpos = (temp_mouse_xpos < 12'd16) ? 12'd16 : temp_mouse_xpos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    reg [1:0] setMouseMax = 2'b00;
    always @(posedge basys_clock) begin
        case (setMouseMax)
            2'b00: begin
                value <= 12'd79; //value is here
                setmax_x <= 1;
                setmax_y <= 0;
                setMouseMax <= setMouseMax + 1; // Changed to non-blocking assignment
            end
            2'b01: begin
                value <= 12'd63;
                setmax_y <= 1; // Changed to non-blocking assignment
                setmax_x <= 0; // Changed to non-blocking assignment
                setMouseMax <= setMouseMax + 1; // Changed to non-blocking assignment
            end
            default: begin
                setmax_x <= 0; // Changed to non-blocking assignment
                setmax_y <= 0; // Changed to non-blocking assignment
            end
        endcase
    end
    
    MouseCtl mouse_ctl_inst (  // Added module instance name
        .clk(basys_clock),
        .rst(0),
        .value(value),
        .setx(0),
        .sety(0),
        .setmax_x(setmax_x),
        .setmax_y(setmax_y),
        .xpos(temp_mouse_xpos),
        .ypos(mouse_ypos),
        .zpos(zpos),
        .left(left),
        .middle(middle),
        .right(right),
        .new_event(new_event),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data)
    );

    wire confirm;
    Mouse_Input mouse_input_inst (
        .basys_clock(basys_clock),
        .left(left),
        .xpos(mouse_xpos),
        .ypos(mouse_ypos),
        .is_promotion(state == PROMOTION),
        .selected_promotion_piece(selected_promotion_piece),
        .curr_x(current_x),
        .curr_y(current_y),
        .confirm(confirm)
    );    
    
    
    wire hover;
    assign hover = mouse_xpos >= 26 && mouse_xpos <= 69 && mouse_ypos >= 42 && mouse_ypos <= 57;
    
    // Edge detection for button and signals
    reg confirm_prev = 0;
    wire confirm_pressed = confirm && !confirm_prev;
    
    //UART components - CHANGED FROM 20 to 32 BITS
    reg [19:0] uart_payload;   // The actual payload data (20 bits)
    wire [31:0] tx_data;       // Full packet with signature and checksum
    reg start_tx = 0;
    wire data_ready;
    wire [31:0] rx_data;
    
    // Calculate checksum for outgoing data
    wire [3:0] tx_checksum = uart_payload[3:0] ^ uart_payload[7:4] ^ 
                           uart_payload[11:8] ^ uart_payload[15:12] ^ 
                           uart_payload[19:16];
    
    // Assemble full packet with signature and checksum
    assign tx_data = {tx_checksum, 8'hAA, uart_payload};
    
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
    
    // UART packet validation
    wire [7:0] rx_signature = rx_data[27:20];
    wire rx_valid_signature = (rx_signature == 8'hAA);
    wire [3:0] rx_checksum = rx_data[31:28];
    wire [3:0] calculated_checksum = rx_data[3:0] ^ rx_data[7:4] ^ rx_data[11:8] ^ rx_data[15:12] ^ 
                                   rx_data[19:16] ^ rx_data[23:20] ^ rx_data[27:24];
    wire rx_valid_checksum = (rx_checksum == calculated_checksum);
    wire rx_valid_packet = rx_valid_signature && rx_valid_checksum;
    
    // Extract move coordinates from received data (payload is in bits 19:0)
    wire [1:0] remote_promotion = rx_data[19:18];
    wire [1:0] remote_type = rx_data[17:16];
    wire [3:0] remote_selected_x = rx_data[15:12];
    wire [3:0] remote_selected_y = rx_data[11:8];
    wire [3:0] remote_current_x = rx_data[7:4];
    wire [3:0] remote_current_y = rx_data[3:0];
    
    // Edge detection for UART data_ready
    reg data_ready_prev = 0;
    wire data_ready_edge = data_ready && !data_ready_prev && rx_valid_packet; // Only trigger on valid packets
    
    wire [5:0] min, sec;
    wire timeout;
    
    Chess_Timer chess_timer_inst (  // Added module instance name
        .basys_clock(basys_clock),
        .game_state(state),
        .min(min),
        .sec(sec),
        .timeout(timeout)
    );
    
    Display_Timer display_timer_inst (  // Added module instance name
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
        
        // Default reset for transient signals
        start_tx <= 0;
        sound <= IDLE;
        
        // Main FSM logic
        case (state)
            PLAYER_TURN: begin
                led[15:11] <= 0;
                if (timeout & !sw[1]) begin
                    state <= player ? BLACK_WIN : WHITE_WIN;
                    uart_payload <= {2'b00, PKT_TYPE_TIMEOUT, selected_x, selected_y, current_x, current_y};
                    start_tx <= 1;
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
                        
                        if (board[to_index +: 4] != EMPTY) begin
                            case (board[to_index +: 4])
                                B_PAWN: B_dead_pawns <= B_dead_pawns + 1;
                                W_PAWN: W_dead_pawns <= W_dead_pawns + 1;
                                B_KNIGHT: B_dead_knights <= B_dead_knights + 1;
                                W_KNIGHT: W_dead_knights <= W_dead_knights + 1;
                                B_BISHOP: B_dead_bishops <= B_dead_bishops + 1;
                                W_BISHOP: W_dead_bishops <= W_dead_bishops + 1;
                                B_ROOK: B_dead_rooks <= B_dead_rooks + 1;
                                W_ROOK: W_dead_rooks <= W_dead_rooks + 1;
                                B_QUEEN: B_dead_queens <= B_dead_queens + 1;
                                W_QUEEN: W_dead_queens <= W_dead_queens + 1;
                            endcase
                        end                        
                        
                        //If the captured is king, end the game
                        if (board[to_index +: 4] == W_KING) begin
                            state <= BLACK_WIN;
                            // Send game end move to opponent
                            uart_payload <= {2'b00, PKT_TYPE_MOVE, selected_x, selected_y, current_x, current_y};
                            start_tx <= 1;
                        end
                        else if (board[to_index +: 4] == B_KING) begin
                            state <= WHITE_WIN;
                            // Send game end move to opponent
                            uart_payload <= {2'b00, PKT_TYPE_MOVE, selected_x, selected_y, current_x, current_y};
                            start_tx <= 1;
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
                                uart_payload <= {2'b00, PKT_TYPE_MOVE, selected_x, selected_y, current_x, current_y};
                                start_tx <= 1;
                                state <= ENEMY_TURN;
                                // Deselect after moving
                                selected_x <= NULL;
                                selected_y <= NULL;
                            end
                        end
                    end
                end
            end
            
            ENEMY_TURN: begin
                // When we receive data from remote player, process it
                if (data_ready_edge) begin
                    case (remote_type)
                        PKT_TYPE_START: begin
                            // Remote player wants to start a new game
                            board <= INITIAL_BOARD;
                            selected_x <= NULL;
                            selected_y <= NULL;
                            state <= player ? PLAYER_TURN : ENEMY_TURN;
                            sound <= PLAY_START;
                            // Reset dead pieces counters
                            W_dead_pawns <= 0; B_dead_pawns <= 0;
                            W_dead_queens <= 0; B_dead_queens <= 0;
                            W_dead_rooks <= 0; B_dead_rooks <= 0;
                            W_dead_bishops <= 0; B_dead_bishops <= 0;
                            W_dead_knights <= 0; B_dead_knights <= 0;
                        end
                        
                        PKT_TYPE_TIMEOUT: begin
                            // Remote player timed out
                            state <= player ? WHITE_WIN : BLACK_WIN;
                            sound <= PLAY_END;
                        end
                        
                        PKT_TYPE_PROMOTION, PKT_TYPE_MOVE: begin
                            // Calculate board indices for the remote move
                            remote_from_index = ((7 - remote_selected_y) * 8 + remote_selected_x) * 4;
                            remote_to_index = ((7 - remote_current_y) * 8 + remote_current_x) * 4;
                            // Execute the move if valid coordinates
                            if (remote_selected_x != NULL && remote_selected_y != NULL && 
                                remote_current_x < 8 && remote_current_y < 8) begin
                                led[13] <= 1;
                                //If the captured is king, end the game
                                if (board[remote_to_index +: 4] == W_KING) begin
                                    state <= BLACK_WIN;
                                    sound <= PLAY_END;
                                end
                                else if (board[remote_to_index +: 4] == B_KING) begin
                                    state <= WHITE_WIN;
                                    sound <= PLAY_END;
                                end
                                else begin  
                                    // Move the piece in the board array
                                    board[remote_to_index +: 4] <= board[remote_from_index +: 4];
                                    board[remote_from_index +: 4] <= EMPTY;
                                    led[12] <= 1;
                                    // Handle promotion if needed
                                    if (remote_type == PKT_TYPE_PROMOTION) begin
                                        case (remote_promotion)
                                            2'b00: board[remote_to_index +: 4] <= player ? B_QUEEN : W_QUEEN;
                                            2'b01: board[remote_to_index +: 4] <= player ? B_ROOK : W_ROOK;
                                            2'b10: board[remote_to_index +: 4] <= player ? B_BISHOP : W_BISHOP;
                                            2'b11: board[remote_to_index +: 4] <= player ? B_KNIGHT : W_KNIGHT;
                                        endcase
                                        led[11] <= 1;
                                        sound <= PLAY_PROMOTION;
                                    end else if (board[remote_to_index +: 4] != EMPTY) begin 
                                        sound <= PLAY_EAT;
                                        case (board[remote_to_index +: 4])
                                            B_PAWN: B_dead_pawns <= B_dead_pawns + 1;
                                            W_PAWN: W_dead_pawns <= W_dead_pawns + 1;
                                            B_KNIGHT: B_dead_knights <= B_dead_knights + 1;
                                            W_KNIGHT: W_dead_knights <= W_dead_knights + 1;
                                            B_BISHOP: B_dead_bishops <= B_dead_bishops + 1;
                                            W_BISHOP: W_dead_bishops <= W_dead_bishops + 1;
                                            B_ROOK: B_dead_rooks <= B_dead_rooks + 1;
                                            W_ROOK: W_dead_rooks <= W_dead_rooks + 1;
                                            B_QUEEN: B_dead_queens <= B_dead_queens + 1;
                                            W_QUEEN: W_dead_queens <= W_dead_queens + 1;
                                        endcase
                                    end else begin 
                                        sound <= PLAY_MOVE;
                                    end
                                
                                    state <= PLAYER_TURN;
                                end
                            end
                        end
                    endcase
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
                    // After promotion, send move data and switch to enemy turn
                    uart_payload <= {selected_promotion_piece, PKT_TYPE_PROMOTION, selected_x, selected_y, promotion_x, promotion_y};                    
                    start_tx <= 1;
                    state <= ENEMY_TURN;
                    selected_x <= NULL;
                    selected_y <= NULL;
                end
            end
            
            START_GAME: begin 
                sound <= PLAY_START; //when game start, play sound
                W_dead_pawns <= 0;
                B_dead_pawns <= 0;
                W_dead_queens <= 0;
                B_dead_queens <= 0;
                W_dead_rooks <= 0;
                B_dead_rooks <= 0;
                W_dead_bishops <= 0;
                B_dead_bishops <= 0;
                W_dead_knights <= 0;
                B_dead_knights <= 0;
                if (confirm_pressed && hover) begin
                     board <= INITIAL_BOARD;
                     selected_x <= NULL;
                     selected_y <= NULL;
                     state <= player ? PLAYER_TURN : ENEMY_TURN;
                     uart_payload <= {16'h0000, PKT_TYPE_START, 2'b00};
                     start_tx <= 1;
                     
                     
                end else if (data_ready_edge && remote_type == PKT_TYPE_START) begin
                     board <= INITIAL_BOARD;
                     selected_x <= NULL;
                     selected_y <= NULL;
                     state <= player ? PLAYER_TURN : ENEMY_TURN;
                end
            end
            
            WHITE_WIN,
            BLACK_WIN: begin
                sound <= PLAY_END;
                if (confirm_pressed) begin
                    state <= START_GAME;
                    // Notify opponent of restart
                    uart_payload <= {16'h0000, PKT_TYPE_START, 2'b00};
                    start_tx <= 1;
                end else if (data_ready_edge && remote_type == PKT_TYPE_START) begin
                     state <= START_GAME;
                end
            end
           
        endcase
    end
    
    VGA_Renderer vga_renderer_inst (
        .board(board),
        .moves(moves),
        .mouse_xpos(mouse_xpos),
        .mouse_ypos(mouse_ypos),
        .hover(hover),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .selected_x(selected_x),
        .selected_y(selected_y),
        .current_x(current_x),
        .current_y(current_y),
        .state(state),  
        .selected_promotion_piece(selected_promotion_piece),
        .oled_data(vga_data)
    );
    
    PMOD PMOD_Inst (
        .clk(basys_clock),
        .sound(sound),
        .DIN(DIN),
        .GAIN(GAIN),
        .SD(SD)
    );
    
    Dead_Piece_Display dead_display_inst (
        basys_clock,
        W_dead_pawns,
        B_dead_pawns,
        W_dead_queens,
        B_dead_queens,
        W_dead_rooks,
        B_dead_rooks,
        W_dead_bishops,
        B_dead_bishops,
        W_dead_knights,
        B_dead_knights,
        JC
    );

endmodule
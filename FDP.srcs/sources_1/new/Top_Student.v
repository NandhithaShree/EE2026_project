`include "Constants.vh"

module Top_Chess (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    output [15:0] led,
    output [7:0] JB,
    input rx,
    output tx
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
   
    wire [3:0] piece;
    Current_Piece (board, grid_x, grid_y, piece); 

    Game_Logic (
        .basys_clock(basys_clock),
        .board(board),
        .grid_x(selected_x),
        .grid_y(selected_y),
        .moves(moves)
    );

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
        .oled_data(oled_data)
    );
    
    //UART
    reg [31:0] tx_data;
    wire [31:0] rx_data;
    reg start_tx = 0;
    wire data_ready; 
    
    top_uart_tx (
        .basys_clock(basys_clock),
        .data_in(tx_data),
        .trigger_tx(start_tx),
        .tx(tx)
    );
    top_uart_rx (
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
    //Debug:
    assign led = rx_data[15:0];
    // Process received move
    integer remote_from_index, remote_to_index;
    reg processing_rx = 0;  // Flag to prevent repeated processing

    wire confirm;
    Btn_Input (basys_clock, btnU, btnC, btnD, btnL, btnR, current_x, current_y, confirm);
    
    integer from_index, to_index;

    always @(posedge basys_clock) begin
        if (start_tx) begin
            start_tx <= 0;
        end
        
        if (confirm) begin
        
        // Case 1: Deselect if clicking on already selected square
        if (selected_x == current_x && selected_y == current_y) begin
            selected_x <= NULL;
            selected_y <= NULL;
        end
        
        // Case 2: Move piece if one is already selected
        else if (selected_x != NULL && selected_y != NULL) begin
            from_index = ((7 - selected_y) * 8 + (selected_x)) * 4;
            to_index = ((7 - current_y) * 8 + (current_x)) * 4;
            
//            // Move the piece in the board array
//            board[to_index +: 4] <= board[from_index +: 4];  // Copy piece to new position
//            board[from_index +: 4] <= EMPTY;  // Clear old position
            
            //Sync move across UART
            tx_data <= {selected_x, selected_y, current_x, current_y};
            start_tx <= 1;

            // Deselect after moving
            selected_x <= NULL;
            selected_y <= NULL;

        end
        
        // Case 3: Select current square if no piece is selected
        else begin
            selected_x <= current_x;
            selected_y <= current_y;
        end
        
        end else begin
        if (data_ready && !processing_rx) begin
            processing_rx <= 1;
            
            // Calculate board indices for the remote move
            remote_from_index = ((7 - remote_selected_y) * 8 + remote_selected_x) * 4;
            remote_to_index = ((7 - remote_current_y) * 8 + remote_current_x) * 4;
            
            // Execute the move on local board (if valid coordinates)
            if (remote_selected_x != NULL && remote_selected_y != NULL && 
                remote_current_x < 8 && remote_current_y < 8) begin
                
                // Move the piece in the board array
                board[remote_to_index +: 4] <= board[remote_from_index +: 4];  // Copy piece to new position
                board[remote_from_index +: 4] <= EMPTY;  // Clear old position
            end
        end
        else if (!data_ready && processing_rx) begin
            // Reset processing flag when data_ready goes low
            processing_rx <= 0;
        end
        end
    end
endmodule
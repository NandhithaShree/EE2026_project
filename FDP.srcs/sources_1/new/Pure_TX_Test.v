module top_uart_tx (
    input basys_clock,        
    input [15:0] sw, 
    input btn_send,           // Button to trigger sending the next 16 bits
    output reg tx
);
    // Parameters for timing
    parameter CLK_FREQ = 100_000_000;  // 100 MHz (typical Basys clock)
    parameter BAUD_RATE = 9600;        // Standard UART baud rate
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    
    // Parameters for UART
    parameter IDLE = 1'b1;             // Idle state is high for UART
    parameter START_BIT = 1'b0;        // Start bit is low
    parameter STOP_BIT = 1'b1;         // Stop bit is high
    
    // State parameters
    parameter WAIT_STATE = 2'b00;
    parameter PREPARE_STATE = 2'b01;
    parameter SENDING_STATE = 2'b10;
    
    // Registers for state and counters
    reg [1:0] state = WAIT_STATE;
    reg [31:0] clock_counter = 0;
    reg [5:0] bit_counter = 0;  // Increased to handle 32+ bits
    
    // Register to store the full 32-bit value
    reg [31:0] tx_data = 0;
    reg load_phase = 0;  // 0 = lower 16 bits, 1 = upper 16 bits
    
    // Debounce circuit for the button
    wire btn_debounced;
    debounce btn_debouncer (
        .clk(basys_clock),
        .btn(btn_send),
        .btn_out(btn_debounced)
    );
    
    // Button edge detection
    reg btn_prev = 0;
    wire btn_pressed = btn_debounced && !btn_prev;
    
    always @(posedge basys_clock) begin
        btn_prev <= btn_debounced;
        
        case (state)
            WAIT_STATE: begin
                tx <= IDLE;  // Idle state for UART is high
                
                // Check if button is pressed to load new data
                if (btn_pressed && load_phase == 0) begin
                    // Load the lower 16 bits from switches
                    tx_data[15:0] <= sw;
                    load_phase <= 1;                end
                else if (btn_pressed && load_phase == 1) begin
                    // Load the upper 16 bits from switches
                    tx_data[31:16] <= sw;
                    load_phase <= 0;        // Reset for next transmission
                    state <= PREPARE_STATE;
                end
            end
            
            PREPARE_STATE: begin
                // Setup for transmission
                bit_counter <= 0;
                clock_counter <= 0;
                state <= SENDING_STATE;
            end
            
            SENDING_STATE: begin
                clock_counter <= clock_counter + 1;
                
                if (clock_counter >= BIT_PERIOD) begin
                    clock_counter <= 0;
                    
                    if (bit_counter == 0) begin
                        tx <= START_BIT;  // Send start bit
                    end
                    else if (bit_counter >= 1 && bit_counter <= 32) begin
                        tx <= tx_data[bit_counter-1];  // Send data bits
                    end
                    else if (bit_counter == 33) begin
                        tx <= STOP_BIT;  // Send stop bit
                    end
                    else begin
                        // Transmission complete
                        state <= WAIT_STATE;
                    end
                    
                    bit_counter <= bit_counter + 1;
                end
            end
        endcase
    end
endmodule
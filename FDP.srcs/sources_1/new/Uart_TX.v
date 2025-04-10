module Uart_TX (
    input basys_clock,        
    input [31:0] data_in,     // 32-bit data input
    input trigger_tx,         // Trigger to start transmission
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
    reg [5:0] bit_counter = 0;  // Handles up to 32 data bits + start/stop bits
    
    // Register to store the 32-bit value
    reg [31:0] tx_data = 0;
    
    // Trigger edge detection (no debouncing needed)
    reg trigger_prev = 0;
    wire trigger_pulse = trigger_tx && !trigger_prev;
    
    always @(posedge basys_clock) begin
        trigger_prev <= trigger_tx;
        
        case (state)
            WAIT_STATE: begin
                tx <= IDLE;  // Idle state for UART is high
                
                // Check if trigger is activated to start transmission
                if (trigger_pulse) begin
                    // Load all 32 bits at once
                    tx_data <= data_in;
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
                        tx <= tx_data[bit_counter-1];  // Send data bits, LSB first
                    end
                    else if (bit_counter == 33) begin
                        tx <= STOP_BIT;  // Send stop bit
                        bit_counter <= bit_counter + 1;  // Increment to exit condition
                    end
                    else begin
                        // Transmission complete
                        state <= WAIT_STATE;
                    end
                    
                    // Only increment bit counter if we're not at the last bit
                    if (bit_counter <= 33) begin
                        bit_counter <= bit_counter + 1;
                    end
                end
            end
        endcase
    end
endmodule

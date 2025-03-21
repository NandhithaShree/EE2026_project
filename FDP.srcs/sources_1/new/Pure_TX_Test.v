module top_uart_tx (
    input basys_clock,        
    input [15:0] sw, 
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
    parameter SENDING_STATE = 2'b01;
    
    // Registers for state and counters
    reg [1:0] state = WAIT_STATE;
    reg [31:0] clock_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [7:0] tx_data;
    
    // Period counter (for periodic transmission)
    reg [31:0] period_counter = 0;
    parameter SEND_PERIOD = CLK_FREQ;  // Send once per second
    
    always @(posedge basys_clock) begin
        case (state)
            WAIT_STATE: begin
                tx <= IDLE;  // Idle state for UART is high
                
                // Increment period counter
                period_counter <= period_counter + 1;
                
                // Check if it's time to send
                if (period_counter >= SEND_PERIOD) begin
                    period_counter <= 0;
                    tx_data <= sw;  // Load switch data
                    state <= SENDING_STATE;
                    bit_counter <= 0;
                    clock_counter <= 0;
                end
            end
            
            SENDING_STATE: begin
                clock_counter <= clock_counter + 1;
                
                if (clock_counter >= BIT_PERIOD) begin
                    clock_counter <= 0;
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 0) begin
                        tx <= START_BIT;  // Send start bit
                    end
                    else if (bit_counter >= 1 && bit_counter <= 8) begin
                        tx <= tx_data[bit_counter-1];  // Send data bits
                    end
                    else if (bit_counter == 9) begin
                        tx <= STOP_BIT;  // Send stop bit
                    end
                    else begin
                        state <= WAIT_STATE;  // Return to wait state
                    end
                end
            end
        endcase
    end
endmodule
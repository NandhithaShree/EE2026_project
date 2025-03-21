module top_uart_rx (
    input basys_clock,        
    input rx,                 // UART RX pin
    output reg [15:0] led      // LED outputs to display received data
);
    // Parameters for timing
    parameter CLK_FREQ = 100_000_000;  // 100 MHz (typical Basys clock)
    parameter BAUD_RATE = 9600;        // Standard UART baud rate
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    parameter HALF_BIT_PERIOD = BIT_PERIOD / 2;  // Sample in the middle of each bit
    
    // Parameters for UART
    parameter IDLE = 1'b1;             // Idle state is high for UART
    parameter START_BIT = 1'b0;        // Start bit is low
    parameter STOP_BIT = 1'b1;         // Stop bit is high
    
    // State parameters
    parameter IDLE_STATE = 2'b00;
    parameter START_BIT_STATE = 2'b01;
    parameter DATA_BITS_STATE = 2'b10;
    parameter STOP_BIT_STATE = 2'b11;
    
    // Registers for state and counters
    reg [1:0] state = IDLE_STATE;
    reg [31:0] clock_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [7:0] rx_data = 0;
    
    // Synchronize rx input to avoid metastability
    reg rx_sync1, rx_sync2;
    always @(posedge basys_clock) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end
    
    always @(posedge basys_clock) begin
        case (state)
            IDLE_STATE: begin
                // Reset counters
                clock_counter <= 0;
                bit_counter <= 0;
                
                // Detect start bit (high to low transition)
                if (rx_sync2 == START_BIT) begin
                    state <= START_BIT_STATE;
                end
            end
            
            START_BIT_STATE: begin
                clock_counter <= clock_counter + 1;
                
                // Sample in the middle of the start bit to confirm
                if (clock_counter >= HALF_BIT_PERIOD) begin
                    // Confirm this is really a start bit
                    if (rx_sync2 == START_BIT) begin
                        clock_counter <= 0;
                        state <= DATA_BITS_STATE;
                    end else begin
                        // Not a valid start bit, go back to idle
                        state <= IDLE_STATE;
                    end
                end
            end
            
            DATA_BITS_STATE: begin
                clock_counter <= clock_counter + 1;
                
                // Sample in the middle of each data bit
                if (clock_counter >= BIT_PERIOD) begin
                    clock_counter <= 0;
                    
                    // Shift in the received bit, LSB first
                    rx_data <= {rx_sync2, rx_data[7:1]};
                    
                    bit_counter <= bit_counter + 1;
                    
                    // Check if we've received all 8 data bits
                    if (bit_counter == 7) begin
                        state <= STOP_BIT_STATE;
                    end
                end
            end
            
            STOP_BIT_STATE: begin
                clock_counter <= clock_counter + 1;
                
                // Sample in the middle of the stop bit
                if (clock_counter >= BIT_PERIOD) begin
                    // Verify stop bit is high
                    if (rx_sync2 == STOP_BIT) begin
                        // Valid frame received, update LED output
                        led <= rx_data;
                    end
                    
                    // Return to idle state to wait for next transmission
                    state <= IDLE_STATE;
                end
            end
        endcase
    end
endmodule
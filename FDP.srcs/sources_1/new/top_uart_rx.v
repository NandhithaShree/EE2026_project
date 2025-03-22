module top_uart_rx (
    input basys_clock,        
    input rx,                 // UART RX pin
    input btn_display,        // Button to switch displayed portions
    output reg [15:0] led    // LED outputs to display received data
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
    reg [5:0] bit_counter = 0;  // Increased to handle 32+ bits
    
    // Register to store the full 32-bit received value
    reg [31:0] rx_data = 0;
    
    // Display state (which 16 bits to show on LEDs)
    reg display_upper = 0;  // 0 = lower 16 bits, 1 = upper 16 bits
    
    // Parsed data - named for clarity in final application
    wire [7:0] current_x = rx_data[7:0];
    wire [7:0] current_y = rx_data[15:8];
    wire [7:0] selected_x = rx_data[23:16];
    wire [7:0] selected_y = rx_data[31:24];
    
    // Debounce circuit for the button
    wire btn_debounced;
    debounce btn_debouncer (
        .clk(basys_clock),
        .btn(btn_display),
        .btn_out(btn_debounced)
    );
    
    // Button edge detection
    reg btn_prev = 0;
    wire btn_pressed = btn_debounced && !btn_prev;
    
    // Synchronize rx input to avoid metastability
    reg rx_sync1, rx_sync2;
    always @(posedge basys_clock) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end
    
    always @(posedge basys_clock) begin
        btn_prev <= btn_debounced;
        
        // Toggle display mode if button is pressed
        if (btn_pressed) begin
            display_upper <= ~display_upper;
            
            // Update LEDs based on display mode
            if (~display_upper) begin  // About to switch to lower half
                led <= rx_data[15:0];
            end else begin  // About to switch to upper half
                led <= rx_data[31:16];
            end
        end
        
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
                    
                    // Shift in the received bit at the appropriate position
                    rx_data[bit_counter] <= rx_sync2;
                    
                    bit_counter <= bit_counter + 1;
                    
                    // Check if we've received all 32 data bits
                    if (bit_counter == 31) begin
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
                        // Update LED display based on current mode
                        if (!display_upper) begin
                            led <= rx_data[15:0];
                        end else begin
                            led <= rx_data[31:16];
                        end
                    end
                    
                    // Return to idle state to wait for next transmission
                    state <= IDLE_STATE;
                end
            end
        endcase
    end
endmodule
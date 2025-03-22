module Top_UART_Test (
    input basys_clock,        // System clock
    input rx,                 // RX input pin (from other board)
    input btnC,               // Trigger transmission button
    input [15:0] sw,          // Switches for data input
    output tx,                // TX output pin (to other board)
    output [15:0] led         // LEDs to display received data
);
    // Internal signals
    wire [31:0] rx_data;  // Full 32-bit received data
    wire [31:0] tx_data;       // Data to transmit
    wire data_ready;          // Signal indicating new data received
    reg [15:0] led_reg;       // Register to drive LEDs
    
    assign tx_data = {16'hABCD, sw}; 
    assign led = rx_data[15:0];
    
    wire confirm;
    debounce (basys_clock, btnC, confirm);
    
    // TX module instantiation
    top_uart_tx tx_module (
        .basys_clock(basys_clock),
        .data_in(tx_data),
        .trigger_tx(confirm),
        .tx(tx)
    );
    
    // RX module instantiation
    top_uart_rx rx_module (
        .basys_clock(basys_clock),
        .rx(rx),
        .data_out(rx_data),
        .data_ready(data_ready)
    );
    
endmodule
module Uart_Test (
    input basys_clock, btnC, rx,
    input  [15:0] sw,
    output tx,
    output [15:0] led
);
    assign led = sw;
    
    reg send_signal = 0;
        reg button_prev = 0;
        reg tx_data = 0; 
        wire rx_data;
        wire busy;
    
        wire btnC_debounced;
        wire move_valid;
    
        // Debounce the button
        debounce debounce_btnC (
            .clk(basys_clock),
            .btn(btnC),
            .btn_out(btnC_debounced)
        );
    
        // UART TX
        uart_tx transmitter (
            .clk(basys_clock),
            .start(send_signal),
            .data(tx_data),
            .tx(tx),
            .busy(busy)
        );
    
        // UART RX
        uart_rx receiver (
            .clk(basys_clock),
            .rx(rx),
            .data(rx_data),
            .valid(move_valid)
        );

        always @(posedge basys_clock) begin
            if (btnC_debounced && !button_prev && !busy) begin  // Rising edge of button press
                tx_data <= sw[0];  // Send switch value
                send_signal <= 1;  // Pulse start signal
            end else begin
                send_signal <= 0;  // Ensure one-cycle pulse
            end
    
            button_prev <= btnC_debounced; // Store button state
        end
endmodule
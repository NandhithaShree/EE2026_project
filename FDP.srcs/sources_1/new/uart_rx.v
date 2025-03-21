`timescale 1ns / 1ps

module uart_rx (
    input clk, rx,
    output reg data,  
    output reg valid  
);

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 115200;
    parameter CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;

    // State definitions
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] state = IDLE;
    reg [13:0] counter = 0;
    reg rx_sync1, rx_sync2; // For synchronizing rx input

    // Double-register the input for synchronization
    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end

    always @(posedge clk) begin
        valid <= 0; // Default state - valid only pulses for one cycle
        
        case(state)
            IDLE: begin
                if (rx_sync2 == 0) begin  // Detect start bit
                    counter <= 0;
                    state <= START;
                end
            end
            
            START: begin
                if (counter >= CYCLES_PER_BIT/2) begin  // Sample in middle of start bit
                    if (rx_sync2 == 0) begin  // Confirm it's still low
                        counter <= 0;
                        state <= DATA;
                    end else begin
                        state <= IDLE;  // False start, go back to idle
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            
            DATA: begin
                if (counter >= CYCLES_PER_BIT) begin  // Sample in middle of data bit
                    data <= rx_sync2;       // Capture the data bit
                    counter <= 0;
                    state <= STOP;
                end else begin
                    counter <= counter + 1;
                end
            end
            
            STOP: begin
                if (counter >= CYCLES_PER_BIT) begin  // Sample in middle of stop bit
                    if (rx_sync2 == 1) begin  // Verify stop bit
                        valid <= 1;  // Data is valid
                    end
                    state <= IDLE;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
endmodule
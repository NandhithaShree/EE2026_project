`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 15:02:22
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx (
    input clk, 
    input start, 
    input data, 
    output reg tx, 
    output reg busy
);

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 115200;
    parameter CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [2:0] bit_index = 0;
    reg [13:0] counter = 0;
    reg sending = 0;
    reg [2:0] shift_reg; 

    always @(posedge clk) begin
        if (start && !sending) begin
            shift_reg <= {1'b1, data, 1'b0}; // Stop bit, Data, Start bit
            sending <= 1;
            bit_index <= 0;
            counter <= 0;
            tx <= 0;  // Start bit
            busy <= 1;
        end

        if (sending) begin
            if (counter >= CYCLES_PER_BIT) begin
                counter <= 0;
                if (bit_index < 2) begin
                    bit_index <= bit_index + 1;
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                end else begin
                    sending <= 0;
                    busy <= 0;
                    tx <= 1;  
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule




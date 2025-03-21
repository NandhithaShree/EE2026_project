`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 15:02:22
// Design Name: 
// Module Name: uart_rx
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


module uart_rx (
    input clk, rx,
    output reg data,  
    output reg valid  
);

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 115200;
    parameter CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [1:0] bit_index = 0;
    reg [13:0] counter = 0;
    reg receiving = 0;
    reg shift_reg;

    always @(posedge clk) begin
        if (!receiving && rx == 0) begin  
            receiving <= 1;
            counter <= CYCLES_PER_BIT / 2;
            bit_index <= 0;
            valid <= 0;
        end

        if (receiving) begin
            if (counter >= CYCLES_PER_BIT) begin
                counter <= 0;
                if (bit_index == 1) begin
                    shift_reg <= rx; 
                    bit_index <= bit_index + 1;
                end else if (bit_index == 2) begin  
                    if (rx == 1) begin  
                        data <= shift_reg;
                        valid <= 1;
                    end
                    receiving <= 0;
                end
            end else begin
                counter <= counter + 1;
            end
        end else begin
            valid <= 0;  
        end
    end
endmodule



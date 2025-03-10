`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 09:55:46 PM
// Design Name: 
// Module Name: LED_Decoder
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


module LED_Decoder(
    input basys_clock,
input [15:0] sw,
input [2:0] state,
output reg [15:0] led
);

wire taskA_clock, taskB_clock, taskC_clock, taskD_clock;
Clock slow_taskA_clock (basys_clock, 5_555_555, taskA_clock); // 9Hz
Clock slow_taskB_clock (basys_clock, 25_000_000, taskB_clock); // 2Hz
Clock slow_taskC_clock (basys_clock, 5_000_000, taskC_clock); // 10Hz
Clock slow_taskD_clock (basys_clock, 50_000_000, taskD_clock); // 1Hz

wire [15:0] mask = 16'b0000_1111_1111_1111;

always @ (posedge basys_clock) begin
    case (state)
        3'b000: begin
            if (taskA_clock)
                led <= sw & mask;
            else
                led <= 16'b0;
        end
        3'b001: begin
            if (taskB_clock)
                led <= sw & mask;
            else
                led <= 16'b0;
        end
        3'b010: begin
            if (taskC_clock)
                led <= sw & mask;
            else
                led <= 16'b0;
        end
        3'b011: begin
            if (taskD_clock)
                led <= sw & mask;
            else
                led <= 16'b0;
        end
        default: begin
            led <= sw;
        end
    endcase
    led[15:12] <= sw[15:12];
end

endmodule

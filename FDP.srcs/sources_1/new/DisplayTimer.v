`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 19:42:01
// Design Name: 
// Module Name: DisplayTimer
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


module DisplayTimer (
    input wire basys_clock,
    input wire [5:0] min1, sec1, min2, sec2,
    input wire player,
    output reg [3:0] an,
    output reg [7:0] seg
);

    wire clock_1ms;
    Clock slow_clock_1ms (basys_clock, 50_000 - 1, clock_1ms);
    
    reg [3:0] digit;
    reg [1:0] digit_select = 0;
    wire [5:0] min, sec;
    
    assign min = (player == 1) ? min1 : min2;
    assign sec = (player == 1) ? sec1 : sec2;

    always @ (posedge clock_1ms) begin
        digit_select = digit_select + 1;
        case (digit_select)
            2'b00: digit <= min / 10;  // Tens of minutes
            2'b01: digit <= min % 10;  // Ones of minutes
            2'b10: digit <= sec / 10;  // Tens of seconds
            2'b11: digit <= sec % 10;  // Ones of seconds
        endcase
    end
    
    always @(posedge clock_1ms) begin
        case (digit_select)
            2'b00: an[3:0] = 4'b0111;
            2'b01: an[3:0] = 4'b1011;
            2'b10: an[3:0] = 4'b1101;
            2'b11: an[3:0] = 4'b1110;
        endcase
    end
    
    always @(posedge clock_1ms) begin
        case (digit)
            4'd0: seg[7:0] = 8'b1100_0000;
            4'd1: seg[7:0] = 8'b1111_1001;
            4'd2: seg[7:0] = 8'b1010_0100;
            4'd3: seg[7:0] = 8'b1011_0000;
            4'd4: seg[7:0] = 8'b1001_1001;
            4'd5: seg[7:0] = 8'b1001_0010;
            4'd6: seg[7:0] = 8'b1000_0010;
            4'd7: seg[7:0] = 8'b1111_1000;
            4'd8: seg[7:0] = 8'b1000_0000;
            4'd9: seg[7:0] = 8'b1001_0000;
            default: seg[7:0] = 8'b1111_1111;
        endcase
    end

endmodule

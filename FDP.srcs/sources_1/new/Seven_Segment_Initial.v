`timescale 1ns / 1ps


module Seven_Segment_Initial (
    input basys_clk,
    output reg [3:0] an,
    output reg [7:0] seg
);

    wire createdfreq; 
    Clock clk_1 (basys_clk, 100000, createdfreq);
    
    reg [1:0] state = 2'b00;
    always @(posedge createdfreq) begin
        state <= state + 1;
    end
    always @(posedge createdfreq) begin
        case (state)
            2'b00: begin
               seg[7:0] <= 8'b10010010; 
               an [3:0] <= 4'b0111;
            end
            2'b01: begin
                seg[7:0] <= 8'b00110000;
                an [3:0] <= 4'b1011;
            end
            2'b10: begin
                seg[7:0] <= 8'b11001111;
                an [3:0] <= 4'b1101;
            end
            2'b11: begin
                seg[7:0] <= 8'b10010010; 
                an [3:0] <= 4'b1110;
            end
        endcase
    end
    
 endmodule
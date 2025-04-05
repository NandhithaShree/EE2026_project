`include "Constants.vh"

module ChessTimer(
    input basys_clock,          
    input [2:0] game_state,         
    output reg [5:0] min, sec
);
    wire clock_1hz;
    Clock (basys_clock, 50_000_000, clock_1hz);

    
//    always @(posedge clock_1hz) begin
    
//       min <= 6'd5; 
//       sec <= 6'd0;
    
////       case(game_state)
////           GAME_START: begin
////                min <= 6'd5; 
////                sec <= 6'd0;
////            end
////            PLAYER_TURN: begin
////                if (sec ==0) begin
////                    if (min > 0) begin
////                        min <= min - 1;
////                        sec <= 6'd59;
////                    end
////                end else begin
////                    sec <= sec -1;
////                end    
////            end
////        endcase
//    end
endmodule
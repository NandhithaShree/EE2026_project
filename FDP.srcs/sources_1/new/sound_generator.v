`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 23:32:17
// Design Name: 
// Module Name: sound_generator
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

`include "Constants.vh"

module sound_generator(
    input clk,
    input [2:0] sound,
    output reg [31:0] freq,
    output reg playing
);

   parameter NOTE_DURATION = 20_312_500;

    // Tone frequencies
    parameter A4 = 440;
    parameter B4 = 494;
    parameter C5 = 523;
    parameter D5 = 587;
    parameter E5 = 659;
    parameter F5 = 698;
    parameter Bb4 = 466;
    parameter G4  = 392;
    parameter E4  = 330;
    parameter A5 = 880;
    parameter G5 = 784;
    parameter C6 = 1046;
    parameter E6  = 1319;
    parameter B5  = 988;
    parameter F6  = 1397;
    parameter G6  = 1568;
    parameter D6  = 1175;
    parameter A6 = 1760;
    parameter Bb5 = 932;
    parameter Eb5 = 622;

    // States
    parameter IDLE = 3'b101;

    reg [2:0] state = IDLE;
    reg [2:0] prev_sound = 3'b000;
    reg [31:0] duration_counter = 0;
    reg [8:0] tone_idx = 0;
    reg [1:0] repeat_count = 0;
    reg [2:0] repeat_max = 1;

    always @(posedge clk) begin
        // Detect new trigger
        if (state == IDLE) begin
            state <= sound;
            tone_idx <= 0;
            duration_counter <= 0;
            playing <= 0;
            freq <= 0;
        end else begin
            playing <= 1;

            case (state)
                PLAY_START: begin
                    if (sound != PLAY_START) begin
                        state <= IDLE;
                        freq <= 0;
                        tone_idx <= 0;
                        duration_counter <= 0;
                        repeat_count <= 0;
                    end else begin
                        case (tone_idx)
                        0:  begin freq <= E6;  repeat_max = 2; end
                        1:  begin freq <= B5;  repeat_max = 1; end
                        2:  begin freq <= C6;  repeat_max = 1; end
                        3:  begin freq <= D6;  repeat_max = 2; end
                        4:  begin freq <= C6;  repeat_max = 1; end
                        5:  begin freq <= B5;  repeat_max = 1; end
                        6:  begin freq <= A5;  repeat_max = 2; end
                        7:  begin freq <= A5;  repeat_max = 1; end
                        8:  begin freq <= C6;  repeat_max = 1; end
                        9:  begin freq <= E6;  repeat_max = 2; end
                        10: begin freq <= D6;  repeat_max = 1; end
                        11: begin freq <= C6;  repeat_max = 1; end
                        12: begin freq <= B5;  repeat_max = 3; end
                        13: begin freq <= C6;  repeat_max = 1; end
                        14: begin freq <= D6;  repeat_max = 2; end
                        15: begin freq <= E6;  repeat_max = 2; end
                        16: begin freq <= C6;  repeat_max = 2; end
                        17: begin freq <= A5;  repeat_max = 2; end
                        18: begin freq <= A5;  repeat_max = 1; end
                        19: begin freq <= A5;  repeat_max = 1; end
                        20: begin freq <= B5;  repeat_max = 1; end
                        21: begin freq <= C6;  repeat_max = 1; end
                        22: begin freq <= D6;  repeat_max = 3; end
                        23: begin freq <= F6;  repeat_max = 1; end
                        24: begin freq <= A6;  repeat_max = 2; end
                        25: begin freq <= G6;  repeat_max = 1; end
                        26: begin freq <= F6;  repeat_max = 1; end
                        27: begin freq <= E6;  repeat_max = 2; end
                        28: begin freq <= C6;  repeat_max = 1; end
                        29: begin freq <= E6;  repeat_max = 1; end
                        30: begin freq <= D6;  repeat_max = 2; end
                        31: begin freq <= C6;  repeat_max = 2; end
                        32: begin freq <= B5;  repeat_max = 2; end
                        33: begin freq <= B5;  repeat_max = 1; end
                        34: begin freq <= C6;  repeat_max = 1; end
                        35: begin freq <= D6;  repeat_max = 2; end
                        36: begin freq <= E6;  repeat_max = 2; end
                        37: begin freq <= C6;  repeat_max = 2; end
                        38: begin freq <= A5;  repeat_max = 2; end
                        39: begin freq <= A5;  repeat_max = 2; end
                        default: begin freq <= 0; repeat_max = 1; end
                    endcase
                
                
                        if (duration_counter < NOTE_DURATION) begin
                            duration_counter <= duration_counter + 1;
                        end else begin
                            duration_counter <= 0;
                            repeat_count <= repeat_count + 1;
                
                            if (repeat_count == repeat_max - 1) begin
                                repeat_count <= 0;
                                tone_idx <= (tone_idx == 39) ? 0 : tone_idx + 1;
                            end
                        end
                    end
                end

                PLAY_END: begin
                    if (sound != PLAY_END) begin
                        state <= IDLE;
                        freq <= 0;
                        tone_idx <= 0;
                        duration_counter <= 0;
                        repeat_count <= 0;
                    end else begin
                    case (tone_idx)
                    0:  begin freq <= C5;   repeat_max = 1; end
                    1:  begin freq <= Eb5;  repeat_max = 1; end
                    2:  begin freq <= G5;   repeat_max = 1; end
                    3:  begin freq <= Bb5;  repeat_max = 1; end
                    4:  begin freq <= G5;   repeat_max = 1; end
                    5:  begin freq <= F5;   repeat_max = 1; end
                    6:  begin freq <= Eb5;  repeat_max = 1; end
                    7:  begin freq <= C5;   repeat_max = 1; end
                    8:  begin freq <= C5;   repeat_max = 1; end
                    9:  begin freq <= G4;   repeat_max = 1; end
                    10: begin freq <= C5;   repeat_max = 1; end
                    11: begin freq <= G5;   repeat_max = 2; end // hold ending note
                   default: begin freq <= 0; repeat_max = 1; end
                   endcase

                    if (duration_counter < NOTE_DURATION) begin
                    duration_counter <= duration_counter + 1;
                    end else begin
                        duration_counter <= 0;
                        repeat_count <= repeat_count + 1;

                        if (repeat_count == repeat_max - 1) begin
                            repeat_count <= 0;
                            tone_idx <= (tone_idx == 11) ? 0 : tone_idx + 1; // loop forever
                        end
                   end
                end
                end


                PLAY_MOVE: begin
                 case (tone_idx)
                 0: freq <= A5;
                endcase

               if (duration_counter < NOTE_DURATION) begin
                   duration_counter <= duration_counter + 1;
               end else begin
                   duration_counter <= 0;
                   tone_idx <= tone_idx + 1;
                   if (tone_idx == 1) begin
                       state <= IDLE;
                   end
               end
           end

                PLAY_PROMOTION: begin
                case (tone_idx)
                    0: freq <= C5;
                    1: freq <= E5;
                    2: freq <= G5;
                    3: freq <= C6;
                    default: freq <= 0;
                endcase
            
                if (duration_counter < NOTE_DURATION)
                    duration_counter <= duration_counter + 1;
                else begin
                    duration_counter <= 0;
                    tone_idx <= tone_idx + 1;
            
                    if (tone_idx == 4) begin
                            tone_idx <= 0;
                            state <= IDLE;
                        end
                    end
                end

                PLAY_EAT: begin
                  case (tone_idx)
                  0: freq <= C5;
                  1: freq <= E5;
                  endcase
              
                  if (duration_counter < NOTE_DURATION) begin
                      duration_counter <= duration_counter + 1;
                  end else begin
                      duration_counter <= 0;
                      tone_idx <= tone_idx + 1;
                      if (tone_idx == 2) begin
                          state <= IDLE;
                      end
                  end
               end
            endcase
        end
    end

endmodule



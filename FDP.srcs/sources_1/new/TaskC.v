`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 15:37:56
// Design Name: 
// Module Name: TaskC
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


module TaskC (
    input reset_task,
    input CLOCK, 
    input btnC, 
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_data
);
    reg [3:0] state = 0;
    reg [6:0] phase_start;
    wire [6:0] phase_end;
    wire CLOCK_1Hz, CLOCK_45p, CLOCK_15p;
    reg [2:0] active_phase; // Tracks the currently active phase
    reg [6:0] reset_flag;

    // Clock Generators
    Clock clk_1Hz (CLOCK, 50000000, CLOCK_1Hz);  
    Clock clk_45p (CLOCK, 1111111, CLOCK_45p); 
    Clock clk_15p (CLOCK, 3333333, CLOCK_15p); 

    // OLED data wires from each phase
    wire [15:0] oled_p0, oled_p1, oled_p2, oled_p3, oled_p4, oled_p5, oled_p6;
    
    wire btnC_debounced;
    Debounce db (.CLOCK(CLOCK), .btn(btnC), .btn_clean(btnC_debounced));

    // Phase Modules
    Phase_0 ph0(CLOCK_45p, phase_start[0], x, y, oled_p0);
    Phase_1 ph1(CLOCK_45p, phase_start[1], x, y, reset_flag[1], phase_end[1], oled_p1);
    Phase_2 ph2(CLOCK_45p, phase_start[2], x, y, reset_flag[2], phase_end[2], oled_p2);
    Phase_3 ph3(CLOCK_15p, phase_start[3], x, y, reset_flag[3], phase_end[3], oled_p3);
    Phase_4 ph4(CLOCK_15p, phase_start[4], x, y, reset_flag[4], phase_end[4], oled_p4);
    Phase_5 ph5(CLOCK_15p, phase_start[5], x, y, reset_flag[5], phase_end[5], oled_p5);
    Phase_6 ph6(CLOCK_15p, phase_start[6], x, y, reset_flag[6], phase_end[6], oled_p6);

    // Initialize phases
    initial begin 
        phase_start = 7'b0000001; // Start with phase 0
        state = 0;
        active_phase = 0;
        reset_flag = 0;
    end
        
always @(posedge CLOCK) begin
        if (reset_task) begin 
            phase_start = 7'b0000001; // Start with phase 0
            state = 0;
            active_phase = 0;
            reset_flag = 0;
        end else begin 
        case (state)
            0: begin 
    
                if (btnC_debounced) begin
                    phase_start[1] <= 1; // ? Start phase 1
                    active_phase <= 1;
                    state <= 1;
                end
            end
            1: begin 
                if (phase_end[1]) begin  
                    phase_start[1] <= 0;
                    phase_start[2] <= 1;
                    active_phase <= 2;
                    state <= 2;
                end
            end
            2: begin 
                if (phase_end[2]) begin
                    phase_start[2] <= 0;
                    phase_start[3] <= 1;
                    active_phase <= 3;
                    state <= 3;
                end
            end
            3: begin 
                if (phase_end[3]) begin 
                    phase_start[3] <= 0;
                    phase_start[4] <= 1;
                    active_phase <= 4;
                    state <= 4;
                end
            end
            4: begin 
                if (phase_end[4]) begin 
                    phase_start[4] <= 0;
                    phase_start[5] <= 1;
                    active_phase <= 5;
                    state <= 5;
                end
            end 
            5: begin 
                if (phase_end[5]) begin 
                    phase_start[5] <= 0;
                    phase_start[6] <= 1;
                    active_phase <= 6;
                    state <= 6;
                end
            end
            6: begin  // ? WAIT for phase 6 to end, but DO NOT reset yet
                if (phase_end[6]) begin
                    state <= 7; // ? Move to waiting state
                end
            end
            7: begin  // ? WAIT for BUTTON PRESS, then RESET
               if (btnC_debounced) begin 
                    phase_start <= 7'b0000001; // ? Clear phase 6 as well 
                    active_phase <= 0;  // ? Reset to Phase 0
                    state <= 0;
                end
            end
    
        endcase
        end
    end



     // Multiplexing OLED Data from active phase
    always @(*) begin
        case (active_phase)
            0: oled_data = oled_p0;
            1: oled_data = oled_p1;
            2: oled_data = oled_p2;
            3: oled_data = oled_p3;
            4: oled_data = oled_p4;
            5: oled_data = oled_p5;
            6: oled_data = oled_p6;
            default: oled_data = oled_p0; 
        endcase
    end


endmodule

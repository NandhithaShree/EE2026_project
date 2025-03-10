`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 19:09:20
// Design Name: 
// Module Name: AnimationController
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


module AnimationController (
    input CLOCK, 
    input btnC, 
    output reg fast_start, slow_start, 
    output reg [6:0] x_output, 
    output reg [5:0] y_output,
    output reg reset
);
    reg [2:0] state = 0;
    wire fast_done, slow_done;
    wire [6:0] x_fast, x_slow;
    wire [5:0] y_fast, y_slow;
    wire CLOCK_1Hz, CLOCK_45p, CLOCK_15p;
    reg [1:0] animateState; // 0: Idle, 1: Fast, 2: Slow
    
    Clock clk_1Hz (CLOCK, 50000000, CLOCK_1Hz);  
    Clock clk_45p (CLOCK, 1111111, CLOCK_45p); 
    Clock clk_15p (CLOCK, 3333333, CLOCK_15p); 
    
    // Instantiate animation modules
    FastAnimate fastMove(CLOCK_45p, fast_start, x_fast, y_fast, fast_done);
    SlowAnimate slowMove(CLOCK_15p, slow_start, x_slow, y_slow, slow_done);
    

    
    always @(posedge CLOCK_1Hz) begin
        case (state)
            0: begin // Initial state, waiting for button press
                reset <= 0;
                if (btnC) begin
                    fast_start <= 1;
                    slow_start <= 0;
                    state <= 1;
                    animateState <= 1; // Fast
                end
            end
            1: begin // Fast movement
                if (fast_done) begin
                    fast_start <= 0; // Stop fast movement properly
                    slow_start <= 1;
                    state <= 2;
                    animateState <= 2; // Slow
                end
            end
            2: begin // Slow movement
                if (slow_done) begin
                    slow_start <= 0; // Stop slow movement
                    state <= 3;
                    animateState <= 0; // Idle
                end
            end
            3: begin // Wait for button press to reset
                if (btnC) begin
                    state <= 0;
                    reset <= 1;
                    fast_start <= 0;
                    slow_start <= 0;
                end
            end
        endcase
    end

    // Combinational logic for position assignment (prevents multiple drivers)
    always @(*) begin
        if (animateState == 1) begin
            x_output = x_fast;
            y_output = y_fast;
        end else if (animateState == 2) begin
            x_output = x_slow;
            y_output = y_slow;
        end else begin
            x_output = 85;
            y_output = 0;
        end
    end
endmodule

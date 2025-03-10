`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Roshni
//  STUDENT B NAME: Srinivasan Nandhitha Shree
//  STUDENT C NAME: Beverly
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////

module Top_Student (input basys_clock, output [7:0] JB, input btnU, input btnC, input btnD, btnL, btnR, input [15:0] sw, output [15:0] led);
    wire [2:0] task_state;
    Switch_Decoder (basys_clock, sw, task_state);
    LED_Decoder (basys_clock, sw, task_state, led);

    wire [6:0] x;
    wire [5:0] y;
    
    wire [15:0] oled_X;
    wire [15:0] oled_A;
    wire [15:0] oled_B;
    wire [15:0] oled_C;
    wire [15:0] oled_D;
    
    TaskX taskX (basys_clock, x, y, oled_X);
    TaskA taskA (basys_clock, btnC, btnU, btnD, x, y, oled_A);
    TaskB taskB (basys_clock, btnC, btnU, btnD, x, y, oled_B);
    TaskC taskC (basys_clock, btnC, x,y, oled_C);
    TaskD taskD (basys_clock, btnL, btnR, btnU, btnD, x, y, oled_D);

    wire [15:0] oled_data;
    Task_Multiplexer (task_state, oled_X, oled_A, oled_B, oled_C, oled_D, oled_D);

    Display display_inst (.basys_clock(basys_clock), .oled_data(oled_data), .x(x), .y(y), .JB(JB));
endmodule

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Govindaraj Roshni Daksha
//  STUDENT B NAME: Srinivasan Nandhitha Shree
//  STUDENT C NAME: Beverly Low
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////

module Top_Student (
    input basys_clock,
    input btnU, btnC, btnD, btnL, btnR,
    input [15:0] sw,
    output [7:0] JB,
    output [15:0] led,
    output [3:0] an,
    output [7:0] seg
);

    wire [2:0] task_state;
    wire reset;
    Switch_Decoder (basys_clock, sw, task_state, reset);
    LED_Decoder (basys_clock, sw, task_state, led);
    Seven_Segment_Initial (basys_clock, an, seg);

    wire [6:0] x;
    wire [5:0] y;
    
    wire [15:0] oled_X;
    wire [15:0] oled_A;
    wire [15:0] oled_B;
    wire [15:0] oled_C;
    wire [15:0] oled_D;
    
    TaskX taskX (basys_clock, x, y, oled_X);
    TaskA taskA (reset, basys_clock, btnC, btnU, btnD, x, y, oled_A);
    TaskB taskB (reset, basys_clock, btnC, btnU, btnD, x, y, oled_B);
    TaskC taskC (reset, basys_clock, btnC, x, y, oled_C);
    TaskD taskD (reset, basys_clock, btnL, btnR, btnU, btnD, x, y, oled_D);

    wire [15:0] oled_data;
    Task_Multiplexer (task_state, oled_X, oled_A, oled_B, oled_C, oled_D, oled_data);

    Display (basys_clock, oled_data, x, y, JB);
endmodule

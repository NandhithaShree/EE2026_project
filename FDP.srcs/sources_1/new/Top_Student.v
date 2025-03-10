`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Govindaraj Roshni Daksha
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input basys_clock,
    input btnC, btnL, btnR, btnU, btnD,
    output [7:0] JB
);    
    wire [6:0] x;
    wire [5:0] y;

    wire [15:0] oled_A;
    wire [15:0] oled_B;
    wire [15:0] oled_D;
    
    TaskA taskA (basys_clock, btnC, btnU, btnD, x, y, oled_A);
    TaskB taskB (basys_clock, btnC, btnU, btnD, x, y, oled_B);
    TaskD taskD (basys_clock, btnL, btnR, btnU, btnD, x, y, oled_D);

    Display display (basys_clock, oled_B , x, y, JB);
endmodule
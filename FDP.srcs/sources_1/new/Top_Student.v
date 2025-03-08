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
    input btnC, btnU, btnD,
    output [7:0] JB
);

    wire [6:0] x;
    wire [5:0] y;
    wire [15:0] oled_data;
    
    TaskA taskA (basys_clock, btnC, btnU, btnD, x, y, oled_data);
    Display display (basys_clock, oled_data , x, y, JB);

endmodule
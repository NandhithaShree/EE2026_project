`timescale 1ns / 1ps

module TaskD (
    input reset,
    input basys_clock,
    input btn_left, btn_right, btn_up, btn_down,
    input [6:0] x,
    input [5:0] y,
    output [15:0] oled_data
);

    wire [6:0] green_x;
    wire [5:0] green_y;
    wire [2:0] move_dir;
    
    TaskD_Input btnInput (
        reset,
        basys_clock,
        btn_left, btn_right, btn_up, btn_down,
        move_dir
    );    

    TaskD_Controller controller (
        basys_clock,
        move_dir,
        green_x,
        green_y
    );
    
    TaskD_Render render (
        basys_clock,
        green_x,
        green_y,
        x,
        y,
        oled_data
    );
endmodule



module TaskC (
    input reset,
    input CLOCK, 
    input btnC,
    input [6:0] x,
    input [5:0] y, 
    output [15:0] pixel_data_output
);

    wire [6:0] x_output;
    wire [5:0] y_output;
    
    wire fast_start;
    wire slow_start;
    wire reset_trail;// NEW: Clears trail when animation resets

    AnimationController animCtrl(CLOCK, btnC, fast_start, slow_start, x_output, y_output, reset_trail);
    pixel_render_TaskC renderer(CLOCK, x, y, x_output, y_output, reset_trail, pixel_data_output);

endmodule
module TaskD_Controller(
    input clock,
    input [2:0] move_dir,
    output reg [6:0] green_x = 5,
    output reg [5:0] green_y = SCREEN_HEIGHT - GREEN_SIZE - SCREEN_OFFSET
);
    parameter GREEN_SIZE = 10;
    parameter RED_SIZE = 30;
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    parameter SCREEN_OFFSET = 5;

    parameter RED_X = SCREEN_WIDTH - RED_SIZE - SCREEN_OFFSET;
    parameter RED_Y = SCREEN_OFFSET;
    parameter BARRIER = 0;
    
    wire clock_30Hz;
    Clock slow_clock_30Hz (clock, 833333, clock_30Hz);
    
    always @(posedge clock_30Hz) begin
            case (move_dir)
                1: begin // Right
                    if (green_x + GREEN_SIZE < SCREEN_WIDTH - SCREEN_OFFSET && 
                        !(green_x + 1 + GREEN_SIZE >= RED_X - BARRIER && green_x + 1 <= RED_X + RED_SIZE + BARRIER &&
                          green_y + GREEN_SIZE >= RED_Y - BARRIER && green_y <= RED_Y + RED_SIZE + BARRIER))
                        green_x <= green_x + 1;
                end
                2: begin // Left
                    if (green_x > SCREEN_OFFSET && 
                        !(green_x - 1 + GREEN_SIZE >= RED_X - BARRIER && green_x - 1 <= RED_X + RED_SIZE + BARRIER &&
                          green_y + GREEN_SIZE >= RED_Y - BARRIER && green_y <= RED_Y + RED_SIZE + BARRIER))
                        green_x <= green_x - 1;
                end
                3: begin // Up 
                    if (green_y > SCREEN_OFFSET && 
                        !(green_x + GREEN_SIZE >= RED_X - BARRIER && green_x <= RED_X + RED_SIZE + BARRIER &&
                          green_y - 1 + GREEN_SIZE >= RED_Y - BARRIER && green_y - 1 <= RED_Y + RED_SIZE + BARRIER))
                        green_y <= green_y - 1;
                end
                4: begin // Down
                    if (green_y + GREEN_SIZE < SCREEN_HEIGHT && 
                        !(green_x + GREEN_SIZE >= RED_X - BARRIER && green_x <= RED_X + RED_SIZE + BARRIER &&
                          green_y + 1 + GREEN_SIZE >= RED_Y - BARRIER && green_y + 1 <= RED_Y + RED_SIZE + BARRIER))
                        green_y <= green_y + 1;
                end
            endcase
        end
endmodule
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Govindaraj Roshni Daksha
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input basys_clock,
    input btnU, btnD, btnC,
    output [7:0] JB,
    output reg [15:0] led
);

    wire clock_1KHz, clock_6p25MHz, clock_25MHz;
    
    flexible_clock_divider slow_clock_1MHz (basys_clock, 99999, clock_1KHz);
    flexible_clock_divider slow_clock_6p25MHz (basys_clock, 7, clock_6p25MHz);
    flexible_clock_divider slow_clock_25MHz (basys_clock, 1, clock_25MHz);
    
    reg [7:0] debounce_counter = 0;
    reg [6:0] inner_diameter = 25;
    reg last_btnU, last_btnD;
    always @ (posedge clock_1KHz) begin
        if (debounce_counter > 0)
            debounce_counter <= debounce_counter - 1;
            
        last_btnU <= btnU;
        last_btnD <= btnD;
        
        if (!debounce_counter) begin
            if (btnU && !last_btnU && inner_diameter <= 40) begin
                inner_diameter = inner_diameter + 5;
                debounce_counter <= 200;
            end
            else if (btnD && !last_btnD && inner_diameter >= 10) begin
                inner_diameter = inner_diameter - 5;
                debounce_counter <= 200;
            end
        end
    end
    
    wire fb;
    wire [12:0] pixel_index;
    wire sending_pixel;
    wire sample_pixel;
    
    wire [6:0] x;
    wire [5:0] y;
    pixel_index_to_coordinates p2c (pixel_index, x, y);

    reg show_taskA = 0;
    always @ (posedge basys_clock) begin
        if (btnC && !show_taskA) show_taskA = 1;
    end
    
    reg [15:0] oled_data;
    always @ (posedge clock_25MHz) begin
        if (!show_taskA) oled_data = 16'b00000_000000_00000;
        else begin
            if ((x >= 2 && x <= 93 && (y >= 2 && y <= 5 || y >= 58 && y <= 61)) || // Top and Bottom Border
                (y >= 2 && y <= 61 && (x >= 2 && x <= 5 || x >= 90 && x <= 93))) // Left and Right Border
                oled_data <= 16'b11111_000000_00000;
            else if ((x - 47) ** 2 + (y - 31) ** 2 >= (inner_diameter / 2) ** 2 &&
                     (x - 47) ** 2 + (y - 31) ** 2 <= ((inner_diameter + 5) / 2) ** 2)
                oled_data <= 16'b00000_111111_00000;
            else
                oled_data <= 16'b00000_000000_00000;
        end
    end
    
    Oled_Display oled (
        .clk(clock_6p25MHz), 
        .reset(0), 
        .frame_begin(fb), 
        .sending_pixels(sending_pixel),
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index),
        .pixel_data(oled_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]),
        .pmoden(JB[7])
    );

endmodule
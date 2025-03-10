`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input basys_clock, input btnC, output [7:0] JB);

 wire CLOCK_6p25; 
 wire fb, sending_p, sampleP;
 wire [12:0] pixel_index;
 wire [15:0] pixel_data_output;

 Clock clk (basys_clock, 7, CLOCK_6p25);
 
 Task_C taskC (basys_clock, btnC, pixel_index, pixel_data_output);
  
 Oled_Display Oled_A ( 
 .clk(CLOCK_6p25), 
 .reset(0),
 .frame_begin(fb), 
 .sending_pixels(sending_p),
.sample_pixel(sampleP), 
.pixel_index(pixel_index), 
.pixel_data(pixel_data_output), 
.cs(JB[0]), 
.sdin(JB[1]), 
.sclk(JB[3]), 
.d_cn(JB[4]), 
.resn(JB[5]), 
.vccen(JB[6]),
.pmoden(JB[7]));
            


endmodule
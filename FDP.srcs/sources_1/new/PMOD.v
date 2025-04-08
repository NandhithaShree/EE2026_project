`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 23:22:22
// Design Name: 
// Module Name: PMOD
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


module PMOD(
    input wire clk,         // 100 MHz clock
    input [3:0] sound,    // Active high to play sound
    output DIN,         // Audio out to PmodAMP2
    output wire GAIN,       // Gain control
    output wire SD          // Shutdown (active high = ON)
);

    // Set gain and enable amp
    assign GAIN = 1'b1;  // 6 dB gain (set LOW for 12 dB)
    assign SD   = 1'b1;  // Keep amp active (LOW = shutdown)
    
    wire playing;
    wire [31:0] freq;
    sound_generator(
        clk,
        sound,
        freq,
        playing
    );
    
    tone_generator(
        clk,
        playing, 
        freq,
        DIN
    );
    
endmodule


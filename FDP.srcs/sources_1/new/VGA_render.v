`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 12:12:23
// Design Name: 
// Module Name: VGA_render
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

`include "Constants.vh"

module VGA_render
	(
		input wire clk, reset,
		input [255:0] board,
        input [63:0] moves,
        input [6:0] selected_x, selected_y,
        input [6:0] current_x, current_y,
        input [3:0] king_piece,
        input is_threatening_king,
        input is_promotion,
        input [1:0] selected_promotion_piece,
		output wire hsync, vsync,
		output wire [11:0] rgb
	);
	
	// register for Basys 2 8-bit RGB DAC 
	reg [11:0] rgb_reg;
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
	
	wire [9:0] x, y; //This needs to map to the current pixel, just in this module
	wire p_tick;
	
	wire [6:0] pixel_x = (x >= 24) ? (x - 24) / 6 : 0; //OFFSET
    wire [6:0] pixel_y = (y) / 6;
	
	//Check if it is piece logic
	wire is_piece;
        wire [3:0] piece;
        Piece_Render piece_render_inst (
            .basys_clock(clk),
            .board(board),
            .pixel_x(pixel_x),
            .pixel_y(pixel_y),
            .is_piece(is_piece),
            .piece(piece)
        );
        
     wire [11:0] VGA_bg_data;
     VGA_Background_Render vga_background_render_inst (
                .basys_clock(clk),
                .pixel_x(pixel_x),
                .pixel_y(pixel_y),
                .selected_x(selected_x),
                .selected_y(selected_y),
                .current_x(current_x),
                .current_y(current_y),
                .data(VGA_bg_data)
            );
            
        wire [11:0] promotion_selection_vga;
            VGA_pawn_promotion_render (
                .basys_clock(clk),
                .pixel_x(pixel_x),
                .pixel_y(pixel_y),
                .selected_promotion_piece(selected_promotion_piece),
                .data(promotion_selection_vga)
            );
            
        wire [4:0] grid_x, grid_y;
        assign grid_x = pixel_x / 8;
        assign grid_y = pixel_y / 8;
        wire [8:0] x_pos = (x - 24) % 48;
        wire [8:0] y_pos = (y) % 48;

        

        // instantiate vga_sync
        VGA_Sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                                .video_on(video_on), .p_tick(p_tick), .x(x), .y(y));

   
   

        // rgb buffer
always @(posedge clk) begin
            if (video_on) begin
               if (is_promotion)
                        rgb_reg = promotion_selection_vga;
                else if (grid_x >= 2 && grid_x <= 9 && grid_y >= 0 && grid_y <= 7) begin
                
                   //PIECE COLOUR
                    if (is_piece) begin
                        if (piece[3] == 1)
                            rgb_reg <= WHITE_VGA;
                        else
                            rgb_reg <= BLACK_VGA;
                    end else begin
                    
                      //AVA MOVES
                        if (moves[grid_y * 8 + grid_x - 2]) begin
                            if ((x_pos - 24) ** 2 + (y_pos - 24) ** 2 <= 225)
                                rgb_reg <= BLUE_VGA;
                            else
                                rgb_reg <= VGA_bg_data;
                        end else begin
                        
                        //IS KING
                            if (piece == king_piece && is_threatening_king) 
                                rgb_reg <= RED_VGA;
                            else 
                                rgb_reg <= VGA_bg_data;
                        end
                    end
                end else begin
                    rgb_reg <= BLACK_VGA; 
                end
            end else begin
                rgb_reg <= BLACK_VGA; 
            end
        end
        
        
        
        // output
        assign rgb = rgb_reg;
endmodule
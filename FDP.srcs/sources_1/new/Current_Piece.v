module Current_Piece(
    input [255:0] board,
    input [3:0] x, y,
    output reg [3:0] piece
);
    wire [7:0] idx;
    assign idx = ((7-y) * 8 + x) * 4; // Convert grid coords to bit position
    always @ (*) begin
        if (y < 0 || y > 7 || x < 0 || x > 7) piece = 4'b0000;
        else piece = board[idx+:4];  // Get 4 bits at calculated index
    end
endmodule

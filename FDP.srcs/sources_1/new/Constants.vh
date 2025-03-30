`ifndef CONSTANTS_VH
`define CONSTANTS_VH

//Colours
parameter WHITE = 16'hFFFF;
parameter BLACK = 16'h0000;
parameter LIGHT_BROWN = 16'hD69A; 
parameter DARK_BROWN = 16'h8410;  
parameter GREEN = 16'h07E0;     
parameter BLUE = 16'h001F;
parameter RED = 16'hF800;

//Piece bits
parameter EMPTY = 4'b0000;
parameter W_PAWN = 4'b1001;
parameter W_KNIGHT = 4'b1010;
parameter W_BISHOP = 4'b1011;
parameter W_ROOK = 4'b1100;
parameter W_QUEEN = 4'b1101;
parameter W_KING = 4'b1110;
parameter B_PAWN = 4'b0001;
parameter B_KNIGHT = 4'b0010;
parameter B_BISHOP = 4'b0011;
parameter B_ROOK = 4'b0100;
parameter B_QUEEN = 4'b0101;
parameter B_KING = 4'b0110;

parameter INITIAL_BOARD = {
    // 8th row (black pieces) - 32 bits
    B_ROOK, B_KNIGHT, B_BISHOP, B_QUEEN, B_KING, B_BISHOP, B_KNIGHT, B_ROOK,
    // 7th row (black pawns) - 32 bits
    B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN,
    // 6th row (empty) - 32 bits
    EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
    // 5th row (empty) - 32 bits
    EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
    // 4th row (empty) - 32 bits
    EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
    // 3rd row (empty) - 32 bits
    EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY,
    // 2nd row (white pawns) - 32 bits
    W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN,
    // 1st row (white pieces) - 32 bits
    W_ROOK, W_KNIGHT, W_BISHOP, W_QUEEN, W_KING, W_BISHOP, W_KNIGHT, W_ROOK
};

// For a four bit reg (grid coordinates), we designate 1000 as NULL.
parameter NULL = 4'b1000;

`endif // CONSTANTS_VH
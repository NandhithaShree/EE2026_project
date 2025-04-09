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

//Colours for VGA 8 Bit 
parameter WHITE_VGA        = 12'hFFF;  // R=F, B=F, G=F
parameter BLACK_VGA        = 12'h000;  // R=0, B=0, G=0
parameter LIGHT_BROWN_VGA  = 12'hCCC;  // R=A, B=5, G=D
parameter DARK_BROWN_VGA   = 12'hAAA;  // R=6, B=4, G=2
parameter GREEN_VGA        = 12'h00F;  // R=0, B=0, G=F
parameter BLUE_VGA         = 12'h0F0;  // R=0, B=F, G=0
parameter RED_VGA = 12'hF00;

//Piece bits
parameter EMPTY = 4'b0000;
parameter KING = 3'b110;
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

parameter START_GAME = 3'b000;
parameter PLAYER_TURN = 3'b001; 
parameter ENEMY_TURN = 3'b010;     
parameter PROMOTION = 3'b011;        
parameter WHITE_WIN = 3'b100;        
parameter BLACK_WIN = 3'b101;

parameter PLAY_START = 3'b000;
parameter PLAY_END = 3'b001;
parameter PLAY_MOVE = 3'b010;
parameter PLAY_PROMOTION = 3'b011;
parameter PLAY_EAT = 3'b100;
parameter IDLE = 3'b101;

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

parameter W = 2'b00;
parameter B = 2'b01;
parameter G = 2'b10;

parameter [2047:0] GAME_START = {
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, B, B, B, W, B, B, B, W, W, W, B, B, W, W, B, B, B, B, W, B, W, B, W, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, W, W, B, W, B, W, W, B, W, W, W, B, W, W, B, W, B, W, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, B, B, W, W, B, B, B, B, W, W, B, W, W, W, W, B, W, W, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, W, B, W, W, B, W, W, B, W, B, W, W, W, W, W, B, W, W, W, W, W, W,
    W, W, W, W, W, B, B, B, W, B, W, W, B, W, B, W, W, B, W, B, B, B, B, W, W, B, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,        
    W, W, W, W, W, B, B, B, W, B, W, W, B, W, B, B, B, B, W, W, B, B, B, W, W, B, B, B, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, W, W, B, W, B, W, W, W, W, B, W, W, W, W, B, W, W, W, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, B, B, B, W, B, B, B, W, W, W, B, B, W, W, W, B, B, W, W, W, W, W,
    W, W, W, W, B, W, W, W, W, B, W, W, B, W, B, W, W, W, W, W, W, W, B, W, W, W, W, B, W, W, W, W,
    W, W, W, W, W, B, B, B, W, B, W, W, B, W, B, B, B, B, W, B, B, B, W, W, B, B, B, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W, W, W, W, W,
    W, W, W, W, W, B, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, B, W, W, W, W, W,
    W, W, W, W, W, B, W, B, B, W, B, B, B, W, W, B, W, W, B, B, W, W, B, B, B, W, B, W, W, W, W, W,
    W, W, W, W, W, B, W, B, W, W, W, B, W, W, B, W, B, W, B, W, B, W, W, B, W, W, B, W, W, W, W, W,
    W, W, W, W, W, B, W, W, B, W, W, B, W, W, B, B, B, W, B, B, W, W, W, B, W, W, B, W, W, W, W, W,
    W, W, W, W, W, B, W, B, B, W, W, B, W, W, B, W, B, W, B, W, B, W, W, B, W, W, B, W, W, W, W, W,
    W, W, W, W, W, B, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, B, W, W, W, W, W,
    W, W, W, W, W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W
};



parameter [2047:0] WHITE_WINS = {
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, W, B, W, B, W, B, B, B, W, B, B, B, W, W, W, W, W, W,
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, W, B, W, B, W, W, B, W, W, B, W, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, W, W, B, W, B, B, B, B, W, B, W, W, B, W, W, B, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, B, W, B, W, B, W, W, B, W, B, W, W, B, W, W, B, W, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, B, W, B, W, W, B, W, W, B, W, B, W, W, B, W, W, B, B, B, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,        
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, W, W, B, W, W, B, B, B, W, B, W, W, W, W, W, W, W,
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, B, W, B, W, B, W, W, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, W, B, B, W, W, B, B, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, B, W, B, W, B, W, B, W, W, B, W, W, W, W, B, W, W, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, B, W, B, W, W, B, W, B, W, W, B, W, B, B, B, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W,
    W, B, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, B, W,
    W, B, G, B, B, G, G, G, B, B, G, B, B, G, B, B, B, G, G, B, G, G, B, B, G, G, B, B, B, G, B, W, 
    W, B, G, B, G, B, G, B, G, B, G, B, G, G, G, B, G, G, B, G, B, G, B, G, B, G, G, B, G, G, B, W,
    W, B, G, B, B, G, G, B, B, G, G, G, B, G, G, B, G, G, B, B, B, G, B, B, G, G, G, B, G, G, B, W, 
    W, B, G, B, G, B, G, G, B, B, G, B, B, G, G, B, G, G, B, G, B, G, B, G, B, G, G, B, G, G, B, W, 
    W, B, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, B, W,
    W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W
};

parameter [2047:0] BLACK_WINS = {
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, B, B, B, W, W, B, W, W, W, W, B, B, W, W, W, B, B, B, W, B, W, W, B, W, W, W, W, W,
    W, W, W, W, B, W, W, B, W, B, W, W, W, B, W, W, B, W, B, W, W, W, W, B, W, B, W, W, W, W, W, W,
    W, W, W, W, B, B, B, W, W, B, W, W, W, B, B, B, B, W, B, W, W, W, W, B, B, W, W, W, W, W, W, W,
    W, W, W, W, B, W, W, B, W, B, W, W, W, B, W, W, B, W, B, W, W, W, W, B, W, B, W, W, W, W, W, W,
    W, W, W, W, B, B, B, W, W, B, B, B, W, B, W, W, B, W, W, B, B, B, W, B, W, W, B, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,        
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, W, W, B, W, W, B, B, B, W, B, W, W, W, W, W, W, W,
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, B, W, B, W, B, W, W, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, W, W, B, W, B, W, B, W, B, B, W, W, B, B, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, B, W, B, W, B, W, B, W, B, W, W, B, W, W, W, W, B, W, W, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, B, W, B, W, W, B, W, B, W, W, B, W, B, B, B, W, W, B, W, W, W, W, W, W, W, 
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W,
    W, B, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, B, W,
    W, B, G, B, B, G, G, G, B, B, G, B, B, G, B, B, B, G, G, B, G, G, B, B, G, G, B, B, B, G, B, W, 
    W, B, G, B, G, B, G, B, G, B, G, B, G, G, G, B, G, G, B, G, B, G, B, G, B, G, G, B, G, G, B, W,
    W, B, G, B, B, G, G, B, B, G, G, G, B, G, G, B, G, G, B, B, B, G, B, B, G, G, G, B, G, G, B, W, 
    W, B, G, B, G, B, G, G, B, B, G, B, B, G, G, B, G, G, B, G, B, G, B, G, B, G, G, B, G, G, B, W, 
    W, B, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, G, B, W,
    W, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W
};

`endif // CONSTANTS_VH
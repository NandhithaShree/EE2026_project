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


//only for OLED
parameter LIGHT_GREEN = 16'b10010_111011_10010; //green for stem
parameter LIGHT_PINK = 16'b11111_110000_11001; //pink for flower
parameter DIRT_RED = 16'b10011_010100_00101; //reddish brown for dirt
parameter GREY = 16'b11010_110100_11010; //light grey for skull

//START, END SCREEN Colours
parameter DARK_GREEN_SCREEN  = 16'h210C;
parameter LIGHT_GREEN_SCREEN = 16'h4210;
parameter GREEN_GREEN_SCREEN = 16'h7394;
parameter LIGHT_BROWN_SCREEN = 16'hEDD6; 
parameter DARK_BROWN_SCREEN  = 16'hD7A0; 

parameter LIGHT_GREEN_VGA         = 12'h456;
parameter DARK_GREEN_VGA          = 12'h233;
parameter LIGHT_BROWN_SCREEN_VGA  = 12'hEBD;
parameter DARK_BROWN_SCREEN_VGA   = 12'hD7A;
parameter GREEN_GREEN             = 12'h77A;

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

parameter [3:0] B = 4'b0000;
parameter [3:0] W = 4'b0001;
parameter [3:0] G = 4'b0010; //green for stem
parameter [3:0] P = 4'b0011; //pink for flower
parameter [3:0] R = 4'b0100; //reddish brown for dirt
parameter [3:0] S = 4'b0101; //light grey for skull
parameter [3:0] H = 4'b0111; //hover
parameter [3:0] LG = 4'b1000;
parameter [3:0] DG = 4'b1001;
parameter [3:0] GG = 4'b1010;
parameter [3:0] LB = 4'b1011;
parameter [3:0] DB = 4'b1100;


parameter [4095:0] GAME_START = {
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DB, DB, DB, LG, DB, DB, DB, DB, DG, LG, DB, DB, LG, DG, DB, DB, DB, DB, LG, DB, LG, DG, DB, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, LG, DB, LG, DB, DG, DG, DB, DG, DB, DB, DB, DB, DG, DG, DG, DB, DB, LG, DB, DB, DG, DB, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, LG, LG, LG, DB, DB, DB, DG, DG, DB, LG, LG, DB, DG, DG, DB, DB, LG, LG, LG, DB, DB, DB, DG, DG, LG, LG,
    DG, DG, LG, LG, DB, LG, DG, DB, DG, DB, LG, LG, DB, LG, DB, DB, DB, DB, LG, DB, DB, LG, DG, DG, DG, DG, DB, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, DB, DB, DB, DB, DG, DB, LG, LG, DB, LG, DB, DG, DG, DB, LG, DB, DB, DB, DB, DG, DB, DB, DB, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    LG, LG, DG, DG, DB, DB, DB, DB, LG, DB, DG, DG, DB, DG, DB, DB, DB, DB, DG, DB, DB, DB, DB, LG, DB, DB, DB, DB, DG, DG, LG, LG,      
    LG, LG, DG, DG, DB, DG, LG, DB, LG, DB, DG, DG, DB, DG, DB, DB, LG, LG, DG, DB, DG, DG, LG, LG, DB, LG, DG, DG, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, LG, LG, LG, DB, DB, DB, DB, DG, DB, DB, DB, DB, DG, DB, DB, DB, DB, LG, DB, DB, DB, DB, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, LG, DB, LG, DB, DG, DG, DB, DG, DB, DB, LG, LG, DG, DG, DG, DG, DB, LG, LG, LG, DG, DB, DG, DG, LG, LG,
    GG, DG, LG, LG, DB, DB, DB, DB, DG, DB, LG, LG, DB, LG, DB, DB, DB, DB, LG, DB, DB, DB, DB, DG, DB, DB, DB, DB, LG, LG, DG, GG, 
     W, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  B,
     W,  W, GG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, GG, B,   B,
     W, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  B,
     W,  W, GG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, GG, B,   B,
     W,  W,  W, GG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, GG,  B,  B,  B,
     W,  W, GG, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, GG,  B,  B,
     W, GG, DG, LB,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H, LB, DG, GG,  B,
     W, GG, LG, LB,  H,  B,  B,  B,  B,  H,  B,  B,  B,  H,  H,  B,  B,  H,  H,  B,  B,  B,  B,  H,  B,  B,  B,  H, LB, LG, GG,  B,
     W,  W, GG, LB,  H,  B,  H,  H,  H,  H,  H,  B,  H,  H,  B,  H,  H,  B,  H,  B,  H,  H,  B,  H,  H,  B,  H,  H, LB, GG,  B,  B,
     W,  W, GG, LB,  H,  B,  B,  B,  B,  H,  H,  B,  H,  H,  B,  B,  B,  B,  H,  B,  B,  B,  H,  H,  H,  B,  H,  H, LB, GG,  B,  B,
     W, GG, LG, LB,  H,  H,  H,  H,  B,  H,  H,  B,  H,  H,  B,  H,  H,  B,  H,  B,  H,  H,  B,  H,  H,  B,  H,  H, LB, LG, GG,  B,
     W, GG, DG, LB,  H,  B,  B,  B,  B,  H,  H,  B,  H,  H,  B,  H,  H,  B,  H,  B,  H,  H,  B,  H,  H,  B,  H,  H, LB, DG, GG,  B,
     W,  W, GG, LB,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H,  H, LB, GG,  B,  B,
     W,  W, GG, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, LB, GG,  B,  B,
     W,  W,  W, GG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, GG,  B,  B,  B,
     W,  W,  W,  W, GG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, GG,  B,  B,  B,  B,
     W,  W,  W,  W,  W, GG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, GG,  B,  B,  B,  B,  B
};

parameter [4095:0] WHITE_WINS = {
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    LG, LG, DG, DG, DB, DG, LG, LG, DB, LG, DB, DG, DG, DB, LG, DB, DB, LG, DB, DB, DB, DB, LG, DB, DB, DB, DB, DG, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, LG, LG, DB, LG, DB, DG, DG, DB, LG, DB, DB, LG, DG, DB, DB, DG, LG, DB, DB, LG, DG, DG, DG, DG, LG, LG,
    LG, LG, DG, DG, DB, DG, DB, LG, DB, LG, DB, DB, DB, DB, LG, DB, DB, LG, DG, DB, DB, DG, LG, DB, DB, DB, DB, DG, DG, DG, LG, LG, 
    LG, LG, DG, DG, DB, DB, DB, DB, DB, LG, DB, DG, DG, DB, LG, DB, DB, LG, DG, DB, DB, DG, LG, DB, DB, LG, DG, DG, DG, DG, LG, LG,
    DG, DG, LG, LG, LG, DB, DB, DB, DG, DG, DB, LG, LG, DB, DG, DB, DB, DG, LG, DB, DB, LG, DG, DB, DB, DB, DB, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DB, DG, DG, LG, DB, LG, DB, DB, DG, DB, DG, LG, DB, LG, DB, DB, DB, DB, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DB, DG, DB, LG, DB, LG, DB, DB, DG, DB, DB, LG, DB, LG, DB, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    LG, LG, DG, DG, DG, DG, LG, DB, LG, DB, DG, DB, DG, DB, DB, LG, DB, LG, DB, DB, DG, DB, DB, DB, DB, LG, DG, DG, DG, DG, LG, LG,      
    LG, LG, DG, DG, DG, DG, LG, DB, DB, DB, DB, DB, DG, DB, DB, LG, DB, LG, DG, DB, DG, DG, LG, LG, DB, LG, DG, DG, DG, DG, LG, LG,    
    LG, LG, DG, DG, DG, DG, LG, LG, DB, DB, DB, DG, DG, DB, DB, LG, DB, LG, DG, DB, DG, DB, DB, DB, DB, LG, DG, DG, DG, DG, LG, LG, 
    LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, GG, GG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  W,  W, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, GG,  W,  W,  W,  W, GG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  W,  W, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
    LG, LG, DG, DG, GG, GG, LG, LG, LG, LG, DG, DG, GG, GG,  W,  W,  W,  W, GG, GG, DG, DG, LG, LG, GG, LG, GG, GG, DG, GG, LG, LG,
    LG, LG, DG, GG,  W,  W, GG, LG, LG, LG, DG, GG,  W,  W,  W,  W,  W,  W,  W,  W, GG, DG, LG, GG,  W, GG,  W,  W, GG,  W, GG, LG,
    LG, LG, GG,  W,  W,  W,  W, GG, LG, LG, DG, DG, GG,  W,  W,  W,  W,  W,  W, GG, DG, DG, LG, GG,  W,  W,  W,  W,  W,  W, GG, LG,
    LG, LG, GG,  W,  W,  W,  W, GG, LG, LG, DG, DG, DG, GG,  W,  W,  W,  W, GG, DG, DG, DG, LG, LG, GG,  W,  W,  W,  W, GG, LG, LG,
    DG, DG, LG, GG,  W,  W, GG, DG, DG, DG, LG, LG, GG,  W,  W,  W,  W,  W,  W, GG, LG, LG, DG, DG, DG, GG,  W,  W, GG, LG, DG, DG,
    DG, DG, GG,  W,  W,  W,  W, GG, DG, DG, LG, GG,  W,  W,  W,  W,  W,  W,  W,  W, GG, LG, DG, DG, DG, GG,  W,  W, GG, LG, DG, DG,
    DG, DG, LG, GG,  W,  W, GG, DG, DG, DG, LG, LG, GG, GG,  W,  W,  W,  W, GG, GG, LG, LG, DG, DG, GG,  W,  W,  W,  W, GG, DG, DG,
    DG, DG, LG, GG,  W,  W, GG, DG, DG, DG, LG, LG, LG, GG,  W,  W,  W,  W, GG, LG, LG, LG, DG, DG, GG,  W,  W,  W,  W, GG, DG, DG,
    LG, LG, DG, GG,  W,  W, GG, LG, LG, LG, DG, DG, GG,  W,  W,  W,  W,  W,  W, GG, DG, DG, LG, LG, GG,  W,  W,  W,  W, GG, LG, LG,
    LG, LG, GG,  W,  W,  W,  W, GG, LG, LG, DG, GG,  W,  W,  W,  W,  W,  W,  W,  W, GG, DG, LG, LG, GG,  W,  W,  W,  W, GG, LG, LG,
    LG, GG,  W,  W,  W,  W,  W,  W, GG, LG, GG,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W, GG, LG, GG,  W,  W,  W,  W,  W,  W, GG, LG,
    GG,  W,  W,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W,  W,  W, GG,
    DG, GG,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W, GG, DG,
    GG,  W,  W,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W,  W,  W,  W,  W, GG, GG,  W,  W,  W,  W,  W,  W,  W,  W, GG
};

parameter [4095:0] BLACK_WINS = {
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
LG, LG, DG, DG, DB, DB, DB, LG, LG, DB, DG, DG, DG, DG, LG, DB, DB, LG, DG, DB, DB, DB, DB, LG, DB, LG, DG, DB, DG, DG, LG, LG,
LG, LG, DG, DG, DB, DG, LG, DB, LG, DB, DG, DG, DG, DG, DB, DB, DB, DB, DG, DB, DG, DG, LG, LG, DB, LG, DB, DG, DG, DG, LG, LG,
LG, LG, DG, DG, DB, DB, DB, LG, LG, DB, DG, DG, DG, DG, DB, LG, LG, DB, DG, DB, DG, DG, LG, LG, DB, DB, DG, DG, DG, DG, LG, LG, 
LG, LG, DG, DG, DB, DG, LG, DB, LG, DB, DG, DG, DG, DG, DB, DB, DB, DB, DG, DB, DG, DG, LG, LG, DB, LG, DB, DG, DG, DG, LG, LG,
DG, DG, LG, LG, DB, DB, DB, DG, DG, DB, DB, DB, DB, LG, DB, DG, DG, DB, LG, DB, DB, DB, DB, DG, DB, DG, LG, DB, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DB, DG, DG, LG, DB, LG, DB, DB, DG, DB, DG, LG, DB, LG, DB, DB, DB, DB, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DB, DG, DB, LG, DB, LG, DB, DB, DG, DB, DB, LG, DB, LG, DB, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
LG, LG, DG, DG, DG, DG, LG, DB, LG, DB, DG, DB, DG, DB, DB, LG, DB, LG, DB, DB, DG, DB, DB, DB, DB, LG, DG, DG, DG, DG, LG, LG,      
LG, LG, DG, DG, DG, DG, LG, DB, DB, DB, DB, DB, DG, DB, DB, LG, DB, LG, DG, DB, DG, DG, LG, LG, DB, LG, DG, DG, DG, DG, LG, LG,    
LG, LG, DG, DG, DG, DG, LG, LG, DB, DB, DB, DG, DG, DB, DB, LG, DB, LG, DG, DB, DG, DB, DB, DB, DB, LG, DG, DG, DG, DG, LG, LG, 
LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, GG, GG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  B,  B, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, GG,  B,  B,  B,  B, GG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
DG, DG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, GG,  B,  B, GG, LG, LG, LG, LG, DG, DG, DG, DG, LG, LG, LG, LG, DG, DG,
LG, LG, DG, DG, GG, GG, LG, LG, LG, LG, DG, DG, GG, GG,  B,  B,  B,  B, GG, GG, DG, DG, LG, LG, GG, LG, GG, GG, DG, GG, LG, LG,
LG, LG, DG, GG,  B,  B, GG, LG, LG, LG, DG, GG,  B,  B,  B,  B,  B,  B,  B,  B, GG, DG, LG, GG,  B, GG,  B,  B, GG,  B, GG, LG,
LG, LG, GG,  B,  B,  B,  B, GG, LG, LG, DG, DG, GG,  B,  B,  B,  B,  B,  B, GG, DG, DG, LG, GG,  B,  B,  B,  B,  B,  B, GG, LG,
LG, LG, GG,  B,  B,  B,  B, GG, LG, LG, DG, DG, DG, GG,  B,  B,  B,  B, GG, DG, DG, DG, LG, LG, GG,  B,  B,  B,  B, GG, LG, LG,
DG, DG, LG, GG,  B,  B, GG, DG, DG, DG, LG, LG, GG,  B,  B,  B,  B,  B,  B, GG, LG, LG, DG, DG, DG, GG,  B,  B, GG, LG, DG, DG,
DG, DG, GG,  B,  B,  B,  B, GG, DG, DG, LG, GG,  B,  B,  B,  B,  B,  B,  B,  B, GG, LG, DG, DG, DG, GG,  B,  B, GG, LG, DG, DG,
DG, DG, LG, GG,  B,  B, GG, DG, DG, DG, LG, LG, GG, GG,  B,  B,  B,  B, GG, GG, LG, LG, DG, DG, GG,  B,  B,  B,  B, GG, DG, DG,
DG, DG, LG, GG,  B,  B, GG, DG, DG, DG, LG, LG, LG, GG,  B,  B,  B,  B, GG, LG, LG, LG, DG, DG, GG,  B,  B,  B,  B, GG, DG, DG,
LG, LG, DG, GG,  B,  B, GG, LG, LG, LG, DG, DG, GG,  B,  B,  B,  B,  B,  B, GG, DG, DG, LG, LG, GG,  B,  B,  B,  B, GG, LG, LG,
LG, LG, GG,  B,  B,  B,  B, GG, LG, LG, DG, GG,  B,  B,  B,  B,  B,  B,  B,  B, GG, DG, LG, LG, GG,  B,  B,  B,  B, GG, LG, LG,
LG, GG,  B,  B,  B,  B,  B,  B, GG, LG, GG,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B, GG, LG, GG,  B,  B,  B,  B,  B,  B, GG, LG,
GG,  B,  B,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B,  B,  B, GG,
DG, GG,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B, GG, DG,
GG,  B,  B,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B,  B,  B,  B,  B, GG, GG,  B,  B,  B,  B,  B,  B,  B,  B, GG
};

parameter [4095:0] DEAD_SCREEN = {
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W,
    R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, P, B, B, P, B, B, P, B, B, B, S, S, S, S, S, S, S, B, B, B, P, B, P, B, B, B, P, B, B,
    B, B, B, P, P, P, P, B, P, P, B, B, S, S, S, S, S, S, S, S, S, B, B, P, P, P, P, B, P, P, B, B,
    B, B, B, B, P, P, P, P, P, B, B, S, S, S, S, S, S, S, S, S, S, S, B, B, P, P, P, P, P, B, B, B,
    B, B, B, B, P, P, P, P, P, B, B, S, S, B, B, S, S, S, B, B, S, S, B, B, P, P, P, P, P, B, B, B,
    B, B, B, B, P, P, P, P, P, B, B, S, S, B, B, S, S, S, B, B, S, S, B, B, P, P, P, P, P, B, B, B,
    B, B, B, B, B, P, P, P, B, B, B, S, S, S, S, S, B, S, S, S, S, S, B, B, B, P, P, P, B, B, B, B,
    B, B, B, B, B, B, G, B, B, B, B, B, S, S, S, B, B, B, S, S, S, B, B, B, B, B, G, B, B, B, B, B,
    B, B, B, B, B, B, G, B, B, B, B, B, S, S, S, S, S, S, S, S, S, B, B, B, B, B, G, B, B, B, B, B,
    B, B, B, B, B, G, G, B, B, B, B, B, B, S, B, S, B, S, B, S, B, B, B, B, B, B, G, G, B, B, B, B,
    B, B, B, B, B, G, B, B, B, B, B, B, B, S, B, S, B, S, B, S, B, B, B, B, B, B, B, G, B, B, B, B,
    B, B, B, B, B, G, B, B, B, B, B, B, B, S, S, S, S, S, S, S, B, B, B, B, B, B, B, G, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, S, S, S, S, S, B, B, B, B, B, B, B, B, B, B, B, B, B,
    R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R,
    R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B,
    B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B, B
};

`endif // CONSTANTS_VH
module Switch_Decoder(
    input basys_clock,
    input [15:0] sw,
    output reg [2:0] state,
    output reg reset
);

    wire [15:0] taskA = 16'b0001_0011_0100_0101;
    wire [15:0] taskB = 16'b0010_0001_0001_1111;
    wire [15:0] taskC = 16'b0100_0011_0010_0101;
    wire [15:0] taskD = 16'b1000_0010_0100_1101;
    
    reg [31:0] reset_counter = 0; // Counts reset duration
    reg reset_flag = 0; // Internal reset trigger
    reg [15:0] prev_sw = 0; // Stores previous switch state
    
    always @ (posedge basys_clock) begin
        if (sw != prev_sw) begin
            prev_sw <= sw;
            reset_flag <= 1;
        end
        
        if (reset_flag) begin
            if (reset_counter < 1_000_000) begin
                reset_counter <= reset_counter + 1;
                reset <= 1;
            end else begin
                reset_flag <= 0;
                reset <= 0;
                reset_counter <= 0;
            end
        end
        
        case (sw)
            taskA: state <= 3'b000;  // Task A
            taskB: state <= 3'b001;  // Task B
            taskC: state <= 3'b010;  // Task C
            taskD: state <= 3'b011;  // Task D
            default: state <= 3'b100; // Default state
        endcase
    end 

endmodule
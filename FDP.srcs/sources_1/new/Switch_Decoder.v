module Switch_Decoder(
    input basys_clock,
    input [15:0] sw,
    output reg [2:0] state
);

    wire [15:0] taskA = 16'b0001_0011_0100_0101;
    wire [15:0] taskB = 16'b0010_0001_0001_1111;
    wire [15:0] taskC = 16'b0100_0011_0010_0101;
    wire [15:0] taskD = 16'b1000_0010_0100_1101;
    
    always @ (posedge basys_clock) begin
        if (sw == taskA)
            state <= 3'b000;  // Task A
        else if (sw == taskB)
            state <= 3'b001;  // Task B
        else if (sw == taskC)
            state <= 3'b010;  // Task C
        else if (sw == taskD)
            state <= 3'b011;  // Task D
        else
            state <= 3'b100;  // Default state
    end

endmodule
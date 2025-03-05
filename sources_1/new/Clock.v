module Clock (
    input basys_clock,
    input [31:0] m,
    output reg slow_clock
    );
    
    reg [31:0] count = 0;
        
    initial begin
        slow_clock = 0;
    end
       
    always @ (posedge basys_clock) begin
        count = (count == m) ? 0 : count + 1;
        slow_clock = (count == 0) ? ~slow_clock : slow_clock;
    end
endmodule
module TaskB_Counter (
    input clock_1KHz,
    input push_button,
    output reg stable_pb
);

    parameter DEBOUNCE_CYCLES = 200;

    reg [31:0] debounce_counter = 0;
    reg button_state_reg = 0;

    always @(posedge clock_1KHz) begin
        if (debounce_counter < DEBOUNCE_CYCLES) begin
            debounce_counter <= debounce_counter + 1;
        end

        if (debounce_counter == DEBOUNCE_CYCLES) begin
            if (push_button == 1) begin
                button_state_reg <= 1;
                debounce_counter <= 0;
            end
        end
    end

    always @(posedge clock_1KHz) begin
        stable_pb <= button_state_reg;
    end

endmodule
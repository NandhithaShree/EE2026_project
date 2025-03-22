module Uart_Test (
    input basys_clock,rx,btnU,btnD,
    input  [15:0] sw,
    output tx,
    output [15:0] led
);
    top_uart_tx(basys_clock, sw, btnU, tx);
    top_uart_rx(basys_clock, rx, btnD, led);
endmodule
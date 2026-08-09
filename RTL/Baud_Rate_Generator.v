
`timescale 1ns / 1ps

module Baud_Rate_Generator(
    input  clk,
    input rst,
    output tx_enb,
    output rx_enb
);

reg [12:0] tx_counter;
reg [8:0]  rx_counter;

always @(posedge clk)
begin
    if (rst)
    begin
        tx_counter <= 0;
        rx_counter <= 0;
    end
    else
    begin
        // TX baud enable: approximately 9600 baud
        if (tx_counter == 13'd5207)
            tx_counter <= 0;
        else
            tx_counter <= tx_counter + 1'b1;

        // RX enable: 16 times the baud rate
        if (rx_counter == 9'd324)
            rx_counter <= 0;
        else
            rx_counter <= rx_counter + 1'b1;
    end
end

assign tx_enb = (tx_counter == 0);
assign rx_enb = (rx_counter == 0);

endmodule


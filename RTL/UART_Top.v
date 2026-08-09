`timescale 1ns / 1ps

module UART_Top(
    input rst,
    input [7:0] data_in,
    input wr_en,
    input clk,
    input rdy_clr,

    output rdy,
    output busy,
    output [7:0] data_out
);

wire rx_clk_enb;
wire tx_clk_enb;
wire tx_temp;

// Baud Rate Generator
Baud_Rate_Generator bg (
    .clk(clk),
    .rst(rst),
    .tx_enb(tx_clk_enb),
    .rx_enb(rx_clk_enb)
);

// Transmitter
Transmitter us (
    .clk(clk),
    .tx_enb(tx_clk_enb),
    .wr_enb(wr_en),
    .rst(rst),
    .data_in(data_in),
    .tx(tx_temp),
    .busy(busy)
);

// Receiver
// Transmitter output is connected directly to receiver input
Receiver ur (
    .clk(clk),
    .rst(rst),
    .rx(tx_temp),
    .rdy_clr(rdy_clr),
    .rx_enb(rx_clk_enb),
    .rdy(rdy),
    .data_out(data_out)
);

endmodule


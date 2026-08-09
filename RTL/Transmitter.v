
`timescale 1ns / 1ps

module Transmitter(
    input clk,
    input tx_enb,
    input wr_enb,
    input rst,
    input [7:0] data_in,
    output reg tx,
    output busy
);

parameter idle_state  = 2'b00;
parameter start_state = 2'b01;
parameter data_state  = 2'b10;
parameter stop_state  = 2'b11;

reg [7:0] data;
reg [2:0] index;
reg [1:0] state;

assign busy = (state != idle_state);

always @(posedge clk)
begin
    if (rst)
    begin
        state <= idle_state;
        data  <= 8'b0;
        index <= 3'b0;
        tx    <= 1'b1;
    end
    else
    begin
        case(state)

            idle_state:
            begin
                tx <= 1'b1;

                if (wr_enb)
                begin
                    data  <= data_in;
                    index <= 3'b0;
                    state <= start_state;
                end
            end

            start_state:
            begin
                if (tx_enb)
                begin
                    tx <= 1'b0;
                    state <= data_state;
                end
            end

            data_state:
            begin
                if (tx_enb)
                begin
                    tx <= data[index];

                    if (index == 3'b111)
                    begin
                        state <= stop_state;
                    end
                    else
                    begin
                        index <= index + 1'b1;
                    end
                end
            end

            stop_state:
            begin
                if (tx_enb)
                begin
                    tx <= 1'b1;
                    state <= idle_state;
                end
            end

            default:
            begin
                state <= idle_state;
                tx <= 1'b1;
            end

        endcase
    end
end

endmodule


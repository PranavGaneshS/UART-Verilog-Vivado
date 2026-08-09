
`timescale 1ns / 1ps

module Receiver(
    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input rx_enb,
    output reg rdy,
    output reg [7:0] data_out
);

parameter idle_state  = 2'b00;
parameter start_state = 2'b01;
parameter data_state  = 2'b10;
parameter stop_state  = 2'b11;

reg [1:0] state;
reg [3:0] sample;
reg [3:0] index;
reg [7:0] temp;

always @(posedge clk)
begin
    if (rst)
    begin
        state    <= idle_state;
        sample   <= 4'd0;
        index    <= 4'd0;
        temp     <= 8'd0;
        data_out <= 8'd0;
        rdy      <= 1'b0;
    end
    else
    begin

        if (rdy_clr)
            rdy <= 1'b0;

        if (rx_enb)
        begin
            case(state)

                // Wait for start bit
                idle_state:
                begin
                    if (rx == 1'b0)
                    begin
                        sample <= 4'd0;
                        state <= start_state;
                    end
                end

                // Confirm start bit at its center
                start_state:
                begin
                    if (sample == 4'd7)
                    begin
                        if (rx == 1'b0)
                        begin
                            sample <= 4'd0;
                            index <= 4'd0;
                            temp <= 8'd0;
                            state <= data_state;
                        end
                        else
                        begin
                            state <= idle_state;
                            sample <= 4'd0;
                        end
                    end
                    else
                    begin
                        sample <= sample + 1'b1;
                    end
                end

                // Receive 8 data bits
                data_state:
                begin
                    if (sample == 4'd15)
                    begin
                        sample <= 4'd0;
                        temp[index] <= rx;

                        if (index == 4'd7)
                        begin
                            state <= stop_state;
                        end
                        else
                        begin
                            index <= index + 1'b1;
                        end
                    end
                    else
                    begin
                        sample <= sample + 1'b1;
                    end
                end

                // Check stop bit
                stop_state:
                begin
                    if (sample == 4'd15)
                    begin
                        if (rx == 1'b1)
                        begin
                            data_out <= temp;
                            rdy <= 1'b1;
                        end

                        sample <= 4'd0;
                        state <= idle_state;
                    end
                    else
                    begin
                        sample <= sample + 1'b1;
                    end
                end

                default:
                begin
                    state <= idle_state;
                    sample <= 4'd0;
                end

            endcase
        end
    end
end

endmodule


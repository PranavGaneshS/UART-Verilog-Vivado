
`timescale 1ns / 1ps

module UART_tb();

reg clk;
reg rst;
reg [7:0] data_in;
reg wr_en;
reg rdy_clr;

wire rdy;
wire busy;
wire [7:0] data_out;

UART_Top uut (
    .rst(rst),
    .data_in(data_in),
    .wr_en(wr_en),
    .clk(clk),
    .rdy_clr(rdy_clr),
    .rdy(rdy),
    .busy(busy),
    .data_out(data_out)
);

// Clock generation
initial
begin
    clk = 1'b0;
end

always #5 clk = ~clk;


// Send one byte
task send_byte(input [7:0] din);
begin
    @(negedge clk);
    data_in = din;
    wr_en = 1'b1;

    @(negedge clk);
    wr_en = 1'b0;
end
endtask


// Clear ready signal
task clear_ready;
begin
    @(negedge clk);
    rdy_clr = 1'b1;

    @(negedge clk);
    rdy_clr = 1'b0;
end
endtask


initial
begin

    // Initial values
    rst = 1'b1;
    data_in = 8'h00;
    wr_en = 1'b0;
    rdy_clr = 1'b0;

    // Reset
    repeat(2)
        @(negedge clk);

    rst = 1'b0;

    // Send A = 41h
    send_byte(8'h41);

    wait(!busy);
    wait(rdy);

    $display("Received Signal = %h", data_out);

    clear_ready;


    // Send T = 54h
    send_byte(8'h54);

    wait(!busy);
    wait(rdy);

    $display("Received Signal = %h", data_out);

    clear_ready;


    #1000 $finish;

end

endmodule


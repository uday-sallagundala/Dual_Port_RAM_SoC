`timescale 1ns/1ps
`define RAM_WIDTH 64
`define ADDR_SIZE 14

module ram_soc_tb;

reg clk;
reg [`RAM_WIDTH-1:0] data_in;
reg [`ADDR_SIZE-1:0] rd_address, wr_address;
reg read, write;

wire [`RAM_WIDTH-1:0] data_out;
wire data_valid;

ram_soc dut (
    .clk(clk),
    .data_in(data_in),
    .rd_address(rd_address),
    .wr_address(wr_address),
    .read(read),
    .write(write),
    .data_out(data_out),
    .data_valid(data_valid)
);

// Clock
initial clk=0;
always #5 clk=~clk;

// Stimulus
initial begin
    data_in=0; rd_address=0; wr_address=0; read=0; write=0;

    // Test writes to different RAM_CHIP blocks using MSB of address
    #10;
    data_in=64'h1111_2222_3333_4444; wr_address=14'h0001; write=1;
    #10; write=0;

    data_in=64'h5555_6666_7777_8888; wr_address=14'h4002; write=1;
    #10; write=0;

    // Read back
    rd_address=14'h0001; read=1;
    #10; read=0;
    $display("Read from chip0: %h", data_out);

    rd_address=14'h4002; read=1;
    #10; read=0;
    $display("Read from chip1: %h", data_out);

    $finish;
end

endmodule

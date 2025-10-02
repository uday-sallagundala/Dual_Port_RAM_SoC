`timescale 1ns/1ps
`define RAM_WIDTH 64
`define ADDR_SIZE 12

module ram_4k_tb;

reg clk;
reg [`RAM_WIDTH-1:0] data_in;
reg [`ADDR_SIZE-1:0] rd_address, wr_address;
reg read, write;

wire [`RAM_WIDTH-1:0] data_out;
wire data_valid;

ram_4k dut (
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

    // Write to memory bank 0
    #10;
    data_in = 64'h1234_5678_9ABC_DEF0;
    wr_address = 0; write = 1;
    #10; write = 0;

    // Read back
    rd_address = 0; read = 1;
    #10; read = 0;

    if(data_valid && data_out == 64'h1234_5678_9ABC_DEF0) begin
		  $display("-----------------------------");
     //   $display("");
        $display("ram_4k TEST PASSED!");
     //   $display("");
        $display("-----------------------------");
		end
	  else
        $display("ram_4K Test Failed: %h", data_out);

    $finish;
end

endmodule

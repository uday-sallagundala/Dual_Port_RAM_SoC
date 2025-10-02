`timescale 1ns/1ps
module dual_port_memory_tb;

parameter RAM_WIDTH = 64;
parameter ADDR_SIZE = 10;
parameter RAM_DEPTH = 1024;

// Inputs
reg clk;
reg [RAM_WIDTH-1:0] data_in;
reg [ADDR_SIZE-1:0] rd_address;
reg [ADDR_SIZE-1:0] wr_address;
reg read, write;
reg mem_wr_en, mem_rd_en;

// Outputs
wire [RAM_WIDTH-1:0] data_out;
wire data_valid;

// Instantiate DUT
dual_port_memory #(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH),
    .ADDR_SIZE(ADDR_SIZE)
) dut (
    .clk(clk),
    .data_in(data_in),
    .rd_address(rd_address),
    .wr_address(wr_address),
    .read(read),
    .write(write),
    .mem_wr_en(mem_wr_en),
    .mem_rd_en(mem_rd_en),
    .data_out(data_out),
    .data_valid(data_valid)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;

// Stimulus
initial begin
    data_in = 0; rd_address = 0; wr_address = 0;
    read = 0; write = 0; mem_wr_en = 0; mem_rd_en = 0;

    // Write some data
    #10;
    data_in = 64'hDEAD_BEEF_CAFE_BABE;
    wr_address = 10; mem_wr_en = 1; write = 1;
    #10; write = 0; mem_wr_en = 0;

    // Read back
    rd_address = 10; mem_rd_en = 1; read = 1;
    #10; read = 0; mem_rd_en = 0;

    // Check result
    if(data_out == 64'hDEAD_BEEF_CAFE_BABE) begin
	     $display("-----------------------------");
     //   $display("");
        $display("dual_port_memory TEST PASSED!");
     //   $display("");
        $display("-----------------------------");
	  end
    else
        $display("dual_port_memory Test Failed: %h", data_out);

    $finish;
end

endmodule

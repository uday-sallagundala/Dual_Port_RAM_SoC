`timescale 1ns/1ps
`define RAM_WIDTH 64
`define ADDR_SIZE 12

module ram_chip_tb;

reg clk;
reg [`RAM_WIDTH-1:0] data_in;
reg [`ADDR_SIZE-1:0] rd_address, wr_address;
reg read, write;
reg chip_en;

wire [`RAM_WIDTH-1:0] data_out;
wire data_valid;

ram_chip dut (
    .clk(clk),
    .data_in(data_in),
    .rd_address(rd_address),
    .wr_address(wr_address),
    .read(read),
    .write(write),
    .chip_en(chip_en),
    .data_out(data_out),
    .data_valid(data_valid)
);

// Clock
initial clk=0;
always #5 clk=~clk;

// Stimulus
initial begin
    data_in=0; rd_address=0; wr_address=0; read=0; write=0; chip_en=0;

    // Enable chip and write
    #10;
    chip_en = 1; data_in=64'hA1B2_C3D4_E5F6_7890; wr_address=5; write=1;
    #10; write=0;

    // Read
    rd_address=5; read=1;
    #10; read=0;

    if(data_valid && data_out==64'hA1B2_C3D4_E5F6_7890) begin
			$display("-----------------------------");
   //     $display("");
        $display("ram_chip TEST PASSED!");
   //     $display("");
        $display("-----------------------------");
	 end
    else
        $display("ram_chip Test Failed: %h", data_out);

    $finish;
end

endmodule

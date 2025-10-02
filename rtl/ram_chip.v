`define RAM_WIDTH 64
`define ADDR_SIZE 12

module ram_chip (
    input  clk,
    input  [`RAM_WIDTH-1:0] data_in,
    input  [`ADDR_SIZE-1:0] rd_address,
    input  [`ADDR_SIZE-1:0] wr_address,
    input  read,
    input  write,
    input  chip_en,               // Chip select
    output tri [`RAM_WIDTH-1:0] data_out,
    output data_valid
);

    // Instantiate ram_4k directly (non-parameterized)
    ram_4k u_ram4k (
        .clk(clk),
        .data_in(data_in),
        .rd_address(rd_address),
        .wr_address(wr_address),
        .read(read && chip_en),    // Enable read only if chip is selected
        .write(write && chip_en),  // Enable write only if chip is selected
        .data_out(data_out),
        .data_valid(data_valid)
    );

endmodule

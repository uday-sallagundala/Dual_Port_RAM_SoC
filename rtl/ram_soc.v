`define RAM_WIDTH 64
`define ADDR_SIZE 14

module ram_soc (
    input  clk,
    input  [`RAM_WIDTH-1:0] data_in,
    input  [`ADDR_SIZE-1:0] rd_address,
    input  [`ADDR_SIZE-1:0] wr_address,
    input  read,
    input  write,
    output [`RAM_WIDTH-1:0] data_out,
    output data_valid
);

    // Chip select from upper 2 bits of address
    wire [1:0] chip_sel_rd = rd_address[`ADDR_SIZE-1 : `ADDR_SIZE-2];
	wire [1:0] chip_sel_wr = wr_address[`ADDR_SIZE-1 : `ADDR_SIZE-2];


    // Outputs from each chip
    wire [`RAM_WIDTH-1:0] chip_dout0, chip_dout1, chip_dout2, chip_dout3;
    wire chip_valid0, chip_valid1, chip_valid2, chip_valid3;

    // Instantiate 4 fixed ram chips
    ram_chip u_chip0 (
        .clk(clk),
        .data_in(data_in),
        .rd_address(rd_address[`ADDR_SIZE-3 : 0]),
        .wr_address(wr_address[`ADDR_SIZE-3 : 0]),
        .read(read),
        .write(write),
        .chip_en((read && (chip_sel_rd==2'b00)) || (write && (chip_sel_wr==2'b00))),
        .data_out(chip_dout0),
        .data_valid(chip_valid0)
    );

    ram_chip u_chip1 (
        .clk(clk),
        .data_in(data_in),
        .rd_address(rd_address[`ADDR_SIZE-3 : 0]),
        .wr_address(wr_address[`ADDR_SIZE-3 : 0]),
        .read(read),
        .write(write),
        .chip_en((read && (chip_sel_rd==2'b01)) || (write && (chip_sel_wr==2'b01))),
        .data_out(chip_dout1),
        .data_valid(chip_valid1)
    );

    ram_chip u_chip2 (
        .clk(clk),
        .data_in(data_in),
        .rd_address(rd_address[`ADDR_SIZE-3 : 0]),
        .wr_address(wr_address[`ADDR_SIZE-3 : 0]),
        .read(read),
        .write(write),
        .chip_en((read && (chip_sel_rd==2'b10)) || (write && (chip_sel_wr==2'b10))),
        .data_out(chip_dout2),
        .data_valid(chip_valid2)
    );

    ram_chip u_chip3 (
        .clk(clk),
        .data_in(data_in),
        .rd_address(rd_address[`ADDR_SIZE-3 : 0]),
        .wr_address(wr_address[`ADDR_SIZE-3 : 0]),
        .read(read),
        .write(write),
        .chip_en((read && (chip_sel_rd==2'b11)) || (write && (chip_sel_wr==2'b11))),
        .data_out(chip_dout3),
        .data_valid(chip_valid3)
    );

    // Multiplex outputs based on read chip select
    assign data_out   = (chip_sel_rd==2'b00) ? chip_dout0 :
                        (chip_sel_rd==2'b01) ? chip_dout1 :
                        (chip_sel_rd==2'b10) ? chip_dout2 :
                                               chip_dout3;

    assign data_valid = (chip_sel_rd==2'b00) ? chip_valid0 :
                        (chip_sel_rd==2'b01) ? chip_valid1 :
                        (chip_sel_rd==2'b10) ? chip_valid2 :
                                               chip_valid3;

endmodule

`define RAM_WIDTH 64
`define ADDR_SIZE 12

module ram_4k (
    input  clk,                                       // RAM Clock
    input  [`RAM_WIDTH-1:0] data_in,                  // Data Input
    input  [`ADDR_SIZE-1:0] rd_address,               // Read Address
    input  [`ADDR_SIZE-1:0] wr_address,               // Write Address
    input  read,                                      // Read Enable
    input  write,                                     // Write Enable
    output tri [`RAM_WIDTH-1:0] data_out,             // Data Output
    output data_valid                                 // Valid flag
);

    // Decoder outputs
    wire mem_wr0, mem_wr1, mem_wr2, mem_wr3;
    wire mem_rd0, mem_rd1, mem_rd2, mem_rd3;

    // Individual outputs
    wire [`RAM_WIDTH-1:0] dout0, dout1, dout2, dout3;
    wire valid0, valid1, valid2, valid3;

    // Write Address Decoder
    memory_decoder wr_add_dec (
        .mem_in1   (wr_address[`ADDR_SIZE-1]),
        .mem_in0   (wr_address[`ADDR_SIZE-2]),
        .mem_out3  (mem_wr3),
        .mem_out2  (mem_wr2),
        .mem_out1  (mem_wr1),
        .mem_out0  (mem_wr0)
    );

    // Read Address Decoder
    memory_decoder rd_add_dec (
        .mem_in1   (rd_address[`ADDR_SIZE-1]),
        .mem_in0   (rd_address[`ADDR_SIZE-2]),
        .mem_out3  (mem_rd3),
        .mem_out2  (mem_rd2),
        .mem_out1  (mem_rd1),
        .mem_out0  (mem_rd0)
    );

    // Four memory banks (each 1K, fixed params inside module)
    dual_port_memory DM0 (
        .clk(clk), .data_in(data_in),
        .rd_address(rd_address[9:0]), .wr_address(wr_address[9:0]),
        .read(read), .write(write),
        .mem_wr_en(mem_wr0), .mem_rd_en(mem_rd0),
        .data_out(dout0), .data_valid(valid0)
    );

    dual_port_memory DM1 (
        .clk(clk), .data_in(data_in),
        .rd_address(rd_address[9:0]), .wr_address(wr_address[9:0]),
        .read(read), .write(write),
        .mem_wr_en(mem_wr1), .mem_rd_en(mem_rd1),
        .data_out(dout1), .data_valid(valid1)
    );

    dual_port_memory DM2 (
        .clk(clk), .data_in(data_in),
        .rd_address(rd_address[9:0]), .wr_address(wr_address[9:0]),
        .read(read), .write(write),
        .mem_wr_en(mem_wr2), .mem_rd_en(mem_rd2),
        .data_out(dout2), .data_valid(valid2)
    );

    dual_port_memory DM3 (
        .clk(clk), .data_in(data_in),
        .rd_address(rd_address[9:0]), .wr_address(wr_address[9:0]),
        .read(read), .write(write),
        .mem_wr_en(mem_wr3), .mem_rd_en(mem_rd3),
        .data_out(dout3), .data_valid(valid3)
    );

    // Tri-state mux for data_out
    assign data_out = mem_rd0 ? dout0 :
                      mem_rd1 ? dout1 :
                      mem_rd2 ? dout2 :
                      mem_rd3 ? dout3 : {`RAM_WIDTH{1'bz}};

    // Valid mux
    assign data_valid = mem_rd0 ? valid0 :
                        mem_rd1 ? valid1 :
                        mem_rd2 ? valid2 :
                        mem_rd3 ? valid3 : 1'b0;

endmodule

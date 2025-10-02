module dual_port_memory ( clk,
						mem_wr_en,
						mem_rd_en,
						data_in,
						rd_address,
						wr_address,
						read,
						write,
						data_out,
						data_valid) ;

parameter RAM_WIDTH=64,
          RAM_DEPTH=1024,
          ADDR_SIZE=10;


input clk;							// RAM Clock
input [RAM_WIDTH-1 : 0] data_in;	// Data Input
input [ADDR_SIZE-1 : 0] rd_address;	// Read Address
input [ADDR_SIZE-1 : 0] wr_address;	// Write Address
input read;							// Read Control
input write;						// Write Control
input mem_wr_en;                    // To Write into memory selected by the decoder - chip enable
input mem_rd_en; 					// To Read from the memory selected by the decoder - chip enable
output reg [RAM_WIDTH-1 : 0] data_out;	// Data Output
output reg data_valid; 				// high when data is read upon read enb and chip enb

// Internal memory
reg [RAM_WIDTH-1:0] memory [0:RAM_DEPTH-1];

//WRITE
always @ (posedge clk)
begin
	if (mem_wr_en && write)
		memory[wr_address] <= data_in;
end  

//READ
always @ (posedge clk)
begin
	if (mem_rd_en && read)
	begin
        data_out <= memory[rd_address];
		data_valid <= 1'b1;
    end
	
	else
    begin
		data_valid <=1'b0;
	end
end
endmodule

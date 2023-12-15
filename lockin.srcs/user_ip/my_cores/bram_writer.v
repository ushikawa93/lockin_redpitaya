
module bram_writer
#(
  parameter integer DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH = 16,
  parameter integer MEMORY_SIZE = 65536
  )
(
	input wire						  clk,
	input wire						  reset_n,
	input wire                        enable,
	
	input wire                        user_reset,
	input wire	[DATA_WIDTH-1:0] 	  data,
	input wire 						  data_valid,
	output wire 					  finished,
	
	// BRAM
	output wire                       bram_clk,
	output wire                       bram_rst,
	output wire [ADDR_WIDTH-1:0]      bram_addr,
	output wire [DATA_WIDTH-1:0]      bram_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_rddata,
	output wire                       bram_we


);

reg [ADDR_WIDTH-1:0] address, address_prev;
reg data_valid_reg;
reg [DATA_WIDTH-1:0] data_reg,data_reg_prev;
reg write_enable;

assign bram_clk = clk;
assign bram_rst = ~reset_n;
assign bram_wrdata = data_reg_prev;
assign bram_addr = address_prev;
assign bram_we = write_enable;

assign finished = (address == MEMORY_SIZE-1)? 1:0;

// Registro las entradas streaming
always @ (posedge clk)
begin
	if(~reset_n || user_reset)
	begin
		data_reg <= 0;
		data_valid_reg <= 0;
	end
	else
	begin
		data_reg <= data;
		data_valid_reg <= data_valid;
	end
end


// Registro las entradas streaming
always @ (posedge clk)
begin
	if(~reset_n || user_reset )
	begin
		 address <= 0;
		 address_prev <= 0;
		 write_enable <= 0;
	end
	else if (enable)
	begin
		if(data_valid_reg)
		begin
		    data_reg_prev <= data_reg;
			write_enable <= 1;
			address_prev <= address;
			address <= (address == MEMORY_SIZE-1)? address: address+1;	// Empiezo a escribir desde el 1...
		end
		else
			write_enable <= 0;
	end
end

endmodule

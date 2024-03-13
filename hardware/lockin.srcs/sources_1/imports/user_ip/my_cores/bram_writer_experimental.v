
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
	
	// BRAM A
	output wire                       bram_A_clk,
	output wire                       bram_A_rst,
	output wire [ADDR_WIDTH-1:0]      bram_A_addr,
	output wire [DATA_WIDTH-1:0]      bram_A_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_A_rddata,
	output wire                       bram_A_we,
	
	// BRAM B
	output wire                       bram_B_clk,
	output wire                       bram_B_rst,
	output wire [ADDR_WIDTH-1:0]      bram_B_addr,
	output wire [DATA_WIDTH-1:0]      bram_B_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_B_rddata,
	output wire                       bram_B_we,	
	
	output wire                       readable_bram   // 0 para bram A o 1 para bram B


);

reg [ADDR_WIDTH-1:0] address, address_prev;
reg data_valid_reg;
reg [DATA_WIDTH-1:0] data_reg,data_reg_prev;
reg write_enable;

wire writing_in_ram_A;

assign bram_A_clk = clk;
assign bram_A_rst = ~reset_n;
assign bram_A_wrdata = (writing_in_ram_A == 0) ? data_reg_prev : 0;
assign bram_A_addr = (writing_in_ram_A == 0) ? address_prev: 0;
assign bram_A_we = (writing_in_ram_A == 0) ?  write_enable : 0;

assign bram_B_clk = clk;
assign bram_B_rst = ~reset_n;
assign bram_B_wrdata = (writing_in_ram_A == 1) ? data_reg_prev : 0;
assign bram_B_addr = (writing_in_ram_A == 1) ? address_prev- MEMORY_SIZE/2 : 0;
assign bram_B_we = (writing_in_ram_A == 1) ?  write_enable : 0;

assign writing_in_ram_A = (address < MEMORY_SIZE/2) ? 0 : 1;
assign readable_bram = !writing_in_ram_A;

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
			address <= (address == MEMORY_SIZE-1)? 0: address+1;	// Empiezo a escribir desde el 1...
		end
		else
			write_enable <= 0;
	end
end

endmodule

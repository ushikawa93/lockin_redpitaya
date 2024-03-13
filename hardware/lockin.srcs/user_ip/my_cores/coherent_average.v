
module coherent_average
#(
  parameter integer DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH = 16,
  parameter integer M = 125,
  parameter integer N_ca = 16;
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
	
	// BRAM PORT A
	output wire                        bram_porta_clk,
	output wire                        bram_porta_rst,
	output wire [ADDR_WIDTH-1:0]  	   bram_porta_addr,
	output wire [ADDR_WIDTH-1:0]       bram_porta_wrdata,
	input  wire [ADDR_WIDTH-1:0]  	   bram_porta_rddata,
	output wire                        bram_porta_we,
	output wire                        bram_porta_ena,
	  
	// BRAM PORT B
	output wire                        bram_portb_clk,
	output wire                        bram_portb_rst,
	output wire [ADDR_WIDTH-1:0]  	   bram_portb_addr,
	output wire [ADDR_WIDTH-1:0]  	   bram_portb_wrdata,
	input  wire [ADDR_WIDTH-1:0]  	   bram_portb_rddata,
	output wire                        bram_portb_we,
	output wire                        bram_portb_ena


);

// Uso el puerto A de la ram para escribir y el B para leer

reg [DATA_WIDTH-1:0] data_reg,data_reg_1;

reg [DATA_WIDTH-1:0] data_vieja;

reg [DATA_WIDTH-1:0] suma;

reg [DATA_WIDTH-1:0] data_to_write;

reg [ADDR_WIDTH-1:0] address_read,address_write;

reg [31:0] wr_enable,wr_enable_1,wr_enable_2,wr_enable_3;

reg [31:0] index,index_1,index_2;

reg [31:0] averaged_cycles;


// Asignaciones a las RAM
assign bram_porta_clk = clk;
assign bram_porta_rst = ~reset_n;

assign bram_porta_wrdata = data_to_write ;
assign bram_porta_addr = address_write ;
assign bram_porta_we = wr_enable_3 ;
assign bram_portb_ena = wr_enable_3;


assign bram_portb_clk = clk;
assign bram_portb_rst = ~reset_n;


assign bram_portb_wrdata =  0;
assign bram_portb_addr = address_read ;
assign bram_portb_we = 0 ;
assign bram_portb_ena = 1;


assign finished = (averaged_cycles == N_ca) ? 1 : 0;

// Registro las entradas streaming
always @ (posedge clk)
begin
	if(~reset_n || user_reset)
	begin
		data_reg <= 0;
		data_reg_1 <= 0;
		data_vieja <= 0;
		suma <= 0;
		address_read <= 0;
		address_write <= 0;
		data_to_write <= 0;
		wr_enable <= 0;
		wr_enable_1 <= 0;
		wr_enable_2 <= 0;
		wr_enable_3 <= 0;
		index <= 0;
		index_1 <= 0;
		index_2 <= 0;
		averaged_cycles <= 0;		
	end
	else
	begin
	
		if(data_valid)
		begin
		
			// FETCH
			data_reg <= data;
			address_read <= index;
			index <= (index+1) % M;
			wr_enable <= 1;
			
			data_reg_1 <= data_reg;
			data_vieja <= bram_portb_rddata;
			index_1 <= index;
			wr_enable_1 <= wr_enable;
			
			// ADD
			suma <= data_reg_1 + data_vieja;
			index_2 <= index_1;
			wr_enable_2 <= wr_enable_1;
			
			// SAVE
			wr_enable_3 <= wr_enable_2;
			address_write <= index_2;
			data_to_write <= suma;
			
			averaged_cycles <= (index_2 == M-1) ? averaged_cycles+1: averaged_cycles;
		
		end
		else
		begin
			wr_enable <= 0;
			wr_enable_1 <= wr_enable;
			wr_enable_2 <= wr_enable_1;
			wr_enable_3 <= wr_enable_2;
		end
		
		
	end
end



endmodule

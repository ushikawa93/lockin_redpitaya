///// ================================================================================= /////  
///// ========================== Módulo BRAM_WRITER =============================== /////  
///// ================================================================================= /////  
//  
// Este módulo escribe datos en una memoria BRAM a partir de una interfaz de entrada streaming.  
// Permite controlar la escritura mediante señales de habilitación y reset de usuario.
//
// Funcionamiento:  
//   - Registra las entradas `data` y `data_valid` para sincronización y timing seguro.  
//   - Mantiene un contador de dirección que avanza cada vez que `data_valid` está activo.  
//   - Genera las señales de escritura (`bram_porta_we`), dirección (`bram_porta_addr`) y datos (`bram_porta_wrdata`)  
//     para la BRAM.  
//   - Señal `finished` indica cuando se ha llegado al final de la memoria definida por `MEMORY_SIZE`.  
//
// Parámetros:  
//   DATA_WIDTH  : Ancho de los datos a escribir (por defecto 32 bits).  
//   ADDR_WIDTH  : Ancho de las direcciones de la BRAM (por defecto 16 bits).  
//   MEMORY_SIZE : Tamaño total de la memoria (por defecto 65536 palabras).  
//
// Puertos:  
//   Entradas:  
//     clk        : Reloj principal.  
//     reset_n    : Reset asincrónico, activo en bajo.  
//     enable     : Habilita el módulo para escribir datos.  
//     user_reset : Reset de usuario para reiniciar la escritura.  
//     data       : Datos de entrada a escribir en BRAM.  
//     data_valid : Indica que `data` es válido.  
//
//   Salidas:  
//     finished      : Señal que indica que se alcanzó el final de la memoria.  
//     bram_porta_clk : Reloj para la BRAM.  
//     bram_porta_rst : Reset para la BRAM (activo alto).  
//     bram_porta_addr: Dirección de la BRAM a escribir.  
//     bram_porta_wrdata: Datos a escribir en la BRAM.  
//     bram_porta_we  : Señal de habilitación de escritura en la BRAM.  
//
// Notas:  
//   - Las entradas streaming se registran para mejorar timing y estabilidad.  
//   - La escritura avanza solo cuando `data_valid` está activo y `enable` está habilitado.  
//   - El módulo es fácilmente parametrizable para distintos tamaños de memoria y anchos de datos.  
//  
///// ================================================================================= /////  

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
	output wire                       bram_porta_clk,
	output wire                       bram_porta_rst,
	output wire [ADDR_WIDTH-1:0]      bram_porta_addr,
	output wire [DATA_WIDTH-1:0]      bram_porta_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_porta_rddata,
	output wire                       bram_porta_we


);

reg [ADDR_WIDTH-1:0] address, address_prev;
reg data_valid_reg;
reg [DATA_WIDTH-1:0] data_reg,data_reg_prev;
reg write_enable;

assign bram_porta_clk = clk;
assign bram_porta_rst = ~reset_n;
assign bram_porta_wrdata = data_reg_prev;
assign bram_porta_addr = address_prev;
assign bram_porta_we = write_enable;

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

///// ================================================================================= /////  
///// ========================= Módulo DATA_STREAM ============================== /////  
///// ================================================================================= /////  
//  
// Este módulo genera un flujo de datos secuenciales desde 0 hasta M-1 de manera cíclica.  
// Se utiliza principalmente como fuente de prueba o como contador de referencia para sistemas  
// de adquisición y procesamiento de señales.  
//
// Funcionamiento:  
//   - Produce un dato por ciclo de reloj mientras `enable` esté activo.  
//   - Al llegar al valor máximo `M-1`, el contador vuelve a 0 y continúa el ciclo.  
//   - La salida `data_out_valid` indica cuándo el dato generado es válido.  
//
// Parámetros:  
//   DATA_WIDTH : Ancho de los datos de salida.  
//   M_WIDTH    : Ancho del registro que almacena el valor máximo `M`.  
//   M          : Valor máximo por defecto para el conteo (puede actualizarse vía `M_in`).  
//
// Entradas:  
//   clk       : Señal de reloj principal.  
//   reset_n   : Reset asincrónico activo en bajo.  
//   enable    : Habilita la generación de datos.  
//   M_in      : Valor máximo dinámico del contador.  
//   user_reset: Reset sincrónico del usuario.  
//
// Salidas:  
//   data_out       : Valor secuencial generado.  
//   data_out_valid : Señal que indica que `data_out` es válida.  
//
// Notas:  
//   - Permite ajustar dinámicamente el límite superior del conteo mediante `M_in`.  
//   - Opera de manera cíclica, ideal para testeo de sistemas de adquisición de datos.  
///// ================================================================================= /////  

module data_stream
#(
	parameter integer DATA_WIDTH = 32,
	parameter integer M_WIDTH = 16,
	parameter integer M = 125
)

(

	input 					clk,
	input 					reset_n,
	input 					enable,
	input [M_WIDTH-1:0]     M_in,
	
	input                   user_reset,
	
	output [DATA_WIDTH-1:0] data_out,
	output 					data_out_valid


);

reg data_out_valid_reg;
reg [DATA_WIDTH-1:0] value,next_value;

reg [M_WIDTH-1:0] M_reg;
    always @ (posedge clk)  M_reg <= M_in;

assign data_out_valid = data_out_valid_reg;
assign data_out = value;


always @ (posedge clk)
begin

	if(~reset_n || user_reset)
	begin
		data_out_valid_reg <= 0;
		next_value <= 0;		
	end
	else
	begin
		if(enable)
		begin
		    value <= next_value;
			next_value <= (next_value == M_reg-1)? 0 : (next_value +1); 
			data_out_valid_reg <= 1;
		end
		else
			data_out_valid_reg <= 0;
	end
end




endmodule

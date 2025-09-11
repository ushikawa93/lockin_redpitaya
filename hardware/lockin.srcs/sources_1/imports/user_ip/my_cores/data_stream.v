//////////////////////////////////////////////////////////////////////////////////
// ============================ data_stream =================================== //
// ============================================================================ // 
// Genera un flujo de datos incremental de ancho parametrizable
//
// Entradas:
// - clk : reloj del sistema
// - reset_n : reset activo en bajo
// - enable : habilita la generación de datos
// - start_value : valor inicial de la secuencia
// - user_reset : reinicio controlado por el usuario
//
// Salidas:
// - data_out : dato de salida
// - data_out_valid : indica cuando data_out es válido
//
// Funcionamiento:
// - Al activarse 'enable', genera valores incrementales a partir de 'start_value'
// - Cada ciclo de reloj incrementa el valor en 1
// - 'data_out_valid' se mantiene en 1 mientras se generan datos
// - Permite reiniciar la secuencia mediante 'reset_n' o 'user_reset'
//
// Autor: MatiOliva
// Fecha: 2025-09-09


module data_stream
#(
	parameter integer DATA_WIDTH = 32
)

(

	input 					clk,
	input 					reset_n,
	input 					enable,
	
	input [DATA_WIDTH-1:0]  start_value,
	input                   user_reset,
	
	output [DATA_WIDTH-1:0] data_out,
	output 					data_out_valid


);

reg data_out_valid_reg;
reg [DATA_WIDTH-1:0] value,next_value;

assign data_out_valid = data_out_valid_reg;
assign data_out = value;


always @ (posedge clk)
begin

	if(~reset_n || user_reset)
	begin
		data_out_valid_reg <= 0;
		next_value <= start_value;		
	end
	else
	begin
		if(enable)
		begin
		    value <= next_value;
			next_value <= next_value +1; 
			data_out_valid_reg <= 1;
		end
		else
			data_out_valid_reg <= 0;
	end
end




endmodule

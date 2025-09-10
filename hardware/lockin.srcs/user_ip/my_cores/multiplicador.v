//////////////////////////////////////////////////////////////////////////////////////
// Módulo: multiplicador
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo implementa un multiplicador digital de 32 bits con interfaz 
//   Avalon streaming. Multiplica las señales de entrada 'data_a' y 'data_b' 
//   cuando 'data_valid' está activo y produce un resultado de 64 bits.
//
// Entradas:
//   clock             -> Señal de reloj principal.
//   reset_n           -> Reset activo bajo.
//   enable            -> Habilita la operación del multiplicador.
//   data_a            -> Primer operando de 32 bits (signed).
//   data_b            -> Segundo operando de 32 bits (signed).
//   data_valid        -> Indica que los datos de entrada son válidos.
//
// Salidas:
//   data_out               -> Resultado de la multiplicación (64 bits signed).
//   data_valid_multiplicacion -> Señal que indica que la salida es válida.
//
// Notas:
//   - Las entradas se registran para mejorar la sincronización y estabilidad de la operación.
//   - Compatible con streaming de datos en FPGA.
//   - Modular y fácil de integrar en sistemas más complejos, como lock-ins segmentados.
//
// Autor: Matías Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////


module multiplicador(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Entrada avalon streaming
	input signed [31:0] data_a,
	input signed [31:0] data_b,
	input data_valid,	
		
	// Salidas avalon streaming 
	output reg signed [63:0] data_out,
	output data_valid_multiplicacion	

);


// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [31:0] data_a_reg; always @ (posedge clock) data_a_reg <= (!reset_n)? 0: data_a;
reg signed [31:0] data_b_reg; always @ (posedge clock) data_b_reg <= (!reset_n)? 0: data_b;
reg data_valid_reg; always @ (posedge clock) data_valid_reg <= (!reset_n)? 0: data_valid;


reg signed [63:0] producto;
reg data_valid_1,data_valid_2,data_out_valid;

//=======================================================
// Algoritmo principal
//=======================================================

always @ (posedge clock or negedge reset_n)
begin
	
	if(!reset_n)
	begin		

		data_out_valid <= 0;
		
	end
	else if(enable)
	begin
		if(data_valid_reg)
		begin				
			data_out <= data_a_reg * data_b_reg;
			data_out_valid <= 1;
			
		end
		else
			data_out_valid <= 0;
		
	end
end

assign data_valid_multiplicacion = data_out_valid;




endmodule

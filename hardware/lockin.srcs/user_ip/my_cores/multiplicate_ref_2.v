//////////////////////////////////////////////////////////////////////////////////////
// Módulo: multiplicate_ref_2
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo implementa la multiplicación de una señal de entrada con 
//   referencias seno y coseno generadas por el módulo 'referencias'. 
//   Produce las componentes en fase y cuadratura de 64 bits para su uso 
//   en un lock-in digital.
//
// Entradas:
//   clock                   -> Señal de reloj principal.
//   reset_n                 -> Reset activo bajo.
//   enable                  -> Habilita la operación del módulo.
//   ptos_x_ciclo [15:0]     -> Número de puntos por ciclo de la referencia.
//   data [31:0]             -> Señal de entrada a multiplicar (signed).
//   data_valid              -> Indica que la señal de entrada es válida.
//
// Salidas:
//   data_out_seno [63:0]         -> Producto de la señal de entrada con la referencia seno.
//   data_out_coseno [63:0]       -> Producto de la señal de entrada con la referencia coseno.
//   data_valid_multiplicacion     -> Señal que indica que ambos productos son válidos.
//
// Notas:
//   - Usa dos instancias del módulo 'multiplicador' para calcular fase y cuadratura.
//   - Compatible con interfaces Avalon streaming para integración en sistemas FPGA.
//   - La salida 'data_valid_multiplicacion' se activa solo cuando ambos productos son válidos.
//
// Autor: Matías Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////


module multiplicate_ref_2(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	
	// Entrada avalon streaming
	input signed [31:0] data,	
	input data_valid,	
		
	// Salidas avalon streaming 
	output signed [63:0] data_out_seno,
	output signed [63:0] data_out_coseno,
	output data_valid_multiplicacion	

);

referencias ref(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Parametro configurable
	.pts_x_ciclo(ptos_x_ciclo),

	// Entrada de sincronizacion
	.avanzar_en_tabla(data_valid),
	
	.data_out_seno(ref_seno),
	.data_out_cos(ref_cos)
	
);

wire signed [31:0] ref_seno;
wire signed [31:0] ref_cos;

wire data_valid_seno,data_valid_cos;


multiplicador prod_fase(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Entrada avalon streaming
	.data_a(data),
	.data_b(ref_seno),
	.data_valid(data_valid),	
		
	// Salidas avalon streaming 
	.data_out(data_out_seno),
	.data_valid_multiplicacion(data_valid_seno)	

);


multiplicador prod_cuadratura(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Entrada avalon streaming
	.data_a(data),
	.data_b(ref_cos),
	.data_valid(data_valid),	
		
	// Salidas avalon streaming 
	.data_out(data_out_coseno),
	.data_valid_multiplicacion(data_valid_cos)	


);


assign data_valid_multiplicacion = data_valid_seno && data_valid_cos;


endmodule


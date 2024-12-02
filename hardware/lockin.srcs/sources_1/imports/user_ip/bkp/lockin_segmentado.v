
module lockin_segmentado(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [31:0] ptos_x_ciclo,
	input [31:0] frames_integracion,
	
	// Entrada avalon streaming
	input data_valid,
	input [31:0] data,	
	
	input start_signal,
	
	input [31:0] referencia_externa_sen,
	input [31:0] referencia_externa_cos,
	input referencia_externa_valid,
		
	// Salidas avalon streaming fase y cuadratura
	output [63:0] data_out_fase,
	output data_out_fase_valid,
	
	output [63:0] data_out_cuad,
	output data_out_cuad_valid,
	
	// Salidas auxiliares
	output reg lockin_ready,	
	output calculo_finalizado,
	output [31:0] datos_promediados
	
);


//=======================================================
// Multiplicacion por referencia
//=======================================================


wire [63:0] data_out_seno;			
wire [63:0] data_out_coseno;
wire data_valid_multiplicacion;

multiplicate_ref_2 multiplicador(

	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	.ptos_x_ciclo(ptos_x_ciclo),
	
	.data(data),
	.data_valid(data_valid),
	
	.referencia_externa_sen(referencia_externa_sen),
	.referencia_externa_cos(referencia_externa_cos),
	.referencia_externa_valid(referencia_externa_valid),		
		
	.data_out_seno(data_out_seno),
	.data_out_coseno(data_out_coseno),
	.data_valid_multiplicacion(data_valid_multiplicacion)

);



//=======================================================
// Filtros pasabajos
//=======================================================

wire calculo_finalizado_fase,calculo_finalizado_cuad,lockin_cuadratura_ready,lockin_fase_ready;


filtro_ma filtro_fase(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Parametros configurables (Para IIR no tienen funcionalidad)
	.ptos_x_ciclo(ptos_x_ciclo),
	.frames_integracion(frames_integracion),
	
	// Interfaz avalon streaming de entrada
	.data_valid(data_valid_multiplicacion),
	.data(data_out_seno),	
	
	.start_signal(start_signal),
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_fase),
	.data_out_valid(data_out_fase_valid),		
	
	// Salidas auxiliares
	.ready_to_calculate(lockin_fase_ready),
	.calculo_finalizado(calculo_finalizado_fase)

);


filtro_ma filtro_cuadratura(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Parametros configurables (Para IIR no tienen funcionalidad)
	.ptos_x_ciclo(ptos_x_ciclo),
	.frames_integracion(frames_integracion),
	
	// Interfaz avalon streaming de entrada
	.data_valid(data_valid_multiplicacion),
	.data(data_out_coseno),	
	
	.start_signal(start_signal),
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_cuad),
	.data_out_valid(data_out_cuad_valid),
	
	// Salidas auxiliares
	.ready_to_calculate(lockin_cuadratura_ready),
	.calculo_finalizado(calculo_finalizado_cuad),
	.datos_promediados(datos_promediados)

);

assign calculo_finalizado = (calculo_finalizado_fase && calculo_finalizado_cuad);

always @ (posedge clock) lockin_ready <= (lockin_fase_ready && lockin_cuadratura_ready);



endmodule


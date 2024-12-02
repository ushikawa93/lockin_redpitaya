
module lockin_segmentado(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	input [15:0] frames_integracion,
	
	// Referencia externa
	input referencia_externa,
	input sync,
	input signed [31:0] referencia_externa_sen,
	input signed [31:0] referencia_externa_cos,
	input referencia_externa_valid,
	
	// Entrada avalon streaming
	input data_valid,
	input signed [31:0] data,	
		
	// Salidas avalon streaming fase y cuadratura
	output signed [63:0] data_out_fase,
	output data_out_fase_valid,
	
	output signed [63:0] data_out_cuad,
	output data_out_cuad_valid,
	
	// Salidas auxiliares
	output reg lockin_ready,
	output [31:0] n_datos_promediados,	
	output reg fifos_llenos
	
);


//=======================================================
// Multiplicacion por referencia
//=======================================================


wire signed [63:0] data_out_seno;			
wire signed [63:0] data_out_coseno;
wire data_valid_multiplicacion;

multiplicate_ref_2 multiplicador(

	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	.ptos_x_ciclo(ptos_x_ciclo),
	
	// Referencia externa
	.referencia_externa(referencia_externa),
	.sync(sync),
	.referencia_externa_sen(referencia_externa_sen),
	.referencia_externa_cos(referencia_externa_cos),
	.referencia_externa_valid(referencia_externa_valid),
	
	
	.data(data),
	.data_valid(data_valid),		
		
	.data_out_seno(data_out_seno),
	.data_out_coseno(data_out_coseno),
	.data_valid_multiplicacion(data_valid_multiplicacion)
);

reg sync_reg;

always @ (posedge clock) sync_reg <= sync;

//=======================================================
// Filtros pasabajos
//=======================================================

filtro_ma_con_sync filtro_fase(

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
	
	.start_signal(sync_reg),
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_fase),
	.data_out_valid(data_out_fase_valid),		
	
	// Salidas auxiliares
	.ready_to_calculate(lockin_fase_ready),
	.calculo_finalizado(fifo_lleno_fase),
	
	.datos_promediados(n_datos_promediados)

);


filtro_ma_con_sync filtro_cuadratura(

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
	
	.start_signal(sync_reg),
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_cuad),
	.data_out_valid(data_out_cuad_valid),
	
	// Salidas auxiliares
	.ready_to_calculate(lockin_cuadratura_ready),
	.calculo_finalizado(fifo_lleno_cuad)

);


wire fifo_lleno_fase,fifo_lleno_cuad,lockin_cuadratura_ready,lockin_fase_ready;

always @ (posedge clock) fifos_llenos <= (fifo_lleno_fase && fifo_lleno_cuad);
always @ (posedge clock) lockin_ready <= (lockin_fase_ready && lockin_cuadratura_ready);




endmodule



module lockin_segmentado(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	input [15:0] frames_integracion,
	
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
	output reg fifos_llenos
	
);


//=======================================================
// Multiplicacion por referencia
//=======================================================

multiplicate_ref_2 multiplicador(

	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	.ptos_x_ciclo(ptos_x_ciclo),
	
	.data(data),
	.data_valid(data_valid),		
		
	.data_out_seno(data_out_seno),
	.data_out_coseno(data_out_coseno),
	.data_valid_multiplicacion(data_valid_multiplicacion)

);


wire signed [63:0] data_out_seno;			
wire signed [63:0] data_out_coseno;
wire data_valid_multiplicacion;


//=======================================================
// Filtros pasabajos
//=======================================================

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
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_fase),
	.data_out_valid(data_out_fase_valid),		
	
	// Salidas auxiliares
	.ready_to_calculate(lockin_fase_ready),
	.calculo_finalizado(fifo_lleno_fase)

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


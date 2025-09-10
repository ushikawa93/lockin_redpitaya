//////////////////////////////////////////////////////////////////////////////////////
// Módulo: lockin_segmentado
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo implementa un lock-in digital que procesa señales de 
//   entrada y calcula las componentes en fase y en cuadratura usando multiplicación 
//   por referencias seno y coseno seguida de filtros pasabajos (MA).
//
// Entradas:
//   clock             -> Señal de reloj principal.
//   reset_n           -> Reset activo bajo.
//   enable            -> Habilita la operación del lock-in.
//   ptos_x_ciclo      -> Número de puntos por ciclo de la señal de referencia.
//   frames_integracion-> Número de frames de integración para el promedio.
//   data_valid        -> Señal que indica que la entrada 'data' es válida.
//   data              -> Señal de entrada a ser procesada.
//
// Salidas:
//   data_out_fase        -> Componente en fase (promediada).
//   data_out_fase_valid  -> Validez de la salida en fase.
//   data_out_cuad        -> Componente en cuadratura (promediada).
//   data_out_cuad_valid  -> Validez de la salida en cuadratura.
//   lockin_ready         -> Indica que ambos canales (fase y cuadratura) están listos.
//   fifos_llenos         -> Indica que los buffers de salida de ambos filtros están llenos.
//
// Estructura interna:
//   - Multiplicador por referencia: Calcula las señales multiplicadas por seno y coseno.
//   - Filtros pasabajos (filtro_ma) para cada componente: Promedian los resultados de la multiplicación.
//   - Señales auxiliares para indicar finalización de cálculo y llenado de FIFOs.
//
// Notas:
//   - Diseñado para procesamiento de señales digitales en FPGA.
//   - Compatible con interfaz Avalon streaming.
//   - Modular y escalable para distintos números de puntos por ciclo y frames de integración.
//
// Autor: Matpuas Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////

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


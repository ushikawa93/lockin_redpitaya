///// ================================================================================= /////  
///// ======================= Módulo LOCKIN_SEGMENTADO ============================ /////  
///// ================================================================================= /////  
//  
// Este módulo implementa un lock-in digital para extraer la fase y cuadratura  
// de una señal de entrada en streaming.  
// Permite trabajar con referencia interna o externa y realiza la multiplicación por la  
// referencia seguida de un filtrado de media móvil sincronizado.
//
// Funcionamiento:  
//   - Multiplica la señal de entrada por la referencia externa (seno y coseno) mediante 
//     el módulo `multiplicate_ref_2`.  
//   - Aplica filtros de media móvil sincronizados (`filtro_ma_con_sync`) a las señales  
//     de fase y cuadratura.  
//   - Genera salidas de fase y cuadratura acumuladas y sus señales de validación.  
//   - Señales auxiliares indican cuándo los FIFOs están llenos y cuándo el lock-in está listo.
//
// Parámetros de configuración:  
//   ptos_x_ciclo        : Número de puntos por ciclo de señal (M).  
//   frames_integracion  : Número de frames a integrar (N).  
//
// Puertos:  
//   Entradas:  
//     clock                       : Reloj principal.  
//     reset_n                     : Reset asincrónico, activo en bajo.  
//     enable                      : Habilita el procesamiento de datos.  
//     referencia_externa           : Indica si se usa referencia externa.  
//     sync                        : Señal de sincronización externa.  
//     referencia_externa_sen      : Componente seno de la referencia externa.  
//     referencia_externa_cos      : Componente coseno de la referencia externa.  
//     referencia_externa_valid    : Indica cuándo la referencia externa es válida.  
//     data_valid                  : Indica cuándo los datos de entrada son válidos.  
//     data                        : Datos de entrada de 32 bits, en complemento a dos.  
//
//   Salidas:  
//     data_out_fase               : Resultado filtrado de la fase (64 bits).  
//     data_out_fase_valid         : Indica que `data_out_fase` es válido.  
//     data_out_cuad               : Resultado filtrado de la cuadratura (64 bits).  
//     data_out_cuad_valid         : Indica que `data_out_cuad` es válido.  
//     lockin_ready                : Indica que el módulo lock-in completó los cálculos.  
//     fifos_llenos                : Indica que los buffers de fase y cuadratura están llenos.  
//     n_datos_promediados         : Cuenta la cantidad de datos promediados en fase.
//
// Notas:  
//   - Sincroniza el inicio del filtrado con la señal `sync`.  
//   - Se utilizan registros intermedios para mejorar el timing y la estabilidad de las señales.  
//   - Permite integraciones múltiples por frame y genera salidas válidas solo cuando los  
//     datos de fase y cuadratura están listos.  
//  
///// ================================================================================= /////  

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


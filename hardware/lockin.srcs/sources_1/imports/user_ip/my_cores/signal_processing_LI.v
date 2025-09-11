///// ================================================================================= /////  
///// ===================== Módulo SIGNAL_PROCESSING_LI ========================== /////  
///// ================================================================================= /////  
//  
// Este módulo implementa un sistema de procesamiento de señales tipo lock-in digital (LIA).  
// Toma una señal de entrada en streaming y la multiplica por referencias de fase y cuadratura,  
// generando las salidas de fase y cuadratura filtradas.
//
// Funcionamiento:  
//   - Registra parámetros de configuración dinámicamente (`parameter_in_0` y `parameter_in_1`).  
//   - Convierte referencias externas de 16 bits a señales de 32 bits para el lock-in segmentado.  
//   - Instancia el módulo `lockin_segmentado` para realizar multiplicación por referencia,  
//     filtrado de media móvil sincronizado y cálculo de fase y cuadratura.  
//   - Genera las señales de salida válidas (`data_out_fase`, `data_out_cuad`) y auxiliares  
//     (`ready_to_calculate`, `processing_finished`, `datos_promediados`).  
//
// Parámetros de configuración:  
//   parameter_in_0 : Número de puntos por ciclo de la referencia (M).  
//   parameter_in_1 : Número de frames de integración (N) para el filtro MA.  
//
// Puertos:  
//   Entradas:  
//     clk                        : Reloj principal.  
//     reset_n                    : Reset asincrónico, activo en bajo.  
//     enable_gral                : Habilita el procesamiento general.  
//     referencia_externa_seno    : Componente seno de la referencia externa.  
//     referencia_externa_cos     : Componente coseno de la referencia externa.  
//     referencia_externa_valid   : Indica cuándo la referencia externa es válida.  
//     data_in                    : Señal de entrada a procesar.  
//     data_in_valid              : Indica cuándo la señal de entrada es válida.  
//     start_signal               : Señal de sincronización para inicio del lock-in.  
//     parameter_in_0             : Parámetro dinámico: puntos por ciclo.  
//     parameter_in_1             : Parámetro dinámico: frames de integración.  
//
//   Salidas:  
//     data_out_fase             : Salida filtrada de fase (64 bits).  
//     data_out_fase_valid       : Indica que `data_out_fase` es válida.  
//     data_out_cuad             : Salida filtrada de cuadratura (64 bits).  
//     data_out_cuad_valid       : Indica que `data_out_cuad` es válida.  
//     ready_to_calculate        : Señal de disponibilidad del lock-in para cálculo.  
//     processing_finished       : Señal que indica que el procesamiento ha finalizado.  
//     datos_promediados         : Cantidad de datos acumulados y promediados.  
//
// Notas:  
//   - Permite integración de lock-in con referencias externas.  
//   - Todos los parámetros y referencias se registran para mejorar timing y estabilidad.  
//   - Se pueden usar las salidas auxiliares para control de buffers y sincronización con otros módulos.  
//  
///// ================================================================================= /////  

module signal_processing_LI(
	input clk,
	input reset_n,
	input enable_gral,	
	
	input [15:0] referencia_externa_seno,
	input [15:0] referencia_externa_cos,
	input referencia_externa_valid,
	
	input [31:0] data_in,
	input 		 data_in_valid,
	
	input start_signal,
	
	output [63:0] data_out_fase,
	output        data_out_fase_valid,
	
	output [63:0] data_out_cuad,
	output        data_out_cuad_valid,
	
	output ready_to_calculate,
	output processing_finished,
	output [31:0] datos_promediados,
	
	input [31:0] parameter_in_0,
	input [31:0] parameter_in_1


);


////////////////////////////////////////////////////////////////
// ================ Registro parametros en reset ===============
////////////////////////////////////////////////////////////////


// Modificables en tiempo de ejecucion:
reg[31:0] parameter_0_reg,parameter_1_reg;

always @ (posedge clk)
begin
	
	parameter_0_reg <= parameter_in_0;
	parameter_1_reg <= parameter_in_1;		
	
end

//////////////////////////////////////////////////
// ================ Procesamiento ===============
//////////////////////////////////////////////////

wire [31:0] M = parameter_0_reg;
wire [31:0] N_ma = parameter_1_reg;

////////////////////////////////////////////////
// ================== Lock in  ===============
////////////////////////////////////////////////

//////// Referencia externa ///////
wire signed [31:0] ref_sen; assign ref_sen = $signed(referencia_externa_seno);
wire signed [31:0] ref_cos; assign ref_cos = $signed(referencia_externa_cos);
wire ref_valid; assign ref_valid = referencia_externa_valid;

//////// Entradas de LIA ///////
wire data_in_lia_valid;
	assign data_in_lia_valid = data_in_valid;

wire [31:0] data_in_lia; 
	assign data_in_lia = data_in;
	
//////// Salidas de lockin ////////
wire [63:0] data_cuad;
wire data_cuad_valid;
wire [63:0] data_fase;
wire data_fase_valid;

wire lockin_finalizado;
wire lockin_ready;	// El lockin esta listo para calcular

lockin_segmentado lock_in(

	// Entradas de control
	.clock(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(M),
	.frames_integracion(N_ma),
	
	// Referencia externa
	.referencia_externa(1),
	.sync(start_signal),
	.referencia_externa_sen(ref_sen),
	.referencia_externa_cos(ref_cos),
	.referencia_externa_valid(ref_valid),
	
	// Entrada avalon streaming
	.data_valid(data_in_lia_valid),
	.data(data_in_lia),	
		
	// Salidas avalon streaming
	.data_out_fase(data_fase),
	.data_out_fase_valid(data_fase_valid),

	.data_out_cuad(data_cuad),
	.data_out_cuad_valid(data_cuad_valid),
	
	// Salidas auxiliares
	.lockin_ready(lockin_ready),
	.n_datos_promediados(datos_promediados),
	.fifos_llenos(lockin_finalizado)
	
);


//////////////////////////////////////////////////
// ================ Salidas  ===============
//////////////////////////////////////////////////

assign data_out_fase = data_fase;
assign data_out1_valid = data_fase_valid;
	
assign data_out_cuad = data_cuad;
assign data_out2_valid = data_cuad_valid;

assign ready_to_calculate = lockin_ready;
assign processing_finished = lockin_finalizado;


endmodule


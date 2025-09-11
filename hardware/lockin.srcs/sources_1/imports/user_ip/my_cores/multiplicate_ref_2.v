///// ================================================================================= /////  
///// ====================== Módulo MULTIPLICATE_REF_2 ============================= /////  
///// ================================================================================= /////  
//  
// Este módulo multiplica una señal de entrada por una referencia de fase y cuadratura,  
// generando dos productos: uno con la componente seno y otro con la componente coseno.  
// Permite usar una referencia interna o externa.
//
// Funcionamiento:  
//   - Genera referencias internas de seno y coseno mediante el módulo `referencias`.  
//   - Si `referencia_externa` está activa, utiliza los valores externos proporcionados.  
//   - Multiplica la señal de entrada `data` por las referencias de fase y cuadratura  
//     usando dos instancias del módulo `multiplicador`.  
//   - Genera las salidas `data_out_seno` y `data_out_coseno` con sus respectivas señales  
//     de validez sincronizadas.
//
// Parámetros de configuración:  
//   ptos_x_ciclo : Número de puntos por ciclo de la señal de referencia.
//
// Puertos:  
//   Entradas:  
//     clock                     : Reloj principal.  
//     reset_n                   : Reset asincrónico, activo en bajo.  
//     enable                    : Habilita el procesamiento de datos.  
//     referencia_externa        : Indica si se usa referencia externa.  
//     sync                      : Señal de sincronización externa.  
//     referencia_externa_sen    : Componente seno de la referencia externa.  
//     referencia_externa_cos    : Componente coseno de la referencia externa.  
//     referencia_externa_valid  : Indica cuándo la referencia externa es válida.  
//     data                      : Datos de entrada de 32 bits, en complemento a dos.  
//     data_valid                : Indica que `data` es válido.
//
//   Salidas:  
//     data_out_seno             : Producto de la señal de entrada por la referencia de fase.  
//     data_out_coseno           : Producto de la señal de entrada por la referencia de cuadratura.  
//     data_valid_multiplicacion : Indica que ambos productos son válidos.
//
// Notas:  
//   - Sincroniza las salidas usando registros internos de validez.  
//   - Permite integraciones y filtrados posteriores de lock-in segmentado.  
//   - Todas las señales de entrada y referencia se registran para evitar problemas de timing.  
//  
///// ================================================================================= /////  

module multiplicate_ref_2(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	
	// Referencia externa
	input referencia_externa,
	input sync,
	input signed [31:0] referencia_externa_sen,
	input signed [31:0] referencia_externa_cos,
	input referencia_externa_valid,
	
	// Entrada avalon streaming
	input signed [31:0] data,	
	input data_valid,	
		
	// Salidas avalon streaming 
	output signed [63:0] data_out_seno,
	output signed [63:0] data_out_coseno,
	output data_valid_multiplicacion	

);

wire signed [31:0] ref_seno_int;
wire signed [31:0] ref_cos_int;

referencias ref(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Parametro configurable
	.pts_x_ciclo(ptos_x_ciclo),

	// Entrada de sincronizacion
	.avanzar_en_tabla(data_valid),
	
	.data_out_seno(ref_seno_int),
	.data_out_cos(ref_cos_int)
	
);

wire signed [31:0] ref_seno = (referencia_externa)? referencia_externa_sen:ref_seno_int;
wire signed [31:0] ref_cos = (referencia_externa)? referencia_externa_cos:ref_cos_int;


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


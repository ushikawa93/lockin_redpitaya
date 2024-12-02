
module multiplicate_ref_2(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [31:0] ptos_x_ciclo,
	
	// Entrada avalon streaming
	input [31:0] data,	
	input data_valid,	
	
	input [31:0] referencia_externa_sen,
	input [31:0] referencia_externa_cos,
	input referencia_externa_valid,
	

	// Salidas avalon streaming 
	output [63:0] data_out_seno,
	output [63:0] data_out_coseno,
	output data_valid_multiplicacion	

);

parameter referencia_externa = 1;

wire [31:0] ref_seno_int;
wire [31:0] ref_cos_int;

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

wire [31:0] ref_seno;
wire [31:0] ref_cos;

assign ref_seno = (referencia_externa == 1)? referencia_externa_sen : ref_seno_int;
assign ref_cos = (referencia_externa == 1)? referencia_externa_cos : ref_cos_int;

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


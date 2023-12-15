
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
		
	// Salidas avalon streaming 
	output [63:0] data_out_seno,
	output [63:0] data_out_coseno,
	output data_valid_multiplicacion	

);

wire [31:0] ref_seno;
wire [31:0] ref_cos;

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

multiplicador prod_fase(

	// Entradas de control
	.clock(clock),
	.reset_n(reset_n),
	.enable(enable),
	
	// Entrada avalon streaming
	.data_a(ref_seno),
	.data_b(data),
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
	.data_a(ref_cos),
	.data_b(data),
	.data_valid(data_valid),	
		
	// Salidas avalon streaming 
	.data_out(data_out_coseno),
	.data_valid_multiplicacion(data_valid_cos)	


);



assign data_valid_multiplicacion = data_valid_seno && data_valid_cos;

endmodule


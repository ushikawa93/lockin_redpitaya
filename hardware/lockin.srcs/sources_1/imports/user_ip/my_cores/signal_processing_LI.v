
module signal_processing_LI(
	input clk,
	input reset_n,
	input enable_gral,	
	
	input [13:0] referencia_externa_seno,
	input [13:0] referencia_externa_cos,
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
	
	// Entrada avalon streaming
	.data_valid(data_in_lia_valid),
	.data(data_in_lia),	
	
	.start_signal(start_signal),
	
	.referencia_externa_sen(ref_sen),
	.referencia_externa_cos(ref_cos),
	.referencia_externa_valid(ref_valid),
		
	// Salidas avalon streaming
	.data_out_fase(data_fase),
	.data_out_fase_valid(data_fase_valid),

	.data_out_cuad(data_cuad),
	.data_out_cuad_valid(data_cuad_valid),
	
	// Salidas auxiliares
	.lockin_ready(lockin_ready),
	.calculo_finalizado(lockin_finalizado),
	.datos_promediados(datos_promediados)
	
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


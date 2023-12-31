
module signal_processing_LI(
	input clk,
	input reset_n,
	input enable_gral,	
	
	input bypass,
	
	input [31:0] data_in,
	input 		 data_in_valid,
	
	output [31:0] data_out1_high,
	output [31:0] data_out1_low,
	output        data_out1_valid,
	
	output [31:0] data_out2_high,
	output [31:0] data_out2_low,
	output        data_out2_valid,
	
	output ready_to_calculate,
	output processing_finished,
	
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

	if(!reset_n)
	begin
		parameter_0_reg <= parameter_in_0;
		parameter_1_reg <= parameter_in_1;		
	end

end

//////////////////////////////////////////////////
// ================ Procesamiento ===============
//////////////////////////////////////////////////

wire [31:0] M = parameter_0_reg;
wire [31:0] N_ma = parameter_1_reg;


////////////////////////////////////////////////
// ================== Lock in  ===============
////////////////////////////////////////////////

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
		
	// Salidas avalon streaming
	.data_out_fase(data_fase),
	.data_out_fase_valid(data_fase_valid),

	.data_out_cuad(data_cuad),
	.data_out_cuad_valid(data_cuad_valid),
	
	// Salidas auxiliares
	.lockin_ready(lockin_ready),
	.calculo_finalizado(lockin_finalizado)
	
);

//////////////////////////////////////////////////
// ================ Salidas  ===============
//////////////////////////////////////////////////

assign data_out1_high = data_fase[63:32];
assign data_out1_low = data_fase[31:0];
assign data_out1_valid = data_fase_valid;
	
assign data_out2_high = data_cuad[63:32];
assign data_out2_low = data_cuad[31:0];
assign data_out2_valid = data_cuad_valid;
	
wire ready_fase,ready_cuadratura;
wire finished_fase,finished_cuadratura;

assign ready_to_calculate = lockin_ready;
assign processing_finished = lockin_finalizado;


//////////////////////////////////////////////////
// ================ Sin procesamiento ===============
//////////////////////////////////////////////////

// Pongo un buffer en el medio para que los data_out se actualizen cada 1 segundo en vez de todo el tiempo

///////////////////////////////////////////////////
//============= Buffer "enlentecedor" =============
///////////////////////////////////////////////////
/*
reg [31:0] counter;
parameter counter_max = 62500000;
reg signed [63:0] data_out1_reg,data_out2_reg;

always @ (posedge clk)
begin
    if(enable_gral)
    begin
        counter <= (counter == counter_max )? 0 : counter+1;
        data_out1_reg <= (counter == counter_max )? {{32{data_in[31]}}, data_in}: data_out1_reg;
        data_out2_reg <= (counter == counter_max )? {{32{data_in[31]}}, data_in}: data_out2_reg;
    end 
end


wire [63:0] data_in_extendido = {{32{data_in[31]}}, data_in};


assign data_out1_high = data_in_extendido[63:32];
assign data_out1_low = data_in_extendido[31:0];
assign data_out1_valid = data_in_valid;
	
assign data_out2_high = data_in_extendido[63:32];
assign data_out2_low = data_in_extendido[31:0];
assign data_out2_valid = data_in_valid;

assign ready_to_calculate = 1;
assign processing_finished = 1;

*/
endmodule


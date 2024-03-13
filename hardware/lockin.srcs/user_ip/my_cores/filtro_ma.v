
module filtro_ma(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	input [15:0] frames_integracion,
	
	// Entrada avalon streaming 
	input data_valid,
	input signed [63:0] data,	
		
	// Salida avalon streaming
	output signed [63:0] data_out,
	output data_out_valid,

	// Salidas auxiliares
	output ready_to_calculate,
	output calculo_finalizado

);


//=======================================================
// Parametros de configuracion 
//=======================================================


wire [15:0] M;	assign M = ptos_x_ciclo;				// Puntos por ciclo de señal
wire [7:0] N; 	assign N = frames_integracion;		// Frames de integracion // Largo del lockin M*N	

reg [63:0] acumulador;
reg [31:0] index;
reg finish,data_out_reg;

// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [63:0] data_in_reg; always @ (posedge clock) data_in_reg <= (!reset_n)? 0: data;
reg data_valid_reg; always @ (posedge clock) data_valid_reg <= (!reset_n)? 0: data_valid;

reg [31:0] MxN;
	always @ (posedge clock) MxN <= M*N;


always @ (posedge clock or negedge reset_n)
begin

	if(!reset_n)
	begin		
		acumulador <= 0;
		index <= 0;		
		finish <= 0;
		data_out_reg <= 0;
	end	
	
	else if (enable)
	begin
		
		if(data_valid_reg && !finish)
		begin			
			index <= index + 1;
			acumulador <= acumulador + data_in_reg;	
			finish <= (index == MxN-1)? 1 : 0;
			data_out_reg <= 1;
		end
		else if(!data_valid_reg && !finish)
		begin
			data_out_reg <= 0;			
		end
	end		
	
end

// Salidas
assign data_out_valid = data_out_reg;
assign data_out = acumulador;
assign ready_to_calculate = 1;
assign calculo_finalizado = finish;


endmodule





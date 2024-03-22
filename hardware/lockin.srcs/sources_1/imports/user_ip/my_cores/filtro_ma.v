module filtro_ma(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [31:0] ptos_x_ciclo,
	input [31:0] frames_integracion,
	
	// Entrada avalon streaming 
	input data_valid,
	input [63:0] data,	
	
	input start_signal,
		
	// Salida avalon streaming
	output [63:0] data_out,
	output data_out_valid,

	// Salidas auxiliares
	output ready_to_calculate,
	output calculo_finalizado

);


//=======================================================
// Parametros de configuracion 
//=======================================================


wire [31:0] M;	assign M = ptos_x_ciclo;				// Puntos por ciclo de se√±al
wire [31:0] N; 	assign N = frames_integracion;		// Frames de integracion // Largo del lockin M*N	

reg [63:0] acumulador;

reg finish,data_out_valid_reg,start;

// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [63:0] data_in_reg; 
    always @ (posedge clock) data_in_reg <= (!reset_n)? 0: $signed(data);
    
reg data_valid_reg; always @ (posedge clock) data_valid_reg <= (!reset_n)? 0: data_valid;

always @ (posedge clock or negedge reset_n)
begin

	if(!reset_n)
	begin		
		data_out_valid_reg <= 0;
		acumulador <= 0;
	end
	
	else if (enable)
	begin
		
		if(data_valid_reg && !finish && start)
		begin
			acumulador <= acumulador + data_in_reg;
			data_out_valid_reg <= 1;
		end
		else if(!data_valid_reg && !finish)
		begin
			data_out_valid_reg <= 0;			
		end
	end		
	
end

// Este cacho de codigo cuenta cuantas seÒales de start llegan
// Cuando me lleguen N seÒales de start pongo en alto la seÒal de finish
// y ahi la cosa deja de calcular...
reg [31:0] start_count;
parameter ignore_cycles = 1;

always @ (posedge clock or negedge reset_n)
begin

    if(!reset_n)
    begin
        start_count <= 0;
        finish <= 0;
        start <= 0;
    end
    else if(enable)
    begin  
        finish <= (start_count == N+1+ignore_cycles)? 1:0;
        
        if(start_count >= 1+ignore_cycles)
            start <= 1;
        
        if(start_signal && !finish)
            start_count <= start_count + 1;            
    end
end

// Salidas
assign data_out_valid = data_out_valid_reg;
assign data_out = acumulador;
assign ready_to_calculate = 1;
assign calculo_finalizado = finish;


endmodule
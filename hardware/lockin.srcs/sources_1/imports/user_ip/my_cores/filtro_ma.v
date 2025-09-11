///// ================================================================================= /////  
///// ========================== Módulo FILTRO_MA ================================ /////  
///// ================================================================================= /////  
//  
// Este módulo implementa un filtro de media móvil (MA) simple.  
// Está diseñado para promediar datos de entrada en frames de N puntos por ciclo, útil para  
// sistemas tipo lock-in digital o procesamiento de señales en streaming.
//
// Funcionamiento:  
//   - Registra las entradas de datos y señales de control para asegurar sincronización.  
//   - Acumula los datos de entrada durante `frames_integracion` frames, cada uno de  
//     `ptos_x_ciclo` puntos por ciclo.  
//   - La acumulación solo ocurre cuando la señal `start_signal` está activa y `enable` está habilitado.  
//   - Mantiene un contador de frames y genera `calculo_finalizado` al completar la integración.  
//
// Parámetros de configuración:  
//   ptos_x_ciclo        : Número de puntos por ciclo de señal (M).  
//   frames_integracion  : Número de frames a integrar (N).  
//
// Puertos:  
//   Entradas:  
//     clock               : Reloj principal.  
//     reset_n             : Reset asincrónico, activo en bajo.  
//     enable              : Habilita el procesamiento de datos.  
//     data_valid          : Indica cuándo los datos de entrada son válidos.  
//     data                : Datos de entrada de 64 bits.  
//     start_signal        : Señal de inicio que habilita el cálculo.  
//
//   Salidas:  
//     data_out            : Datos acumulados y promediados.  
//     data_out_valid      : Indica que `data_out` es válido.  
//     ready_to_calculate   : Siempre alto; indica que el módulo puede procesar datos.  
//     calculo_finalizado   : Se activa al completar N frames de integración.  
//     datos_promediados    : Cuenta los datos efectivamente acumulados.
//
// Notas:  
//   - Ignora los primeros ciclos de `start_signal` mediante el parámetro interno `ignore_cycles`.  
//   - Todas las señales de entrada son registradas para evitar problemas de timing.  
//   - Es una versión simplificada sin sincronización adicional; útil para promediado de señales.  
//  
///// ================================================================================= /////  


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
	output calculo_finalizado,
	output [31:0] datos_promediados

);


//=======================================================
// Parametros de configuracion 
//=======================================================


wire [31:0] M;	assign M = ptos_x_ciclo;				// Puntos por ciclo de señal
wire [31:0] N; 	assign N = frames_integracion;		// Frames de integracion // Largo del lockin M*N	

reg [63:0] acumulador;

reg [31:0] datos_promediados_reg;

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
		datos_promediados_reg <= 0;
	end
	
	else if (enable)
	begin
		
		if(data_valid_reg && !finish && start)
		begin
			acumulador <= acumulador + data_in_reg;
			data_out_valid_reg <= 1;
			datos_promediados_reg <= datos_promediados_reg + 1;
		end
		else if(!data_valid_reg && !finish)
		begin
			data_out_valid_reg <= 0;			
		end
	end		
	
end

// Este cacho de codigo cuenta cuantas se�ales de start llegan
// Cuando me lleguen N se�ales de start pongo en alto la se�al de finish
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
        
        
        if(start_count >= 1+ignore_cycles)
            start <= 1;
        
        if(start_signal && !finish)
        begin
            start_count <= start_count + 1;            
            finish <= (start_count == N+1+ignore_cycles-1)? 1:0;
        end
    end
end

// Salidas
assign data_out_valid = data_out_valid_reg;
assign data_out = acumulador;
assign ready_to_calculate = 1;
assign calculo_finalizado = finish;
assign datos_promediados = datos_promediados_reg;


endmodule
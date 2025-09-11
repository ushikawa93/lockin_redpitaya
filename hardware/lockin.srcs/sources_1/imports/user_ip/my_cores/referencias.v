///// ================================================================================= /////  
///// ========================== Módulo REFERENCIAS ============================== /////  
///// ================================================================================= /////  
//  
// Este módulo genera referencias de seno y coseno a partir de tablas de búsqueda (LUT)  
// predefinidas. Permite ajustar el número de puntos por ciclo y realizar atenuación de la señal.
//
// Funcionamiento:  
//   - Lee tablas de 2048 posiciones para seno (`x2048_16b.mem`) y coseno (`y2048_16b.mem`).  
//   - Ajusta el intervalo de acceso según `pts_x_ciclo` para generar el número deseado de puntos por ciclo.  
//   - Avanza el índice de la tabla solo cuando `avanzar_en_tabla` está activo.  
//   - Salidas ajustadas en 32 bits, centradas alrededor de cero y con atenuación opcional.  
//
// Parámetros de configuración:  
//   pts_x_ciclo : Número de puntos por ciclo de la referencia.  
//   ref_mean_value : Valor medio de las tablas de referencia (por defecto 32767).  
//   atenuacion : Desplazamiento a la derecha aplicado a la salida (división por 2^atenuacion).  
//
// Puertos:  
//   Entradas:  
//     clock             : Reloj principal.  
//     reset_n           : Reset asincrónico, activo en bajo.  
//     enable            : Habilita el procesamiento de datos.  
//     avanzar_en_tabla   : Señal que indica cuándo avanzar el índice de la tabla.  
//
//   Salidas:  
//     data_out_seno      : Salida del seno de referencia ajustada a 32 bits.  
//     data_out_cos       : Salida del coseno de referencia ajustada a 32 bits.
//
// Notas:  
//   - Permite cambiar dinámicamente el número de puntos por ciclo sin modificar las tablas.  
//   - Todas las salidas se centran en cero y se pueden atenuar según el parámetro `atenuacion`.  
//   - Es útil para módulos de lock-in digital que requieren referencias periódicas.  
//  
///// ================================================================================= /////  

module referencias(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametro configurable
	input [31:0] pts_x_ciclo,

	// Entrada de sincronizacion
	input avanzar_en_tabla,
	
	output [31:0] data_out_seno,
	output [31:0] data_out_cos

);


//=======================================================
// Parametros de configuracion de los módulos
//=======================================================

parameter ref_mean_value = 32767;
parameter atenuacion = 0;

reg [11:0] M; always @ (posedge clock) M = pts_x_ciclo;				// Puntos por ciclo de señal


(* KEEP = "TRUE" *)reg [11:0] interval;
	always @ (posedge clock) interval = 2048/M; // Para poder cambiar el largo de la secuencia sin tener que leer otro archivo
	

//=======================================================
// Reg/Wire declarations
//=======================================================

// Referencias seno y coseno en sendas LU table
reg [15:0]  ref_sen   [0:2047];	initial	$readmemh("x2048_16b.mem",ref_sen);
reg [15:0] 	ref_cos   [0:2047];	initial	$readmemh("y2048_16b.mem",ref_cos);

reg [11:0] index;

reg signed [31:0] data_out_seno_reg;
reg signed [31:0] data_out_cos_reg;

//reg avanzar_en_tabla_reg; always @ (posedge clock) avanzar_en_tabla_reg <= (!reset_n)? 0: avanzar_en_tabla;


//=======================================================
// Algoritmo principal
//=======================================================

always @ (posedge clock or negedge reset_n)
begin
	
	if(!reset_n)
	begin		
		
		index <= 1;	
		data_out_seno_reg <= {16'b0, ref_sen[0]};
		data_out_cos_reg <= {16'b0, ref_cos[0]};

	end
	else if(enable)
	begin
		if(avanzar_en_tabla)
		begin
			
			index <= (index == (M-1))? 0: index+1;					
						
			data_out_seno_reg <= {16'b0,ref_sen[index*interval]};
			data_out_cos_reg <= {16'b0,ref_cos[index*interval]};
				
		end
	end
end

//=======================================================
// Salidas
//=======================================================

assign data_out_seno = (data_out_seno_reg - ref_mean_value) >>> atenuacion;
assign data_out_cos = (data_out_cos_reg - ref_mean_value) >>> atenuacion;



endmodule



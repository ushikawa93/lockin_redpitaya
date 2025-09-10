//////////////////////////////////////////////////////////////////////////////////////
// Módulo: GCL (Generador Congruencial Lineal)
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo implementa un generador congruencial lineal (Linear Congruential 
//   Generator, LCG) para producir números pseudoaleatorios de 32 bits a partir de 
//   una semilla de entrada. La salida se expande a 64 bits para compatibilidad
//   con otros módulos de procesamiento de datos.
//
// Entradas:
//   i_Clk    -> Señal de reloj principal.
//   i_Enable -> Habilita la generación de números pseudoaleatorios.
//   i_seed   -> Semilla inicial de 32 bits para el generador.
//
// Salidas:
//   o_Data       -> Número pseudoaleatorio de 64 bits generado.
//   o_Data_valid -> Señal que indica que 'o_Data' contiene un valor válido.
//
// Parámetros / Variables internas:
//   m           -> Módulo del generador congruencial (2^32).
//   a           -> Multiplicador del generador congruencial (69069).
//   c           -> Incremento del generador congruencial (1).
//   reg_seed    -> Registro que almacena la semilla actual.
//   reg_mult    -> Registro que almacena el producto intermedio a*seed.
//   reg_suma    -> Registro que almacena la suma intermedia (a*seed + c).
//   data_valid_1,2,3 -> Señales internas para pipeline de validez de datos.
//
// Funcionalidad:
//   - Genera números pseudoaleatorios siguiendo la ecuación: X_{n+1} = (a*X_n + c) mod m
//   - Usa un pipeline de 3 etapas para calcular la multiplicación, suma y módulo.
//   - La salida es válida después de tres ciclos de reloj desde la habilitación.
//
// Notas:
//   - Puede integrarse con módulos de generación de ruido o simulación de señales.
//   - Salida y validez son sincronizadas con el reloj.
//   - Preparado para entornos de FPGA con reloj único.
//
// Autor: Matías Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////

module GCL(
	input i_Clk,
	input i_Enable,
	input [31:0] i_seed,
	
	output reg [63:0] o_Data,
	output reg o_Data_valid
	);
	
	reg data_valid_1; initial data_valid_1 = 0;
	reg data_valid_2; initial data_valid_2 = 0;
	reg data_valid_3; initial data_valid_3 = 0;
	
	reg [32:0] reg_seed;
	
	parameter [32:0] m = 2 ** 32;
	parameter [32:0] a = 69069;
	parameter [32:0] c = 1;
	
	
	reg [63:0] reg_mult;
	reg [63:0] reg_suma;
		
   initial o_Data = 0;
   always @ (posedge i_Clk)
   if(i_Enable)
	begin
		
		// Registro entradas 
		reg_seed <= i_seed;
		data_valid_1 <= 1;
		
		// Calculo multiplicacion y pospongo entradas
		reg_mult <= a * reg_seed;
		data_valid_2 <= data_valid_1;
		
		// Calculo suma y pospongo entradas
		reg_suma <= reg_mult + c;
		data_valid_3 <= data_valid_2;
		
		// Calculo Salida
		o_Data <= reg_suma % m;
		o_Data_valid <= data_valid_3;
	end
	else
	begin
		data_valid_1 <= 0;
		data_valid_2 <= 0;
		data_valid_3 <= 0;
		o_Data_valid <= 0;
	end
		
	
	
endmodule
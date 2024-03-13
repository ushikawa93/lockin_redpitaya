
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
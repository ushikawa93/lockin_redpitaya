
module multiplicador(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Entrada avalon streaming
	input signed [31:0] data_a,
	input signed [31:0] data_b,
	input data_valid,	
		
	// Salidas avalon streaming 
	output reg signed [63:0] data_out,
	output data_valid_multiplicacion	

);


// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [31:0] data_a_reg; always @ (posedge clock) data_a_reg <= (!reset_n)? 0: data_a;
reg signed [31:0] data_b_reg; always @ (posedge clock) data_b_reg <= (!reset_n)? 0: data_b;
reg data_valid_reg; always @ (posedge clock) data_valid_reg <= (!reset_n)? 0: data_valid;


reg signed [63:0] producto;
reg data_valid_1,data_valid_2,data_out_valid;

//=======================================================
// Algoritmo principal
//=======================================================

always @ (posedge clock or negedge reset_n)
begin
	
	if(!reset_n)
	begin		

		data_out_valid <= 0;
		
	end
	else if(enable)
	begin
		if(data_valid_reg)
		begin				
			data_out <= data_a_reg * data_b_reg;
			data_out_valid <= 1;
			
		end
		else
			data_out_valid <= 0;
		
	end
end

assign data_valid_multiplicacion = data_out_valid;




endmodule

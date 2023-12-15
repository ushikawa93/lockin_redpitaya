
module promedio_lineal
#(
  parameter integer DATA_IN_WIDTH = 32,
  parameter integer DATA_OUT_WIDTH = 32,
  parameter integer N_AVGD_SAMPLES_WIDTH = 16
  )
(
	input clk,
	input reset_n,
	
	input wire	[DATA_IN_WIDTH-1:0] 	  data,
	input wire 						  data_valid,

	output wire [DATA_OUT_WIDTH-1:0] 	  data_out,
	output wire 					  data_out_valid,
	
	input wire [N_AVGD_SAMPLES_WIDTH-1:0]        N_averaged_samples                 

);

reg [DATA_OUT_WIDTH-1:0] promedio;
reg [31:0] counter;
reg [N_AVGD_SAMPLES_WIDTH-1:0] N;

always @ (posedge clk) N <= N_averaged_samples;


always @ (posedge clk or negedge reset_n)
begin
	
	if(!reset_n)
	begin
		promedio <= 0;
		counter <= 0;
	end
	
	else if (data_valid)
	begin
		if(counter < N)
		begin
			promedio <= promedio + data;
			counter <= counter + 1;
		end 
		else
		begin
			promedio <= data;
			counter <= 1;
		end
	end

end

assign data_out = promedio;
assign data_out_valid = (counter == N);

endmodule

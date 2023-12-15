
module promedio_coherente
#(
  parameter integer DATA_IN_WIDTH = 32,
  parameter integer DATA_OUT_WIDTH = 32,
  parameter integer N_AVGD_CYCLES_WIDTH = 16
  )

(
	input clk,
	input reset_n,
	
	input wire	[DATA_IN_WIDTH-1:0] 	  data,
	input wire 						  data_valid,

	output wire [DATA_OUT_WIDTH-1:0] 	  data_out,
	output wire 					  data_out_valid,
	
	input wire [N_AVGD_CYCLES_WIDTH-1:0]        N_averaged_cycles                

);

// Trabajo en progreso!

endmodule






module promedio_lineal
#(
  parameter integer DATA_IN_WIDTH = 32,
  parameter integer DATA_OUT_WIDTH = 32,
  parameter integer N_AVGD_SAMPLES_WIDTH = 32
  )
(
	input clk,
	input reset_n,
	
	input wire signed	[DATA_IN_WIDTH-1:0] 	  data,
	input wire 						              data_valid,

	output wire signed [DATA_OUT_WIDTH-1:0] 	  data_out,
	output wire 					              data_out_valid,
	
	input wire [N_AVGD_SAMPLES_WIDTH-1:0]         log2_divisor,
	input wire [N_AVGD_SAMPLES_WIDTH-1:0]         N_averaged_samples

);

reg signed [DATA_OUT_WIDTH-1:0] promedio;
reg signed [DATA_OUT_WIDTH-1:0] data_out_reg;
reg [31:0] counter;
reg [N_AVGD_SAMPLES_WIDTH-1:0] N;
reg [31:0] log2_div_reg;

always @ (posedge clk)
begin
    
    if(!reset_n)
    begin
        N <= 0;
        log2_div_reg <= 0;
    end
    else
    begin
       N <= N_averaged_samples;
       log2_div_reg <= log2_divisor;
    end
end


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
		    data_out_reg <= promedio >>> log2_div_reg;  
			promedio <= data;
			counter <= 1;
		end
	end

end

assign data_out = data_out_reg;
assign data_out_valid = (counter == N);

endmodule

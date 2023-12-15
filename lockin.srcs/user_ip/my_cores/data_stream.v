
module data_stream
#(
	parameter integer DATA_WIDTH = 32
)

(

	input 					clk,
	input 					reset_n,
	input 					enable,
	
	input [DATA_WIDTH-1:0]  start_value,
	input                   user_reset,
	
	output [DATA_WIDTH-1:0] data_out,
	output 					data_out_valid


);

reg data_out_valid_reg;
reg [DATA_WIDTH-1:0] value,next_value;

assign data_out_valid = data_out_valid_reg;
assign data_out = value;


always @ (posedge clk)
begin

	if(~reset_n || user_reset)
	begin
		data_out_valid_reg <= 0;
		next_value <= start_value;		
	end
	else
	begin
		if(enable)
		begin
		    value <= next_value;
			next_value <= next_value +1; 
			data_out_valid_reg <= 1;
		end
		else
			data_out_valid_reg <= 0;
	end
end




endmodule

`timescale 1ns / 1ps

module clk_adapter
#(
  parameter integer DATA_IN_WIDTH = 32,
  parameter integer DATA_OUT_WIDTH = 32
  )

(

        input clk_in,
        input clk_out,
        
        input [DATA_IN_WIDTH-1:0] data_in,
        input data_in_valid,
        
        output [DATA_OUT_WIDTH-1:0] data_out,
        output data_out_valid


    );
    
reg [DATA_IN_WIDTH-1:0] data_in_reg,data_out_reg;
reg data_out_valid_reg;
reg data_available;

always @ (negedge clk_in)
begin
    
    if(data_in_valid)
    begin
        data_in_reg <= data_in;
        data_available <= 1;    
    end
    else
        data_available <= 0;    
    
end
    
always @ (posedge clk_out)
begin
    
    if(data_available)
    begin
        data_out_reg <= data_in_reg;
        data_out_valid_reg <= 1;
    end
    else    
        data_out_valid_reg <= 0;

end
    
assign data_out_valid = data_out_valid_reg;
assign data_out = data_out_reg;

endmodule

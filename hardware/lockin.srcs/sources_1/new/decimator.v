`timescale 1ns / 1ps

module decimator(

    input clk,
    input reset_n,
    input enable,

    input [31:0] data_in,
    input data_in_valid,
    
    input [31:0] decimate_value,
    
    output [31:0] data_out,
    output data_out_valid,
    
    output finish


    );

parameter FIFO_DEPTH = 1024;

reg [31:0] counter_data;
reg [31:0] counter;
reg [31:0] data_out_reg;
reg data_out_valid_reg;
reg finish_reg;

always @ (posedge clk or negedge reset_n)
begin

    if(!reset_n)
    begin
        counter <= 0;
        data_out_valid_reg <= 0;
        data_out_reg <= 0;
        counter_data <= 0;
        finish_reg <= 0;
    end
    else if (enable)
        if (data_in_valid)
        begin
            
            counter <= counter +1;
            if(counter == decimate_value-1)
                counter <= 0;
            
            if(counter == 0)
            begin
                data_out_reg <= data_in;
                data_out_valid_reg <= 1;                
                counter_data <= (counter_data == FIFO_DEPTH)? counter_data : counter_data + 1;
            end
            else
                data_out_valid_reg <= 0;
        end
        else
            data_out_valid_reg <= 0;
     else
        data_out_valid_reg <= 0;
        
end

assign data_out = data_out_reg;
assign data_out_valid = data_out_valid_reg;
assign finish = (counter_data == FIFO_DEPTH)? 1 : 0;


endmodule

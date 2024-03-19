`timescale 1ns / 1ps

module start_signal_generator(

    input clk,
    input reset_n,
    
    input [31:0] data,
    input data_valid,
    
    output start

    );

wire [31:0] data_signed;
assign data_signed = $signed(data);


reg signed [31:0] data_reg;
reg out_register;

always @ (posedge clk)
begin
    
    if(!reset_n)    
    begin
        out_register <= 0;
        data_reg <= 0;
    end
    else if(data_valid)
    begin
        data_reg <= data_signed;        
        out_register <= ( (data_signed >=0)  && (data_reg <0) ) ? 1 : 0;        
    end
end

assign start = ( out_register && data_valid ) ;

endmodule

`timescale 1ns / 1ps

module delay_axi_streaming(

    input clk,
    input reset_n,
    input bypass_n,

    input [13:0] data_in,
    input data_in_valid,
    
    output [13:0] data_out,
    output data_out_valid
    
);

parameter delay = 14;

reg [13:0] data_reg [delay-1:0];
reg data_valid_reg [delay-1:0];
integer i;

always @ (posedge clk)
begin
    
    data_reg[0] <= data_in;
    data_valid_reg[0] <= data_in_valid;
    
    for (i = 0; i < delay-1; i = i + 1) begin
        data_reg[i+1] <= data_reg[i];
        data_valid_reg[i+1] <= data_valid_reg[i];    
    end
    
end

assign data_out = (!bypass_n)? data_in : data_reg[delay-1];
assign data_out_valid = (!bypass_n)? data_in_valid : data_valid_reg[delay-1];

endmodule

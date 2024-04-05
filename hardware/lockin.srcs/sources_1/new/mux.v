`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 16:52:16
// Design Name: 
// Module Name: mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux
#(
  parameter integer DATA_IN_WIDTH = 14,
  parameter integer DATA_OUT_WIDTH = 14
  )

(

    input [DATA_IN_WIDTH-1:0] data_in_0,
    input data_in_0_valid,
    input [DATA_IN_WIDTH-1:0] data_in_1,
    input data_in_1_valid,
    input sel,
    input finish_0,
    input finish_1,
    
    output [DATA_OUT_WIDTH-1:0] data_out,
    output data_out_valid,
    output finish
    );
    

assign data_out = (sel == 0)? $signed(data_in_0) : $signed(data_in_1);
assign data_out_valid = (sel == 0)? data_in_0_valid : data_in_1_valid;
assign finish = (sel == 0)? finish_0 : finish_1;

endmodule

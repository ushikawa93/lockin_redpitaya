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


module mux(

    input [13:0] data_in_0,
    input data_in_0_valid,
    input [13:0] data_in_1,
    input data_in_1_valid,
    input sel,
    
    output [31:0] data_out,
    output data_out_valid
    );
    

assign data_out = (sel == 0)? $signed(data_in_0) : $signed(data_in_1);
assign data_out_valid = (sel == 0)? data_in_0_valid : data_in_1_valid;

endmodule

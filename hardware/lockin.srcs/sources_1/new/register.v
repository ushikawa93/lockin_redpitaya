`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2024 16:47:03
// Design Name: 
// Module Name: register
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


module register(

    input d,
    input reset_n,
    input clk,
    
    output q

    );
    

reg q_reg;

always @ (posedge clk or negedge reset_n)
begin

    if(!reset_n)
        q_reg <= 0;
    else
        q_reg <= d;
       
end
assign q = q_reg;


endmodule

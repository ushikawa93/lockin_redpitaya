`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2024 18:32:55
// Design Name: 
// Module Name: calc_sum_limit
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


module mult_32_bits(

    input clk,
    input enable,
    input reset_n,
    
    input [31:0] data_in_a,
    input [15:0] data_in_b,
    
    output [47:0] data_out

    );


// Este modulo calcula data_in_a x data_in_b en forma eficiente..
// El problema es que data_in_a puede ser de 32 bits, y los macros del multiplicador solo trabajan con un maximo de 25 bits 
// Entonces voy a dividir data_in_a en cosas mas chicas para hacer la multiplicacion y despues sumar todo

wire [15:0] A0,A1; // -> A = A0 + A1 << 16
wire [15:0] B = data_in_b;

assign A0 = data_in_a[15:0];
assign A1 = data_in_a[31:16];


reg [31:0] P0,P1; // -> P0 = B*A0 / P1 = B*A1 
reg [47:0] P,aux,data_out_reg; // P = A*B = (A0 + A1 << 16) * B = A0*B + (A1*B) << 16 = P0 + P1 << 16

always @ (posedge clk)
begin

    if(!reset_n)
    begin
        P0 <= 0;
        P1 <= 0;
        P <= 0;
        aux <= 0;
        data_out_reg <= 0;
    end
    else if(enable)  
    begin
    
        P0 <= A0 * B;
        P1 <= A1 * B;    
        aux <= (P1 << 16);
        P <= P0 + aux;
        data_out_reg <= P;
    end
end

assign data_out = data_out_reg;
   
endmodule
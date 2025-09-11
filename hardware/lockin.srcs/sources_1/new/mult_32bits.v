`timescale 1ns / 1ps
///// ================================================================================= /////
///// ============================ Módulo Multiplicador 32x16 ========================= /////
///// ================================================================================= /////
//
// Este módulo implementa una multiplicación eficiente entre:
//   - un operando de 32 bits (data_in_a)
//   - y un operando de 16 bits (data_in_b)
//
// Problema a resolver:
//   - Multiplicar directamente puede tardar mucho tiempo con operandos grandes.
//   - Para solucionarlo, se descompone data_in_a en dos mitades de 16 bits (A0 y A1)
//     y se realiza la operación por partes.
//
// Funcionamiento:
//   - Se divide A en: A = A0 + (A1 << 16).
//   - Se calculan los productos parciales: 
//        P0 = A0 * B
//        P1 = A1 * B
//   - Se compone el resultado: 
//        P = P0 + (P1 << 16)
//   - El resultado final (48 bits) se entrega en data_out.
//
// Puertos:
//   clk       : Reloj del sistema.
//   enable    : Habilita el cálculo en el flanco positivo.
//   reset_n   : Reset activo en bajo.
//   data_in_a : Operando de 32 bits.
//   data_in_b : Operando de 16 bits.
//   data_out  : Resultado de 48 bits de la multiplicación.
//
// Notas:
//   - El cálculo es secuencial, se actualiza en cada ciclo habilitado.
//   - El módulo utiliza registros para mantener los productos parciales.
//   - Útil cuando se requiere multiplicación 32x16 sin un macro dedicado.
//
///// ================================================================================= /////

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
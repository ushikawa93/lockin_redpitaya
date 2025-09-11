`timescale 1ns / 1ps
///// ================================================================================= /////
///// =============================== Módulo REGISTER ================================= /////
///// ================================================================================= /////
//
// Este módulo implementa un registro tipo D con reset asincrónico activo en bajo.
//
// Funcionamiento:
//   - En cada flanco positivo de clk, la salida q toma el valor de la entrada d.
//   - Si reset_n = 0, la salida q se fuerza a 0 independientemente de clk o d.
//   - El valor almacenado se mantiene estable entre flancos de reloj.
//
// Puertos:
//   Entradas:
//     d       : Entrada de datos (1 bit).
//     reset_n : Reset asincrónico, activo en bajo.
//     clk     : Señal de reloj.
//
//   Salidas:
//     q       : Salida registrada (1 bit).
//
// Notas:
//   - El reset tiene prioridad sobre la captura de datos.
//   - Este bloque puede utilizarse como celda básica de almacenamiento en diseños
//     secuenciales más complejos.
//
///// ================================================================================= /////


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

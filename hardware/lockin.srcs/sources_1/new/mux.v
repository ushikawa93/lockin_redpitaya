`timescale 1ns / 1ps
///// ================================================================================= /////
///// =============================== Módulo MUX 2 a 1 ================================ /////
///// ================================================================================= /////
//
// Este módulo implementa un multiplexor 2 a 1 con soporte de señales de validación
// y de finalización. Permite seleccionar entre dos flujos de datos de entrada
// en base a la señal de control "sel".
//
// Funcionamiento:
//   - Si sel = 0 → se enruta data_in_0 hacia la salida.
//   - Si sel = 1 → se enruta data_in_1 hacia la salida.
//   - La validez de la salida (data_out_valid) sigue la validez del dato seleccionado.
//   - La señal finish se propaga desde el flujo de entrada seleccionado.
//
// Parámetros:
//   DATA_IN_WIDTH  : Ancho de los datos de entrada (por defecto 14 bits).
//   DATA_OUT_WIDTH : Ancho de los datos de salida (por defecto 14 bits).
//
// Puertos:
//   Entradas:
//     data_in_0       : Primer dato de entrada.
//     data_in_0_valid : Bandera de validez para data_in_0.
//     data_in_1       : Segundo dato de entrada.
//     data_in_1_valid : Bandera de validez para data_in_1.
//     sel             : Señal de selección (0 → canal 0, 1 → canal 1).
//     finish_0        : Bandera de finalización asociada a data_in_0.
//     finish_1        : Bandera de finalización asociada a data_in_1.
//
//   Salidas:
//     data_out        : Dato de salida, correspondiente a la entrada seleccionada.
//     data_out_valid  : Bandera de validez de la salida.
//     finish          : Bandera de finalización correspondiente a la entrada seleccionada.
//
// Notas:
//   - Es un módulo combinacional, no utiliza registros internos.
//   - Se adapta automáticamente al ancho de datos definido por parámetros.
//
///// ================================================================================= /////


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

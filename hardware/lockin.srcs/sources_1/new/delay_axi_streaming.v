`timescale 1ns / 1ps
///// ================================================================================= /////
///// =========================== Módulo Delay AXI Streaming ========================== /////
///// ================================================================================= /////
//
// Este módulo implementa un retardo configurable para flujos de datos
// en interfaces tipo AXI-Streaming.
//
// Funcionalidad:
//   - Recibe datos de entrada de DATA_WIDTH bits junto con una señal de validez.
//   - Retrasa los datos y la validez un número de ciclos igual a DELAY.
//   - Incluye la opción de bypass (sin retardo) mediante la señal bypass_n.
//
// Parámetros:
//   DATA_WIDTH : Ancho de los datos en bits (por defecto 16).
//   DELAY      : Número de ciclos de retardo (por defecto 14).
//
// Puertos:
//   clk            : Reloj del sistema.
//   reset_n        : Reset activo en bajo.
//   bypass_n       : Control de bypass, cuando está en 0 desactiva el retardo.
//   data_in        : Datos de entrada.
//   data_in_valid  : Señal que indica cuándo data_in es válido.
//   data_out       : Datos de salida (con o sin retardo).
//   data_out_valid : Señal de validez de data_out.
//
// Notas:
//   - El retardo se implementa mediante registros en cadena.
//   - Si bypass_n está en bajo, los datos de salida siguen directamente a data_in.
//   - Compatible con interfaces AXI-Streaming.
//
///// ================================================================================= /////


module delay_axi_streaming #(
    parameter DATA_WIDTH = 16, // Parameter to set the bit-width
    parameter DELAY = 14       // Parameter to set the delay
)(
    input clk,
    input reset_n,
    input bypass_n,

    input [DATA_WIDTH-1:0] data_in,
    input data_in_valid,
    
    output [DATA_WIDTH-1:0] data_out,
    output data_out_valid
);

reg [DATA_WIDTH-1:0] data_reg [DELAY-1:0];
reg data_valid_reg [DELAY-1:0];
integer i;

always @ (posedge clk) begin
    data_reg[0] <= data_in;
    data_valid_reg[0] <= data_in_valid;
    
    for (i = 0; i < DELAY-1; i = i + 1) begin
        data_reg[i+1] <= data_reg[i];
        data_valid_reg[i+1] <= data_valid_reg[i];    
    end
end

assign data_out = (!bypass_n) ? data_in : data_reg[DELAY-1];
assign data_out_valid = (!bypass_n) ? data_in_valid : data_valid_reg[DELAY-1];

endmodule
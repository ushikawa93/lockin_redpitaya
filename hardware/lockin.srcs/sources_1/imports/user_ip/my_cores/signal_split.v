//////////////////////////////////////////////////////////////////////////////////
// Módulo: signal_split
//
// Descripción:
//   Este módulo recibe una señal de entrada y la divide en dos señales de salida.
//   - Ambas señales de salida conservan la validación de la entrada.
//   - Se ajusta el ancho de cada salida según los parámetros definidos.
//
// Parámetros principales:
//   ADC_DATA_WIDTH    : Cantidad de bits de la señal ADC de entrada
//   AXIS_TDATA_WIDTH  : Ancho de los datos AXIS de entrada/salida
//
// Puertos principales:
//   S_AXIS_tdata      : Datos de entrada
//   S_AXIS_tvalid     : Indica que los datos de entrada son válidos
//   M_AXIS_PORT1_tdata: Primera señal de salida
//   M_AXIS_PORT1_tvalid: Validación de la primera salida
//   M_AXIS_PORT2_tdata: Segunda señal de salida
//   M_AXIS_PORT2_tvalid: Validación de la segunda salida
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module signal_split #
(
    parameter ADC_DATA_WIDTH = 16,
    parameter AXIS_TDATA_WIDTH = 32
)
(
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    input [AXIS_TDATA_WIDTH-1:0]        S_AXIS_tdata,
    input                               S_AXIS_tvalid,
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    output wire [AXIS_TDATA_WIDTH-1:0]  M_AXIS_PORT1_tdata,
    output wire                         M_AXIS_PORT1_tvalid,
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    output wire [AXIS_TDATA_WIDTH-1:0]  M_AXIS_PORT2_tdata,
    output wire                         M_AXIS_PORT2_tvalid
);

    assign M_AXIS_PORT1_tdata = {{(AXIS_TDATA_WIDTH-ADC_DATA_WIDTH+1){S_AXIS_tdata[ADC_DATA_WIDTH-1]}},S_AXIS_tdata[ADC_DATA_WIDTH-1:0]};
    assign M_AXIS_PORT2_tdata = {{(AXIS_TDATA_WIDTH-ADC_DATA_WIDTH+1){S_AXIS_tdata[AXIS_TDATA_WIDTH-1]}},S_AXIS_tdata[AXIS_TDATA_WIDTH-1:ADC_DATA_WIDTH]};
    assign M_AXIS_PORT1_tvalid = S_AXIS_tvalid;
    assign M_AXIS_PORT2_tvalid = S_AXIS_tvalid;

endmodule
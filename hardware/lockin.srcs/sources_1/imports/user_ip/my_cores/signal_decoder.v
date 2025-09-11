//////////////////////////////////////////////////////////////////////////////////
// Módulo: signal_decoder
//
// Descripción:
//   Este módulo decodifica los bits más significativos de una señal ADC de entrada
//   y enciende uno de los 8 LEDs según el valor decodificado.
//   - La señal de entrada se recibe por un AXIS interface.
//   - Se puede ajustar un desplazamiento de bits según el rango de voltaje del ADC.
//
// Parámetros principales:
//   ADC_WIDTH       : Cantidad de bits de la señal ADC
//   AXIS_TDATA_WIDTH: Ancho de los datos AXIS
//   BIT_OFFSET      : Desplazamiento de bits según rango de voltaje
//
// Puertos principales:
//   S_AXIS_tdata : Datos de entrada del ADC
//   S_AXIS_tvalid: Indica que los datos de entrada son válidos
//   clk          : Reloj del sistema
//   rst          : Reset del módulo
//   led_out      : Salida a los LEDs según el valor decodificado
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module signal_decoder #
(
    parameter ADC_WIDTH = 14,
    parameter AXIS_TDATA_WIDTH = 32,
    parameter BIT_OFFSET = 0 // 4 for +/-20 V or 0 for +/-1 V ADC voltage range setting
)
(
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    input [AXIS_TDATA_WIDTH-1:0]    S_AXIS_tdata,
    input                           S_AXIS_tvalid,
    input                           clk,
    input                           rst,
    output reg [7:0]                led_out
);
    wire [2:0] value;

    assign value = S_AXIS_tdata[ADC_WIDTH-BIT_OFFSET-1:ADC_WIDTH-BIT_OFFSET-3];

    always @(posedge clk)
        if (~rst)
            led_out <= 8'hFF;
        else
            case (value)
                3'b011  : led_out <= 8'b00000001;
                3'b010  : led_out <= 8'b00000010;
                3'b001  : led_out <= 8'b00000100;
                3'b000  : led_out <= 8'b00001000;
                3'b111  : led_out <= 8'b00010000;
                3'b110  : led_out <= 8'b00100000;
                3'b101  : led_out <= 8'b01000000;
                3'b100  : led_out <= 8'b10000000;
                default : led_out <= 8'b00000000;
            endcase
endmodule
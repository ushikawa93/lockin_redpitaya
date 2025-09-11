//////////////////////////////////////////////////////////////////////////////////
// Módulo: frequency_counter
//
// Descripción:
//   Este módulo recibe una señal de entrada proveniente de un ADC y cuenta
//   los ciclos entre transiciones de la señal basadas en umbrales definidos.
//   La señal de entrada se pasa directamente a la salida junto con su validación.
//   Cuando se alcanzan N ciclos, se registra el valor del contador y se reinicia.
//
// Parámetros principales:
//   ADC_WIDTH      : Cantidad de bits de la señal ADC
//   AXIS_TDATA_WIDTH : Ancho de los datos de entrada/salida
//   COUNT_WIDTH    : Tamaño del contador
//   HIGH_THRESHOLD : Umbral alto para detectar transición
//   LOW_THRESHOLD  : Umbral bajo para detectar transición
//
// Puertos principales:
//   S_AXIS_IN_tdata   : Datos de entrada
//   S_AXIS_IN_tvalid  : Indica que los datos de entrada son válidos
//   clk               : Reloj del sistema
//   rst               : Reset del módulo
//   Ncycles           : Cantidad de ciclos a contar
//   M_AXIS_OUT_tdata  : Datos de salida
//   M_AXIS_OUT_tvalid : Indica que los datos de salida son válidos
//   counter_output    : Valor del contador cuando se completa Ncycles
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module frequency_counter #
(
    parameter ADC_WIDTH = 14,
    parameter AXIS_TDATA_WIDTH = 32,
    parameter COUNT_WIDTH = 32,
    parameter HIGH_THRESHOLD = -100,
    parameter LOW_THRESHOLD = -150
)
(
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    input [AXIS_TDATA_WIDTH-1:0]   S_AXIS_IN_tdata,
    input                          S_AXIS_IN_tvalid,
    input                          clk,
    input                          rst,
    input [COUNT_WIDTH-1:0]        Ncycles,
    output [AXIS_TDATA_WIDTH-1:0]  M_AXIS_OUT_tdata,
    output                         M_AXIS_OUT_tvalid,
    output [COUNT_WIDTH-1:0]       counter_output
);

    wire signed [ADC_WIDTH-1:0]    data;
    reg                            state, state_next;
    reg [COUNT_WIDTH-1:0]          counter=0, counter_next=0;
    reg [COUNT_WIDTH-1:0]          counter_output=0, counter_output_next=0;
    reg [COUNT_WIDTH-1:0]          cycle=0, cycle_next=0;


    // Wire AXIS IN to AXIS OUT
    assign  M_AXIS_OUT_tdata[ADC_WIDTH-1:0] = S_AXIS_IN_tdata[ADC_WIDTH-1:0];
    assign  M_AXIS_OUT_tvalid = S_AXIS_IN_tvalid;

    // Extract only the 14-bits of ADC data
    assign  data = S_AXIS_IN_tdata[ADC_WIDTH-1:0];



    // Handling of the state buffer for finding signal transition at the threshold
    always @(posedge clk)
    begin
        if (~rst)
            state <= 1'b0;
        else
            state <= state_next;
    end


    always @*            // logic for state buffer
    begin
        if (data > HIGH_THRESHOLD)
            state_next = 1;
        else if (data < LOW_THRESHOLD)
            state_next = 0;
        else
            state_next = state;
    end



    // Handling of counter, counter_output and cycle buffer
    always @(posedge clk)
    begin
        if (~rst)
        begin
            counter <= 0;
            counter_output <= 0;
            cycle <= 0;
        end
        else
        begin
            counter <= counter_next;
            counter_output <= counter_output_next;
            cycle <= cycle_next;
        end
    end


    always @* // logic for counter, counter_output, and cycle buffer
    begin
        counter_next = counter + 1; // increment on each clock cycle
        counter_output_next = counter_output;
        cycle_next = cycle;

        if (state < state_next) // high to low signal transition
        begin
            cycle_next = cycle + 1; // increment on each signal transition
            if (cycle >= Ncycles-1)
            begin
                counter_next = 0;
                counter_output_next = counter;
                cycle_next = 0;
            end
        end
    end

endmodule
`timescale 1ns / 1ps
///// ================================================================================= /////
///// ============================ Módulo Linear Mean ================================= /////
///// ================================================================================= /////
//
// Este módulo implementa un cálculo de promedio lineal (acumulativo) sobre
// un conjunto de muestras de entrada, con control de decimación y tope de datos.
//
// Funcionalidad:
//   - Recibe datos de entrada de 32 bits junto con una señal de validez.
//   - Acumula las muestras recibidas y, al alcanzar el valor definido
//     por decimate_value, entrega el promedio acumulado.
//   - Reinicia el contador y continúa con el siguiente bloque de datos.
//   - Controla la cantidad máxima de datos procesados mediante FIFO_DEPTH.
//
// Parámetros:
//   FIFO_DEPTH : Profundidad máxima de datos a procesar (por defecto 1024).
//
// Puertos:
//   clk            : Reloj del sistema.
//   reset_n        : Reset activo en bajo.
//   enable         : Habilita el funcionamiento del módulo.
//   data_in        : Dato de entrada (32 bits).
//   data_in_valid  : Señal que indica cuándo data_in es válido.
//   decimate_value : Número de muestras a promediar antes de emitir salida.
//   data_out       : Resultado del promedio acumulado.
//   data_out_valid : Señal de validez de data_out.
//   finish         : Indica que se alcanzó FIFO_DEPTH.
//
// Notas:
//   - El promedio se acumula en la variable "promedio" hasta decimate_value.
//   - Cada vez que se alcanza el valor de decimación, se emite data_out.
//   - Cuando counter_data llega a FIFO_DEPTH, la señal finish se activa.
//   - Útil para reducir ruido y calcular valores medios de señales continuas.
//
///// ================================================================================= /////


module linear_mean(

    input clk,
    input reset_n,
    input enable,

    input [31:0] data_in,
    input data_in_valid,
    
    input [31:0] decimate_value,
    
    output [31:0] data_out,
    output data_out_valid,
    
    output finish


    );

parameter FIFO_DEPTH = 1024;

reg [31:0] counter_data;
reg [31:0] counter;
reg [31:0] promedio;
reg [31:0] data_out_reg;
reg data_out_valid_reg;
reg finish_reg;

always @ (posedge clk or negedge reset_n)
begin

    if(!reset_n)
    begin
        counter <= 0;
        data_out_valid_reg <= 0;
        data_out_reg <= 0;
        counter_data <= 0;
        finish_reg <= 0;
        promedio <= 0;
    end
    else if (enable)
        if (data_in_valid)
        begin
            
            promedio <= promedio + data_in;
            counter <= counter +1;
            
            if(counter == decimate_value-1)
                counter <= 0;
            
            if(counter == 0)
            begin
                data_out_reg <= promedio;
                promedio <= data_in;
                
                data_out_valid_reg <= 1;                
                counter_data <= (counter_data == FIFO_DEPTH)? counter_data : counter_data + 1;
            end
            else
                data_out_valid_reg <= 0;
        end
        else
            data_out_valid_reg <= 0;
     else
        data_out_valid_reg <= 0;
        
end

assign data_out = data_out_reg;
assign data_out_valid = data_out_valid_reg;
assign finish = (counter_data == FIFO_DEPTH)? 1 : 0;


endmodule

`timescale 1ns / 1ps
///// ================================================================================= /////
///// ============================== Módulo Decimator ================================= /////
///// ================================================================================= /////
//
// Este módulo implementa un diezmador simple para flujo de datos.
//
// Funcionalidad:
//   - Recibe muestras de entrada de 32 bits con una señal de validez.
//   - Entrega cada N-ésima muestra, donde N = decimate_value.
//   - Lleva un conteo de las muestras entregadas (hasta FIFO_DEPTH).
//   - Activa 'finish' cuando se alcanzan FIFO_DEPTH muestras de salida.
//   - Incluye reset y enable para control flexible en la integración.
//
// Puertos:
//   clk              : Reloj del sistema.
//   reset_n          : Reset activo en bajo.
//   enable           : Habilitación del módulo.
//   data_in          : Datos de entrada de 32 bits.
//   data_in_valid    : Indica cuándo data_in es válido.
//   decimate_value   : Factor de diezmado.
//   data_out         : Datos de salida de 32 bits (flujo diezmado).
//   data_out_valid   : Indica cuándo data_out es válido.
//   finish           : Activo cuando se alcanzan FIFO_DEPTH muestras de salida.
//
// Notas:
//   - El módulo procesa datos solo cuando data_in_valid está en alto.
//   - El diezmado funciona entregando una muestra cada decimate_value ciclos.
//   - La señal finish se activa cuando el contador interno counter_data
//     llega a FIFO_DEPTH.
//
///// ================================================================================= /////



module decimator(

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
    end
    else if (enable)
        if (data_in_valid)
        begin
            
            counter <= counter +1;
            if(counter == decimate_value-1)
                counter <= 0;
            
            if(counter == 0)
            begin
                data_out_reg <= data_in;
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

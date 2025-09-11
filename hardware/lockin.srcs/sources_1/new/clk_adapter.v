`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////
// Módulo: clk_adapter
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo permite transferir datos entre dos dominios de reloj distintos:
//   - clk_in  : dominio de entrada (fuente de datos).
//   - clk_out : dominio de salida (consumidor de datos).
//
//   El mecanismo es simple: cuando llega un dato válido en clk_in, este se registra
//   y se marca como disponible. Luego, en el flanco positivo de clk_out, si hay un
//   dato disponible, se transfiere al dominio de salida junto con una señal de
//   validación.
//
// Parámetros:
//   DATA_IN_WIDTH   -> Ancho del bus de datos de entrada.
//   DATA_OUT_WIDTH  -> Ancho del bus de datos de salida.
//
// Puertos:
//   Entradas:
//     - clk_in            : Reloj del dominio de entrada.
//     - clk_out           : Reloj del dominio de salida.
//     - data_in           : Datos de entrada.
//     - data_in_valid     : Señal que indica que data_in es válido.
//
//   Salidas:
//     - data_out          : Datos de salida sincronizados con clk_out.
//     - data_out_valid    : Señal de validación de data_out.
//
// Notas:
//   - La transferencia se hace sin handshake ni control de backpressure.
//   - Diseñado para casos donde clk_in y clk_out tienen frecuencias cercanas o
//     cuando se puede tolerar la pérdida de datos en situaciones de desajuste.
//   - No asegura sincronización robusta en entornos con dominios de reloj muy distintos.
//     Para aplicaciones críticas se recomienda usar FIFO asincrónica.
//
// Autor: Matías Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////

module clk_adapter
#(
  parameter integer DATA_IN_WIDTH = 32,
  parameter integer DATA_OUT_WIDTH = 32
  )

(

        input clk_in,
        input clk_out,
        
        input [DATA_IN_WIDTH-1:0] data_in,
        input data_in_valid,
        
        output [DATA_OUT_WIDTH-1:0] data_out,
        output data_out_valid


    );
    
reg [DATA_IN_WIDTH-1:0] data_in_reg,data_out_reg;
reg data_out_valid_reg;
reg data_available;

always @ (negedge clk_in)
begin
    
    if(data_in_valid)
    begin
        data_in_reg <= data_in;
        data_available <= 1;    
    end
    else
        data_available <= 0;    
    
end
    
always @ (posedge clk_out)
begin
    
    if(data_available)
    begin
        data_out_reg <= data_in_reg;
        data_out_valid_reg <= 1;
    end
    else    
        data_out_valid_reg <= 0;

end
    
assign data_out_valid = data_out_valid_reg;
assign data_out = data_out_reg;

endmodule

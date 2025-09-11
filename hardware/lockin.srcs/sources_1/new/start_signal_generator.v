`timescale 1ns / 1ps

///// ================================================================================= /////
///// ======================= Módulo START_SIGNAL_GENERATOR =========================== /////
///// ================================================================================= /////
//
// Este módulo genera una señal de inicio (start) a partir de la detección de cruces 
// por cero en la señal de entrada. Está diseñado para sincronizar procesos que deben 
// comenzar en un punto específico del ciclo de la señal.
//
// Funcionamiento:
//   - Monitorea el bit de signo de la señal de entrada (data[DATA_WIDTH-1]).
//   - Detecta transiciones de negativo a positivo (cero ascendente).
//   - Cuando se detecta la condición, genera un pulso de inicio (start).
//   - El pulso se habilita durante un ciclo de reloj y luego se bloquea 
//     durante aproximadamente M/2 muestras, donde M es el período estimado
//     entregado en approxM.
//   - Una máquina de estados controla el flujo: 
//         idle → habilitar_salida → esperar → idle.
//
// Parámetros:
//   DATA_WIDTH : Ancho de la señal de entrada (bits).
//
// Puertos:
//   Entradas:
//     clk         : Reloj principal.
//     reset_n     : Reset asincrónico, activo en bajo.
//     data        : Datos de entrada (DATA_WIDTH bits).
//     data_valid  : Indica cuando los datos de entrada son válidos.
//     approxM     : Aproximación del número de puntos por período.
//
//   Salidas:
//     start       : Pulso de inicio generado cuando se detecta la condición.
//
// Notas:
//   - El cálculo de halfM = (approxM/2 + approxM/4) ajusta la ventana de bloqueo 
//     entre pulsos para mayor robustez en la detección.
//   - Este módulo es útil para sincronización en algoritmos de lock-in, FFT, 
//     o cualquier proceso periódico.
//
///// ================================================================================= /////


module start_signal_generator#(
    parameter DATA_WIDTH = 16 
)(

    input clk,
    input reset_n,
    
    input [DATA_WIDTH-1:0] data,
    input data_valid,
    
    input [31:0] approxM, 
    
    output start

    );

reg signo_reg,signo_reg_reg;  
reg out_register;
reg [31:0] counter;
wire [31:0] halfM; 
    assign halfM = (approxM >> 1) + (approxM >> 2);

reg [2:0] state;
parameter idle=1, habilitar_salida = 2, esperar=3;


always @ (posedge clk or negedge reset_n)
begin
    
    if(!reset_n)    
    begin
        signo_reg <= 0;
        signo_reg_reg <= 1;
        out_register <= 0;
        counter <= 0;
        state <= idle;
    end
    
    else if (data_valid)
    begin
    
    case(state)
        idle:
        begin
            out_register <= 0;
            counter <= 0;
            signo_reg <= data[DATA_WIDTH-1];
            signo_reg_reg <= signo_reg;
            state <= ((!signo_reg) && (signo_reg_reg))? habilitar_salida: idle;        
        end
                
        habilitar_salida:
        begin
            out_register <= 1;
            state <= esperar;
        end
        esperar:
        begin
            out_register <= 0;
            counter <= counter + 1;
            state <= (counter == halfM) ? idle : esperar;
 
        end
        
     endcase
    
      
    end
end

assign start = out_register ;

endmodule

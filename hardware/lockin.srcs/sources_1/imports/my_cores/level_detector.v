`timescale 1ns / 1ps
///// ================================================================================= /////  
///// ============================ Módulo LEVEL_DETECTOR =========================== /////  
///// ================================================================================= /////  
//  
// Este módulo detecta si dos señales de entrada superan un nivel de referencia dado.  
// Se utilizan registros para almacenar temporalmente las entradas y generar las señales de detección.  
//
// Entradas:  
//   clk             : Señal de reloj del sistema.  
//   reset_n         : Reset activo en bajo.  
//   level_to_detect : Nivel de referencia contra el cual se comparan las entradas.  
//   data_in_1       : Primera señal de entrada a monitorear.  
//   data_in_1_valid : Validez de la primera entrada.  
//   data_in_2       : Segunda señal de entrada a monitorear.  
//   data_in_2_valid : Validez de la segunda entrada.  
//
// Salidas:  
//   level_detected_0 : Señal que indica si `data_in_1` supera el nivel de referencia.  
//   level_detected_1 : Señal que indica si `data_in_2` supera el nivel de referencia.  
//
// Funcionamiento:  
//   - Cada ciclo de reloj, si la entrada correspondiente es válida, se compara con `level_to_detect`.  
//   - Si la entrada supera el nivel, la salida asociada se activa.  
//   - Se registran los valores de entrada para evitar glitches por cambios asincrónicos.  
//
// Aplicaciones:  
//   - Detección de niveles en sistemas de adquisición de datos.  
//   - Disparo de eventos cuando una señal supera un umbral definido.  
///// ================================================================================= /////  


module level_detector(
    input clk,
    input reset_n,
    input signed [31:0] level_to_detect,
    
    input signed [13:0] data_in_1,
    input data_in_1_valid,
    
    input signed [13:0] data_in_2,
    input data_in_2_valid,
    
    
    output level_detected_0,
    output level_detected_1
    );
    

reg level_detected_1_reg;
reg level_detected_2_reg;

reg signed [31:0] level;

reg signed [13:0] data_in_1_reg;
reg signed [13:0] data_in_2_reg;

always @ (posedge clk)
begin

    if (!reset_n)
    begin
        level_detected_1_reg <= 0;
        level_detected_2_reg <= 0;
        level <= 0;
        data_in_1_reg <= 0;
        data_in_2_reg <= 0;
    end
    else
    begin
        
        level <= level_to_detect;
        
        if(data_in_1_valid)
        begin
            data_in_1_reg <= data_in_1;    
            level_detected_1_reg <= (data_in_1_reg > level) ? 1 : 0;        
        end
        
        if(data_in_2_valid)
        begin
            data_in_2_reg <= data_in_2;    
            level_detected_2_reg <= (data_in_2_reg > level) ? 1 : 0;        
        end
        
    end
    

end

assign level_detected_0 = level_detected_1_reg;
assign level_detected_1 = level_detected_2_reg;   
    
    
endmodule

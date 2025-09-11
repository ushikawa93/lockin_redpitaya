`timescale 1ns / 1ps
///// ================================================================================= /////  
///// ============================ Módulo DRIVE_LEDS =============================== /////  
///// ================================================================================= /////  
//  
// Este módulo permite controlar un conjunto de 8 LEDs a partir de señales individuales de entrada.  
// Cada entrada controla un LED correspondiente en la salida de 8 bits `signal_out`.  
//
// Funcionamiento:  
//   - Los bits individuales `signal_0` a `signal_7` se concatenan para formar un bus de salida de 8 bits.  
//   - El bit más significativo (`signal_7`) se asigna al LED más alto del bus de salida.  
//   - El bit menos significativo (`signal_0`) se asigna al LED más bajo del bus de salida.  
//
// Entradas:  
//   signal_0, signal_1, ..., signal_7 : Señales individuales que controlan cada LED.  
//
// Salida:  
//   signal_out : Bus de 8 bits que representa el estado de los LEDs.  
//
// Notas:  
//   - Este módulo simplifica la conexión de múltiples señales a LEDs físicos o lógicos en FPGA.  
///// ================================================================================= /////  


module drive_leds(
    
    input signal_0,
    input signal_1,
    input signal_2,
    input signal_3,
    input signal_4,
    input signal_5,
    input signal_6,
    input signal_7,
    
    output [7:0] signal_out
    
    

    );
    
assign signal_out = { signal_7,signal_6,signal_5,signal_4,signal_3,signal_2,signal_1,signal_0};
endmodule

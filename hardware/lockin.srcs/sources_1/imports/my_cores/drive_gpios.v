`timescale 1ns / 1ps
///// ================================================================================= /////  
///// ============================ Módulo DRIVE_GPIOS ============================= /////  
///// ================================================================================= /////  
//  
// Este módulo permite la gestión de señales GPIO bidireccionales a través de un bus de 8 bits.  
// Separa la parte alta y baja del bus `signal_export` para entradas y salidas, respectivamente,  
// y facilita la conexión de señales individuales a un conjunto compacto de pines exportados.
//
// Funcionamiento:  
//   - Los 4 bits más bajos de `signal_export` representan las señales de entrada (`input_0` a `input_3`).  
//   - Los 4 bits más altos de `signal_export` representan las señales de salida (`output_0` a `output_3`).  
//   - Se puede acceder tanto a entradas como a salidas de manera simultánea a través del bus de 8 bits.
//
// Entradas:  
//   input_0, input_1, input_2, input_3 : Señales de entrada individuales.  
//
// Salidas:  
//   output_0, output_1, output_2, output_3 : Señales de salida individuales.  
//
// Bidireccional:  
//   signal_export : Bus de 8 bits que combina entradas y salidas para la interconexión externa.  
//
// Notas:  
//   - Se asignan explícitamente los bits de entrada y salida al bus `signal_export` para mayor claridad.  
//   - Este módulo facilita la integración de GPIOs en un diseño más amplio de FPGA o SoC.  
///// ================================================================================= /////  


module drive_gpios(
    
    input input_0,
    input input_1,
    input input_2,
    input input_3,
    
    output output_0,
    output output_1,
    output output_2,
    output output_3,
    
    inout [7:0] signal_export
    
    );
    
    wire [3:0] input_signals;
    wire [3:0] output_signals;
    
      // Asigna las se�ales de entrada a la parte alta de la se�al_export
    assign input_signals = {input_3, input_2, input_1, input_0};
    assign signal_export[3:0] = input_signals;

    // Asigna las se�ales de salida a la parte baja de la se�al_export
    assign output_signals = {output_3, output_2, output_1, output_0};
    assign signal_export[7:4] = output_signals;


    
    
    assign signal_export = { input_3,input_2,input_1,input_0,output_3,output_2,output_1,output_0 };
    
    
    
endmodule

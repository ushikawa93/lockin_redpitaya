///// ================================================================================= /////  
///// ========================== Módulo MULTIPLICADOR ============================== /////  
///// ================================================================================= /////  
//  
// Este módulo realiza la multiplicación de dos señales de entrada de 32 bits utilizando  
// un macro DSP optimizado (`MULT_MACRO`) para instanciación eficiente en FPGA.  
// La salida es un valor de 64 bits correspondiente al producto de las entradas.
//
// Funcionamiento:  
//   - Registra las entradas `data_a` y `data_b` para mejorar el timing y la sincronización.  
//   - Ajusta los anchos de los datos a los máximos soportados por el macro DSP:  
//       - data_a: 25 bits  
//       - data_b: 18 bits  
//   - Multiplica las entradas cuando `enable` y `data_valid` están activos.  
//   - Genera `data_out` y la señal `data_valid_multiplicacion` indicando que el producto es válido.
//
// Puertos:  
//   Entradas:  
//     clock                  : Reloj principal.  
//     reset_n                : Reset asincrónico, activo en bajo.  
//     enable                 : Habilita el procesamiento de datos.  
//     data_a                 : Primer operando de 32 bits (complemento a dos).  
//     data_b                 : Segundo operando de 32 bits (complemento a dos).  
//     data_valid             : Indica cuándo las entradas son válidas.  
//
//   Salidas:  
//     data_out               : Producto de los dos operandos (64 bits).  
//     data_valid_multiplicacion : Indica que `data_out` es válido.
//
// Notas:  
//   - Utiliza el macro `MULT_MACRO` de Xilinx para asegurar una implementación eficiente  
//     en DSPs de FPGAs 7 Series.  
//   - Todas las señales de entrada son registradas para evitar problemas de timing.  
//   - La latencia del macro está configurada en 0 ciclos para minimizar retrasos.  
//  
///// ================================================================================= /////  

module multiplicador(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Entrada avalon streaming
	input [31:0] data_a,
	input [31:0] data_b,
	input data_valid,	
		
	// Salidas avalon streaming 
	output [63:0] data_out,
	output data_valid_multiplicacion	

);

// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [31:0] data_a_reg;
always @(posedge clock) data_a_reg <= (!reset_n) ? 0 : $signed(data_a);

reg signed [31:0] data_b_reg;
always @(posedge clock) data_b_reg <= (!reset_n) ? 0 : $signed(data_b);

reg data_valid_reg;
always @(posedge clock) data_valid_reg <= (!reset_n) ? 0 : data_valid;


//=======================================================
// Multiplico con este macro para que se intancien bien los DSP
//=======================================================

// Cambio los widths a los maximos que admite el macro este
wire [24:0] data_a_input_mult = data_a_reg[24:0];
wire [17:0] data_b_input_mult = data_b_reg[17:0];
wire [42:0] data_out_multiplicacion;


MULT_MACRO #(
      .DEVICE("7SERIES"), // Target Device: "7SERIES" 
      .LATENCY(0),        // Desired clock cycle latency, 0-4
      .WIDTH_A(25),       // Multiplier A-input bus width, 1-25
      .WIDTH_B(18)        // Multiplier B-input bus width, 1-18
   ) MULT_MACRO_inst (
      .P(data_out_multiplicacion),     // Multiplier output bus, width determined by WIDTH_P parameter
      .A(data_a_reg),     // Multiplier input A bus, width determined by WIDTH_A parameter
      .B(data_b_reg),     // Multiplier input B bus, width determined by WIDTH_B parameter
      .CE(enable),   // 1-bit active high input clock enable
      .CLK(clock), // 1-bit positive edge clock input
      .RST(!reset_n)  // 1-bit input active high reset
   );

//=======================================================
// Algoritmo principal
//=======================================================

reg signed [63:0] producto;
reg data_valid_1, data_valid_2, data_out_valid;

always @(posedge clock or negedge reset_n) begin

    if (!reset_n) begin
        data_out_valid <= 0;
        
    end else if (enable) begin
    
        if (data_valid_reg) begin
            producto <= $signed(data_out_multiplicacion);
            data_out_valid <= 1;
            
        end else begin
            data_out_valid <= 0;
            
        end
    end
end

assign data_out = producto;
assign data_valid_multiplicacion = data_out_valid;


endmodule

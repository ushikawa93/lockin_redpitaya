//////////////////////////////////////////////////////////////////////////////////
// ============================= BRAM Test Core ================================ //
// ============================================================================ //
// Módulo: bram_test_core
// Descripción:
//   Genera patrones de prueba en una BRAM y permite verificar el funcionamiento
//   de la interfaz de escritura y disparo. Se organiza como una máquina de estados
//   con las siguientes etapas:
//
//   - Estado 0: Inicialización de registros internos.
//   - Estado 1: Borrado de la BRAM (llenado con ceros).
//   - Estado 2: Espera de trigger externo para comenzar la prueba.
//   - Estado 3: Escritura secuencial de datos crecientes en BRAM.
//   - Estado 4: Finalización de la prueba, activando la señal `finished`.
//
// Parámetros:
//   - AXIS_TDATA_WIDTH : Ancho de datos de la interfaz AXIS (default 32).
//   - BRAM_DATA_WIDTH  : Ancho de palabra de la BRAM (default 32).
//   - BRAM_ADDR_WIDTH  : Ancho de dirección de la BRAM (default 13).
//   - nsamples         : Cantidad de muestras a escribir (default 16).
//   - step             : Incremento aplicado al valor de prueba en cada muestra.
//
// Entradas:
//   - aclk, aresetn : Señales de reloj y reset.
//   - trig          : Trigger externo de inicio de adquisición.
//   - user_reset    : Reset manual del usuario.
//   - test_value    : Valor base de prueba para escritura en BRAM.
//
// Salidas:
//   - finished      : Señal que indica fin de la operación.
//   - bram_porta_*  : Interfaz hacia BRAM (clk, rst, addr, wrdata, we).
//
// Notas:
//   - Se detecta flanco ascendente de `trig` para iniciar la secuencia.
//   - El bug comentado en el código: el primer address puede no escribirse
//     correctamente y requiere ajuste en la inicialización de direcciones.
//
// Autor: MatiOliva
//////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


// Solo falta arreglar que en el primer address no escribe bien...

module bram_test_core #
(
  parameter integer AXIS_TDATA_WIDTH = 32,
  parameter integer BRAM_DATA_WIDTH = 32,
  parameter integer BRAM_ADDR_WIDTH = 13,  // 2^15 = 32768 positions
  parameter integer nsamples = 16,
  parameter integer step = 1
)
(
  // System signals
  input  wire                        aclk,
  input  wire                        aresetn,
  
  // User signals
  input  wire						 trig,
  input  wire 						 user_reset,
  output wire 						 finished,
  input wire [BRAM_DATA_WIDTH-1:0]   test_value,

  // BRAM PORT A
  output wire                        bram_porta_clk,
  output wire                        bram_porta_rst,
  output wire [BRAM_ADDR_WIDTH-1:0]  bram_porta_addr,
  output wire [BRAM_DATA_WIDTH-1:0]  bram_porta_wrdata,
  input  wire [BRAM_DATA_WIDTH-1:0]  bram_porta_rddata,
  output wire                        bram_porta_we
  
);


  reg [BRAM_ADDR_WIDTH-1:0] int_addrA_reg, int_addrA_next;
  reg [2:0] int_case_reg, int_case_next;
  reg int_wren_reg, int_wren_next;
  reg [BRAM_DATA_WIDTH-1:0] int_data_reg, int_data_next;
  reg d_trig;
  wire trigger;  
  reg int_finished_reg, int_finished_next;
  
  reg [15:0] int_incremento_reg,int_incremento_next;  
  
  assign finished = int_finished_reg;  
  assign bram_porta_clk = aclk;
  
  assign bram_porta_rst = ~aresetn;
  assign bram_porta_addr = int_addrA_reg;
  assign bram_porta_wrdata = int_data_reg;
  assign bram_porta_we = int_wren_reg;
  
  
  always@(posedge aclk) begin
	 if (user_reset) d_trig <= 0;
	 else d_trig <= trig;
  end
  assign trigger = (trig == 1) && (d_trig == 0) ? 1 : 0;
  
  
  always @(posedge aclk)
  begin
    if(~aresetn )
    begin
      int_addrA_reg <= {(BRAM_ADDR_WIDTH){1'b0}};
      int_case_reg <= 3'd0;
      int_wren_reg <= 1'b0;
      int_data_reg <= {(BRAM_DATA_WIDTH){1'b0}};
	  int_finished_reg <= 1'b0;
	  int_incremento_reg <= 0;

    end
    else
    begin
      int_addrA_reg <= int_addrA_next;
      int_case_reg <= int_case_next;
      int_wren_reg <= int_wren_next;
	  int_data_reg <= int_data_next;
  	  int_finished_reg <= int_finished_next;
  	  int_incremento_reg <= int_incremento_next;

    end
  end

  
  always @*
  begin
    
    int_addrA_next = int_addrA_reg;
    int_case_next = int_case_reg;
    int_wren_next=int_wren_reg;
    int_data_next = int_data_reg;
    int_finished_next = int_finished_reg;
    int_incremento_next = int_incremento_reg;

    case(int_case_reg)
      0:    // Begin state
      begin
        int_addrA_next = {(BRAM_ADDR_WIDTH){1'b0}};
		int_case_next = 3'd1;
		int_wren_next = 1'b1;
		int_data_next = {(BRAM_DATA_WIDTH){1'b0}};
		int_finished_next = 0;
		int_incremento_next = 0;

      end
      1:    // Clear BRAM state
      begin
        int_addrA_next = int_addrA_reg + 1'b1;
        if(int_addrA_reg == nsamples-1) // clear until all the addresses are zero
        begin
          int_case_next = 3'd2;
		  int_wren_next = 1'b0;
        end
      end
      2:    // Wait for trigger
      begin
        int_addrA_next = -1;    // Si no es -2 empieza a escribir mal, por queeeeeee
        int_wren_next = 1'b0;
        if(trigger)
        begin
			int_case_next = 3'd3;	
			int_wren_next = 1'b1;
			int_data_next = test_value;
        end
      end
	  3:    // Measure
      begin
        int_addrA_next = int_addrA_reg + 1;
		int_data_next = test_value + int_incremento_reg;
		int_incremento_next = int_incremento_reg + step;
		int_wren_next = 1'b1;
		if (int_addrA_reg == nsamples-1)
		begin
			 int_case_next = 3'd4;
        end
      end
      4:	// finished
      begin
        int_finished_next = 1;
        
        if(user_reset)
        begin
			int_case_next = 3'd0;
        end
      end

    endcase
  end



endmodule

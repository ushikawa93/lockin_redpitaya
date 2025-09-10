//////////////////////////////////////////////////////////////////////////////////
// ============================ BRAM Multiplexer =============================== //
// ============================================================================ //
// Módulo: bram_mux
// Descripción:
//   Multiplexa el acceso de un tercer bloque de control (C) hacia dos BRAMs (A y B).
//   Dependiendo de la señal `readable_bram`, redirige las señales de dirección,
//   datos y escritura hacia BRAM_A o BRAM_B, y selecciona de cuál se leen los datos.
//
// Parámetros:
//   - DATA_WIDTH: Ancho de palabra en bits (default: 32)
//   - ADDR_WIDTH: Ancho de dirección en bits (default: 16)
//
// Entradas:
//   - bram_C_* : Señales provenientes del bloque controlador externo.
//   - readable_bram : Selección de BRAM (0 → A, 1 → B).
//
// Salidas:
//   - bram_A_*, bram_B_* : Señales dirigidas hacia las BRAMs A y B.
//   - bram_C_rddata : Datos leídos de la BRAM seleccionada.
//
// Notas:
//   - Se utiliza un único reloj y reset compartido desde BRAM_C.
//   - Solo una BRAM puede ser accedida en cada ciclo.
//
// Autor: MatiOliva
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module bram_mux#
(
  parameter integer DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH = 16 
 )
(

 // BRAM A
	output wire                       bram_A_clk,
	output wire                       bram_A_rst,
	output wire [ADDR_WIDTH-1:0]      bram_A_addr,
	output wire [DATA_WIDTH-1:0]      bram_A_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_A_rddata,
	output wire                       bram_A_we,
	
	// BRAM B
	output wire                       bram_B_clk,
	output wire                       bram_B_rst,
	output wire [ADDR_WIDTH-1:0]      bram_B_addr,
	output wire [DATA_WIDTH-1:0]      bram_B_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_B_rddata,
	output wire                       bram_B_we,	
	
	// BRAM C
	input wire                       bram_C_clk,
	input wire                       bram_C_rst,
	input wire [ADDR_WIDTH-1:0]      bram_C_addr,
	input wire [DATA_WIDTH-1:0]      bram_C_wrdata,
	output  wire [DATA_WIDTH-1:0]    bram_C_rddata,
	input wire                       bram_C_we,
	
	input wire                        readable_bram

    );    
    
    
    assign bram_A_clk = bram_C_clk;
    assign bram_A_rst = bram_C_rst;
    assign bram_A_addr = (readable_bram == 0) ? bram_C_addr : 0;
    assign bram_A_wrdata = (readable_bram == 0) ? bram_C_wrdata : 0;
    assign bram_A_we = (readable_bram == 0) ? bram_C_we : 0;
    
    assign bram_B_clk = bram_C_clk;
    assign bram_B_rst = bram_C_rst;
    assign bram_B_addr = (readable_bram == 1) ? bram_C_addr : 0;
    assign bram_B_wrdata = (readable_bram == 1) ? bram_C_wrdata : 0;
    assign bram_B_we = (readable_bram == 1) ? bram_C_we : 0;
    
    assign bram_C_rddata = (readable_bram == 0) ? bram_A_rddata: bram_B_rddata;
    
    
    
    
endmodule

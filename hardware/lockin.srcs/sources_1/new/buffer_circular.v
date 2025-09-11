`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////
// Módulo: buffer_circular
//////////////////////////////////////////////////////////////////////////////////////
// Descripción:
//   Este módulo implementa un buffer circular basado en BRAM con tres puertos:
//   - Un puerto de entrada (A) para escritura.
//   - Dos puertos de salida (B y C) que se alternan como áreas de lectura/escritura.
//
//   La memoria se divide en dos mitades (cada una de tamaño MEMORY_SIZE/2).
//   Mientras una mitad es usada para escritura desde el puerto A, 
//   la otra mitad queda disponible para lectura desde el puerto correspondiente (B o C).
//
// Parámetros:
//   DATA_WIDTH   -> Ancho de palabra de datos (bits).
//   ADDR_WIDTH   -> Ancho de direcciones (bits).
//   MEMORY_SIZE  -> Tamaño total de memoria (por defecto 65536).
//
// Puertos:
//   Entrada BRAM (A):
//     - bram_porta_clk      : Reloj de escritura.
//     - bram_porta_rst      : Reset.
//     - bram_porta_addr     : Dirección de escritura.
//     - bram_porta_wrdata   : Datos de entrada.
//     - bram_porta_rddata   : Datos leídos.
//     - bram_porta_we       : Habilitación de escritura.
//
//   Salida BRAM (B):
//     - bram_portb_clk      : Reloj (clonado de A).
//     - bram_portb_rst      : Reset (clonado de A).
//     - bram_portb_addr     : Dirección de acceso.
//     - bram_portb_wrdata   : Datos escritos (en modo escritura).
//     - bram_portb_rddata   : Datos leídos desde BRAM.
//     - bram_portb_we       : Habilitación de escritura.
//
//   Salida BRAM (C):
//     - bram_portc_clk      : Reloj (clonado de A).
//     - bram_portc_rst      : Reset (clonado de A).
//     - bram_portc_addr     : Dirección de acceso.
//     - bram_portc_wrdata   : Datos escritos (en modo escritura).
//     - bram_portc_rddata   : Datos leídos desde BRAM.
//     - bram_portc_we       : Habilitación de escritura.
//
//   Señal de control:
//     - redable_buffer      : Indica qué mitad del buffer está disponible para lectura.
//                             0 → se puede leer puerto B (C en escritura).
//                             1 → se puede leer puerto C (B en escritura).
//
// Notas:
//   - La escritura siempre se realiza en la mitad opuesta a la que está habilitada para lectura.
//   - Facilita el procesamiento de bloques de datos en paralelo (ping-pong buffering).
//
// Autor: Matías Oliva
// Fecha: 2025
//////////////////////////////////////////////////////////////////////////////////////


module buffer_circular
#(
  parameter integer DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH = 16,
  parameter integer MEMORY_SIZE = 65536
  )
(
    // BRAM IN
	input wire                       bram_porta_clk,
	input wire                       bram_porta_rst,
	input wire [ADDR_WIDTH-1:0]      bram_porta_addr,
	input wire [DATA_WIDTH-1:0]      bram_porta_wrdata,
	output  wire [DATA_WIDTH-1:0]    bram_porta_rddata,
	input wire                       bram_porta_we,
	
	// BRAM OUT1
	output wire                       bram_portb_clk,
	output wire                       bram_portb_rst,
	output reg [ADDR_WIDTH-1:0]      bram_portb_addr,
	output reg [DATA_WIDTH-1:0]      bram_portb_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_portb_rddata,
	output reg                       bram_portb_we,
	
	// BRAM OUT2
	output wire                       bram_portc_clk,
	output wire                       bram_portc_rst,
	output reg [ADDR_WIDTH-1:0]      bram_portc_addr,
	output reg [DATA_WIDTH-1:0]      bram_portc_wrdata,
	input  wire [DATA_WIDTH-1:0]      bram_portc_rddata,
	output reg                       bram_portc_we,
	
	output wire                       redable_buffer // si esta en 0 puedo leer el B, si esta en 1 puedo leer el C

    );
    
assign bram_portb_clk = bram_porta_clk;
assign bram_portc_clk = bram_porta_clk;

assign bram_portb_rst = bram_porta_rst;
assign bram_portc_rst = bram_porta_rst;

assign redable_buffer = (bram_porta_addr < MEMORY_SIZE / 2) ? 1:0;

always @*
begin

    if(redable_buffer == 1)     // Si el que puedo leer es el C escribo en el B
    begin
    
        bram_portb_addr = bram_porta_addr;
        bram_portb_wrdata = bram_porta_wrdata;
        bram_portb_we = bram_porta_we;
        
        bram_portc_addr = 0;
        bram_portc_wrdata = 0;
        bram_portc_we = 0;

    end
    else        // Si el que puedo leer es el B escribo en el C
    begin    
    
        bram_portc_addr = bram_porta_addr - MEMORY_SIZE / 2;
        bram_portc_wrdata = bram_porta_wrdata;
        bram_portc_we = bram_porta_we;
        
        bram_portb_addr = 0;
        bram_portb_wrdata = 0;
        bram_portb_we = 0;   
    
    end



end

endmodule

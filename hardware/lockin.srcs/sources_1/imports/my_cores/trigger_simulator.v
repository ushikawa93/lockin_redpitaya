`timescale 1ns / 1ps
///// ================================================================================= /////  
///// ========================== Módulo TRIGGER_SIMULATOR ========================= /////  
///// ================================================================================= /////  
//  
// Este módulo simula distintos modos de trigger sobre una señal de entrada digitalizada.  
// Puede generar triggers basados en:  
//   1) Conteo continuo (cada M muestras).  
//   2) Cruce de nivel (comparando la señal con un nivel de referencia).  
//   3) Trigger externo (entrada digital externa).  
//
// Entradas:  
//   clk                  : Señal de reloj del sistema.  
//   reset_n              : Reset activo en bajo.  
//   user_reset           : Reset externo desde el usuario.  
//   data_in              : Señal de datos a monitorear.  
//   data_valid           : Validez de la señal de datos.  
//   M_in                 : Número de muestras para el trigger continuo.  
//   K_sobremuestreo_in   : Factor de sobremuestreo para el trigger de nivel.  
//   log2_div_in          : Factor de división log2 aplicado al trigger de nivel.  
//   trigger_mode_in      : Modo de trigger (0 = continuo, 1 = nivel, 2 = externo).  
//   trigger_level_in     : Nivel de referencia para trigger de nivel.  
//   trig_externo         : Trigger externo digital.  
//
// Salidas:  
//   trig_cont_export     : Indica un trigger continuo generado internamente.  
//   trig                 : Trigger final según el modo seleccionado.  
//
// Funcionamiento:  
//   - Trigger continuo: Se genera un pulso cada M muestras.  
//   - Trigger de nivel: Detecta flancos ascendentes sobre `trigger_level_in` y evita rebotes con un contador de hold-off.  
//   - Trigger externo: Se genera un pulso cuando `trig_externo` cambia a alto, con un hold-off similar.  
//   - Las entradas se registran para sincronizar las operaciones y evitar glitches.  
//   - La señal final `trig` selecciona automáticamente el modo configurado.  
//
// Aplicaciones:  
//   - Simulación de triggers en sistemas de adquisición de datos.  
//   - Pruebas de sincronización y adquisición controlada por eventos.  
///// ================================================================================= /////  


module trigger_simulator
(
    input clk,
    input reset_n,
    input user_reset,
    
    input signed [31:0] data_in,
    input               data_valid,    
    
    input [31:0] M_in,
    input [31:0] K_sobremuestreo_in,
    input [31:0] log2_div_in,    
    input [3:0] trigger_mode_in,
    input signed [31:0] trigger_level_in,
    
    input trig_externo,
    output trig_cont_export,
    
    output trig

);

   
    

// Pongo registros para las entradas que vienen del uC

reg [31:0] M_reg;
reg [31:0] K_reg;
reg [31:0] log2_div_reg;
reg [3:0] trigger_mode_reg;
reg signed [31:0] trigger_level_reg;
reg signed [31:0] trigger_level_k_mult;
reg signed [31:0] trigger_level_k_mult_div;

always @ (posedge clk)
begin

    if(!reset_n)
    begin
        K_reg <= 0;
        M_reg <= 0;
        trigger_mode_reg <= 0;
        trigger_level_reg <= 0;    
        log2_div_reg <= 0;
        trigger_level_k_mult <= 0;
    end
    else
    begin
        K_reg <= K_sobremuestreo_in;
        M_reg <= M_in;
        trigger_mode_reg <= trigger_mode_in;
        trigger_level_reg <= trigger_level_in;    
        log2_div_reg <= log2_div_in;
        
        trigger_level_k_mult <= (trigger_level_reg * K_reg) ;
        
        trigger_level_k_mult_div <= trigger_level_k_mult >> log2_div_reg;
        
    end

end

// Primera opcion de trigger se dispara una vez cada M muestras
// esto funcinoa si conozco exactamente la frecuencia de lo que quiero medir 
// por ejemplo si la estoy generando
reg [31:0] counter_cont;
reg trigger_continuo_reg;

always @ (posedge clk)
begin  
    
    if(~reset_n || user_reset)
	begin
		counter_cont <= 0;
	end
	else if(data_valid)
	begin
		counter_cont <= ( counter_cont == M_reg-1 )? 0 : counter_cont + 1;
		trigger_continuo_reg = (counter_cont == M_reg-1)?1:0;
	end
    
end


// Segunda opcion de trigger
// aca me fijo cuando la se�al pasa un nivel y ahi la disparo
reg trigger_nivel_reg;
reg signed [31:0] data_in_reg;
reg [31:0] counter_level;

// Peque�a maquina de estados para evitar que dos trigger se habiliten muy juntos
// esto podr�a pasar por ruido por ejemplo
// por ahora lo soluciono asi capaz hay otro metodo mejor...
reg [2:0] state;
localparam idle=0,trigger_off=1;

always @ (posedge clk)
begin
    if(!reset_n || user_reset)
    begin
        state <= idle; 
        counter_level <= 0;
        trigger_nivel_reg <= 0;
        data_in_reg <= 0; 
    end       
    else 
    begin
      
        if(data_valid)
        begin    
        
          data_in_reg <= data_in;
    
          case(state)
            idle:
            begin
                counter_level <= 0;
                state <= ( (data_in > trigger_level_k_mult_div) && (data_in_reg <= trigger_level_k_mult_div) ) ? trigger_off : idle;
                trigger_nivel_reg <= ( (data_in > trigger_level_k_mult_div) && (data_in_reg <= trigger_level_k_mult_div) ) ? 1 : 0 ;
            end
            trigger_off:
            begin  
                trigger_nivel_reg <= 0;      
                counter_level <= counter_level +1;
                state <= (counter_level < M_reg/2)? trigger_off : idle;
            end
          endcase
       end
   end
end


// Tercera opcion de trigger: Trigger externo
reg trigger_ext_reg;
reg [2:0] state_ext; // Hago una maquina de estados parecida a la de recien para evitar que se disparen muy juntos dos trigger
reg [31:0] counter_ext;

always @(posedge clk)
begin
    
    if(!reset_n)
    begin
       trigger_ext_reg <= 0;            
       state_ext <= idle;  
       counter_ext <= 0;
    end
    else 
    begin
        case(state_ext)
              
             idle:
             begin
               counter_ext <= 0;
               trigger_ext_reg <= trig_externo;
               state_ext <= (trigger_ext_reg == 0) ? idle : trigger_off;          
             end
             trigger_off:
             begin
               if(data_valid)
               begin
                    counter_ext <= counter_ext +1;
                    trigger_ext_reg <= 0;      
               end
               state_ext <= (counter_ext < M_reg/2)? trigger_off : idle;

             end
        endcase
        
    end
end

wire trigger_continuo = trigger_continuo_reg;
wire trigger_nivel = trigger_nivel_reg; 
wire trigger_externo = trigger_ext_reg;
assign trig_cont_export = trigger_continuo_reg;
    
assign trig = (trigger_mode_reg == 0) ? trigger_continuo: ( (trigger_mode_reg == 1)? trigger_nivel: ( (trigger_mode_reg == 2)? trigger_externo : 0  ) );
 
endmodule

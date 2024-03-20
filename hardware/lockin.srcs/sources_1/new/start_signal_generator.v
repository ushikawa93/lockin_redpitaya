`timescale 1ns / 1ps

module start_signal_generator(

    input clk,
    input reset_n,
    
    input [13:0] data,
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
            signo_reg <= data[13];
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

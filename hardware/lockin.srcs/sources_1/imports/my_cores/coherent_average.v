
module coherent_average
#(
  parameter integer DATA_WIDTH = 32,
  parameter integer ADDR_WIDTH = 16,
  parameter integer N_CA_WIDTH = 32,
  parameter integer RAM_SIZE = 32768,
  parameter integer M_WIDTH = 16,
  parameter integer INDICES_ADDR = 10
  
  )
(
	input wire						  clk,
	input wire						  reset_n,	
	input wire                        user_reset,
	input wire                        trigger,
	
	input wire	[DATA_WIDTH-1:0] 	  data,
	input wire 						  data_valid,
	output wire 					  finished,
	
	input wire [N_CA_WIDTH-1:0]        N_ca_in,
	input wire [N_CA_WIDTH-1:0]        N_prom_lineal_in,
	
	// BRAM PORT A
	output wire                        bram_porta_clk,
	output wire                        bram_porta_rst,
	output wire [ADDR_WIDTH-1:0]  	   bram_porta_addr,
	output wire [DATA_WIDTH-1:0]       bram_porta_wrdata,
	input  wire [DATA_WIDTH-1:0]  	   bram_porta_rddata,
	output wire                        bram_porta_we,
	  
	// BRAM PORT B
	output wire                        bram_portb_clk,
	output wire                        bram_portb_rst,
	output wire [ADDR_WIDTH-1:0]  	   bram_portb_addr,
	output wire [DATA_WIDTH-1:0]  	   bram_portb_wrdata,
	input  wire [DATA_WIDTH-1:0]  	   bram_portb_rddata,
	output wire                        bram_portb_we,
	
	// BRAM extra para guardar los indices finales de cada ciclo de promediacion
	output wire [INDICES_ADDR-1:0]     bram_index_addr,
	output wire                        bram_index_clk,
	output wire [16:0]                 bram_index_data,
	output wire                        bram_index_enable


);

// Uso el puerto A de la ram para escribir y el B para leer

reg [DATA_WIDTH-1:0] data_reg;

reg [DATA_WIDTH-1:0] data_vieja;

reg [DATA_WIDTH-1:0] suma;

wire [DATA_WIDTH-1:0] data_to_write;

reg [DATA_WIDTH-1:0] wr_data;

wire [ADDR_WIDTH-1:0] address_read,address_write;

wire write_enable;

reg wr_enable,wr_enable_1,wr_enable_2,wr_enable_3;

reg [31:0] index,index_1,index_2,index_3,index_4;

reg [31:0] averaged_cycles;

reg [2:0] state;
parameter clean=0,wait_for_trigger=1,calculate=2,save_last_index=3,update_last_index_address=4,finish=5;

   
reg [N_CA_WIDTH-1:0] N_ca_reg;
    always @ (posedge clk) N_ca_reg <= N_ca_in;
    
reg [N_CA_WIDTH-1:0] N_prom_lineal_reg;
    always @ (posedge clk) N_prom_lineal_reg <= N_prom_lineal_in;
    
// Deteccion de flanco en la señal de trigger
wire flanco_trigger;
reg trigger_reg,data_valid_reg;

    always @ (posedge clk) 
        if(~reset_n || user_reset)
        begin
            trigger_reg <= 0;
        end
        else
        begin
            data_valid_reg <= data_valid;
            if(data_valid)
            begin               
                trigger_reg <= trigger;
            end
           
        end
        
assign flanco_trigger = (trigger_reg == 0) && (trigger ==1);

// Asignaciones a las RAM
assign bram_porta_clk = clk;
assign bram_porta_rst = ~reset_n;
assign bram_porta_wrdata = data_to_write ;
assign bram_porta_addr = address_write ;
assign bram_porta_we = write_enable ;

assign bram_portb_clk = clk;
assign bram_portb_rst = ~reset_n;
assign bram_portb_wrdata =  0;
assign bram_portb_addr = address_read ;
assign bram_portb_we = 0 ;

// Registros y asignaciones para la RAM donde guardo los indices:
reg bram_index_enable_reg;
reg [INDICES_ADDR-1:0] bram_index_addr_reg;
reg [31:0] bram_index_data_reg;

assign bram_index_clk = clk;
assign bram_index_enable = bram_index_enable_reg;
assign bram_index_addr = bram_index_addr_reg;
assign bram_index_data = bram_index_data_reg;

reg finished_reg;


always @ (posedge clk)
begin
	if(~reset_n || user_reset)
	begin

		data_reg <= 0;
		data_vieja <= 0;
		suma <= 0;
		wr_data <= 0;
		
		wr_enable <= 0;
		wr_enable_1 <= 0;
		wr_enable_2 <= 0;
		wr_enable_3 <= 0;
		
		index <= 0;
		index_1 <= 0;
		index_2 <= 0;
		index_3 <= 0;
		index_4 <= 0;
		
		averaged_cycles <= 0; 
		finished_reg <= 0;
		
		bram_index_addr_reg <= 0;
        bram_index_enable_reg <= 0;
        
		state <= clean;
	end
	else if (data_valid)
	begin
	
        case(state)
        
        clean:
        begin
           index_3 <= (index_3 + 1 ) ;
           index_4 <= (index_4 + 1 ) ;
           wr_data <= 0;
           wr_enable_2 <= 1;
           wr_enable_3 <= 1;
           finished_reg <= 0;
           
           bram_index_enable_reg <= 1;
           bram_index_addr_reg <= bram_index_addr_reg + 1;
           bram_index_data_reg <= 0;
           
           if(address_write == RAM_SIZE-1)
           begin
               state <= wait_for_trigger;
               index_3 <= 0;
               index_4 <= 0;
               wr_enable_2 <= 0;
               wr_enable_3 <= 0;
               bram_index_addr_reg <= 0;
               bram_index_enable_reg <= 0;
           end
           
        end
        
        
        wait_for_trigger:
        begin
          data_reg <= 0;
          data_vieja <= 0;
          suma <= 0;
          wr_data <= 0;
          
          index <= 0;
          index_1 <= 0;
          index_2 <= 0;
          index_3 <= 0;
          index_4 <= 0;
          
          wr_enable <= 0;
          wr_enable_1 <= 0;
          wr_enable_2 <= 0;
          finished_reg <= 0;
          bram_index_enable_reg <= 0;
          
           if(flanco_trigger)
           begin
               state <= calculate;
               averaged_cycles <= averaged_cycles + 1;
           end	   
        
        end
        
        
        calculate:	
        begin                    
                // FETCH
                data_reg <= data;
                data_vieja <= bram_portb_rddata;
                index <= index+1;
                wr_enable <= 1;   
                
                // ADD
                suma <= data_reg + data_vieja;
                index_1 <= index;
                wr_enable_1 <= wr_enable;
                               
                // SAVE
                wr_data <= suma;
                wr_enable_2 <= wr_enable_1;
                index_2 <= index_1;         
                        
                // EXTRA 1 -> Este es para que el indice empieze en 0 la primera vez que lo escribo!
                index_3 <= index_2;
                
                // Estos son solo necesarios en caso de que entre una muestra en TODOS los ciclos de reloj (N_prom_lineal = 1)
                wr_enable_3 <= wr_enable_2;
                index_4 <= index_3;  
                
                // Me llega el flanco y dejo de escribir.. debería en realidad escribir un par de muestras mas (terminar el pipeline...)
                //state <=  (flanco_trigger )? (( averaged_cycles == N_ca_reg )? finish : wait_for_trigger) : calculate ;        
                state <=  (flanco_trigger )? save_last_index : calculate ;   
          end
          save_last_index:
          begin
            wr_enable <= 0;
            wr_enable_1 <= 0;
            wr_enable_2 <= 0;
            finished_reg <= 0;
            
            bram_index_data_reg <= address_write;
            bram_index_enable_reg <= 1;
            
            state <= update_last_index_address;

          end
          
          update_last_index_address:
          begin
              
            bram_index_addr_reg <= bram_index_addr_reg + 1;   
            bram_index_enable_reg <= 0;
            
            state <=  ( averaged_cycles == N_ca_reg ) ? finish : wait_for_trigger;

          end
          
          finish:
          begin		
                wr_enable <= 0;
                wr_enable_1 <= 0;
                wr_enable_2 <= 0;
                wr_enable_3 <= 0;
                finished_reg <= 1;
          end		  
        endcase
	end
end

assign address_read = index;
assign data_to_write = wr_data;

// Si esto esta andando a maxima velocidad N_prom_lineal = 1 la cosa anda un toque distinto que si tengo algun ciclo en el medio para "pensar" por eso este cacho de codigo
reg max_velocidad;

always @ (posedge clk)
begin

    if(!reset_n)
    begin
        max_velocidad <= 0;
    end
    else
    begin
        max_velocidad <= (N_prom_lineal_reg == 1)? 1:0;
    end
    
end


assign write_enable = (max_velocidad)? ( (wr_enable_3) && (data_valid_reg) ) : ( (wr_enable_2) && (data_valid_reg) );
assign address_write = (max_velocidad)? index_4 :  index_3;
assign finished = finished_reg;

endmodule

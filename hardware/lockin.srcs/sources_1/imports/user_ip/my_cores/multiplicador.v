
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2023 13:54:12
// Design Name: 
// Module Name: level_detector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module level_detector(
    input clk,
    input reset_n,
    input signed [31:0] level_to_detect,
    
    input signed [13:0] data_in_1,
    input data_in_1_valid,
    
    input signed [13:0] data_in_2,
    input data_in_2_valid,
    
    
    output level_detected_0,
    output level_detected_1
    );
    

reg level_detected_1_reg;
reg level_detected_2_reg;

reg signed [31:0] level;

reg signed [13:0] data_in_1_reg;
reg signed [13:0] data_in_2_reg;

always @ (posedge clk)
begin

    if (!reset_n)
    begin
        level_detected_1_reg <= 0;
        level_detected_2_reg <= 0;
        level <= 0;
        data_in_1_reg <= 0;
        data_in_2_reg <= 0;
    end
    else
    begin
        
        level <= level_to_detect;
        
        if(data_in_1_valid)
        begin
            data_in_1_reg <= data_in_1;    
            level_detected_1_reg <= (data_in_1_reg > level) ? 1 : 0;        
        end
        
        if(data_in_2_valid)
        begin
            data_in_2_reg <= data_in_2;    
            level_detected_2_reg <= (data_in_2_reg > level) ? 1 : 0;        
        end
        
    end
    

end

assign level_detected_0 = level_detected_1_reg;
assign level_detected_1 = level_detected_2_reg;   
    
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2023 15:19:53
// Design Name: 
// Module Name: drive_leds
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


module drive_leds(
    
    input signal_0,
    input signal_1,
    input signal_2,
    input signal_3,
    input signal_4,
    input signal_5,
    input signal_6,
    input signal_7,
    
    output [7:0] signal_out
    
    

    );
    
assign signal_out = { signal_7,signal_6,signal_5,signal_4,signal_3,signal_2,signal_1,signal_0};
endmodule

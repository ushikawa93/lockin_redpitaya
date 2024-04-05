// (c) Copyright 1995-2024 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:signal_processing_LI:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_signal_processing_LI_0_0 (
  clk,
  reset_n,
  enable_gral,
  referencia_externa_seno,
  referencia_externa_cos,
  referencia_externa_valid,
  data_in,
  data_in_valid,
  start_signal,
  data_out_fase,
  data_out_fase_valid,
  data_out_cuad,
  data_out_cuad_valid,
  ready_to_calculate,
  processing_finished,
  datos_promediados,
  parameter_in_0,
  parameter_in_1
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_axis_red_pitaya_adc_0_0_adc_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *)
input wire reset_n;
input wire enable_gral;
input wire [13 : 0] referencia_externa_seno;
input wire [13 : 0] referencia_externa_cos;
input wire referencia_externa_valid;
input wire [31 : 0] data_in;
input wire data_in_valid;
input wire start_signal;
output wire [63 : 0] data_out_fase;
output wire data_out_fase_valid;
output wire [63 : 0] data_out_cuad;
output wire data_out_cuad_valid;
output wire ready_to_calculate;
output wire processing_finished;
output wire [31 : 0] datos_promediados;
input wire [31 : 0] parameter_in_0;
input wire [31 : 0] parameter_in_1;

  signal_processing_LI inst (
    .clk(clk),
    .reset_n(reset_n),
    .enable_gral(enable_gral),
    .referencia_externa_seno(referencia_externa_seno),
    .referencia_externa_cos(referencia_externa_cos),
    .referencia_externa_valid(referencia_externa_valid),
    .data_in(data_in),
    .data_in_valid(data_in_valid),
    .start_signal(start_signal),
    .data_out_fase(data_out_fase),
    .data_out_fase_valid(data_out_fase_valid),
    .data_out_cuad(data_out_cuad),
    .data_out_cuad_valid(data_out_cuad_valid),
    .ready_to_calculate(ready_to_calculate),
    .processing_finished(processing_finished),
    .datos_promediados(datos_promediados),
    .parameter_in_0(parameter_in_0),
    .parameter_in_1(parameter_in_1)
  );
endmodule

// (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
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


// IP VLNV: xilinx.com:module_ref:coherent_average:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_coherent_average_0_0 (
  clk,
  reset_n,
  user_reset,
  trigger,
  data,
  data_valid,
  finished,
  N_ca_in,
  N_prom_lineal_in,
  bram_porta_clk,
  bram_porta_rst,
  bram_porta_addr,
  bram_porta_wrdata,
  bram_porta_rddata,
  bram_porta_we,
  bram_portb_clk,
  bram_portb_rst,
  bram_portb_addr,
  bram_portb_wrdata,
  bram_portb_rddata,
  bram_portb_we,
  bram_index_addr,
  bram_index_clk,
  bram_index_data,
  bram_index_enable
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_axis_red_pitaya_adc_0_0_adc_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *)
input wire reset_n;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME user_reset, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 user_reset RST" *)
input wire user_reset;
input wire trigger;
input wire [31 : 0] data;
input wire data_valid;
output wire finished;
input wire [31 : 0] N_ca_in;
input wire [31 : 0] N_prom_lineal_in;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta CLK" *)
output wire bram_porta_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta RST" *)
output wire bram_porta_rst;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta ADDR" *)
output wire [15 : 0] bram_porta_addr;
output wire [31 : 0] bram_porta_wrdata;
input wire [31 : 0] bram_porta_rddata;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta WE" *)
output wire bram_porta_we;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb CLK" *)
output wire bram_portb_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb RST" *)
output wire bram_portb_rst;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb ADDR" *)
output wire [15 : 0] bram_portb_addr;
output wire [31 : 0] bram_portb_wrdata;
input wire [31 : 0] bram_portb_rddata;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb WE" *)
output wire bram_portb_we;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_index ADDR" *)
output wire [9 : 0] bram_index_addr;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_index CLK" *)
output wire bram_index_clk;
output wire [16 : 0] bram_index_data;
output wire bram_index_enable;

  coherent_average #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(16),
    .N_CA_WIDTH(32),
    .RAM_SIZE(32768),
    .M_WIDTH(16),
    .INDICES_ADDR(10)
  ) inst (
    .clk(clk),
    .reset_n(reset_n),
    .user_reset(user_reset),
    .trigger(trigger),
    .data(data),
    .data_valid(data_valid),
    .finished(finished),
    .N_ca_in(N_ca_in),
    .N_prom_lineal_in(N_prom_lineal_in),
    .bram_porta_clk(bram_porta_clk),
    .bram_porta_rst(bram_porta_rst),
    .bram_porta_addr(bram_porta_addr),
    .bram_porta_wrdata(bram_porta_wrdata),
    .bram_porta_rddata(bram_porta_rddata),
    .bram_porta_we(bram_porta_we),
    .bram_portb_clk(bram_portb_clk),
    .bram_portb_rst(bram_portb_rst),
    .bram_portb_addr(bram_portb_addr),
    .bram_portb_wrdata(bram_portb_wrdata),
    .bram_portb_rddata(bram_portb_rddata),
    .bram_portb_we(bram_portb_we),
    .bram_index_addr(bram_index_addr),
    .bram_index_clk(bram_index_clk),
    .bram_index_data(bram_index_data),
    .bram_index_enable(bram_index_enable)
  );
endmodule

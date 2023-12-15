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


// IP VLNV: xilinx.com:user:bram_switch:1.0
// IP Revision: 6

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_bram_switch_0_1 (
  switch,
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
  bram_portc_clk,
  bram_portc_rst,
  bram_portc_addr,
  bram_portc_wrdata,
  bram_portc_rddata,
  bram_portc_we
);

input wire switch;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta CLK" *)
input wire bram_porta_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta RST" *)
input wire bram_porta_rst;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta ADDR" *)
input wire [14 : 0] bram_porta_addr;
input wire [31 : 0] bram_porta_wrdata;
output wire [31 : 0] bram_porta_rddata;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_porta WE" *)
input wire bram_porta_we;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb CLK" *)
input wire bram_portb_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb RST" *)
input wire bram_portb_rst;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb ADDR" *)
input wire [14 : 0] bram_portb_addr;
input wire [31 : 0] bram_portb_wrdata;
output wire [31 : 0] bram_portb_rddata;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portb WE" *)
input wire bram_portb_we;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portc CLK" *)
output wire bram_portc_clk;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portc RST" *)
output wire bram_portc_rst;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portc ADDR" *)
output wire [14 : 0] bram_portc_addr;
output wire [31 : 0] bram_portc_wrdata;
input wire [31 : 0] bram_portc_rddata;
(* X_INTERFACE_INFO = "xilinx.com:user:BRAM:1.0 bram_portc WE" *)
output wire bram_portc_we;

  bram_switch #(
    .BRAM_DATA_WIDTH(32),
    .BRAM_ADDR_WIDTH(15)
  ) inst (
    .switch(switch),
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
    .bram_portc_clk(bram_portc_clk),
    .bram_portc_rst(bram_portc_rst),
    .bram_portc_addr(bram_portc_addr),
    .bram_portc_wrdata(bram_portc_wrdata),
    .bram_portc_rddata(bram_portc_rddata),
    .bram_portc_we(bram_portc_we)
  );
endmodule

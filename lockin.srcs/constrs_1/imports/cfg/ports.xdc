set_property PACKAGE_PIN V16 [get_ports {adc_dat_a_i[13]}]
set_property PACKAGE_PIN W16 [get_ports {adc_dat_a_i[1]}]
set_property PACKAGE_PIN Y16 [get_ports {adc_dat_a_i[2]}]
set_property PACKAGE_PIN W15 [get_ports {adc_dat_a_i[3]}]
set_property PACKAGE_PIN W14 [get_ports {adc_dat_a_i[4]}]
set_property PACKAGE_PIN Y14 [get_ports {adc_dat_a_i[5]}]
set_property PACKAGE_PIN W13 [get_ports {adc_dat_a_i[6]}]
set_property PACKAGE_PIN V12 [get_ports {adc_dat_a_i[7]}]
set_property PACKAGE_PIN V13 [get_ports {adc_dat_a_i[8]}]
set_property PACKAGE_PIN Y17 [get_ports {adc_dat_a_i[0]}]
set_property PACKAGE_PIN T15 [get_ports {adc_dat_a_i[10]}]
set_property PACKAGE_PIN V15 [get_ports {adc_dat_a_i[11]}]
set_property PACKAGE_PIN T16 [get_ports {adc_dat_a_i[12]}]
set_property PACKAGE_PIN T14 [get_ports {adc_dat_a_i[9]}]
set_property PACKAGE_PIN Y18 [get_ports {adc_dat_b_i[13]}]
set_property PACKAGE_PIN P16 [get_ports {adc_dat_b_i[1]}]
set_property PACKAGE_PIN P18 [get_ports {adc_dat_b_i[2]}]
set_property PACKAGE_PIN N17 [get_ports {adc_dat_b_i[3]}]
set_property PACKAGE_PIN R19 [get_ports {adc_dat_b_i[4]}]
set_property PACKAGE_PIN T20 [get_ports {adc_dat_b_i[5]}]
set_property PACKAGE_PIN T19 [get_ports {adc_dat_b_i[6]}]
set_property PACKAGE_PIN U20 [get_ports {adc_dat_b_i[7]}]
set_property PACKAGE_PIN V20 [get_ports {adc_dat_b_i[8]}]
set_property PACKAGE_PIN R18 [get_ports {adc_dat_b_i[0]}]
set_property PACKAGE_PIN W19 [get_ports {adc_dat_b_i[10]}]
set_property PACKAGE_PIN Y19 [get_ports {adc_dat_b_i[11]}]
set_property PACKAGE_PIN W18 [get_ports {adc_dat_b_i[12]}]
set_property PACKAGE_PIN W20 [get_ports {adc_dat_b_i[9]}]

# set_property CFGBVS VCCO [current_design]
# set_property CONFIG_VOLTAGE 3.3 [current_design]

### ADC

# data

set_property IOSTANDARD LVCMOS18 [get_ports {adc_dat_a_i[*]}]
set_property IOB TRUE [get_ports {adc_dat_a_i[*]}]


set_property IOSTANDARD LVCMOS18 [get_ports {adc_dat_b_i[*]}]
set_property IOB TRUE [get_ports {adc_dat_b_i[*]}]


# clock input

set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports adc_clk_p_i]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports adc_clk_n_i]
set_property PACKAGE_PIN U18 [get_ports adc_clk_p_i]
set_property PACKAGE_PIN U19 [get_ports adc_clk_n_i]

# clock output

set_property IOSTANDARD LVCMOS18 [get_ports adc_enc_p_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_enc_n_o]

set_property SLEW FAST [get_ports adc_enc_p_o]
set_property SLEW FAST [get_ports adc_enc_n_o]

set_property DRIVE 8 [get_ports adc_enc_p_o]
set_property DRIVE 8 [get_ports adc_enc_n_o]

set_property PACKAGE_PIN N20 [get_ports adc_enc_p_o]
set_property PACKAGE_PIN P20 [get_ports adc_enc_n_o]

# clock duty cycle stabilizer (CSn)

set_property IOSTANDARD LVCMOS18 [get_ports adc_csn_o]
set_property PACKAGE_PIN V18 [get_ports adc_csn_o]
set_property SLEW FAST [get_ports adc_csn_o]
set_property DRIVE 8 [get_ports adc_csn_o]

### DAC

# data

set_property IOSTANDARD LVCMOS33 [get_ports {dac_dat_o[*]}]
set_property SLEW FAST [get_ports {dac_dat_o[*]}]
set_property DRIVE 8 [get_ports {dac_dat_o[*]}]
# set_property IOB TRUE [get_ports {dac_dat_o[*]}]

set_property PACKAGE_PIN M19 [get_ports {dac_dat_o[0]}]
set_property PACKAGE_PIN M20 [get_ports {dac_dat_o[1]}]
set_property PACKAGE_PIN L19 [get_ports {dac_dat_o[2]}]
set_property PACKAGE_PIN L20 [get_ports {dac_dat_o[3]}]
set_property PACKAGE_PIN K19 [get_ports {dac_dat_o[4]}]
set_property PACKAGE_PIN J19 [get_ports {dac_dat_o[5]}]
set_property PACKAGE_PIN J20 [get_ports {dac_dat_o[6]}]
set_property PACKAGE_PIN H20 [get_ports {dac_dat_o[7]}]
set_property PACKAGE_PIN G19 [get_ports {dac_dat_o[8]}]
set_property PACKAGE_PIN G20 [get_ports {dac_dat_o[9]}]
set_property PACKAGE_PIN F19 [get_ports {dac_dat_o[10]}]
set_property PACKAGE_PIN F20 [get_ports {dac_dat_o[11]}]
set_property PACKAGE_PIN D20 [get_ports {dac_dat_o[12]}]
set_property PACKAGE_PIN D19 [get_ports {dac_dat_o[13]}]

# control

set_property IOSTANDARD LVCMOS33 [get_ports dac_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_rst_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_sel_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_wrt_o]
set_property SLEW FAST [get_ports dac_*_o]
set_property DRIVE 8 [get_ports dac_clk_o]
set_property DRIVE 8 [get_ports dac_rst_o]
set_property DRIVE 8 [get_ports dac_sel_o]
set_property DRIVE 8 [get_ports dac_wrt_o]
# set_property IOB TRUE [get_ports {dac_*_o}]

set_property PACKAGE_PIN M17 [get_ports dac_wrt_o]
set_property PACKAGE_PIN N16 [get_ports dac_sel_o]
set_property PACKAGE_PIN M18 [get_ports dac_clk_o]
set_property PACKAGE_PIN N15 [get_ports dac_rst_o]

### PWM

set_property IOSTANDARD LVCMOS18 [get_ports {dac_pwm_o[*]}]
set_property SLEW FAST [get_ports {dac_pwm_o[*]}]
set_property DRIVE 12 [get_ports {dac_pwm_o[*]}]
# set_property IOB TRUE [get_ports {dac_pwm_o[*]}]

set_property PACKAGE_PIN T10 [get_ports {dac_pwm_o[0]}]
set_property PACKAGE_PIN T11 [get_ports {dac_pwm_o[1]}]
set_property PACKAGE_PIN P15 [get_ports {dac_pwm_o[2]}]
set_property PACKAGE_PIN U13 [get_ports {dac_pwm_o[3]}]

### XADC



### Expansion connector

set_property IOSTANDARD LVCMOS33 [get_ports {exp_p_tri_io[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {exp_n_tri_io[*]}]
set_property SLEW FAST [get_ports {exp_p_tri_io[*]}]
set_property SLEW FAST [get_ports {exp_n_tri_io[*]}]
set_property DRIVE 8 [get_ports {exp_p_tri_io[*]}]
set_property DRIVE 8 [get_ports {exp_n_tri_io[*]}]
set_property PULLUP true [get_ports {exp_p_tri_io[7]}]
set_property PULLUP true [get_ports {exp_p_tri_io[6]}]
set_property PULLUP true [get_ports {exp_p_tri_io[5]}]
set_property PULLUP true [get_ports {exp_p_tri_io[4]}]
set_property PULLUP true [get_ports {exp_p_tri_io[3]}]
set_property PULLUP true [get_ports {exp_p_tri_io[2]}]
set_property PULLUP true [get_ports {exp_p_tri_io[1]}]
set_property PULLUP true [get_ports {exp_p_tri_io[0]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[7]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[6]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[5]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[4]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[3]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[2]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[1]}]
set_property PULLDOWN  true [get_ports {exp_n_tri_io[0]}]

set_property PACKAGE_PIN G17 [get_ports {exp_p_tri_io[0]}]
set_property PACKAGE_PIN G18 [get_ports {exp_n_tri_io[0]}]
set_property PACKAGE_PIN H16 [get_ports {exp_p_tri_io[1]}]
set_property PACKAGE_PIN H17 [get_ports {exp_n_tri_io[1]}]
set_property PACKAGE_PIN J18 [get_ports {exp_p_tri_io[2]}]
set_property PACKAGE_PIN H18 [get_ports {exp_n_tri_io[2]}]
set_property PACKAGE_PIN K17 [get_ports {exp_p_tri_io[3]}]
set_property PACKAGE_PIN K18 [get_ports {exp_n_tri_io[3]}]
set_property PACKAGE_PIN L14 [get_ports {exp_p_tri_io[4]}]
set_property PACKAGE_PIN L15 [get_ports {exp_n_tri_io[4]}]
set_property PACKAGE_PIN L16 [get_ports {exp_p_tri_io[5]}]
set_property PACKAGE_PIN L17 [get_ports {exp_n_tri_io[5]}]
set_property PACKAGE_PIN K16 [get_ports {exp_p_tri_io[6]}]
set_property PACKAGE_PIN J16 [get_ports {exp_n_tri_io[6]}]
set_property PACKAGE_PIN M14 [get_ports {exp_p_tri_io[7]}]
set_property PACKAGE_PIN M15 [get_ports {exp_n_tri_io[7]}]





### SATA connector

set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_p_o[*]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_n_o[*]}]

set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_p_i[*]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_n_i[*]}]

set_property PACKAGE_PIN T12 [get_ports {daisy_p_o[0]}]
set_property PACKAGE_PIN U12 [get_ports {daisy_n_o[0]}]

set_property PACKAGE_PIN U14 [get_ports {daisy_p_o[1]}]
set_property PACKAGE_PIN U15 [get_ports {daisy_n_o[1]}]

set_property PACKAGE_PIN P14 [get_ports {daisy_p_i[0]}]
set_property PACKAGE_PIN R14 [get_ports {daisy_n_i[0]}]

set_property PACKAGE_PIN N18 [get_ports {daisy_p_i[1]}]
set_property PACKAGE_PIN P19 [get_ports {daisy_n_i[1]}]

### LED

set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
set_property SLEW SLOW [get_ports {led_o[*]}]
set_property DRIVE 8 [get_ports {led_o[*]}]

set_property PACKAGE_PIN F16 [get_ports {led_o[0]}]
set_property PACKAGE_PIN F17 [get_ports {led_o[1]}]
set_property PACKAGE_PIN G15 [get_ports {led_o[2]}]
set_property PACKAGE_PIN H15 [get_ports {led_o[3]}]
set_property PACKAGE_PIN K14 [get_ports {led_o[4]}]
set_property PACKAGE_PIN G14 [get_ports {led_o[5]}]
set_property PACKAGE_PIN J15 [get_ports {led_o[6]}]
set_property PACKAGE_PIN J14 [get_ports {led_o[7]}]

set_property BEL A6LUT [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer[25]_i_2_comp}]
set_property BEL C6LUT [get_cells {system_i/BRAM2/bram_switch_0/inst/bram_porta_rddata[22]_INST_0}]
set_property BEL C6LUT [get_cells {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/doutb[22]_INST_0_i_2}]
set_property BEL CFF [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[25]}]
set_property BEL F7BMUX [get_cells {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/doutb[22]_INST_0}]
set_property BEL D6LUT [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer[25]_i_1_comp}]
set_property LOC RAMB36_X0Y15 [get_cells {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[17].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram}]
set_property LOC SLICE_X18Y32 [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer[25]_i_2_comp}]
set_property LOC SLICE_X18Y32 [get_cells {system_i/BRAM2/bram_switch_0/inst/bram_porta_rddata[22]_INST_0}]
set_property LOC SLICE_X19Y45 [get_cells {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/doutb[22]_INST_0_i_2}]
set_property LOC SLICE_X20Y26 [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[25]}]
set_property LOC SLICE_X19Y45 [get_cells {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/doutb[22]_INST_0}]
set_property LOC SLICE_X21Y26 [get_cells {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer[25]_i_1_comp}]

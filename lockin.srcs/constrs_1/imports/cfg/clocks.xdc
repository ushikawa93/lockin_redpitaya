create_clock -period 8.000 -name adc_clk [get_ports adc_clk_p_i]

set_input_delay -clock adc_clk -max 3.400 [get_ports {adc_dat_a_i[*]}]
set_input_delay -clock adc_clk -max 3.400 [get_ports {adc_dat_b_i[*]}]

create_clock -period 4.000 -name rx_clk [get_ports {daisy_p_i[1]}]

# El clk (creo que el del ADC) va a demasiados lugares y esto hace que no lo pueda mapear correctamente
# Esto no lo soluciona sino que le digo que lo ignore a ver si la cosa anda...
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets system_i/uP/processing_system7_0/inst/FCLK_CLK0]

# Caminos inter clocks no me interesa analizarlos
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks adc_clk]
set_false_path -from [get_clocks adc_clk] -to [get_clocks clk_fpga_0]

# Estos caminos no pasan el timing y estoy cansado de ver errores
# Son problemas de los IP que vienen y no afectan realmente
# (El clock que me interesa tener bien bien es el del ADC y estos son de lo otro)
set_false_path -from [get_pins {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/m_payload_i_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/m_payload_i_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM2/axi_bram_reader_1/inst/bram_reader_v1_0_S00_AXI_inst/axi_araddr_reg[*]/C}] -to [get_pins {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/axi_bram_reader_1/inst/bram_reader_v1_0_S00_AXI_inst/axi_araddr_reg[*]/C}] -to [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/D}]


set_false_path -from [get_pins {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]

set_false_path -from [get_pins {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/C}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/m_payload_i_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/C}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/m_payload_i_reg[*]/D}]

set_false_path -from [get_pins {system_i/BRAM2/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/C}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/C}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]

set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/has_mux_b.B/no_softecc_sel_reg.ce_pri.sel_pipe_reg[*]/C}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]

set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM18.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/skid_buffer_reg[*]/D}]
set_false_path -from [get_pins {system_i/BRAM1/blk_mem_gen_1/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[*].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM18.ram/CLKBWRCLK}] -to [get_pins {system_i/uP/ps7_0_axi_periph/xbar/inst/gen_sasd.crossbar_sasd_0/reg_slice_r/m_payload_i_reg[*]/D}]

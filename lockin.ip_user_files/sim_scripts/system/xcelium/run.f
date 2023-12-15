-makelib xcelium_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_util_ds_buf_1_0/util_ds_buf.vhd" \
  "../../../bd/system/ip/system_util_ds_buf_1_0/sim/system_util_ds_buf_1_0.vhd" \
  "../../../bd/system/ip/system_util_ds_buf_2_0/sim/system_util_ds_buf_2_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ipshared/412c/src/axis_red_pitaya_dac.v" \
  "../../../bd/system/ip/system_axis_red_pitaya_dac_0_0/sim/system_axis_red_pitaya_dac_0_0.v" \
-endlib
-makelib xcelium_lib/xbip_utils_v3_0_10 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/364f/hdl/xbip_utils_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_utils_v2_0_6 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/1971/hdl/axi_utils_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_pipe_v3_0_6 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/7468/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_bram18k_v3_0_6 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/d367/hdl/xbip_bram18k_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/mult_gen_v12_0_18 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/ab19/hdl/mult_gen_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_dsp48_wrapper_v3_0_4 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/cdbf/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_dsp48_addsub_v3_0_6 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/910d/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_dsp48_multadd_v3_0_6 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/b0ac/hdl/xbip_dsp48_multadd_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/dds_compiler_v6_0_22 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/a99f/hdl/dds_compiler_v6_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_dds_compiler_0_0/sim/system_dds_compiler_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0.v" \
  "../../../bd/system/ipshared/aae3/src/axis_constant.v" \
  "../../../bd/system/ip/system_axis_constant_0_0/sim/system_axis_constant_0_0.v" \
-endlib
-makelib xcelium_lib/xlslice_v1_0_2 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/11d0/hdl/xlslice_v1_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xlslice_0_2/sim/system_xlslice_0_2.v" \
  "../../../bd/system/ip/system_xlslice_1_0/sim/system_xlslice_1_0.v" \
  "../../../bd/system/ip/system_xlslice_0_0/sim/system_xlslice_0_0.v" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_gpio_v2_0_29 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/6219/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_axi_gpio_0_0/sim/system_axi_gpio_0_0.vhd" \
  "../../../bd/system/ip/system_axi_gpio_1_0/sim/system_axi_gpio_1_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xlslice_0_3/sim/system_xlslice_0_3.v" \
  "../../../bd/system/ip/system_xlslice_0_1/sim/system_xlslice_0_1.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_axi_gpio_0_2/sim/system_axi_gpio_0_2.vhd" \
  "../../../bd/system/ip/system_axi_gpio_0_1/sim/system_axi_gpio_0_1.vhd" \
  "../../../bd/system/ip/system_Control_and_Nca_0/sim/system_Control_and_Nca_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xlslice_0_4/sim/system_xlslice_0_4.v" \
  "../../../bd/system/ip/system_xlslice_0_5/sim/system_xlslice_0_5.v" \
  "../../../bd/system/ip/system_N_prom_lineal_0/sim/system_N_prom_lineal_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_Trigger_0/sim/system_Trigger_0.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_15 -sv \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_processing_system7_0_0/sim/system_processing_system7_0_0.v" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_rst_ps7_0_125M_0/sim/system_rst_ps7_0_125M_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xbar_0/sim/system_xbar_0.v" \
  "../../../bd/system/ipshared/7cca/src/axis_red_pitaya_adc.v" \
  "../../../bd/system/ip/system_axis_red_pitaya_adc_0_0/sim/system_axis_red_pitaya_adc_0_0.v" \
  "../../../bd/system/ip/system_signal_split_0_0/sim/system_signal_split_0_0.v" \
  "../../../bd/system/ip/system_promedio_lineal_0_0/sim/system_promedio_lineal_0_0.v" \
  "../../../bd/system/ip/system_coherent_average_0_0/sim/system_coherent_average_0_0.v" \
  "../../../bd/system/ip/system_promedio_lineal_0_1/sim/system_promedio_lineal_0_1.v" \
  "../../../bd/system/ip/system_coherent_average_0_1/sim/system_coherent_average_0_1.v" \
  "../../../bd/system/ipshared/6db2/src/axi_bram_reader.v" \
  "../../../bd/system/ipshared/6db2/src/bram_reader_v1_0_S00_AXI.v" \
  "../../../bd/system/ip/system_axi_bram_reader_1_1/sim/system_axi_bram_reader_1_1.v" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_blk_mem_gen_1_1/sim/system_blk_mem_gen_1_1.v" \
  "../../../bd/system/ipshared/a281/src/bram_switch.v" \
  "../../../bd/system/ip/system_bram_switch_0_1/sim/system_bram_switch_0_1.v" \
  "../../../bd/system/ip/system_axi_bram_reader_1_2/sim/system_axi_bram_reader_1_2.v" \
  "../../../bd/system/ip/system_bram_switch_0_2/sim/system_bram_switch_0_2.v" \
  "../../../bd/system/ip/system_level_detector_0_0/sim/system_level_detector_0_0.v" \
  "../../../bd/system/ip/system_trigger_simulator_0_0_1/sim/system_trigger_simulator_0_0.v" \
  "../../../bd/system/ip/system_drive_leds_0_0/sim/system_drive_leds_0_0.v" \
  "../../../bd/system/ip/system_axi_bram_reader_0_0/sim/system_axi_bram_reader_0_0.v" \
  "../../../bd/system/ip/system_blk_mem_gen_0_1/sim/system_blk_mem_gen_0_1.v" \
  "../../../bd/system/ip/system_drive_gpios_0_0/sim/system_drive_gpios_0_0.v" \
  "../../../bd/system/ip/system_drive_gpios_0_1/sim/system_drive_gpios_0_1.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../adquisidor.gen/sources_1/bd/system/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system/ip/system_auto_pc_0/sim/system_auto_pc_0.v" \
  "../../../bd/system/sim/system.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib


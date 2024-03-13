vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xbip_utils_v3_0_10
vlib modelsim_lib/msim/axi_utils_v2_0_6
vlib modelsim_lib/msim/xbip_pipe_v3_0_6
vlib modelsim_lib/msim/xbip_bram18k_v3_0_6
vlib modelsim_lib/msim/mult_gen_v12_0_18
vlib modelsim_lib/msim/xbip_dsp48_wrapper_v3_0_4
vlib modelsim_lib/msim/xbip_dsp48_addsub_v3_0_6
vlib modelsim_lib/msim/xbip_dsp48_multadd_v3_0_6
vlib modelsim_lib/msim/dds_compiler_v6_0_22
vlib modelsim_lib/msim/xlslice_v1_0_2
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/interrupt_control_v3_1_4
vlib modelsim_lib/msim/axi_gpio_v2_0_29
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_13
vlib modelsim_lib/msim/processing_system7_vip_v1_0_15
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_27
vlib modelsim_lib/msim/fifo_generator_v13_2_7
vlib modelsim_lib/msim/axi_data_fifo_v2_1_26
vlib modelsim_lib/msim/axi_crossbar_v2_1_28
vlib modelsim_lib/msim/blk_mem_gen_v8_4_5
vlib modelsim_lib/msim/axi_protocol_converter_v2_1_27

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xbip_utils_v3_0_10 modelsim_lib/msim/xbip_utils_v3_0_10
vmap axi_utils_v2_0_6 modelsim_lib/msim/axi_utils_v2_0_6
vmap xbip_pipe_v3_0_6 modelsim_lib/msim/xbip_pipe_v3_0_6
vmap xbip_bram18k_v3_0_6 modelsim_lib/msim/xbip_bram18k_v3_0_6
vmap mult_gen_v12_0_18 modelsim_lib/msim/mult_gen_v12_0_18
vmap xbip_dsp48_wrapper_v3_0_4 modelsim_lib/msim/xbip_dsp48_wrapper_v3_0_4
vmap xbip_dsp48_addsub_v3_0_6 modelsim_lib/msim/xbip_dsp48_addsub_v3_0_6
vmap xbip_dsp48_multadd_v3_0_6 modelsim_lib/msim/xbip_dsp48_multadd_v3_0_6
vmap dds_compiler_v6_0_22 modelsim_lib/msim/dds_compiler_v6_0_22
vmap xlslice_v1_0_2 modelsim_lib/msim/xlslice_v1_0_2
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap interrupt_control_v3_1_4 modelsim_lib/msim/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_29 modelsim_lib/msim/axi_gpio_v2_0_29
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_13 modelsim_lib/msim/axi_vip_v1_1_13
vmap processing_system7_vip_v1_0_15 modelsim_lib/msim/processing_system7_vip_v1_0_15
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_27 modelsim_lib/msim/axi_register_slice_v2_1_27
vmap fifo_generator_v13_2_7 modelsim_lib/msim/fifo_generator_v13_2_7
vmap axi_data_fifo_v2_1_26 modelsim_lib/msim/axi_data_fifo_v2_1_26
vmap axi_crossbar_v2_1_28 modelsim_lib/msim/axi_crossbar_v2_1_28
vmap blk_mem_gen_v8_4_5 modelsim_lib/msim/blk_mem_gen_v8_4_5
vmap axi_protocol_converter_v2_1_27 modelsim_lib/msim/axi_protocol_converter_v2_1_27

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_util_ds_buf_1_0/util_ds_buf.vhd" \
"../../../bd/system/ip/system_util_ds_buf_1_0/sim/system_util_ds_buf_1_0.vhd" \
"../../../bd/system/ip/system_util_ds_buf_2_0/sim/system_util_ds_buf_2_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ipshared/412c/src/axis_red_pitaya_dac.v" \
"../../../bd/system/ip/system_axis_red_pitaya_dac_0_0/sim/system_axis_red_pitaya_dac_0_0.v" \

vcom -work xbip_utils_v3_0_10  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/364f/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_6  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/1971/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_6  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/7468/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_bram18k_v3_0_6  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/d367/hdl/xbip_bram18k_v3_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_18  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/ab19/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_4  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/cdbf/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_addsub_v3_0_6  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/910d/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_multadd_v3_0_6  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/b0ac/hdl/xbip_dsp48_multadd_v3_0_vh_rfs.vhd" \

vcom -work dds_compiler_v6_0_22  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/a99f/hdl/dds_compiler_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_dds_compiler_0_0/sim/system_dds_compiler_0_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0.v" \
"../../../bd/system/ipshared/aae3/src/axis_constant.v" \
"../../../bd/system/ip/system_axis_constant_0_0/sim/system_axis_constant_0_0.v" \

vlog -work xlslice_v1_0_2  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/11d0/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_xlslice_0_2/sim/system_xlslice_0_2.v" \
"../../../bd/system/ip/system_xlslice_1_0/sim/system_xlslice_1_0.v" \
"../../../bd/system/ip/system_xlslice_0_0/sim/system_xlslice_0_0.v" \

vcom -work axi_lite_ipif_v3_0_4  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_2  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_4  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_29  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/6219/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_axi_gpio_0_0/sim/system_axi_gpio_0_0.vhd" \
"../../../bd/system/ip/system_axi_gpio_1_0/sim/system_axi_gpio_1_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_xlslice_0_3/sim/system_xlslice_0_3.v" \
"../../../bd/system/ip/system_xlslice_0_1/sim/system_xlslice_0_1.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_axi_gpio_0_2/sim/system_axi_gpio_0_2.vhd" \
"../../../bd/system/ip/system_axi_gpio_0_1/sim/system_axi_gpio_0_1.vhd" \
"../../../bd/system/ip/system_Control_and_Nca_0/sim/system_Control_and_Nca_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_xlslice_0_4/sim/system_xlslice_0_4.v" \
"../../../bd/system/ip/system_xlslice_0_5/sim/system_xlslice_0_5.v" \
"../../../bd/system/ip/system_N_prom_lineal_0/sim/system_N_prom_lineal_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_Trigger_0/sim/system_Trigger_0.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_13  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_15  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L processing_system7_vip_v1_0_15 -L xilinx_vip "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_processing_system7_0_0/sim/system_processing_system7_0_0.v" \

vcom -work proc_sys_reset_v5_0_13  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/system/ip/system_rst_ps7_0_125M_0/sim/system_rst_ps7_0_125M_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_27  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_7  -93  \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_26  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_28  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
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

vlog -work blk_mem_gen_v8_4_5  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
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

vlog -work axi_protocol_converter_v2_1_27  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../adquisidor.gen/sources_1/bd/system/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/7698" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../adquisidor.gen/sources_1/bd/system/ipshared/ee60/hdl" "+incdir+C:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system/ip/system_auto_pc_0/sim/system_auto_pc_0.v" \
"../../../bd/system/sim/system.v" \

vlog -work xil_defaultlib \
"glbl.v"


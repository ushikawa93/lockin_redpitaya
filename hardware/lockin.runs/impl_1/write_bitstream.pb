
�
�The XPM instance: <%s> is part of IP: <%s>. This XPM instance will be excluded from the .mmi because updatemem is prohibited from making changes to an XPM that is part of an IP.
136*memdata2�
�system_i/Control/uP/fifo_1/U0/COMP_IPIC2AXI_S/grxd.COMP_RX_FIFO/gfifo_gen.COMP_AXIS_FG_FIFO/COMP_FIFO/xpm_fifo_base_inst/gen_sdpram.xpm_memory_base_inst2default:default2.
system_i/Control/uP/fifo_12default:defaultZ28-208h px� 
�
�Found XPM memory block %s with a %s property set to %s. A value of %s is required. You will not be able to use the updatemem program to update the bitstream with new data for the %s block.
119*memdata2�
�system_i/Control/uP/axis_clock_converter_0/inst/gen_async_conv.axisc_async_clock_converter_0/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_sdpram.xpm_memory_base_inst2default:default2&
P_MEMORY_PRIMITIVE2default:default2
distributed2default:default2
block2default:default2�
�system_i/Control/uP/axis_clock_converter_0/inst/gen_async_conv.axisc_async_clock_converter_0/xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_sdpram.xpm_memory_base_inst2default:defaultZ28-167h px� 
x
Command: %s
53*	vivadotcl2G
3write_bitstream -force system_wrapper.bit -bin_file2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0102default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0102default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
csystem_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/A[29:0]]system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/A2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
csystem_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/B[17:0]]system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/B2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
]system_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/A[29:0]Wsystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/A2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
fInput pipelining: DSP %s input %s is not pipelined. Pipelining DSP48 input will improve performance.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
]system_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/B[17:0]Wsystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/B2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPIP-1h px� 
�
�PREG Output pipelining: DSP %s output %s is not pipelined (PREG=0). Pipelining the DSP48 output will improve performance and often saves power so it is suggested whenever possible to fully pipeline this function.  If this DSP48 function was inferred, it is suggested to describe an additional register stage after this function.  If the DSP48 was instantiated in the design, it is suggested to set the PREG attribute to 1.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
csystem_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/P[47:0]]system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-1h px� 
�
�PREG Output pipelining: DSP %s output %s is not pipelined (PREG=0). Pipelining the DSP48 output will improve performance and often saves power so it is suggested whenever possible to fully pipeline this function.  If this DSP48 function was inferred, it is suggested to describe an additional register stage after this function.  If the DSP48 was instantiated in the design, it is suggested to set the PREG attribute to 1.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
]system_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/P[47:0]Wsystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-1h px� 
�	
�MREG Output pipelining: DSP %s multiplier stage %s is not pipelined (MREG=0). Pipelining the multiplier function will improve performance and will save significant power so it is suggested whenever possible to fully pipeline this function.  If this multiplier was inferred, it is suggested to describe an additional register stage after this function.  If there is no registered adder/accumulator following the multiply function, two pipeline stages are suggested to allow both the MREG and PREG registers to be used.  If the DSP48 was instantiated in the design, it is suggested to set both the MREG and PREG attributes to 1 when performing multiply functions.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
csystem_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/P[47:0]]system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-2h px� 
�	
�MREG Output pipelining: DSP %s multiplier stage %s is not pipelined (MREG=0). Pipelining the multiplier function will improve performance and will save significant power so it is suggested whenever possible to fully pipeline this function.  If this multiplier was inferred, it is suggested to describe an additional register stage after this function.  If there is no registered adder/accumulator following the multiply function, two pipeline stages are suggested to allow both the MREG and PREG registers to be used.  If the DSP48 was instantiated in the design, it is suggested to set both the MREG and PREG attributes to 1 when performing multiply functions.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2�
 "�
]system_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/P[47:0]Wsystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL/P2default:default2default:default2=
 %DRC|Netlist|Instance|Pipeline|DSP48E12default:default8ZDPOP-2h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0	�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_02default:default2default:default2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0/ENARDEN�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0/ENARDEN2default:default2default:default2�
 "�
asystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenasystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0	�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_02default:default2default:default2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0/ENBWREN�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_0/ENBWREN2default:default2default:default2�
 "�
asystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenasystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1	�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_12default:default2default:default2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1/ENARDEN�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1/ENARDEN2default:default2default:default2�
 "�
asystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenasystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1	�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_12default:default2default:default2�
 "�
�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1/ENBWREN�system_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg_1/ENBWREN2default:default2default:default2�
 "�
asystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenasystem_i/Fuente_datos/referencias/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB18 async control check: The RAMB18E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg	�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg2default:default2default:default2�
 "�
�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg/ENARDEN�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg/ENARDEN2default:default2default:default2�
 "�
Lsystem_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenLsystem_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB18E12default:default8Z	REQP-1840h px� 
�
�RAMB18 async control check: The RAMB18E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2�
 "�
�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg	�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg2default:default2default:default2�
 "�
�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg/ENBWREN�system_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/i_rtl.i_quarter_table.i_block_rom.i_pipe_1.pre_asyn_sin_RAM_op_reg/ENBWREN2default:default2default:default2�
 "�
Lsystem_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclkenLsystem_i/DAC/dds_compiler_0/U0/i_synth/i_dds/I_SINCOS.i_std_rom.i_rom/aclken2default:default2default:default2r
 "\
"system_i/enable_reg/inst/q_reg_reg	"system_i/enable_reg/inst/q_reg_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB18E12default:default8Z	REQP-1840h px� 
�
�enum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND: %s: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2L
 4DRC|Netlist|Instance|Invalid attribute value|DSP48E12default:default8ZAVAL-4h px� 
�
�enum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND: %s: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2L
 4DRC|Netlist|Instance|Invalid attribute value|DSP48E12default:default8ZAVAL-4h px� 
�
�enum_MREG_0_connects_CEM_GND: %s: When the DSP48E1 MREG attribute is set to 0, the CEM input pin should be tied to GND to save power.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2A
 )DRC|Netlist|Instance|Required Pin|DSP48E12default:default8ZREQP-30h px� 
�
�enum_MREG_0_connects_CEM_GND: %s: When the DSP48E1 MREG attribute is set to 0, the CEM input pin should be tied to GND to save power.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2A
 )DRC|Netlist|Instance|Required Pin|DSP48E12default:default8ZREQP-30h px� 
�
�enum_PREG_0_connects_CEP_GND: %s: When the DSP48E1 PREG attribute is set to 0, the CEP input pin should be tied to GND to save power.%s*DRC2�
 "�
[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL	[system_i/lock_in/inst/lock_in/multiplicador/prod_cuadratura/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2A
 )DRC|Netlist|Instance|Required Pin|DSP48E12default:default8ZREQP-31h px� 
�
�enum_PREG_0_connects_CEP_GND: %s: When the DSP48E1 PREG attribute is set to 0, the CEP input pin should be tied to GND to save power.%s*DRC2�
 "�
Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL	Usystem_i/lock_in/inst/lock_in/multiplicador/prod_fase/MULT_MACRO_inst/dsp_bl.DSP48_BL2default:default2default:default2A
 )DRC|Netlist|Instance|Required Pin|DSP48E12default:default8ZREQP-31h px� 
�	
�writefirst: Synchronous clocking is detected for BRAM (%s) in SDP mode with WRITE_FIRST write-mode. This is the preferred mode for best power characteristics, however it may exhibit address collisions if the same address appears on both read and write ports resulting in unknown or corrupted read data. It is suggested to confirm via simulation that an address collision never occurs and if so it is suggested to try and avoid this situation. If address collisions cannot be avoided, the write-mode may be set to READ_FIRST which guarantees that the read data is the prior contents of the memory at the cost of additional power in the design. See the FPGA Memory Resources User Guide for additional information.%s*DRC2�
 "�
�system_i/Control/uP/fifo_1/U0/COMP_IPIC2AXI_S/grxd.COMP_RX_FIFO/gfifo_gen.COMP_AXIS_FG_FIFO/COMP_FIFO/xpm_fifo_base_inst/gen_sdpram.xpm_memory_base_inst/gen_wr_a.gen_word_narrow.mem_reg	�system_i/Control/uP/fifo_1/U0/COMP_IPIC2AXI_S/grxd.COMP_RX_FIFO/gfifo_gen.COMP_AXIS_FG_FIFO/COMP_FIFO/xpm_fifo_base_inst/gen_sdpram.xpm_memory_base_inst/gen_wr_a.gen_word_narrow.mem_reg2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8ZREQP-181h px� 
u
DRC finished with %s
1905*	planAhead27
#0 Errors, 14 Warnings, 7 Advisories2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
e
Writing bitstream %s...
11*	bitstream2(
./system_wrapper.bit2default:defaultZ40-11h px� 
e
Writing bitstream %s...
11*	bitstream2(
./system_wrapper.bin2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a ULT device. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.698*projectZ1-1876h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
212default:default2
142default:default2
02default:default2
02default:defaultZ4-41h px� 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:372default:default2
00:00:312default:default2
2393.6172default:default2
393.9572default:defaultZ17-268h px� 


End Record
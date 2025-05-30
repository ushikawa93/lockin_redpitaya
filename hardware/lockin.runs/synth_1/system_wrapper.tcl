# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.runs/synth_1/system_wrapper.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 1
set_msg_config -id {HDL-1065} -limit 10000
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.cache/wt [current_project]
set_property parent.project_path C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths {
  c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/user_ip
  c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/lu_tables
} [current_project]
update_ip_catalog
set_property ip_output_repo c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
set_property verilog_define TOOL_VIVADO [current_fileset]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_mem {
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/lu_tables/x2048_16b.mem
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/lu_tables/y2048_16b.mem
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/lu_tables/x2048_14b.mem
}
read_verilog -library xil_defaultlib {
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/my_cores/drive_gpios.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/my_cores/drive_leds.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/and_2.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/mux.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/decimator.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/linear_mean.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/delay_axi_streaming.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/start_signal_generator.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/signal_split.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/new/register.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/filtro_ma_con_sync.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/lockin_segmentado.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/multiplicador.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/multiplicate_ref_2.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/referencias.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/user_ip/my_cores/signal_processing_LI.v
  C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/imports/system_wrapper.v
}
add_files C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/sources_1/bd/system/system.bd
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_util_ds_buf_1_0/system_util_ds_buf_1_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_util_ds_buf_1_0/system_util_ds_buf_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_util_ds_buf_2_0/system_util_ds_buf_2_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_util_ds_buf_2_0/system_util_ds_buf_2_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_rst_ps7_0_125M_0/system_rst_ps7_0_125M_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_rst_ps7_0_125M_0/system_rst_ps7_0_125M_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axis_clock_converter_0_1/system_axis_clock_converter_0_1_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_2/system_axi_gpio_0_2_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_2/system_axi_gpio_0_2_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_2/system_axi_gpio_0_2.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_1/system_axi_gpio_0_1_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_1/system_axi_gpio_0_1_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_1/system_axi_gpio_0_1.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_Control_and_Nca_0/system_Control_and_Nca_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_Control_and_Nca_0/system_Control_and_Nca_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_Control_and_Nca_0/system_Control_and_Nca_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_result_cuad_0/system_result_cuad_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_result_cuad_0/system_result_cuad_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_result_cuad_0/system_result_cuad_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_3/system_axi_gpio_0_3_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_3/system_axi_gpio_0_3_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_axi_gpio_0_3/system_axi_gpio_0_3.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_M_and_Nma_0/system_M_and_Nma_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_M_and_Nma_0/system_M_and_Nma_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_M_and_Nma_0/system_M_and_Nma_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_finished_and_decimator_method_0/system_finished_and_decimator_method_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_finished_and_decimator_method_0/system_finished_and_decimator_method_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_finished_and_decimator_method_0/system_finished_and_decimator_method_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/ip/system_auto_pc_0/system_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.gen/sources_1/bd/system/system_ooc.xdc]

OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/constrs_1/imports/cfg/clocks.xdc
set_property used_in_implementation false [get_files C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/constrs_1/imports/cfg/clocks.xdc]

read_xdc C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/constrs_1/imports/cfg/ports.xdc
set_property used_in_implementation false [get_files C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/constrs_1/imports/cfg/ports.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1

read_checkpoint -auto_incremental -incremental C:/Users/mati9/OneDrive/Documentos/00-RedPitaya/lockin_redpitaya/hardware/lockin.srcs/utils_1/imports/synth_1/system_wrapper.dcp
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top system_wrapper -part xc7z010clg400-1 -directive PerformanceOptimized -fsm_extraction one_hot -keep_equivalent_registers -resource_sharing off -no_lc -shreg_min_size 5
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef system_wrapper.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file system_wrapper_utilization_synth.rpt -pb system_wrapper_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }

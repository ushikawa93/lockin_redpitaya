# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "esperar" -parent ${Page_0}
  ipgui::add_param $IPINST -name "habilitar_salida" -parent ${Page_0}
  ipgui::add_param $IPINST -name "idle" -parent ${Page_0}


}

proc update_PARAM_VALUE.esperar { PARAM_VALUE.esperar } {
	# Procedure called to update esperar when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.esperar { PARAM_VALUE.esperar } {
	# Procedure called to validate esperar
	return true
}

proc update_PARAM_VALUE.habilitar_salida { PARAM_VALUE.habilitar_salida } {
	# Procedure called to update habilitar_salida when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.habilitar_salida { PARAM_VALUE.habilitar_salida } {
	# Procedure called to validate habilitar_salida
	return true
}

proc update_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to update idle when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to validate idle
	return true
}


proc update_MODELPARAM_VALUE.idle { MODELPARAM_VALUE.idle PARAM_VALUE.idle } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.idle}] ${MODELPARAM_VALUE.idle}
}

proc update_MODELPARAM_VALUE.habilitar_salida { MODELPARAM_VALUE.habilitar_salida PARAM_VALUE.habilitar_salida } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.habilitar_salida}] ${MODELPARAM_VALUE.habilitar_salida}
}

proc update_MODELPARAM_VALUE.esperar { MODELPARAM_VALUE.esperar PARAM_VALUE.esperar } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.esperar}] ${MODELPARAM_VALUE.esperar}
}


# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAX_bits" -parent ${Page_0}
  ipgui::add_param $IPINST -name "atenuacion" -parent ${Page_0}


}

proc update_PARAM_VALUE.MAX_bits { PARAM_VALUE.MAX_bits } {
	# Procedure called to update MAX_bits when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_bits { PARAM_VALUE.MAX_bits } {
	# Procedure called to validate MAX_bits
	return true
}

proc update_PARAM_VALUE.atenuacion { PARAM_VALUE.atenuacion } {
	# Procedure called to update atenuacion when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.atenuacion { PARAM_VALUE.atenuacion } {
	# Procedure called to validate atenuacion
	return true
}


proc update_MODELPARAM_VALUE.MAX_bits { MODELPARAM_VALUE.MAX_bits PARAM_VALUE.MAX_bits } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_bits}] ${MODELPARAM_VALUE.MAX_bits}
}

proc update_MODELPARAM_VALUE.atenuacion { MODELPARAM_VALUE.atenuacion PARAM_VALUE.atenuacion } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.atenuacion}] ${MODELPARAM_VALUE.atenuacion}
}


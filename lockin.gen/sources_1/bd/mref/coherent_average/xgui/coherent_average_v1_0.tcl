# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INDICES_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_CA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAM_SIZE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.INDICES_ADDR { PARAM_VALUE.INDICES_ADDR } {
	# Procedure called to update INDICES_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INDICES_ADDR { PARAM_VALUE.INDICES_ADDR } {
	# Procedure called to validate INDICES_ADDR
	return true
}

proc update_PARAM_VALUE.M_WIDTH { PARAM_VALUE.M_WIDTH } {
	# Procedure called to update M_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_WIDTH { PARAM_VALUE.M_WIDTH } {
	# Procedure called to validate M_WIDTH
	return true
}

proc update_PARAM_VALUE.N_CA_WIDTH { PARAM_VALUE.N_CA_WIDTH } {
	# Procedure called to update N_CA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_CA_WIDTH { PARAM_VALUE.N_CA_WIDTH } {
	# Procedure called to validate N_CA_WIDTH
	return true
}

proc update_PARAM_VALUE.RAM_SIZE { PARAM_VALUE.RAM_SIZE } {
	# Procedure called to update RAM_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAM_SIZE { PARAM_VALUE.RAM_SIZE } {
	# Procedure called to validate RAM_SIZE
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.N_CA_WIDTH { MODELPARAM_VALUE.N_CA_WIDTH PARAM_VALUE.N_CA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_CA_WIDTH}] ${MODELPARAM_VALUE.N_CA_WIDTH}
}

proc update_MODELPARAM_VALUE.RAM_SIZE { MODELPARAM_VALUE.RAM_SIZE PARAM_VALUE.RAM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAM_SIZE}] ${MODELPARAM_VALUE.RAM_SIZE}
}

proc update_MODELPARAM_VALUE.M_WIDTH { MODELPARAM_VALUE.M_WIDTH PARAM_VALUE.M_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_WIDTH}] ${MODELPARAM_VALUE.M_WIDTH}
}

proc update_MODELPARAM_VALUE.INDICES_ADDR { MODELPARAM_VALUE.INDICES_ADDR PARAM_VALUE.INDICES_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INDICES_ADDR}] ${MODELPARAM_VALUE.INDICES_ADDR}
}


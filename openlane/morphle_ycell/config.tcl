set script_dir [file dirname [file normalize [info script]]]


set ::env(DESIGN_NAME) ycell

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/morphle/ycell.v"

set ::env(CLOCK_PERIOD) "0"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(FP_SIZING) relative
set ::env(FP_CORE_UTIL) 35
set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.55

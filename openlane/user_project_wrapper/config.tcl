set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg

set ::env(PDN_CFG) $script_dir/pdn.tcl
set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"

set ::unit 2.4
set ::env(FP_IO_VEXTEND) [expr 2*$::unit]
set ::env(FP_IO_HEXTEND) [expr 2*$::unit]
set ::env(FP_IO_VLENGTH) $::unit
set ::env(FP_IO_HLENGTH) $::unit
set ::env(FP_PDN_VOFFSET) "16.32"
set ::env(FP_PDN_VPITCH) "153.6"
set ::env(FP_PDN_HOFFSET) "16.65"
#set ::env(FP_PDN_HPITCH) "153.18"
set ::env(FP_PDN_HPITCH) "76.59"

set ::env(FP_WELLTAP_CELL) ""
set ::env(FP_ENDCAP_CELL) ""

set ::env(_SPACING) 1.6
set ::env(_WIDTH) 3

set ::env(_VDD_NET_NAME) vccd1
set ::env(_GND_NET_NAME) vssd1
set ::env(_V_OFFSET) 14
set ::env(_H_OFFSET) $::env(_V_OFFSET)


set ::env(FP_IO_VTHICKNESS_MULT) 4
set ::env(FP_IO_HTHICKNESS_MULT) 4


set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "10"

set ::env(CLOCK_TREE_SYNTH) 0

set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.23


# Need to fix a FastRoute bug for this to work, but it's good
# for a sense of "isolation"
set ::env(MAGIC_ZEROIZE_ORIGIN) 0
set ::env(MAGIC_WRITE_FULL_LEF) 1

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/morphle/ycell.v \
	$script_dir/../../verilog/morphle/yblock.v \
	$script_dir/../../verilog/morphle/user_proj_block.v"


set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/user_proj_example.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/user_proj_example.gds"

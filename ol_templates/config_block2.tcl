set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/morphle/yblock.v \
	$script_dir/../../verilog/morphle/user_proj_block.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
        $script_dir/../../verilog/morphle/ycell.v"

set ::env(EXTRA_LEFS) "\
        $script_dir/../../lef/morphle_ycell.lef"

set ::env(EXTRA_GDS_FILES) "\
        $script_dir/../../gds/morphle_ycell.gds"

set ::env(PDN_CFG) $script_dir/pdn.tcl
set ::env(FP_PDN_CORE_RING) 1

set ::unit 3
set ::env(FP_IO_VEXTEND) [expr 2*$::unit]
set ::env(FP_IO_HEXTEND) [expr 2*$::unit]
set ::env(FP_IO_VLENGTH) $::unit
set ::env(FP_IO_HLENGTH) $::unit

set ::env(FP_IO_VTHICKNESS_MULT) 4
set ::env(FP_IO_HTHICKNESS_MULT) 4

set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0

# Need to fix a FastRoute bug for this to work, but it's good
# for a sense of "isolation"
set ::env(MAGIC_ZEROIZE_ORIGIN) 0
set ::env(MAGIC_WRITE_FULL_LEF) 1

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) "200"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(FP_CONTEXT_DEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/floorplan/ioPlacer.def.macro_placement.def
set ::env(FP_CONTEXT_LEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/merged_unpadded.lef
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1500 1500"
set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.65


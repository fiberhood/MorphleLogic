# SPDX-FileCopyrightText: 2020 Jecel Mattos de Assumpcao Jr
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/morphle/ycell.v \
	$script_dir/../../verilog/morphle/yblock.v \
	$script_dir/../../verilog/morphle/user_proj_block.v"

set ::env(CLOCK_PORT) "la_out\[112i\]"
set ::env(CLOCK_PERIOD) "2000"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(FP_CONTEXT_DEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/floorplan/ioPlacer.def.macro_placement.def
set ::env(FP_CONTEXT_LEF) $script_dir/../user_project_wrapper/runs/user_project_wrapper/tmp/merged_unpadded.lef
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1200 1200"
#set ::env(FP_SIZING) relative
#set ::env(FP_CORE_UTIL) 35
set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.35


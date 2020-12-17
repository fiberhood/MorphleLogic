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

set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"

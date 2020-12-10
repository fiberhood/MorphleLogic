# SPDX-FileCopyrightText: Copyright 2020 Jecel Mattos de Assumpcao Jr
# 
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



.PHONY: help
help:
	@echo "      available commands (do 'make <command>')"
	@echo
	@awk '/^.PHONY/{print "    " $$2}' Makefile

.PHONY: init_block_flat
init_block_flat:
	@echo
	@echo "       clearing user_projec_example"
	@echo
	rm -fR ../openlane/user_proj_example/*
	@echo
	@echo "       overwritting user_proj_example with 16x16 block"
	@echo
	cp config_block.tcl ../openlane/user_proj_example/config.tcl
	cp pin_order.cfg ../openlane/user_proj_example/pin_order.cfg

.PHONY: init_block_cells
init_block_cells:
	@echo
	@echo "       clearing user_projec_example"
	@echo
	rm -fR ../openlane/user_proj_example/*
	@echo
	@echo "       overwritting user_proj_example with 16x16 block using black box cells"
	@echo
	cp config_block2.tcl ../openlane/user_proj_example/config.tcl
	cp pdn.tcl ../openlane/user_proj_example/pdn.tcl
	cp pin_order.cfg ../openlane/user_proj_example/pin_order.cfg
	@echo
	@echo "      creating new macro_placement.cfg file"
	@echo
	@echo -n >../openlane/user_proj_example/macro_placement.cfg
	@for r in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		for c in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo "blk.column\["$$c"\].row\["$$r"\].yc "$$(printf %.3f $$((187000+72000*$$c))e-3)" "$$(printf %.3f $$((87000+76160*$$r))e-3)" S" >> ../openlane/user_proj_example/macro_placement.cfg; \
		done \
	done



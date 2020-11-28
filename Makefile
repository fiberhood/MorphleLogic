# SPDX-FileCopyrightText: Copyright 2020 eFabless
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

FILE_SIZE_LIMIT_MB = 10
LARGE_FILES := $(shell find . -type f -size +$(FILE_SIZE_LIMIT_MB)M -not -path "./.git/*")

LARGE_FILES_GZ := $(addsuffix .gz, $(LARGE_FILES))

ARCHIVES := $(shell find . -type f -name "*.gz")
ARCHIVE_SOURCES := $(basename $(ARCHIVES))

ifndef PDK_ROOT
$(error PDK_ROOT is undefined, please export it before running make)
endif

.DEFAULT_GOAL := ship

# We need portable GDS_FILE pointers...
.PHONY: ship
ship: uncompress
	@echo "###############################################"
	@echo "Generating Caravel GDS (sources are in the 'gds' directory)"
	@sleep 1
	@cd gds && MAGTYPE=mag magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/current/sky130A.magicrc -noc -dnull gen_caravel.tcl < /dev/null



.PHONY: clean
clean:
	echo "clean"



.PHONY: verify
verify:
	echo "verify"



$(LARGE_FILES_GZ): %.gz: %
	@if ! [ $(suffix $<) == ".gz" ]; then\
		gzip -n --best $< > /dev/null &&\
		echo "$< -> $@";\
	fi

# This target compresses all files larger than $(FILE_SIZE_LIMIT_MB) MB
.PHONY: compress
compress: $(LARGE_FILES_GZ)
	@echo "Files larger than $(FILE_SIZE_LIMIT_MB) MBytes are compressed!"



$(ARCHIVE_SOURCES): %: %.gz
	@gzip -d $< &&\
	echo "$< -> $@";\

.PHONY: uncompress
uncompress: $(ARCHIVE_SOURCES)
	@echo "All files are uncompressed!"

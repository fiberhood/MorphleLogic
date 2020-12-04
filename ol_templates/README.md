<!---
< SPDX-FileCopyrightText: Copyright 2020 Jecel Mattos de Assumpcao Jr
< 
< SPDX-License-Identifier: Apache-2.0 
< 
< Licensed under the Apache License, Version 2.0 (the "License");
< you may not use this file except in compliance with the License.
< You may obtain a copy of the License at
< 
<     https://www.apache.org/licenses/LICENSE-2.0
< 
< Unless required by applicable law or agreed to in writing, software
< distributed under the License is distributed on an "AS IS" BASIS,
< WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
< See the License for the specific language governing permissions and
< limitations under the License.
--->
# Templates for OpenLane configuration files

Several files are used for each possible project to be included in the Caravel chip. One is a Verilog file that is used to generate *user_proj_example.gds* (the name must be this as it is what *user_project_wrapper* expects) and another is a Tcl configuration file that must be copied to *../openlane/user_proj_example/config.tcl* so openlane can do its job.

Other files are *pdn.tcl* and *pin_order.cfg*.

### user_proj_block

*<project root>/verilog/morphle/user_proj_block.v* is invoked from *config_block.tcl* (which gets renamed when copied to *<project root>/openlane/user_proj_example/*) and connects a single 16x16 yblock cells to the Caravel logic analyzer pins. It also attaches a dummy circuit to the Wishbone interface, but leaves all io pins dangling (so ignore warnings about that).

### user_proj_block2

*<project root>/verilog/morphle/user_proj_block.v* is invoked from *config_block2.tcl* (which gets renamed when copied to *<project root>/openlane/user_proj_example/*) and connects a single 16x16 yblock cells to the Caravel logic analyzer pins. It also attaches a dummy circuit to the Wishbone interface, but leaves all io pins dangling (so ignore warnings about that). In this version the ycell has been hardned and the yblock is build from that.

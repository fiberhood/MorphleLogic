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
## Verilog Library of building blocks for Morphle Logic

### ycell.v

The basic element is *ycell* ("yellow cell", named so because of the first illustrations). This file also defines a trivial configuration circuit that shifts in 3 configuration bits and decodes the 8 possible combinations into the needed control signals.

### yblock.v

*yblock* just being an array of ycells of the specified BLOCKWIDTH and BLOCKHEIGHT. Besides connecting the ycells to each other, yblock connects the wires at the edges of the array to ports so it can be used as a component in a larger system.

## Caravel User Project Examples

## user_proj_block.v


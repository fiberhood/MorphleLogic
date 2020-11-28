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
# Morphle Logic Project

This is a combination of the Morphle Logic asynchronous runtime reconfigurable array with the Caravel project to design a chip for the Skywater 130 nm technology.

Details of each project are in their respective README files:

- [README for Morphle Logic](README_MORPHLE_LOGIC.md)
- [README for Caravel](README_CARAVEL.md)

This version of the chip uses a single block of "yellow cells" from Morphle Logic connected to the logic analyzer pins inside Caravel. The processor in the management frame can inject a configuration into the block (a reset, configuration clock and 16 configuration bits interface with the capability of reading back 16 configuration bits coming out of the bottom of the block) and then inject a value into the top interface of the block (16 pairs of bits) and read back the value coming out the top of the block. The left, down and right interfaces are hardwired to loop back into themselves (which shouldn't matter as their missing neighbors always assert that they are "empty").

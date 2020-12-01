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
# Verilog files specific to Morphle Logic

Pairs of files are used for each possible project to be included in the Caravel chip. One is a Verilog file that is used to generate *user_proj_example.gds* (the name must be this as it is what *user_project_wrapper* expects) and the other is a Tcl configuration file that must be copied to *../../openlane/user_proj_example/config.tcl* so openlane can do its job.

- *user_proj_block.v* and *user_proj_block.v* connect a single 16x16 yblock cell to the Caravel logic analyzer pins. It also attaches a dummy circuit to the Wishbone interface, but leaves all io pins dangling (so ignore warnings about that).

## library

The main library contains the building blocks for Morphle Logic:

- *ycell.v*: the basic element is *ycell* ("yellow cell", named so because of the first illustrations)
- *yblock.v*: *yblock* just being an array of ycells of the specified BLOCKWIDTH and BLOCKHEIGHT. Besides connecting the ycells to each other, yblock connects the wires at the edges of the array to ports so it can be used as a component in a larger system.

## Tests

The circuits of this kind are simulation-only can test the components in the library

The way to execute them is

    iverilog testNNNdescription.v
    vvp a.out

Normally some output is printed or a .vcd file is generated which can then be examined with gtkwave.

### test001ycfsm.v

This puts the asynchronous finite state machine inside the basic Morphle Logic cell through its paces and prints out values from the tester and several internal signals of the fsm module. The use of internal signals helped debug the initial design, but might break this test if that design is changed in the future.

Many signals are two bit busses and can have the values 0 (indicating "empty"), 1 (indicating a logical 0) or 2 (indicating a logica 1). Some internal signals can be temporarily 3 but that normally shouldn't appear.

### test002ycfsm.v

This is the finite state machine being tested by this and the previous test. The expected output value is indicated by the color inside each circle representing the states. The input values are indicated by the color of the arrows, which can be hard to see due to the red stripes.

![Finite State Machine for basic Morphle Logic cell](ycfsmnum.png)

A separate file, "test002.tv", has the actual test vectors with one 7 bit vector per line. The reset signal is a single bit but all others are pairs with 00 indicating "empty", 01 indicating a logical 0 and 10 a logical 1. The last two bits are the expected value for the output and an error is printed if that is not what comes out of the actual circuit.

Since no internal signals are used, this test should work even if the circuit is changed as long as it still implements the fsm indicated above. In order to check that all transitions (arrows) are tested they were numbered and the test vector file has comments indicating where each transitions is tested for the first time. In order to get to a transition that hasn't yet been tested it is often necessary to go through many that have already been seen. That is the big problem with black box testing and why it is a good idea to include BIST (built-in self test circuits) in a design.

### test003ycconfig.v

This tests the configuration circuit by manually shifting in 3 bits at a time and listing the outputs. It adds a comment about which state the configuration is in after the 3 bits.

A second configuration circuit is cascaded with the first in this test. Every time the first circuit has a valid configuration, the second one should have the previous valid configuration of the first circuit.

### test004ycell.v

A separate file, "test004.tv", has the actual test vectors as a 28 bit vector per line in the form of a 7 digit hex number. The first two bits are ignored and the rest are used as inputs to the "yellow cell" (the basic building block of Morphle Logic) or as values to be compared against the actual outputs.

<!---
< SPDX-FileCopyrightText: Copyright 2020 eFabless
< with initial lines added 2020 by Jecel Mattos de Assumpcao Jr
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

[README for Morphle Logic](README_MORPHLE_LOGIC.md) gives more details about what Morphle Logic is.

[Original Caravel README](README_caravel.md) has the information about the Caravel project itself.

This version of the chip uses a single block of "yellow cells" from Morphle Logic connected to the logic analyzer pins inside Caravel. The processor in the management frame can inject a configuration into the block (a reset, configuration clock and 16 configuration bits interface with the capability of reading back 16 configuration bits coming out of the bottom of the block) and then inject a value into the top interface of the block (16 pairs of bits) and read back the value coming out the top of the block. The left, down and right interfaces are hardwired to indicate empty neighbors with the inputs always empty as well.

## Testing

The various unit tests and the test harness for Morphle Logic blocks and the *user_proj_example* can be found in the *verilog/mtests* directory.

## Steps to build caravel.gds

Note that the project includes many intermediate files that were generated separately. Using the tools to generate new versions of them is not a good idea. Only the "user_proj_example" and "user_project_wrappers" should be touched and then magic is used to combine this result with previously generated files of the remaining subprojects into the final .gds file with the chip masks.

OpenLane runs inside Docker so that should be installed and able to run as the current user and not just as root.

To build the modified Caravel chip that includes Morphle Logic instead of the supplied *user_proj_example*, the following steps should be taken starting from the root of the MorphleLogic project:

    export PDK_ROOT=<path where the various PDK projects will be placed>

If the supplied *user_proj_example* is still present in the openlane subdirectory, then this will patch it to use Morphle Logic verilog files instead by replacing everything in that subdirectory with new versions of the needed files:

    cd ol_templates
    make init_block_cells
    cd ..

Note that we are now skipping *user_proj_example* and doing *user_project_wrapper* directly to make hooking up power to the yellow cells simpler. The above sequence is still needed so generate the macro placement file which is placed in *..example* but also used by *..wrapper*.

In the *ol_templates* subdirectory, you can "make help" to see other options. One such is "make init_block_flat" which will copy the files needed so that *user_proj_example* will be built as a single mass of standard cells.

If the various PDK packages have been installed with the correct versions then this step can be skipped:

    make pdk

If the large files in MorphleLogic are still compressed then you can:

    make uncompress

    export OPENLANE_ROOT=<path where the right version of OpenLane has been installed>
    cd openlane

If OpenLane has not yet been installed in the indicated place you can:

    make openlane

Currently the project is going to be built using the yellow cells as black boxes, so they have to be generated first:

    make morphle_ycell

This should be the result:

<p align="center">
<img src="/doc/morphle_logic_ycell.png" width="75%" height="75%"> 
</p>

The next step is to generate *user_project_wrapper* which now directly includes all the yellow cell macros and other logic from *user_proj_example* instead of just wires.

    make user_project_wrapper

Here is the result:

<p align="center">
<img src="/doc/morphle_logic_user_project_wrapper.png" width="75%" height="75%"> 
</p>

Note that the design rule checker (DRC) will give 6 errors complaining about tapcells being too far. This is due to the ycell macros disrupting the nice pattern of tapcells to their right, so that where the pattern changes at the very right edge there is a slightly longer stretch. The six errors are all about a single missing tap point. But there is not any actual circuits in this region of the chip - it is empty space. Fixing this error would be possible by moving the macros to the left, but then OpenLane causes actual errors by running vertical metal 4 traces too close to the power rails.

<p align="center">
<img src="/doc/morphle_logic_tapcellerror.png" width="75%" height="75%"> 
</p>

Now we have the *gds/user_project_wrapper.gds* file that the main script needs.
Be sure that you have the latest version of the *magic* tool, otherwise you will get some very hard to understand errors.

    cd ..
    make ship

If there were no errors in any step then the file *gds/caravel.gds* has the final design. The files needed for error checking should also all be available at this point.

<p align="center">
<img src="/doc/morphle_logic_caravel.png" width="75%" height="75%"> 
</p>

It is possible to "make compress" to make it easier to move the repository around (only files larger than 10MB, by default, will be affected).


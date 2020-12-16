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

[README for Morphle Logic](README_MORPHLE_LOGIC.md) gives more details about that part
of the project.

This version of the chip uses a single block of "yellow cells" from Morphle Logic connected to the logic analyzer pins inside Caravel. The processor in the management frame can inject a configuration into the block (a reset, configuration clock and 16 configuration bits interface with the capability of reading back 16 configuration bits coming out of the bottom of the block) and then inject a value into the top interface of the block (16 pairs of bits) and read back the value coming out the top of the block. The left, down and right interfaces are hardwired to loop back into themselves (which shouldn't matter as their missing neighbors always assert that they are "empty").

## Steps to build caravel.gds

Note that the project includes many intermediate files that were generated separately. Using the tools to generate new versions of them is not a good idea. Only the "user_proj_example" and "user_project_wrappers" should be touched and then magic is used to combine this result with previously generated files of the remaining subprojects into the final .gds file with the chip masks.

OpenLane runs inside Docker so that should be installed and able to run as the current user and not just as root.

To build the modified Caravel chip that includes Morphle Logic instead of the supplied *user_proj_example*, the following steps should be taken starting from the root of the MorphleLogic project:

    export PDK_ROOT=<path where the various PDK projects will be placed>

If the supplied *user_proj_example* is still present in the openlane subdirectory, then this will patch it to use Morphle Logic verilog files instead by replacing everything in that subdirectory with new versions of the needed files:

    cd ol_templates
    make init_block_flat
    cd ..

In the *ol_templates* subdirectory, you can "make help" to see other options. One such is "make init_block_cells" which will copy the files needed so that *user_proj_example* will be built using the yellow cells as block boxes instead of doing the whole circuit at once. This will require having previously generated the ycell files.

If the various PDK packages have been installed with the correct versions then this step can be skipped:

    make pdk

If the large files in MorphleLogic are still compressed then you can:

    make uncompress

    export OPENLANE_ROOT=<path where the right version of OpenLane has been installed>
    cd openlane

If OpenLane has not yet been installed in the indicated place you can:

    make openlane

If the project is going to be built using the yellow cells as black boxes, then they have to be generated first:

    make morphle_ycell

The next step (which is the first non optional one) is to generate all the files for the example project:

    make user_proj_example


Note that this uses files generated in the *user_project_wrapper* subproject (definition files that help the included subproject know where the pins will go) even though that uses this one. It is not bad as circular dependencies go.

    make user_project_wrapper

Now we have the *gds/user_project_wrapper.gds* file that the main script needs.
Be sure that you have the latest version of the *magic* tool, otherwise you will get some very hard to understand errors.

    cd ..
    make ship

If there were no errors in any step then the file *gds/caravel.gds* has the final design. The files needed for error checking should also all be available at this point.

It is possible to "make compress" to make it easier to move the repository around (only files larger than 10MB, by default, will be affected).

===========================================

The Caravel README is below for reference only since the instructions above are better for this fork:

=======
# CIIC Harness  

A template SoC for Google SKY130 free shuttles. It is still WIP. The current SoC architecture is given below.

<p align="center">
<img src="/doc/ciic_harness.png" width="75%" height="75%"> 
</p>


## Getting Started:

* For information on tooling and versioning, please refer to [this][1].

Start by cloning the repo and uncompressing the files.
```bash
git clone https://github.com/efabless/caravel.git
cd caravel
make uncompress
```

Then you need to install the open_pdks prerequisite:
 - [Magic VLSI Layout Tool](http://opencircuitdesign.com/magic/index.html) is needed to run open_pdks -- version >= 8.3.60*

 > \* Note: You can avoid the need for the magic prerequisite by using the openlane docker to do the installation step in open_pdks. This could be done by cloning [openlane](https://github.com/efabless/openlane/tree/master) and following the instructions given there to use the Makefile.

Install the required version of the PDK by running the following commands:

```bash
export PDK_ROOT=<The place where you want to install the pdk>
make pdk
```

Then, you can learn more about the caravel chip by watching these video:
- Caravel User Project Features -- https://youtu.be/zJhnmilXGPo
- Aboard Caravel -- How to put your design on Caravel? -- https://youtu.be/9QV8SDelURk
- Things to Clarify About Caravel -- What versions to use with Caravel? -- https://youtu.be/-LZ522mxXMw
    - You could only use openlane:rc6
    - Make sure you have the commit hashes provided here inside the [Makefile](./Makefile)
## Aboard Caravel:

Your area is the full user_project_wrapper, so feel free to add your project there or create a differnt macro and harden it seperately then insert it into the user_project_wrapper. For example, if your design is analog or you're using a different tool other than OpenLANE.

If you will use OpenLANE to harden your design, go through the instructions in this [README.md][0].

You must copy your synthesized gate-level-netlist for `user_project_wrapper` to `verilog/gl/` and overwrite `user_project_wrapper.v`. Otherwise, you can point to it in [info.yaml](info.yaml).

> Note: If you're using openlane to harden your design, this should happen automatically.

Then, you will need to put your design aboard the Caravel chip. Make sure you have the following:

- [Magic VLSI Layout Tool](http://opencircuitdesign.com/magic/index.html) installed on your machine. We may provide a Dockerized version later.\*
- You have your user_project_wrapper.gds under `./gds/` in the Caravel directory.

 > \* **Note:** You can avoid the need for the magic prerequisite by using the openlane docker to run the make step. This [section](#running-make-using-openlane-magic) shows how.

Run the following command:

```bash
export PDK_ROOT=<The place where the installed pdk resides. The same PDK_ROOT used in the pdk installation step>
make
```

This should merge the GDSes using magic and you'll end up with your version of `./gds/caravel.gds`. You should expect ~90 magic DRC violations with the current "development" state of caravel.

## Running Make using OpenLANE Magic

To use the magic installed inside Openlane to complete the final GDS streaming out step, export the following:

```bash
export PDK_ROOT=<The location where the pdk is installed>
export OPENLANE_ROOT=<the absolute path to the openlane directory cloned or to be cloned>
export IMAGE_NAME=<the openlane image name installed on your machine. Preferably openlane:rc6>
export CARAVEL_PATH=$(pwd)
```

Then, mount the docker:

```bash
docker run -it -v $CARAVEL_PATH:$CARAVEL_PATH -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e CARAVEL_PATH=$CARAVEL_PATH -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME
```

Finally, once inside the docker run the following commands:
```bash
cd $CARAVEL_PATH
make
exit
```

This should merge the GDSes using magic and you'll end up with your version of `./gds/caravel.gds`. You should expect ~90 magic DRC violations with the current "development" state of caravel.


## IMPORTANT:

Please make sure to run `make compress` before commiting anything to your repository. Avoid having 2 versions of the gds/user_project_wrapper.gds or gds/caravel.gds one compressed and the other not compressed.

## Required Directory Structure

- ./gds/ : includes all the gds files used or produced from the project.
- ./def/ : includes all the def files used or produced from the project.
- ./lef/ : includes all the lef files used or produced from the project.
- ./mag/ : includes all the mag files used or produced from the project.
- ./maglef/ : includes all the maglef files used or produced from the project.
- ./spi/lvs/ : includes all the maglef files used or produced from the project.
- ./verilog/dv/ : includes all the simulation test benches and how to run them. 
- ./verilog/gl/ : includes all the synthesized/elaborated netlists. 
- ./verilog/rtl/ : includes all the Verilog RTLs and source files.
- ./openlane/`<macro>`/ : includes all configuration files used to run openlane on your project.
- info.yaml: includes all the info required in [this example](info.yaml). Please make sure that you are pointing to an elaborated caravel netlist as well as a synthesized gate-level-netlist for the user_project_wrapper

## Managment SoC
The managment SoC runs firmware that can be used to:
- Configure User Project I/O pads
- Observe and control User Project signals (through on-chip logic analyzer probes)
- Control the User Project power supply

The memory map of the management SoC can be found [here](verilog/rtl/README)

## User Project Area
This is the user space. It has limited silicon area (TBD, about 3.1mm x 3.8mm) as well as a fixed number of I/O pads (37) and power pads (10).  See [the Caravel  premliminary datasheet](doc/caravel_datasheet.pdf) for details.
The repository contains a [sample user project](/verilog/rtl/user_proj_example.v) that contains a binary 32-bit up counter.  </br>

<p align="center">
<img src="/doc/counter_32.png" width="50%" height="50%">
</p>

The firmware running on the Management Area SoC, configures the I/O pads used by the counter and uses the logic probes to observe/control the counter. Three firmware examples are provided:
1. Configure the User Project I/O pads as o/p. Observe the counter value in the testbench: [IO_Ports Test](verilog/dv/caravel/user_proj_example/io_ports).
2. Configure the User Project I/O pads as o/p. Use the Chip LA to load the counter and observe the o/p till it reaches 500: [LA_Test1](verilog/dv/caravel/user_proj_example/la_test1).
3. Configure the User Project I/O pads as o/p. Use the Chip LA to control the clock source and reset signals and observe the counter value for five clock cylcles:  [LA_Test2](verilog/dv/caravel/user_proj_example/la_test2).

[0]: openlane/README.md
[1]: mpw-one-b.md

// SPDX-FileCopyrightText: Copyright 2020 Jecel Mattos de Assumpcao Jr
// 
// SPDX-License-Identifier: Apache-2.0 
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     https://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is has been replaced by a block of Morphle Logic cells
 * connected to the Logic Analyzer pins
 *
 *-------------------------------------------------------------
 */

module user_proj_example (
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output reg wbs_ack_o,
    output reg [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb
);
  parameter BLOCKWIDTH = 16; // this should not be changed
  parameter BLOCKHEIGHT = 16;
  parameter HMSB = BLOCKWIDTH-1;
  parameter HMSB2 = (2*BLOCKWIDTH)-1;
  parameter VMSB = BLOCKHEIGHT-1;
  parameter VMSB2 = (2*BLOCKHEIGHT)-1;

  assign io_out = {`MPRJ_IO_PADS{1'b0}};
  assign io_oeb = {`MPRJ_IO_PADS{1'b0}};

// dummy wishbone: you read back what you write
  dummy_slave wbs(
	  .wb_clk_i(wb_clk_i),
	  .wb_rst_i(wb_rst_i),
	  .wb_stb_i(wbs_stb_i),
	  .wb_cyc_i(wbs_cyc_i),
	  .wb_we_i(wbs_we_i),
	  .wb_sel_i(wbs_sel_i),
	  .wb_adr_i(wbs_adr_i),
	  .wb_dat_i(wbs_dat_i),
	  .wb_dat_o(wbs_dat_o),
	  .wb_ack_o(wbs_ack_o));

// logic analyzer connections and test project
//
// to make things easier for the RISC-V we configure
// 127 to 64 as outputs to the circuit under test
// 63 to 0 as inputs observing points in the circuit
  
  // these are all left hanging
  wire [HMSB:0] lhempty;   // this cell interrupts horizontal signals to left
  wire [HMSB:0] uvempty;   // this cell interrupts vertical signals to up
  wire [HMSB:0] rhempty;   // this cell interrupts horizontal signals to right
  wire [HMSB:0] dvempty;   // this cell interrupts vertical signals to down

  // UP
  wire [HMSB:0] uempty = {BLOCKWIDTH{1'b0}};    // cell U is not empty, so the LA is above us
  wire [HMSB2:0] uout;
  wire [HMSB:0] cbitout; // configuration bit to next cell (D)
  assign la_data_out = {{80{1'b0}},cbitout,uout};
  // la_data_in[127:114] are unused output
  wire reset = la_data_in[113]; // freezes the cell operations and clears everything
  wire confclk = la_data_in[112];  // a strobe to enter one configuration bit
  wire [HMSB:0] cbitin = la_data_in[111:96];   // new configuration bit from previous cell (U)
  wire [HMSB2:0] uin = la_data_in[95:64];

  // DOWN
  wire [HMSB:0] dempty = {BLOCKWIDTH{1'b1}};    // cell D is empty, so we are the bottommost of a signal
  wire [HMSB2:0] dout;                    // left dangling to avoid loops that confuse the tools
  wire [HMSB2:0] din = {(2*BLOCKWIDTH){1'b0}};

  // LEFT
  wire [VMSB:0] lempty = {BLOCKHEIGHT{1'b1}};    // cell L is empty, so we are the leftmost of a signal
  wire [VMSB2:0] lout;
  wire [VMSB2:0] lin = {(2*BLOCKHEIGHT){1'b0}};

  // RIGHT
  wire [VMSB:0] rempty = {BLOCKHEIGHT{1'b1}};    // cell D is empty, so we are the rightmost of a signal
  wire [VMSB2:0] rout;
  wire [VMSB2:0] rin = {(2*BLOCKHEIGHT){1'b0}};

    yblock #(.BLOCKWIDTH(BLOCKWIDTH), .BLOCKHEIGHT(BLOCKHEIGHT))
        blk (.reset(reset), .confclk(confclk), .cbitin(cbitin), .cbitout(cbitout),
             .lhempty(lhempty), .uvempty(uvempty),
             .rhempty(rhempty), .dvempty(dvempty),
             .uempty(uempty), .uin(uin), .uout(uout),
             .dempty(dempty), .din(din), .dout(dout),
             .lempty(lempty), .lin(lin), .lout(lout),
             .rempty(rempty), .rin(rin), .rout(rout));

endmodule



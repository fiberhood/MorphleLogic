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
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb
);
  parameter BLOCKWIDTH = 16;
  parameter BLOCKHEIGHT = 16;
  parameter HMSB = BLOCKWIDTH-1;
  parameter HMSB2 = (2*BLOCKWIDTH)-1;
  parameter VMSB = BLOCKHEIGHT-1;
  parameter VMSB2 = (2*BLOCKHEIGHT)-1;


// dummy wishbone: you read back what you write

    reg [31:0] store;

    wire valid = wb_cyc_i & wb_stb_i;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_o <= 1'b 0;
        end else begin
            if (wb_we_i == 1'b 1) begin
                if (wb_sel_i[0]) store[7:0]   <= wb_dat_i[7:0];
                if (wb_sel_i[1]) store[15:8]  <= wb_dat_i[15:8];
                if (wb_sel_i[2]) store[23:16] <= wb_dat_i[23:16];
                if (wb_sel_i[3]) store[31:24] <= wb_dat_i[31:24];
            end
            wb_dat_o <= store;
            wb_ack_o <= valid & !wb_ack_o;
        end
    end

// logic analyzer connections and test project
//
// to make things easier for the RISC-V we configure
// 127 to 64 as outputs to the circuit under test
// 63 to 0 as inputs observing points in the circuit
  
  assign la_data_out[127:48] = {48{1'b0}}; // don't leave it dangling
                                           // 127:64 is output, 63:48 is unused input
  wire reset = la_data_in[113]; // freezes the cell operations and clears everything
                                // 127:114 is unused output
  wire confclk = la_data_in[112];  // a strobe to enter one configuration bit
  wire [HMSB:0] cbitin = la_data_in[111:96];   // new configuration bit from previous cell (U)
  wire [HMSB:0] cbitout; // configuration bit to next cell (D)
  assign la_data_out[47:32] = cbitout;

  // these are all left hanging
  wire [HMSB:0] lhempty;   // this cell interrupts horizontal signals to left
  wire [HMSB:0] uvempty;   // this cell interrupts vertical signals to up
  wire [HMSB:0] rhempty;   // this cell interrupts horizontal signals to right
  wire [HMSB:0] dvempty;   // this cell interrupts vertical signals to down

  // UP
  wire [HMSB:0] uempty = {HMSB{1'b0}};    // cell U is empty, so we are the topmost of a signal
  wire [HMSB2:0] uin = la_data_in[95:64];
  wire [HMSB2:0] uout;
  assign la_data_out[31:0] = uout;
  // DOWN
  wire [HMSB:0] dempty = {HMSB{1'b1}};    // cell D is empty, so we are the bottommost of a signal
  wire [HMSB2:0] dout;
  wire [HMSB2:0] din = {HMSB2{1'b0}};
  // LEFT
  wire [VMSB:0] lempty = {VMSB{1'b1}};    // cell L is empty, so we are the leftmost of a signal
  wire [VMSB2:0] lout;
  wire [VMSB2:0] lin = {VMSB2{1'b0}};
  // RIGHT
  wire [VMSB:0] rempty = {VMSB{1'b1}};    // cell D is empty, so we are the rightmost of a signal
  wire [VMSB2:0] rout;
  wire [VMSB2:0] rin = {VMSB2{1'b0}};

    yblock #(.BLOCKWIDTH(BLOCKWIDTH), .BLOCKHEIGHT(BLOCKHEIGHT))
        blk (reset, confclk, cbitin, cbitout,
             lhempty, uvempty,
             rhempty, dvempty,
             uempty, uin, uout,
             dempty, din, dout,
             lempty, lin, lout,
             rempty, rin, rout);

endmodule



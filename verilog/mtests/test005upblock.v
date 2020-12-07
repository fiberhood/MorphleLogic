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

// This tests the user_proj_example in Caravel with the version that has
// a single 16x16 yblock attached to the logic analyzer pins.
// This reads a file with test vectors and it applies it to the device under
// test (DUT) and checks that the output is expected. Only the wires and
// outputs of the device are used, not the internal signals. This allows
// these to be regression tests that do not depend on internal changes to
// the DUT.

// this circuit was derived from the one described in
// https://syssec.ethz.ch/content/dam/ethz/special-interest/infk/inst-infsec/system-security-group-dam/education/Digitaltechnik_14/14_Verilog_Testbenches.pdf

`timescale 1ns/1ps
`include "../rtl/defines.v"
`include "../morphle/ycell.v"
`include "../morphle/yblock.v"
`include "../morphle/user_proj_block.v"

module test005upblock;

  reg [51:0] tvout;
  reg [47:0] xtvin;
  
  integer r, c;  // for printing rows and columns

  reg[31:0] vectornum, errors;   // bookkeeping variables
  reg[99:0]  testvectors[10000:0];// array of testvectors/
  reg clk;   // DUT is asynchronous, but the test circuit can't be
  // generate clock
  always     // no sensitivity list, so it always executes
  begin
    clk= 0; #5; clk= 1; #5;// 10ns period
  end

    wire vdda1 = 1'b1;	// User area 1 3.3V supply
    wire vdda2 = 1'b1;	// User area 2 3.3V supply
    wire vssa1 = 1'b0;	// User area 1 analog ground
    wire vssa2 = 1'b0;	// User area 2 analog ground
    wire vccd1 = 1'b1;	// User area 1 1.8V supply
    wire vccd2 = 1'b1;	// User area 2 1.8v supply
    wire vssd1 = 1'b0;	// User area 1 digital ground
    wire vssd2 = 1'b0;	// User area 2 digital ground

    // Wishbone Slave ports (WB MI A)
    wire wb_clk_i = clk;
    wire wb_rst_i = tvout[97];
    wire wbs_stb_i = 1'b0;
    wire wbs_cyc_i = 1'b0;
    wire wbs_we_i = 1'b0;
    wire [3:0] wbs_sel_i = {4{1'b0}};
    wire [31:0] wbs_dat_i = {32{1'b0}};
    wire [31:0] wbs_adr_i = {32{1'b0}};
    wire wbs_ack_o;
    wire [31:0] wbs_dat_o;

    // Logic Analyzer Signals
    wire  [127:0] la_data_in = {{12{1'b0}},tvout,{64{1'b0}}};
    wire [127:0] la_data_out;
    wire  [127:0] la_oen;

    // IOs
    wire  [37:0] io_in = {38{1'b0}};
    wire [37:0] io_out;
    wire [37:0] io_oeb;

  
  user_proj_example  DUT (
    .vdda1(vdda1),	// User area 1 3.3V supply
    .vdda2(vdda2),	// User area 2 3.3V supply
    .vssa1(vssa1),	// User area 1 analog ground
    .vssa2(vssa2),	// User area 2 analog ground
    .vccd1(vccd1),	// User area 1 1.8V supply
    .vccd2(vccd2),	// User area 2 1.8v supply
    .vssd1(vssd1),	// User area 1 digital ground
    .vssd2(vssd2),	// User area 2 digital ground

    // Wishbone Slave ports (WB MI A)
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),

    // Logic Analyzer Signals
    .la_data_in(la_data_in),
    .la_data_out(la_data_out),
    .la_oen(la_oen),

    // IOs
    .io_in(io_in),
    .io_out(io_out),
    .io_oeb(io_oeb)
);
  
  initial
  begin
    $readmemh("test005.tv", testvectors); // Read vectors
    vectornum= 0; errors = 0;  // Initialize 
  end
  
  // apply test vectors on rising edge of clk
  always @(posedge clk)
  begin
    #1; {tvout,xtvin} = testvectors[vectornum][99:0];
    if (xtvin === 48'bx)
    begin
      $display("%d tests completed with %d errors", vectornum-1, errors);
      $finish;   // End simulation
    end
  end
  
  wire reset = la_data_in[113];

  wire [2:0] cfg [0:15][0:15];

  genvar row, col;
  generate
  for (row = 0; row < 16; row = row + 1) begin : vertical
      for (col = 0; col < 16; col = col + 1) begin : horizontal
          assign cfg[row][col] = DUT.blk.column[col].row[row].yc.cfg.cnfg;
      end
  end
  endgenerate
      
  // check results on falling edge of clk
  always @(negedge clk)
  begin
    $display("testing vector %d", vectornum);
    if ((!tvout[51] & la_data_out[47:0] !== xtvin[47:0])) 
    begin
      $display("Error: sent = %b %b %h %h",
               la_data_in[113], la_data_in[112], la_data_in[111:96], la_data_in[95:64]);
      $display("  outputs = %h %h (%h %h exp)",
               la_data_out[47:32], la_data_out[31:0],
               xtvin[47:32], xtvin[31:0]);
      errors = errors + 1;
    end
    if (tvout[50]) // set this bit to pretty print cells
    begin
      for (r = 0; r < 6; r = r + 1) begin // top to bottom
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("   %b%b %b%b ", DUT.blk.vs[r][1+2*c], DUT.blk.vs[r][2*c],
                                  DUT.blk.vb[r][1+2*c], DUT.blk.vb[r][2*c]);
        end
        $display("  ");
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("  +--%b--+", DUT.blk.ve2[r][c]);
        end
        $display("  ");
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("%b%b|     |", DUT.blk.hb[c+1][1+2*r], DUT.blk.hb[c+1][2*r]);
        end
        $display("  ");
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("  %b  ", DUT.blk.he2[c][r]);
          if (cfg[r][c] == 3'b000) $write(".");
          else if (cfg[r][c] == 3'b001) $write("+");
          else if (cfg[r][c] == 3'b010) $write("-");
          else if (cfg[r][c] == 3'b011) $write("|");
          else if (cfg[r][c] == 3'b100) $write("1");
          else if (cfg[r][c] == 3'b101) $write("0");
          else if (cfg[r][c] == 3'b110) $write("Y");
          else if (cfg[r][c] == 3'b111) $write("N");
          else $write("?");
          $write("  %b", DUT.blk.he2[c][r]);
        end
        $display("  ");
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("%b%b|     |", DUT.blk.hs[c+1][1+2*r], DUT.blk.hs[c+1][2*r]);
        end
        $display("  ");
        for (c = 15; c > 1; c = c - 1) begin // left to right
          $write("  +--%b--+", DUT.blk.ve[r+1][c]);
        end
        $display("  ");
      end
    end
      // increment array index and read next testvector
    vectornum= vectornum + 1;
  end
  
endmodule

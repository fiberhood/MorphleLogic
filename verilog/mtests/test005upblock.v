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
    $display("just read vector %d %h %h", vectornum, tvout, xtvin);
    if (xtvin === 48'bx)
    begin
      $display("%d tests completed with %d errors", vectornum-1, errors);
      $finish;   // End simulation
    end
  end
  
  wire reset = la_data_in[113];
  
  // check results on falling edge of clk
  always @(negedge clk)
  begin
    $display("testing vector %d %h %h", vectornum, tvout, xtvin);
    if ((!tvout[51] & la_data_out[47:32] !== xtvin[47:32]) |
        (!tvout[50] & la_data_out[31:0] !== xtvin[31:0])) 
    begin
      $display("Error: sent = %b %b %h %h",
               la_data_in[113], la_data_in[112], la_data_in[111:96], la_data_in[95:64]);
      $display("  outputs = %h %h (%h %h exp)",
               la_data_out[47:32], la_data_out[31:0],
               xtvin[47:32], xtvin[31:0]);
      errors = errors + 1;
    end
      $display(" uin0 = %b", DUT.blk.vs[0]);
      $display(" uin1 = %b", DUT.blk.vs[1]);
      $display(" uin2 = %b", DUT.blk.vs[2]);
      $display(" uin3 = %b", DUT.blk.vs[3]);
      $display(" lin0 = %b", DUT.blk.hs[0]);
      $display(" lin1 = %b", DUT.blk.hs[1]);
      $display(" lin2 = %b", DUT.blk.hs[2]);
      $display(" lin3 = %b", DUT.blk.hs[3]);
      $display(" lin4 = %b", DUT.blk.hs[4]);
      $display(" lin5 = %b", DUT.blk.hs[5]);
      $display(" lin6 = %b", DUT.blk.hs[6]);
      $display(" lin7 = %b", DUT.blk.hs[7]);
      $display(" ve0 = %b", DUT.blk.ve[0]);
      $display(" ve1 = %b", DUT.blk.ve[1]);
      $display(" ve2 = %b", DUT.blk.ve[2]);
      $display(" ve3 = %b", DUT.blk.ve[3]);
      $display(" he0 = %b", DUT.blk.he[0]);
      $display(" he1 = %b", DUT.blk.he[1]);
      $display(" he2 = %b", DUT.blk.he[2]);
      $display(" he3 = %b", DUT.blk.he[3]);
      $display(" he4 = %b", DUT.blk.he[4]);
      $display(" he5 = %b", DUT.blk.he[5]);
      $display(" he6 = %b", DUT.blk.he[6]);
      $display(" he7 = %b", DUT.blk.he[7]);
      $display(" back ve0 = %b", DUT.blk.ve2[0]);
      $display(" ve1 = %b", DUT.blk.ve2[1]);
      $display(" ve2 = %b", DUT.blk.ve2[2]);
      $display(" ve3 = %b", DUT.blk.ve2[3]);
      $display(" he0 = %b", DUT.blk.he2[0]);
      $display(" he1 = %b", DUT.blk.he2[1]);
      $display(" he2 = %b", DUT.blk.he2[2]);
      $display(" he3 = %b", DUT.blk.he2[3]);
      $display(" he4 = %b", DUT.blk.he2[4]);
      $display(" he5 = %b", DUT.blk.he2[5]);
      $display(" he6 = %b", DUT.blk.he2[6]);
      $display(" he7 = %b", DUT.blk.he2[7]);
      // increment array index and read next testvector
    vectornum= vectornum + 1;
    $display("testing vector %d next", vectornum);
  end
  
endmodule

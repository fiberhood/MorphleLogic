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

// a more complete test for the "yellow cell" for Morphle Logic
// this reads a file with test vectors and it applies it to the device under
// test (DUT) and checks that the output is expected. Only the inputs and
// outputs of the device are used, not the internal signals. This allows
// these to be regression tests that do not depend on internal changes to
// the DUT.

// this circuit was derived from the one described in
// https://syssec.ethz.ch/content/dam/ethz/special-interest/infk/inst-infsec/system-security-group-dam/education/Digitaltechnik_14/14_Verilog_Testbenches.pdf

`timescale 1ns/1ps
`include "ycell.v"

module test004ycell;

  // control
  reg reset; // freezes the cell operations and clears everything
  reg confclk;  // a strobe to enter one configuration bit
  reg cbitin;   // new configuration bit from previous cell (U)
  wire cbitout; // configuration bit to next cell (D)
  wire hempty;   // this cell interrupts horizontal signals
  wire vempty;   // this cell interrupts vertical signals
  // UP
  reg uempty;    // cell U is empty, so we are the topmost of a signal
  reg [1:0] uin;
  wire [1:0] uout;
  // DOWN
  reg dempty;    // cell D is empty, so we are the bottommost of a signal
  reg [1:0] din;
  wire [1:0] dout;
  // LEFT
  reg lempty;    // cell L is empty, so we are the leftmost of a signal
  reg [1:0] lin;
  wire [1:0] lout;
  // RIGHT
  reg rempty;    // cell D is empty, so we are the rightmost of a signal
  reg [1:0] rin;
  wire [1:0] rout;
  
  reg xcbitout; // expected value for cbitout
  reg xhempty;
  reg xvempty;
  reg [1:0] xuout;
  reg [1:0] xdout;
  reg [1:0] xlout;
  reg [1:0] xrout;
  

  reg[31:0] vectornum, errors;   // bookkeeping variables
  reg[25:0]  testvectors[10000:0];// array of testvectors/
  reg clk;   // DUT is asynchronous, but the test circuit can't be
  // generate clock
  always     // no sensitivity list, so it always executes
  begin
    clk= 0; #5; clk= 1; #5;// 10ns period
  end
  
  ycell DUT (reset, confclk, cbitin, cbitout,
             hempty, vempty,
             uempty, uin, uout,
             dempty, din, dout,
             lempty, lin, lout,
             rempty, rin, rout);
  
  initial
  begin
    $readmemh("test004.tv", testvectors); // Read vectors
    vectornum= 0; errors = 0;  // Initialize 
  end
  
  // apply test vectors on rising edge of clk
  always @(posedge clk)
  begin
    #1; {xhempty,xvempty,  // 7 hex digits
         uempty,dempty,lempty,rempty,
         reset,confclk,cbitin,xcbitout,
         uin,xuout,
         din,xdout,
         lin,xlout,
         rin,xrout} = testvectors[vectornum][25:0];
  end
  
  // check results on falling edge of clk
  always @(negedge clk)
  begin
    if (reset === 1'bx)
    begin
      $display("%d tests completed with %d errors", vectornum, errors);
      $finish;   // End simulation
    end
    $display("testing vector %d", vectornum);
    if (vectornum>6)        // skip six entries to settle down since we
                            // can't expect unknown values
    begin
      if ({hempty,vempty,cbitout,uout,dout,lout,rout} !==
          {xhempty,xvempty,xcbitout,xuout,xdout,xlout,xrout}) 
      begin
        $display("Error: inputs = %b %b %b %b %b %b",
                 {uempty,dempty,lempty,rempty},
                 {reset,confclk,cbitin},
                 uin,din,lin,rin);
        $display("  outputs = %b (%b exp)",
                 {hempty,vempty,cbitout,uout,dout,lout,rout},
                 {xhempty,xvempty,xcbitout,xuout,xdout,xlout,xrout});
        errors = errors + 1;
      end
    end
      // increment array index and read next testvector
    vectornum= vectornum+ 1;
  end
  
endmodule

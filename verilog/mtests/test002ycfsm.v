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

// a more complete test for the basic finite state machine for Morphle Logic
// this reads a file with test vectors and it applies it to the device under
// test (DUT) and checks that the output is expected. Only the inputs and
// outputs of the device are used, not the internal signals. This allows
// these to be regression tests that do not depend on internal changes to
// the DUT.

// this circuit was derived from the one described in
// https://syssec.ethz.ch/content/dam/ethz/special-interest/infk/inst-infsec/system-security-group-dam/education/Digitaltechnik_14/14_Verilog_Testbenches.pdf

`timescale 1ns/1ps
`include "../morphle/ycell.v"

module test002fsm;

  reg [1:0] in;
  wire [1:0] out;
  reg [1:0] outexpected;
  reg reset;
  reg [1:0] match;

  reg[31:0] vectornum, errors;   // bookkeeping variables
  reg[6:0]  testvectors[10000:0];// array of testvectors/
  reg clk;   // DUT is asynchronous, but the test circuit can't be
  // generate clock
  always     // no sensitivity list, so it always executes
  begin
    clk= 1; #5; clk= 0; #5;// 10ns period
  end
  
  ycfsm DUT (.reset(reset), .in(in), .match(match), .out(out));
  
  initial
  begin
    $readmemb("test002.tv", testvectors); // Read vectors
    vectornum= 0; errors = 0;  // Initialize 
  end
  
  // apply test vectors on rising edge of clk
  always @(posedge clk)
  begin
    #1; {reset, in, match, outexpected} = testvectors[vectornum];
  end
  
  // check results on falling edge of clk
  always @(negedge clk)
  begin
    $display("testing vector %d", vectornum);
    if (vectornum>1)        // skip two entries to settle down
    begin
      if (out !== outexpected) 
      begin
        $display("Error: inputs = %b", {reset, in, match});
        $display("  outputs = %b (%b exp)",out,outexpected);
        errors = errors + 1;
      end
    end
      // increment array index and read next testvector
    vectornum= vectornum+ 1;
    if (testvectors[vectornum] ===7'bx)
    begin
      $display("%d tests completed with %d errors", vectornum, errors);
      $finish;   // End simulation
    end
  end
  
endmodule

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

// simple test for the basic finite state machine for Morphle Logic
// this lists many internal variables in order to find a bug in the
// reset logic, so it isn't a proper black box test. It is also an
// experiement in generating a waveform file

`timescale 1ns/1ps
`include "morphlelogic.v"

module test1fsm;

  reg [1:0] in;
  wire [1:0] out;
  reg reset;
  reg [1:0] match;
  
  ycfsm DUT (reset, in, match, out);
  
  initial
  begin
    reset = 0; in = `Vempty; match = `Vempty;
    #10 reset = 1;
    #10 reset = 0;
    #10 in = `V1;
    #10 match = `V1;
    #10 match = `Vempty;
    #10 in = `Vempty;
    #10 match = `V0;
    #10 match = `Vempty;
    #10 in = `V1;
    #10 match = `V1;
    #10 in = `Vempty;
    #10 in = `V0;
    #10 match = `Vempty;
    #10 in = `Vempty;
    #10;
  end
  
  initial
  begin
  $monitor($time,,reset,out,,
           in,DUT.lin,DUT.nlin,DUT.inval,DUT.linval,,
           match,DUT.lmatch,DUT.nlmatch,DUT.matchval,DUT.lmatchval,,
           DUT.clear2,DUT.lmempty,DUT.nlmempty);
  $dumpfile("test.vcd");
  $dumpvars;
  end
  
endmodule

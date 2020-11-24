// Copyright 2020 Jecel Mattos de Assumpcao Jr
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


// These are the building blocks for Morphle Logic, an asynchronous
// runtime reconfigurable array (ARRA).

// many signals are two bit busses
`define Vempty 0
`define V0     1
`define V1     2
// the combination 3 is not defined

// this asynchronous finite state machine is the basic building block
// of Morphle Logic. It explicitly defines 5 simple latches that
// directly change when their inputs do, so there is no clock anywhere

module ycfsm (reset, in, match, out);
    input reset;
    input [1:0] in;
    input [1:0] match;
    output [1:0] out;
    
    wire [1:0] lin;
    wire [1:0] nlin;
    wire [1:0] lmatch;
    wire [1:0] nlmatch;
    wire lmempty;
    wire nlmempty;
    
    wire clear;
    wire linval, inval, lmatchval, matchval;
    
    assign linval    = lin != `Vempty;
    assign inval     = in != `Vempty;
    assign lmatchval = lmatch != `Vempty;
    assign matchval  = match != `Vempty;
    
    assign clear = reset | (lmempty & linval & ~inval);
    wire clear2;
    assign clear2 = {clear,clear};
    
    // two bit latches
    assign lin = ~(clear2 | nlin);
    assign nlin = ~(in | lin);
    
    assign lmatch = ~(clear2 | nlmatch);
    assign nlmatch = ~((match & {nlmempty,nlmempty}) | lmatch);
    
    // one bit latch
    assign lmempty = ~(~(linval | lmatchval) | nlmempty);
    assign nlmempty = ~((lmatchval & ~matchval) | lmempty);
    
    // forward the result of combining match and in
    assign out[1] = lin[1] & lmatch[1];
    assign out[0] = (lmatch[1] & lin[0]) & (lmatch[0] & linval);
    
endmodule

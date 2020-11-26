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
    wire [1:0] clear2;
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
    assign out[0] = (lmatch[1] & lin[0]) | (lmatch[0] & linval);
    
endmodule

// each "yellow cell" in Morphle Logic can be configured to one of eight
// different options. This circuit saves the 3 bits of the configuration
// and outputs the control circuit the rest of the cell needs
//
// the case statement is where the meaning of the configuration bits are
// defined and is the only thing that needs to change (not counting software)
// if the meaning needs to be changed

module ycconfig (confclk, cbitin, cbitout,
                 empty,
                 hblock, hbypass, hmatch0, hmatch1,
                 vblock, vbypass, vmatch0, vmatch1);
       input confclk, cbitin;
       output cbitout;
       output empty;
       output hblock, hbypass, hmatch0, hmatch1;
       output vblock, vbypass, vmatch0, vmatch1;
       reg [8:0] r;  // case needs REG even though we want a combinational circuit
       assign {empty,hblock,hbypass, hmatch0, hmatch1,
               vblock, vbypass, vmatch0, vmatch1} = r;
       
       reg [2:0] config;
       always @(posedge confclk) config = {config[1:0],cbitin}; // shift to msb
       assign cbitout = config[2];  // shifted to next cell
       
       always @(config)
         case(config)
           3'b000: r = 9'b110001000; // space is empty and blocked
           3'b001: r = 9'b000110011; // +     sync with don't cares
           3'b010: r = 9'b001001000; // -     horizontal short circuit
           3'b011: r = 9'b010000100; // |     vertical short circuit
           3'b100: r = 9'b000110001; // 1     1 vertical, X horizontal
           3'b101: r = 9'b000110010; // 0     0 vertical, X horizontal
           3'b110: r = 9'b000010011; // Y     X vertical, 1 horizontal     
           3'b111: r = 9'b000100011; // N     X vertical, 0 horizontal
         endcase
       
endmodule

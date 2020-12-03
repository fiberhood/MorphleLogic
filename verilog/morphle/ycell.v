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

module ycfsm (
    input reset,
    input [1:0] in,
    input [1:0] match,
    output [1:0] out);
    
    wire [1:0] lin;
    wire [1:0] nlin;
    wire [1:0] lmatch;
    wire [1:0] nlmatch;
    wire lmempty;
    wire nlmempty;
        
    wire linval    =| lin; // lin != `Vempty;
    wire inval     =| in; // in != `Vempty;
    wire lmatchval =| lmatch; // lmatch != `Vempty;
    wire matchval  =| match; // match != `Vempty;
    
    wire clear = reset | (lmempty & linval & ~inval);
    wire [1:0] clear2 = {clear,clear};
    
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

module ycconfig (
       input confclk, cbitin,
       output cbitout,
       output empty,
       output hblock, hbypass, hmatch0, hmatch1,
       output vblock, vbypass, vmatch0, vmatch1);
       
       reg [8:0] r;  // case needs REG even though we want a combinational circuit
       assign {empty,hblock,hbypass, hmatch0, hmatch1,
               vblock, vbypass, vmatch0, vmatch1} = r;
       
       reg [2:0] cnfg;
       always @(posedge confclk) cnfg = {cnfg[1:0],cbitin}; // shift to msb
       assign cbitout = cnfg[2];  // shifted to next cell
       
       always @*
         case(cnfg)
           default: r = 9'b110001000; // . is empty and blocked
           3'b001: r = 9'b000110011; // +     sync with don't cares
           3'b010: r = 9'b001001000; // -     horizontal short circuit
           3'b011: r = 9'b010000100; // |     vertical short circuit
           3'b100: r = 9'b000110001; // 1     1 vertical, X horizontal
           3'b101: r = 9'b000110010; // 0     0 vertical, X horizontal
           3'b110: r = 9'b000010011; // Y     X vertical, 1 horizontal     
           3'b111: r = 9'b000100011; // N     X vertical, 0 horizontal
         endcase
       
endmodule

// this is the heart of Morphle Logic. It is called the "yellow cell" because
// of the first few illustrations of how it would work, with "red cells" being
// where the inputs and outputs connect to the network. Each yellow cell
// connects to four neighbors, labelled U (up), D (down), L (left) and R (right)
//
// Each cell receives its configuration bits from U and passes them on to D
//
// Values are indicated by a pair of wires, where 00 indicates empty, 01 a
// 0 value and 10 indicates a 1 value. The combination 11 should never appear
//
// Vertical signals are implemented by a pair of pairs, one of which goes
// from U to D and the second goes D to U. The first pair is the accumulated
// partial results from several cells while the second is the final result
// Horizontal signals also have a L to R pair for partial results and a R to L
// pair for final results

module ycell(
  // control
  input reset,    // freezes the cell operations and clears everything
  output reseto,  // pass through to help routing
  input confclk,   // a strobe to enter one configuration bit
  output confclko,
  input cbitin,   // new configuration bit from previous cell (U)
  output cbitout, // configuration bit to next cell (D)
  output hempty,  // this cell interrupts horizontal signals
  output hempty2,
  output vempty,  // this cell interrupts vertical signals
  output vempty2,
  // UP
  input uempty,    // cell U is empty, so we are the topmost of a signal
  input [1:0] uin,
  output [1:0] uout,
  // DOWN
  input dempty,    // cell D is empty, so we are the bottommost of a signal
  input [1:0] din,
  output [1:0] dout,
  // LEFT
  input lempty,    // cell L is empty, so we are the leftmost of a signal
  input [1:0] lin,
  output [1:0] lout,
  // RIGHT
  input rempty,    // cell D is empty, so we are the rightmost of a signal
  input [1:0] rin,
  output [1:0] rout);
  
  // bypass to pins on opposite side of the circuit (could add buffers?)
  assign reseto = reset;
  assign confclko = confclk;
  assign hempty2 = hempty;
  assign vempty2 = vempty;
  
  // configuration signals decoded
  wire empty;
  wire hblock, hbypass, hmatch0, hmatch1;
  wire vblock, vbypass, vmatch0, vmatch1;
  ycconfig cfg (.confclk(confclk), .cbitin(cbitin), .cbitout(cbitout),
                 .empty(empty),
                 .hblock(hblock), .hbypass(hbypass), .hmatch0(hmatch0), .hmatch1(hmatch1),
                 .vblock(vblock), .vbypass(vbypass), .vmatch0(vmatch0), .vmatch1(vmatch1));
                 
  assign hempty = empty | hblock;
  wire hreset = reset | hblock; // perhaps "| hbypass" to save energy?
  wire [1:0] hin;
  wire [1:0] hout;
  wire [1:0] hback;

  assign vempty = empty | vblock;
  wire vreset = reset | vblock;
  wire [1:0] vin;
  wire [1:0] vout;
  wire [1:0] vback;

  wire [1:0] hmatch = {vback[1]&hmatch1,vback[0]&hmatch0};
  ycfsm hfsm (.reset(hreset), .in(hin), .match(hmatch), .out(hout));
  wire [1:0] bhout = hbypass ? hin : hout;
  assign rout = bhout;
  assign hin = lempty ? {~(hback[1]|hback[1'b0]),1'b0} : lin;
  assign hback = (rempty | hempty) ? bhout : rin; // don't propagate when rightmost or empty
  assign lout = hback;
  
  wire [1:0] vmatch = {hback[1]&vmatch1,hback[0]&vmatch0};
  ycfsm vfsm (.reset(vreset), .in(vin), .match(vmatch), .out(vout));
  wire [1:0] bvout = vbypass ? vin : vout;
  assign dout = bvout;
  assign vin = uempty ? {~(vback[1]|vback[1'b0]),1'b0} : uin;
  assign vback = (dempty | vempty) ? bvout : din; // don't propagate when bottommost or empty
  assign uout = vback;

endmodule


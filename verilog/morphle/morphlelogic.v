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
       
       reg [2:0] cnfg;
       always @(posedge confclk) cnfg = {cnfg[1:0],cbitin}; // shift to msb
       assign cbitout = cnfg[2];  // shifted to next cell
       
       always @*
         case(cnfg)
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

module ycell(reset, confclk, cbitin, cbitout,
             hempty, vempty,
             uempty, uin, uout,
             dempty, din, dout,
             lempty, lin, lout,
             rempty, rin, rout);
  // control
  input reset; // freezes the cell operations and clears everything
  input confclk;  // a strobe to enter one configuration bit
  input cbitin;   // new configuration bit from previous cell (U)
  output cbitout; // configuration bit to next cell (D)
  output hempty;   // this cell interrupts horizontal signals
  output vempty;   // this cell interrupts vertical signals
  // UP
  input uempty;    // cell U is empty, so we are the topmost of a signal
  input [1:0] uin;
  output [1:0] uout;
  // DOWN
  input dempty;    // cell D is empty, so we are the bottommost of a signal
  input [1:0] din;
  output [1:0] dout;
  // LEFT
  input lempty;    // cell L is empty, so we are the leftmost of a signal
  input [1:0] lin;
  output [1:0] lout;
  // RIGHT
  input rempty;    // cell D is empty, so we are the rightmost of a signal
  input [1:0] rin;
  output [1:0] rout;
  
  // configuration signals decoded
  wire empty;
  wire hblock, hbypass, hmatch0, hmatch1;
  wire vblock, vbypass, vmatch0, vmatch1;
  ycconfig cfg (confclk, cbitin, cbitout,
                 empty,
                 hblock, hbypass, hmatch0, hmatch1,
                 vblock, vbypass, vmatch0, vmatch1);
                 
  assign hempty = empty | hblock;
  assign vempty = empty | vblock;
  wire hreset = reset | hblock; // perhaps "| hbypass" to save energy?
  wire vreset = reset | vblock;
  
  // internal wiring
  wire [1:0] vin;
  wire [1:0] vout;
  wire [1:0] vback;
  wire [1:0] hin;
  wire [1:0] hout;
  wire [1:0] hback;
  
  wire [1:0] hmatch = {vback[1]&hmatch1,vback[0]&hmatch0};
  ycfsm hfsm (hreset, hin, hmatch, hout);
  wire [1:0] bhout = hbypass ? hin : hout;
  assign rout = bhout;
  assign hin = lempty ? {~(hback[1]|hback[1'b0]),1'b0} : lin;
  assign hback = (rempty | hempty) ? bhout : rin; // don't propagate when rightmost or empty
  assign lout = hback;
  
  wire [1:0] vmatch = {hback[1]&vmatch1,hback[0]&vmatch0};
  ycfsm vfsm (vreset, vin, vmatch, vout);
  wire [1:0] bvout = vbypass ? vin : vout;
  assign dout = bvout;
  assign vin = uempty ? {~(vback[1]|vback[1'b0]),1'b0} : uin;
  assign vback = (dempty | vempty) ? bvout : din; // don't propagate when bottommost or empty
  assign uout = vback;

endmodule

module yblock(reset, confclk, cbitin, cbitout,
             lhempty, uvempty,
             rhempty, dvempty,
             uempty, uin, uout,
             dempty, din, dout,
             lempty, lin, lout,
             rempty, rin, rout);
  parameter BLOCKWIDTH = 8;
  parameter BLOCKHEIGHT = 8;
  parameter HMSB = BLOCKWIDTH-1;
  parameter HMSB2 = (2*BLOCKWIDTH)-1;
  parameter VMSB = BLOCKHEIGHT-1;
  parameter VMSB2 = (2*BLOCKHEIGHT)-1;
  // control
  input reset; // freezes the cell operations and clears everything
  input confclk;  // a strobe to enter one configuration bit
  input [HMSB:0] cbitin;   // new configuration bit from previous cell (U)
  output [HMSB:0] cbitout; // configuration bit to next cell (D)
  output [HMSB:0] lhempty;   // this cell interrupts horizontal signals to left
  output [HMSB:0] uvempty;   // this cell interrupts vertical signals to up
  output [HMSB:0] rhempty;   // this cell interrupts horizontal signals to right
  output [HMSB:0] dvempty;   // this cell interrupts vertical signals to down
  // UP
  input [HMSB:0] uempty;    // cell U is empty, so we are the topmost of a signal
  input [HMSB2:0] uin;
  output [HMSB2:0] uout;
  // DOWN
  input [HMSB:0] dempty;    // cell D is empty, so we are the bottommost of a signal
  input [HMSB2:0] din;
  output [HMSB2:0] dout;
  // LEFT
  input [VMSB:0] lempty;    // cell L is empty, so we are the leftmost of a signal
  input [VMSB2:0] lin;
  output [VMSB2:0] lout;
  // RIGHT
  input [VMSB:0] rempty;    // cell D is empty, so we are the rightmost of a signal
  input [VMSB2:0] rin;
  output [VMSB2:0] rout;
  
  // vertical lines are row order, horizontal lines are column order
  // this makes assigns chunks much simpler
  
  wire [((BLOCKWIDTH*(BLOCKHEIGHT+1))-1):0] vcbit;
  wire [((BLOCKWIDTH*(BLOCKHEIGHT+2))-1):0] ve; // first and last rows go outside
  wire [(((BLOCKWIDTH+2)*BLOCKHEIGHT)-1):0] he; // first and last columns go outside
  wire [(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):0] vs; // signal pairs
  wire [(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):0] vb; // signal pairs back
  wire [(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):0] hs; // signal pairs
  wire [(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):0] hb; // signal pairs back
  
  genvar x;
  genvar y;
  
  generate
    for (x = 0 ; x < BLOCKWIDTH ; x = x + 1) begin
      for (y = 0 ; y < BLOCKHEIGHT ; y = y + 1) begin
        ycell gencell (reset, confclk,
             // cbitin, cbitout,
             vcbit[x+(y*BLOCKWIDTH)], vcbit[x+((y+1)*BLOCKWIDTH)],
             // hempty, vempty,
             he[y+((x+1)*BLOCKHEIGHT)], ve[x+((y+1)*BLOCKWIDTH)],
             // uempty, uin, uout,
             ve[x+(y*BLOCKWIDTH)],
             vs[(2*x)+1+(y*2*BLOCKWIDTH):(2*x)+(y*2*BLOCKWIDTH)],
             vb[(2*x)+1+(y*2*BLOCKWIDTH):(2*x)+(y*2*BLOCKWIDTH)],
             // dempty, din, dout,
             ve[x+((y+2)*BLOCKWIDTH)],
             vs[(2*x)+1+((y+1)*2*BLOCKWIDTH):(2*x)+((y+1)*2*BLOCKWIDTH)],
             vb[(2*x)+1+((y+1)*2*BLOCKWIDTH):(2*x)+((y+1)*2*BLOCKWIDTH)],
             // lempty, lin, lout,
             he[y+(x*BLOCKHEIGHT)],
             hs[(2*y)+1+(x*2*BLOCKHEIGHT):(2*y)+(x*2*BLOCKHEIGHT)],
             hb[(2*y)+1+(x*2*BLOCKHEIGHT):(2*y)+(x*2*BLOCKHEIGHT)],
             // rempty, rin, rout
             he[y+((x+2)*BLOCKHEIGHT)],
             hs[(2*y)+1+((x+1)*2*BLOCKHEIGHT):(2*y)+((x+1)*2*BLOCKHEIGHT)],
             hb[(2*y)+1+((x+1)*2*BLOCKHEIGHT):(2*y)+((x+1)*2*BLOCKHEIGHT)]
             );
      end
    end
  endgenerate

  // the ends of the arrays of wire go to the outside
  
  assign vcbit[BLOCKWIDTH-1:0] = cbitin;   
  assign cbitout = vcbit[((BLOCKWIDTH*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*BLOCKHEIGHT]; 
  assign lhempty = he[BLOCKWIDTH+BLOCKHEIGHT-1:BLOCKWIDTH]; 
  assign uvempty = ve[BLOCKWIDTH-1+BLOCKHEIGHT:BLOCKHEIGHT]; 
  assign rhempty = he[(((BLOCKWIDTH+1)*BLOCKHEIGHT)-1):BLOCKWIDTH*BLOCKHEIGHT]; 
  assign dvempty = ve[((BLOCKWIDTH*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*BLOCKHEIGHT]; 
  // UP
  assign ve[BLOCKWIDTH-1:0] = uempty; 
  assign vs[(2*BLOCKWIDTH)-1:0] = uin;
  assign uout = vb[(2*BLOCKWIDTH)-1:0];
  // DOWN
  assign ve[((BLOCKWIDTH*(BLOCKHEIGHT+2))-1):BLOCKWIDTH*(BLOCKHEIGHT+1)] = dempty; 
  assign vb[(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*2*BLOCKHEIGHT] = din;
  assign dout = vs[(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*2*BLOCKHEIGHT];
  // LEFT
  assign he[BLOCKHEIGHT-1:0] = lempty;   
  assign hs[(2*BLOCKHEIGHT)-1:0] = lin;
  assign lout = hb[(2*BLOCKHEIGHT)-1:0];
  // RIGHT
  assign he[(((BLOCKWIDTH+2)*BLOCKHEIGHT)-1):(BLOCKWIDTH+1)*BLOCKHEIGHT] = rempty;  
  assign hb[(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):BLOCKWIDTH*BLOCKHEIGHT*2] = rin;
  assign rout = hs[(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):BLOCKWIDTH*BLOCKHEIGHT*2];
  
endmodule


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


// This uses the building blocks for Morphle Logic, an asynchronous
// runtime reconfigurable array (ARRA), as found in ycell.v to create
// a block of yellow cells wired together and with ports to connect
// to other blocks

// many signals are two bit busses
`define Vempty 0
`define V0     1
`define V1     2
// the combination 3 is not defined


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
  // this makes assigning chunks much simpler
  
  // ----[]----[]----[]----
  //  0     1     2     3     BLOCKHEIGHT+1   vcbit
  //
  // ====[]====[]====[]====
  // 1,0    3,2   5,4   7,6   (BLOCKHEIGHT+1)*2  hs, hb, vs, vb
  //
  // u    [ued]     [ued]    [ued]   d
  // \-----/| \------+|+------/|\----/
  // uv-----+--------/ \-------+-----dv   BLOCKHEIGHT+2  he, ve
    
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
    for (x = 0 ; x < BLOCKWIDTH ; x = x + 1) begin : generate_columns
      for (y = 0 ; y < BLOCKHEIGHT ; y = y + 1) begin : generate_rows
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
             vb[(2*x)+1+((y+1)*2*BLOCKWIDTH):(2*x)+((y+1)*2*BLOCKWIDTH)],
             vs[(2*x)+1+((y+1)*2*BLOCKWIDTH):(2*x)+((y+1)*2*BLOCKWIDTH)],
             // lempty, lin, lout,
             he[y+(x*BLOCKHEIGHT)],
             hs[(2*y)+1+(x*2*BLOCKHEIGHT):(2*y)+(x*2*BLOCKHEIGHT)],
             hb[(2*y)+1+(x*2*BLOCKHEIGHT):(2*y)+(x*2*BLOCKHEIGHT)],
             // rempty, rin, rout
             he[y+((x+2)*BLOCKHEIGHT)],
             hb[(2*y)+1+((x+1)*2*BLOCKHEIGHT):(2*y)+((x+1)*2*BLOCKHEIGHT)],
             hs[(2*y)+1+((x+1)*2*BLOCKHEIGHT):(2*y)+((x+1)*2*BLOCKHEIGHT)]
             );
      end
    end
  endgenerate

  // the ends of the arrays of wire go to the outside
  
  assign vcbit[BLOCKWIDTH-1:0] = cbitin;   
  assign cbitout = vcbit[((BLOCKWIDTH*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*BLOCKHEIGHT]; 
  // UP
  assign ve[BLOCKWIDTH-1:0] = uempty;
  assign uvempty = ve[(2*BLOCKWIDTH)-1:BLOCKWIDTH]; 
  assign vs[(2*BLOCKWIDTH)-1:0] = uin;
  assign uout = vb[(2*BLOCKWIDTH)-1:0];
  // DOWN
  assign ve[((BLOCKWIDTH*(BLOCKHEIGHT+2))-1):BLOCKWIDTH*(BLOCKHEIGHT+1)] = dempty;
  assign dvempty = ve[BLOCKWIDTH-1+BLOCKHEIGHT*BLOCKWIDTH:BLOCKHEIGHT*BLOCKWIDTH]; 
  assign vb[(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*2*BLOCKHEIGHT] = din;
  assign dout = vs[(((BLOCKWIDTH*2)*(BLOCKHEIGHT+1))-1):BLOCKWIDTH*2*BLOCKHEIGHT];
  // LEFT
  assign he[BLOCKHEIGHT-1:0] = lempty;
  assign lhempty = he[(2*BLOCKHEIGHT)-1:BLOCKHEIGHT];   
  assign hs[(2*BLOCKHEIGHT)-1:0] = lin;
  assign lout = hb[(2*BLOCKHEIGHT)-1:0];
  // RIGHT
  assign he[(((BLOCKWIDTH+2)*BLOCKHEIGHT)-1):(BLOCKWIDTH+1)*BLOCKHEIGHT] = rempty;
  assign rhempty = ve[BLOCKHEIGHT-1+BLOCKHEIGHT*BLOCKWIDTH:BLOCKHEIGHT*BLOCKWIDTH];  
  assign hb[(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):BLOCKWIDTH*BLOCKHEIGHT*2] = rin;
  assign rout = hs[(((BLOCKWIDTH+1)*(BLOCKHEIGHT*2))-1):BLOCKWIDTH*BLOCKHEIGHT*2];
  
endmodule


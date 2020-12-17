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


module yblock #(parameter
  BLOCKWIDTH = 8,
  BLOCKHEIGHT = 8,
  HMSB = BLOCKWIDTH-1,
  HMSB2 = (2*BLOCKWIDTH)-1,
  VMSB = BLOCKHEIGHT-1,
  VMSB2 = (2*BLOCKHEIGHT)-1)
  (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
  // control
  input reset,              // freezes the cell operations and clears everything
  input confclk,            // a strobe to enter one configuration bit
  input [HMSB:0] cbitin,    // new configuration bit from previous cell (U)
  output [HMSB:0] cbitout,  // configuration bit to next cell (D)
  output [HMSB:0] lhempty,  // this cell interrupts horizontal signals to left
  output [HMSB:0] uvempty,  // this cell interrupts vertical signals to up
  output [HMSB:0] rhempty,  // this cell interrupts horizontal signals to right
  output [HMSB:0] dvempty,  // this cell interrupts vertical signals to down
  // UP
  input [HMSB:0] uempty,    // cells U is empty, so we are the topmost of a signal
  input [HMSB2:0] uin,
  output [HMSB2:0] uout,
  // DOWN
  input [HMSB:0] dempty,    // cells D is empty, so we are the bottommost of a signal
  input [HMSB2:0] din,
  output [HMSB2:0] dout,
  // LEFT
  input [VMSB:0] lempty,    // cells L is empty, so we are the leftmost of a signal
  input [VMSB2:0] lin,
  output [VMSB2:0] lout,
  // RIGHT
  input [VMSB:0] rempty,    // cells D is empty, so we are the rightmost of a signal
  input [VMSB2:0] rin,
  output [VMSB2:0] rout);
  
  // vertical lines are row order, horizontal lines are column order
  // this makes assigning chunks much simpler
  
  // top,right            bottom,left 
  // \/                   \/
  // ----[]----[]----[]----
  //  0     1     2     3     BLOCKHEIGHT+1   vcbit, he, he2, ve, ve2, rst, cclk
  //
  // ====[]====[]====[]====
  // 1,0    3,2   5,4   7,6   (BLOCKHEIGHT+1)*2  hs, hb, vs, vb
    
  wire [HMSB:0] vcbit[BLOCKHEIGHT:0];
  wire [HMSB:0] ve[BLOCKHEIGHT:0];
  wire [VMSB:0] he[BLOCKWIDTH:0];
  wire [HMSB:0] rst[BLOCKHEIGHT:0];
  wire [HMSB:0] cclk[BLOCKHEIGHT:0];
  wire [HMSB:0] ve2[BLOCKHEIGHT:0];
  wire [VMSB:0] he2[BLOCKWIDTH:0];
  wire [HMSB2:0] vs[BLOCKHEIGHT:0]; // signal pairs
  wire [HMSB2:0] vb[BLOCKHEIGHT:0]; // signal pairs back
  wire [VMSB2:0] hs[BLOCKWIDTH:0]; // signal pairs
  wire [VMSB2:0] hb[BLOCKWIDTH:0]; // signal pairs back
  
  genvar x;
  genvar y;
  
  // column BLOCKWIDTH is leftmost, 0 is rightmost
  // row 0 is the topmost, BLOCKHEIGHT is bottommost
  
  generate
    for (x = 0 ; x < BLOCKWIDTH ; x = x + 1) begin : column
      for (y = 0 ; y < BLOCKHEIGHT ; y = y + 1) begin : row
        ycell yc (
`ifdef USE_POWER_PINS
             .vccd1(vccd1),
             .vssd1(vssd1),
`endif
             .reset(rst[y][x]), .reseto(rst[y+1][x]),
             .confclk(cclk[y][x]), .confclko(cclk[y+1][x]),
             // cbitin, cbitout,
             .cbitin(vcbit[y][x]), .cbitout(vcbit[y+1][x]),
             // hempty, vempty, (R, U)
             .hempty(he2[x+1][y]), .vempty(ve2[y][x]),
             // hempty2, vempty2, (L, D)
             .hempty2(he[x][y]), .vempty2(ve[y+1][x]),
             // uempty, uin, uout,
             .uempty(ve[y][x]),
             .uin(vs[y][2*x+1:2*x]),
             .uout(vb[y][2*x+1:2*x]),
             // dempty, din, dout,
             .dempty(ve2[y+1][x]),
             .din(vb[y+1][2*x+1:2*x]),
             .dout(vs[y+1][2*x+1:2*x]),
             // lempty, lin, lout,
             .lempty(he[x+1][y]),
             .lin(hs[x+1][2*y+1:2*y]),
             .lout(hb[x+1][2*y+1:2*y]),
             // rempty, rin, rout
             .rempty(he2[x][y]),
             .rin(hb[x][2*y+1:2*y]),
             .rout(hs[x][2*y+1:2*y])
             );
      end
    end
  endgenerate

//   he[2]---l[1]h2--he[1]----l[0]h2---he[0]
//   he2[2]--h[1]r---he2[1]---h[0]r----he2[0]

  // the ends of the arrays of wire go to the outside
  assign rst[0] = {BLOCKWIDTH{reset}};
  assign cclk[0] = {BLOCKWIDTH{confclk}};
  
  assign vcbit[0] = cbitin;   
  assign cbitout = vcbit[BLOCKHEIGHT]; 
  // UP
  assign ve[0] = uempty;
  assign uvempty = ve2[0]; 
  assign vs[0] = uin;
  assign uout = vb[0];
  // DOWN
  assign ve2[BLOCKHEIGHT] = dempty;
  assign dvempty = ve[BLOCKHEIGHT]; 
  assign vb[BLOCKHEIGHT] = din;
  assign dout = vs[BLOCKHEIGHT];
  // RIGHT
  assign he2[0] = rempty;
  assign rhempty = he[0];   
  assign hb[0] = rin;
  assign rout = hs[0];
  // LEFT
  assign he[BLOCKWIDTH] = lempty;
  assign lhempty = he2[BLOCKWIDTH];  
  assign hs[BLOCKWIDTH] = lin;
  assign lout = hb[BLOCKWIDTH];
  
endmodule


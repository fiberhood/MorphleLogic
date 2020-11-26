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

// this tests the configuration circuit for Morphle Logic. For each tests
// 3 bits have to be shifted into the circuit and then the output is
// checked for the desired value

`timescale 1ns/1ps
`include "morphlelogic.v"

module test1fsm;

  reg confclk, cbitin;
  wire cbitout;
  wire empty;
  wire hblock, hbypass, hmatch0, hmatch1;
  wire vblock, vbypass, vmatch0, vmatch1;

  ycconfig DUT (confclk, cbitin, cbitout,
                 empty,
                 hblock, hbypass, hmatch0, hmatch1,
                 vblock, vbypass, vmatch0, vmatch1);
  
  // adds a second device cascade with the main one being tested to
  // see if the expected timing (always holds the previous configuration
  // of the first device) is present
  
  wire cbitout2;
  wire empty2;
  wire hblock2, hbypass2, hmatch02, hmatch12;
  wire vblock2, vbypass2, vmatch02, vmatch12;

  ycconfig DUT2 (confclk, cbitout, cbitout2,
                 empty2,
                 hblock2, hbypass2, hmatch02, hmatch12,
                 vblock2, vbypass2, vmatch02, vmatch12);

  initial
  begin
    confclk = 0; cbitin = 0;
    #10 cbitin = 0; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = space");
    #10 cbitin = 0; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = +");
    #10 cbitin = 0; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = -");
    #10 cbitin = 0; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = |");
    #10 cbitin = 1; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = 1");
    #10 cbitin = 1; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = 0");
    #10 cbitin = 1; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 0; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = Y");
    #10 cbitin = 1; // msb
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1;
    #10 confclk = 1;
    #10 confclk = 0;
    #10 cbitin = 1; // lsb
    #10 confclk = 1;
    #10 confclk = 0; $display("configuration = N");
    #10;
  end
  
  initial
  $monitor($time,,confclk,cbitin,cbitout,,empty,,
                hblock, hbypass, hmatch0, hmatch1,,
                vblock, vbypass, vmatch0, vmatch1,,
                cbitout2,,empty2,,
                hblock2, hbypass2, hmatch02, hmatch12,,
                vblock2, vbypass2, vmatch02, vmatch12);
  
  
endmodule

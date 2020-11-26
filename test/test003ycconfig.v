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

`include "../verilog/morphlelogic.v"

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
  wire [9:0] ans;
  
  assign ans = {cbitout, empty,
                hblock, hbypass, hmatch0, hmatch1,
                vblock, vbypass, vmatch0, vmatch1};
  
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
    #10;
  end
  
  initial
  $monitor($time,,confclk,,cbitin,,ans);
  
  end
  
endmodule

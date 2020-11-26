# Morphle Logic

The most well known reconfigurable hardware systems are the FPGAs (Field Programmable Logic Arrays) and the CPLDs (Complex Programmable Logic Devices). Though currently the two terms are a bit fuzzy for low end devices, originally FPGAs had an architecture with islands of configurable logic, normally small LUTs (lookup tables), connected via a static routing fabric with circuits not that different from early telephone switching hubs. CPLDs, on the other hand, evolved from PALs (Programmable Arrays Logic) with an OR of ANDs architectures. CPLDs are like a small number of PALs connected inside a single chip.

Morphle Logic represents an alternative in the design space of reconfigurable hardware. Like the two options, it has its advantages and limitations. The main advantages are the simple integration with software systems and the ease of generating new configurations at runtime.

## Key Concepts

At the most basic level, Morphle Logic is a large 2D matrix of simple cells. Each cell is connected to the one above, below, to the left and to the right of it.

### Cell Configuration

Each cell can be configured to one of eight values, which we represent with a character:

 0. space: the default state, it is used to isolate different circuits
 1. +: this allows signals to cross this cell vertically and horizontally without interfering with each other
 2. -: this allows signals to cross this cell horizontally
 3. |: this allows signals to cross this cell vertically
 4. 1: when the vertical input is 1, the horizontal output is set to 1
 5. 0: when the vertical input is 0, the horizontal output is set to 1
 6. Y: when the horizontal input is 1, the vertical output is set to 1
 7. N: when the horizontal input is 0, the vertical output is set to 0

An alternative name for Morphle Logic would be "match logic" since you explicitly list the values that you want the inputs to match.

Here is an example of a two bit half adder:

    ||
    00N
    11NY
      ||

The first and last lines use | to make it easier to see where the two inputs are coming in from the top and the two outputs (sum and carry, respectively) are going out the bottom. In a real circuit they probably wouldn't be needed as you can normally connect two circuits by just placing them next to each other.

The 11 forms a two input AND gate, while the 00 is a two input NOR gate (AND with the inputs inverted). It is easier to understand in terms of matching the inputs, as mentioned above. The vertical NN is exactly the same as 00 but rotated 90 degrees. So it too is a NOR gate. The means that the sum is 1 if we don't see a 00 input and we don't see a 11 input, which is a XOR (exclusive OR). The Y is a vertical one input AND gate, which is just a buffer repeating a horizontal signal to a vertical one. If we prefer the carry to be horizontal then the Y is not needed.

### Asynchronous Operation

The the horizontal and vertical signals going through each cell can have three values: 1, 0 and empty. A group of cells only operate when all of their outputs are empty and all of their inputs have actual values. After the operation the outputs will have values and the inputs will be empty.

One way to think of ML operation is that waves of data values flow through the circuit. An alternative way is to think that waves of empty values flow backwards through the circuit (a bit like electrons and holes in semiconductors). If a wave of data arrives at a part of the circuit that doesn't have empty outputs, it must wait in place until they become empty. This means that there is no separation of sequential logic and combinational logic like in synchronous circuits.

ML works fastest when alternating valid and empty data flows through the circuit. If some output stalls, then next waves of data stop behind it just like cars stopping at a red light squeeze out the same between them. When the output does become free the waves start to move again and tend to spread out.

### Network

Two ML circuits are connected by placing them next to each other and having them touch, or else using a few "-" or "|" cells to bridge the small space between them.

It would be possible, but very slow, to connect very distant circuits this way. A better way is to use a packet switching network to link didtant circuits, in contrast to the circuit switching fabric of FPGAs (though extremely recent FPGAs have added packet switching).

Packets of data through a network look just like waves of data through a ML circuit, so there is no mismatch when converting between one and the other.

Instead of having every ML cell connect to the network, a row of special cells is inserted between some of the normal rows (between every 8 normal rows, for example). These cells also have eight possible configurations:

 0. space: the default state, it is used to isolate the row above from the one in the row below
 1. a: this receives a bit from the first network port
 2. b: this receives a bit from the second network port
 3. c: this receives a bit from the third network port
 4. |: this connects a cell from the row above to a cell in the row below
 5. r: this outputs a bit to the first network port
 6. s: this outputs a bit to the second network port
 7. t: this outputs a bit to the third network port

A two bit full adder could receive its data from the network are return its results to the network:

    ab   ab
    00N  00N
    11NN 11NN
      ||   ||
    0N0| 0N0|
    1N1N 1N1N
    || 0-Y| |
    ||    | |
    ||    | |
    cs    s t

Note that rows and columns can easily be swapped to help match the outputs of a circuit to the inputs of the next circuit.

The first row and the last row are network ports while the 8 middle rows are normal ML cells. Two bits from an incoming packet are placed in the columns labelled "a" and two bits from a different packet are sent to columns "b". A single bit from a third packet goes into the bottom of the columns labelled "c". There is no conflict between that and the first "a" because of a space cell in that column. A and B are the values to be added and C is the carry in.

The two bits from the addition appear in the columns labelled "s" and exit the bottom into the network as one packet. The carry out is a separate one bit packet read from the column labelled "t".

The network protocol is very simple. A row and column address select a starting point and a size field indicates how many columns will receive the packet. The row address only takes into account the special rows with networking hardware. In the adder example above the row with the "a" and "b" would be address 0 and the one with "c", "s" and "t" would be row 1.

The column address and packet size might be restricted to a multiple of some value, like 8. This means that the lowest three bits of the column address and of the size would be ignored in this case.

The following packet types are used:

 0. configure: the following bytes are shifted into the configuration registers of the rows below
 1. a: the following bytes supply the bits for the "a" inputs
 2. b: the following bytes supply the bits for the "b" inputs
 3. c: the following bytes supply the bits for the "c" inputs
 4. run: at the start of a configuration all lines and columns are forced to empty. This packet allows the circuit to function normally
 5. r: the following bytes are to be used as the header for any packets with bits from the "r" outputs
 6. s: the following bytes are to be used as the header for any packets with bits from the "s" outputs
 7. t: the following bytes are to be used as the header for any packets with bits from the "t" outputs

## Files

Besides all the files in the Caravel project, the Morphle Logic specific hardware description can
be found in "verilog/morphle/" and that includes all tests.



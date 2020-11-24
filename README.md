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

The 11 forms a two input AND gate, while the 00 is a two input NOR gate (AND with the inputs inverted). It is easier to understand in terms of matching the inputs, as mentioned above. The vertical NN is exactly the same as 00 but rotated 90 degrees. So it too as a NOR gate. The means that the sum is 1 if we don't see a 00 input and we don't see a 11 input, which is a XOR (exclusive OR). The Y is a vertical one input AND gate, which is just a buffer repeating a horizontal signal to a vertical one. If we prefer the carry to be horizontal then the Y is not needed.

### Asynchronous Operation

The the horizontal and vertical signals going through each cell can have three values: 1, 0 and empty. A group of cells only operate when all of their outputs are empty and all of their inputs have actual values. After the operation the outputs will have values and the inputs will be empty.
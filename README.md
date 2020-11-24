# Morphle Logic

The most well known reconfigurable hardware systems are the FPGAs (Field Programmable Logic Arrays) and the CPLDs (Complex Programmable Logic Devices). Though currently the two terms are a bit fuzzy for low end devices, originally FPGAs had an architecture with islands of configurable logic, normally small LUTs (lookup tables), connected via a static routing fabric with circuits not that different from early telephone switching hubs. CPLDs, on the other hand, evolved from PALs (Programmable Arrays Logic) with an OR of ANDs architectures. CPLDs are like a small number of PALs connected inside a single chip.

Morphle Logic represents an alternative in the design space of reconfigurable hardware. Like the two options, it has its advantages and limitations. The main advantages are the simple integration with software systems and the ease of generating new configurations at runtime.

##Key Concepts

At the most basic level, Morphle Logic is a large 2D matrix of simple cells. Each cell is connected to the one above, below, to the left and to the right of it.

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
RTL created should always be SystemVerilog.

The goal of any RTL should be an abstraction of a schematic. That is, a user
should be able to read the RTL and easily sketch out a schematic. Although,
code is being written RTL is the creation of hardware. The RTL created should be
easily inferred as a primitive; gates (AND, OR, NOT, XOR, XNOR, NAND, NOR),
Flip Flops (DFF, DFF_ARST, DFF_ARST_EN, DFF_EN, DFF_SRST, DFF_SRST_EN,
TFF_ARST), Arithmetic (Adder, Subtractor, Multiplier), Comparators (Equal,
Greater than Equal to, Greater than, Less than or Equal to, Less than),
Multiplexors/Demultiplexors, Fifos (Synchronous, Asynchronous), Memories (RAM,
ROM).

## Editor rules

1. Only use UTF-8 encoding.
2. Lines must not be longer than 80 characters.
3. Only use spaces, never use Tab characters for indentation.
4. Never leave trailing whitespace.
5. Insert a final new line at the end of the file.
6. Use "\n" as the end of line character.
7. When creating comments, never wrap lines.

## Naming
1. Always use camelCase
2. Never truncate variable names to save space. Readability of a variable name
is more important.
3.

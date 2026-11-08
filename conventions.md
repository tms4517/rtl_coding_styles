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
8. All new lines should start as an multiple of 2 spaces. No odd number of
   spaces.

## Naming

1. Always use camelCase
2. Never truncate variable names to save space. Readability of a variable name
is more important.
3. The prefixing or suffixing of variable names for example `*_camelCase` or
`camelCase_*` serves to draw the users attention to a specific property of a
variable.
  - `*_q`: variable is the Q pin of a flip flop.
  - `*_d`: variable is the D pin of a flip flop.
  - `*_n`: variable is active-low. It is especially important to identify
           active-low resets.
  - `*_p`: variable is a pulse. This will make it clear to users if special
           handling of the pulse is required.
  - `i_*`: prefix all input ports.
  - `o_*`: prefix all output ports.
  - `u_*`: prefix all module instances.

---
name: rtl-coding-styles
description: Use when writing, generating, refactoring or reviewing SystemVerilog RTL (modules, packages, flip flops, muxes, FIFOs, memories) so the code matches Tej Sanghavi's hand-written RTL style. Covers naming, file layout, procedural block rules, flip flop templates (ffTemplate.json) and svlint/Verilator sign-off (.svlint.toml).
---

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
7. Comments longer than 80 characters must be broken into multiple `//` lines.
8. All new lines should start as an multiple of 2 spaces. No odd number of
   spaces.

## Naming

1. Always use lowerCamelCase for modules, packages, variables, ports,
   instances and loop labels, combined with the prefixes and suffixes below.
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
  - `pa_*`: prefix package names.
  - `ty_*`: prefix typedefs.
4. Parameters and local parameters use UPPER_SNAKE_CASE, e.g. `ADDRESS_WIDTH`.
5. Typedefs should be prefixed with `ty_*` and are UPPER_SNAKE_CASE.

## Module defaults

1. One module per file.
2. Filename must be the module name.
3. A file must contain a copyright header as the first line. Use:
   `// Copyright (c) <Year> Tej Sanghavi.`
4. Before a module declaration and after the copyright there must be an
   explanation of the purpose of the module, how its implemented and how it
   serves the wider project (for submodules).
5. Always declare `` `default_nettype none`` before the module or package
   declaration and after the explanation.
6. Always declare `` `resetall`` immediately after the `endmodule` or
   `endpackage`.
7. Rules 1-6 apply to package files as well as module files.

## SV rules

1. Only use `logic` data type. The exception is parameters and local
   parameters, which must use an explicit two-state type, e.g.
   `int unsigned` or `bit`.
2. Only use `always_ff` and `always_comb` as procedural statements.
3. Only use the non-blocking assignment `<=` in `always_ff`. Only use blocking
   assignment `=` in `always_comb`.
4. One variable per procedural block.
5. As there is always only one variable per procedural block, there is no need
   for `begin` and `end` statements.
6. The variable assignement should take place on a new line indented by 2 spaces
   after the `always_comb` statement.
7. When creating FFs refer to `ffTemplate.json`. Never copy the template's
   `// DFF:`/`// TFF:` pin comments into the RTL; use only the code.
8. In SV, all the logic is synthesized by default. Never use the `generate`
   and `endgenerate` keywords.
9. `for` loops are only used at module level, with `always_ff`/`always_comb`
   blocks inside them. Never put a `for` loop inside a procedural block. This
   makes the purpose of for loops clear - repeating an arbitrary piece of
   hardware n times.
10. Use standard iterator names in for loops `i`, `j`, `k`.
11. For loop begin and end labels should be meaningful.
12. After the for loop declaration, include a blank line and start the logic on
    the following line. After the logic, leave a blank line and then include
    the `end` statement.
13. Never use unpacked arrays.
14. Every `if`, `else if` statement must have an `else` statement.
15. Every `case` statement must have a corresponding `default` statement.
16. Input and output ports must be of `var logic`.
17. Never mix comparison and bitwise operators without brackets, e.g. write
    `a & (b == c)`, not `a & b == c`.
18. Separate sensitivity list items with `,`, never `or`, e.g.
    `always_ff @(posedge i_clk, posedge i_arst)`.
17. Preprocessor and compiler directives should not be indented, and that there
    are no items preceeding a directive on the same line.
18. Only use bitwise operators eg `&, ~, |` if bitwise operation is intended.
    Otherwise, use normal boolean operators `&&, !, ||`.

## Preferences

1. Declare the variables first before using them.
2. Do not bunch all the logic declarations together. The logic must be declared
   just above the procedural statements which use them.
3. Declare variables on the same line only if they are related. For example, the
   `*_d` and `*_q` pins of a register.
4. If declaring a FF, declare the `always_ff` first and then the `always_comb`
   after to assign to the `d` pin.
5. Group together related code using comments that VSCode uses to fold the
   editor. The folding comments are:
   start: `// {{{ <short description of block>`
           // Explanantion of whats implemented.
           <blank line>
           <code>
           <blank line>
   end:   `// }}} <short decription of block>`.
6. Every code block should have an explanation of what's implemented. It should
   not state the obvious but rather functionally explain whats implemented and
   how it relates to the module.
7. Use comma leading por-list style.
8. Named port connections only, .* is banned, one port per line.
9. Use `'0` or `'1` instead of 1'b1.

## Verification

1. Run svlint to enforce the RTL styles, using the `.svlint.toml` in this
   skill's directory.
   `svlint -c <skill_dir>/.svlint.toml *.sv`
2. There should be no violations from Verilator.
   `"verilator --lint-only -Wall *.sv"`

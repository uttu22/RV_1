# Yosys Guide for RISC-V Synthesis

## What is Yosys?

Yosys is an open-source RTL synthesis tool for Verilog and SystemVerilog. It converts RTL into an internal netlist representation, applies optimization passes, performs technology mapping, and writes output in formats like Verilog, BLIF, JSON, or EDIF.

This guide covers how to use Yosys from the command line, the most important commands/passes, and how they are used in a typical flow.

---

## Installing Yosys

On Linux, install from package managers or build from source.

- Ubuntu / Debian:
  - `sudo apt update && sudo apt install yosys`
- Fedora:
  - `sudo dnf install yosys`
- Arch:
  - `sudo pacman -S yosys`
- Build from source:
  - `git clone https://github.com/YosysHQ/yosys.git`
  - `cd yosys && make` (use `make config-gcc` if needed)
  - `sudo make install`

---

## Running Yosys

### Interactive shell mode

Start Yosys with no arguments to enter the interactive shell:

```bash
yosys
```

Then run commands inside the shell, for example:

```bash
read_verilog top.sv
synth -top top
write_verilog synth.v
```

### One-shot script mode

Pass a script with `-p` or use a file with `-s`:

```bash
yosys -p "read_verilog top.sv; synth -top top; write_verilog synth.v"
```

Or:

```bash
yosys -s script.ys
```

### Show all available commands

Inside Yosys shell:

```bash
help
```

Show details for a specific command:

```bash
help read_verilog
```

---

## Yosys Command-Line Options

- `-p <command>`: execute commands and exit
- `-s <script.ys>`: run script file
- `-q`: quiet mode
- `-V`: print Yosys version
- `-m <plugin>`: load plugin library
- `-l <logfile>`: write log output to a file

Example:

```bash
yosys -p "read_systemverilog test.sv; synth -top alu; write_verilog alu_synth.v"
```

---

## Basic Workflow Commands

### Input commands

- `read_verilog <file>`: read Verilog files
- `read_systemverilog <file>`: read SystemVerilog files
- `read_blif <file>`: read BLIF netlists
- `read_json <file>`: read Yosys JSON netlists
- `read_liberty <file>`: read Liberty timing/cell libraries
- `read_xdc <file>`: read Xilinx constraints (when supported)

### Output commands

- `write_verilog <file>`: write Verilog netlist
- `write_blif <file>`: write BLIF netlist
- `write_json <file>`: write Yosys JSON netlist
- `write_edif <file>`: write EDIF netlist
- `write_ilang <file>`: write internal Yosys ILANG representation
- `write_smt2 <file>`: write SMT-LIB v2 for formal verification
- `write_mif <file>` / `write_mem`: write memories in other formats

### Topology and checking

- `hierarchy`: build and check the design hierarchy
- `proc`: translate processes to netlist, especially for asynchronous and sequential logic
- `check`: verify module connectivity and port correctness
- `stat`: print statistics for cells, wires, memories, and modules
- `show`: produce a graphviz PNG of the design hierarchy or selected module

---

## Synthesis and Optimization Commands

### Core synthesis passes

- `synth [-top <name>]`: run a generic synthesis flow for FPGA/ASIC targets. This is a standard high-level command that expands processes, creates registers, and infers logic.
- `synth_xilinx`, `synth_ice40`, `synth_qlfie32`, `synth_alu`: technology-specific synthesis flows for FPGAs.
- `synth_int`: perform integer arithmetic support and generic integer optimizations.

### RTL lowering and processing

- `proc`: convert always blocks and initial blocks into an internal FSM/netlist representation.
- `flatten`: inline modules, remove hierarchy, and flatten the design.
- `memory`: infer memories and convert arrays into memory cells.
- `opt`: optimize logic by simplifying gates and removing redundant signals.
- `opt_clean`: remove unused cells and wires.
- `clean`: remove unused objects and reduce netlist clutter.
- `techmap`: perform technology mapping to library-specific primitives.
- `abc`: run the ABC logic synthesis tool for technology mapping and logic optimization.
- `dffsr2dff`: convert flip-flops with reset/set into plain DFF cells.
- `share`: share structurally identical sub-circuits.

### Special optimization passes

- `opt_expr`: simplify arithmetic expressions and constant propagation.
- `opt_mux`: optimize multiplexers.
- `opt_clean`: remove redundant nets after changes.
- `opt_merge`: merge equivalent gates.
- `opt_rmdff`: remove redundant D flip-flops.
- `opt_bool`: boolean simplification.

### Mapping and technology-specific passes

- `techmap -map <mapfile>`: map generic cells to target cells via a mapping file.
- `abc -liberty <liberty_file>`: run ABC using the provided library for technology mapping.
- `dfflibmap -liberty <liberty_file>`: map flip-flops to target library cells.
- `stat`: check how many logic cells are generated before and after map.

---

## Common Synthesis Flow Example

This is a common script for a simple design with a top module named `top`:

```bash
yosys -p "
  read_systemverilog riscv_core/alu.sv riscv_core/reg_bank.sv riscv_core/decode_logic.sv
  hierarchy -check -top top
  proc
  flatten
  opt
  memory
  opt_clean
  write_verilog synth_top.v
"
```

For a complete FPGA flow use a target-specific command:

```bash
yosys -p "
  read_verilog design.sv
  synth_ice40 -top top
  write_verilog top_synth.v
"
```

---

## Important Yosys Commands and Their Purposes

### `read_<format>` commands

- `read_verilog`: parse Verilog source files.
- `read_systemverilog`: parse SystemVerilog source files.
- `read_blif`, `read_json`, `read_edif`: import netlists from other tools.
- `read_liberty`: import standard cell timing libraries.

### `write_<format>` commands

- `write_verilog`: export a synthesized Verilog netlist.
- `write_json`: export a JSON netlist for downstream tools.
- `write_blif`: export a BLIF file for logic synthesis.
- `write_edif`: export to EDIF for interoperability.
- `write_ilang`: export internal Yosys ILANG form.

### `synth` commands

- `synth`: generic RTL synthesis flow.
- `synth_xilinx`: synthesis for Xilinx FPGA targets.
- `synth_ice40`: synthesis flow for Lattice iCE40.
- `synth_qlfie32`: synthesis for QuickLogic FPGAs.
- `synth_int`: infer and optimize integer operations.

### Flow control commands

- `hierarchy`: verify and flatten design hierarchy.
- `proc`: translate processes to netlist.
- `flatten`: remove hierarchy.
- `opt`: perform general logic optimizations.
- `clean`: remove unused nets.
- `stat`: report cell/wire statistics.
- `check`: validate the netlist.

### Memory and register handling

- `memory`: infer block RAM and memories.
- `memory_bram`: instantiate specific BRAM cells.
- `mem2reg`: convert memory constructs to registers.
- `dffsr2dff`: convert reset/set flip-flops to plain DFFs.

### Mapping and timing

- `abc`: use the ABC tool to optimize and map logic.
- `techmap`: map generic logic to library cells.
- `memory_map`: map memories to target memory cells.
- `dfflibmap`: map DFFs to library cells using `.lib` files.

### Debugging and reporting

- `show`: generate schematic images or graphs.
- `stat`: count cells, nets, and memory resources.
- `design`: print the design structure.
- `getports`: list ports on a module.
- `get_carry_cells`: report inferred carry chains.

### Verification and checks

- `check`: verify that every signal is connected and ports are correct.
- `equiv_check`: compare two designs for equivalence.
- `sat`: run SAT-based checks.
- `prep`: prepare design for formal tools.

---

## Example Yosys Script File

Create a script file `synth.ys`:

```tcl
read_systemverilog riscv_core/alu.sv
read_systemverilog riscv_core/reg_bank.sv
read_systemverilog riscv_core/decode_logic.sv
hierarchy -check -top top
proc
flatten
opt
memory
opt_clean
write_verilog synth_top.v
write_json synth_top.json
```

Run it with:

```bash
yosys -s synth.ys
```

---

## Typical RISC-V Synthesis Tips

- Use `read_systemverilog` for SystemVerilog source.
- Pass all source files or a file list to Yosys so the hierarchy is complete.
- Use `hierarchy -check -top <top>` to ensure the top module is recognized.
- Use `proc` before `opt` to convert RTL processes to gates.
- Use `memory` if your design uses arrays or inferred RAM.
- Use `write_verilog` to inspect the synthesized netlist.
- Use `stat` to verify cell counts before and after mapping.

---

## Getting Help from Yosys

- `help`: list all commands.
- `help <command>`: show usage and options for a specific command.
- `help <command> <subcommand>`: show help for more detailed usage.

Example:

```bash
yosys
help synth
help write_verilog
```

---

## Quick Command Reference

```text
read_systemverilog <files>   # parse input RTL
hierarchy -check -top <top>  # validate top-level design
proc                         # lower processes to netlist
opt                          # optimize logic
memory                       # infer memory blocks
opt_clean                    # remove unused nets
write_verilog <file>         # export synthesized Verilog
write_json <file>            # export Yosys JSON
show                         # visualize design
stat                         # print design statistics
check                        # validate netlist integrity
```

## Visualizing a Netlist and Generating Diagrams

### Yosys `show` command

Yosys can generate visualization files directly with `show`.

Example:

```bash
yosys -p "read_systemverilog riscv_core/alu.sv riscv_core/reg_bank.sv riscv_core/decode_logic.sv; hierarchy -check -top top; proc; show -format png -stretch -prefix top"
```

This creates an image file such as `top_top.png` using Graphviz. The `show` command also writes intermediate `.dot` files.

### Using `show` with module selection

```bash
yosys -p "read_systemverilog *.sv; hierarchy -check -top top; proc; show -module top -format png -prefix top"
```

Common options:
- `-format png`: generate PNG output
- `-format pdf`: generate PDF output
- `-prefix <name>`: output file prefix
- `-module <mod>`: show only a specific module
- `-stretch`: make the graph easier to read

### Graphviz tools

If Yosys does not generate the final image directly, it will produce a `.dot` file. Use Graphviz to convert it:

```bash
dot -Tpng top_top.dot -o top_top.png
```

Other Graphviz formats:
- `dot -Tpdf top_top.dot -o top_top.pdf`
- `dot -Tsvg top_top.dot -o top_top.svg`

Install Graphviz if needed:

```bash
sudo apt install graphviz
```

### Visualizing Yosys JSON/netlist with external tools

After writing JSON or BLIF, you can use tools such as `netlistsvg` for HTML diagrams.

Example from a Yosys JSON netlist:

```bash
yosys -p "read_systemverilog riscv_core/alu.sv riscv_core/reg_bank.sv riscv_core/decode_logic.sv; hierarchy -check -top top; proc; write_json top.json"
netlistsvg top.json
```

This generates an interactive HTML diagram of the netlist.

### When to use each method

- Use `show` when you want a quick static graph of the design or a module.
- Use Graphviz for more control over layout and output format.
- Use `netlistsvg` when you want an interactive netlist browser and a richer view of gates.

## Note on "Functions"

In Yosys, the main reusable elements are command passes, not typical software functions. Each command performs a specific synthesis or transformation task.

If you need a complete list of every Yosys pass and command, run:

```bash
yosys -p "help"
```

and then inspect any pass by name with `help <pass>`.

---

## Recommended File

This note is saved in `yosys_guide.md` in the workspace root. Use it as your reference when working with Yosys and when building synthesis scripts for your RISC-V core.

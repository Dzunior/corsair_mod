# VHDL Testbench Generation Example

This example demonstrates how to generate a VHDL testbench for a register map module with AXI-Lite interface using automatic testbench generation.

## Overview

The Corsair tool can now automatically generate VHDL testbenches when creating register map modules with AXI-Lite interfaces. This makes it easier to verify the functionality of generated designs with automated tests.

## Usage

Run the generation script:

```bash
python3 generate.py
```

This will generate two files:
- `regs.vhd` - The register map module with AXI-Lite interface
- `regs_tb.vhd` - A testbench for the register map module (generated automatically)

## Automatic Testbench Generation

The testbench is generated automatically when you set `generate_testbench=True`:

```python
from corsair import generators, RegisterMap, Register, BitField

# Create your register map
rmap = RegisterMap()
rmap.add_registers([...])

# Generate module with automatic testbench generation
generators.Vhdl(
    rmap,
    path='regs.vhd',
    interface='axil',
    generate_testbench=True  # Automatically generates regs_tb.vhd
).generate()
```

The testbench will automatically:
- Use the same configuration (data width, address width, reset polarity) as the module
- Include all registers and bitfields from the register map
- Test reset values, write operations, and read operations
- Be saved with a `_tb` suffix (e.g., `regs.vhd` → `regs_tb.vhd`)

You can also specify a custom testbench path:

```python
generators.Vhdl(
    rmap,
    path='my_regs.vhd',
    interface='axil',
    generate_testbench=True,
    testbench_path='my_custom_testbench.vhd'
).generate()
```

## Generated Register Map

The example creates a register map with:

- **CTRL Register (0x00)**: Control register with enable, mode, and start bits
- **STATUS Register (0x04)**: Status register with ready, error, and busy flags (read-only)
- **DATA Register (0x08)**: Data register with 16-bit value
- **CONFIG Register (0x0C)**: Configuration register with threshold and gain settings

## Simulating with GHDL

If you have GHDL installed, you can simulate the design:

```bash
ghdl -a regs.vhd
ghdl -a regs_tb.vhd
ghdl -e regs_tb
ghdl -r regs_tb
```

## Testbench Features

The generated testbench includes:

1. **Clock and reset generation** - Automatic clock generation with configurable period
2. **AXI-Lite master stimulus** - Test cases for register read and write operations
3. **Register interface signals** - Properly connected register bitfield signals
4. **Automated tests** for each register:
   - Reset value verification by reading after reset
   - Write and readback for writable registers
   - Data integrity checks
5. **Automatic pass/fail reporting** with error counting
6. **Timeout watchdog** - Prevents hanging simulations
7. **Same configuration** - Uses the same data width, address width, and reset polarity as the module

## Using with Other Tools

The testbench can also be simulated with:
- ModelSim/QuestaSim
- Vivado Simulator
- Any VHDL-2008 compliant simulator

For other simulators, adjust the compilation and simulation commands accordingly.

## Manual Testbench Generation

If you prefer to generate the testbench separately, you can still use the `VhdlTestbench` generator:

```python
from corsair import generators

# Generate module
generators.Vhdl(rmap, path='regs.vhd', interface='axil').generate()

# Generate testbench separately
generators.VhdlTestbench(
    rmap,
    path='regs_tb.vhd',
    dut_file='regs.vhd',
    interface='axil'
).generate()
```

## Register Access Types

The generator supports various register access types:

- **rw**: Read-Write registers with output signals
- **ro**: Read-Only registers with input signals
- **wo**: Write-Only registers with output signals

And hardware connection types:

- **o**: Output only (for write registers)
- **i**: Input only (for read registers)
- **oe**: Output with enable (hardware can override)
- **ioe**: Bidirectional with enable
- **ioea**: Bidirectional with enable and read access indicator

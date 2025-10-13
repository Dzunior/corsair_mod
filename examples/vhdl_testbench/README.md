# VHDL Testbench Generation Example

This example demonstrates how to generate a VHDL testbench for an AXI-Lite to Local Bus bridge module.

## Overview

The Corsair tool can now generate VHDL testbenches for the bridge modules it creates. This makes it easier to verify the functionality of generated designs.

## Usage

Run the generation script:

```bash
python3 generate.py
```

This will generate two files:
- `axil2lb.vhd` - The AXI-Lite to Local Bus bridge module
- `axil2lb_tb.vhd` - A testbench for the bridge module

## Simulating with GHDL

If you have GHDL installed, you can simulate the design:

```bash
ghdl -a axil2lb.vhd
ghdl -a axil2lb_tb.vhd
ghdl -e axil2lb_tb
ghdl -r axil2lb_tb
```

## Testbench Features

The generated testbench includes:

1. **Clock and reset generation** - Automatic clock generation with configurable period
2. **AXI-Lite master stimulus** - Test cases for write and read transactions
3. **Local Bus slave model** - Simple response model that echoes addresses
4. **Test scenarios**:
   - Simple write transaction
   - Simple read transaction
   - Write with byte strobes
5. **Automatic pass/fail reporting**
6. **Timeout watchdog** - Prevents hanging simulations

## Customization

You can customize the generator by modifying the configuration:

```python
from corsair import config

# Set custom configuration
globcfg = config.default_globcfg()
globcfg['data_width'] = 64  # Change data width
globcfg['address_width'] = 32  # Change address width
config.set_globcfg(globcfg)

# Generate with custom configuration
generators.VhdlTestbench(
    path='custom_tb.vhd',
    dut_file='custom_dut.vhd',
    bridge_type='axil'
).generate()
```

## Using with Other Tools

The testbench can also be simulated with:
- ModelSim/QuestaSim
- Vivado Simulator
- Any VHDL-2008 compliant simulator

For other simulators, adjust the compilation and simulation commands accordingly.

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Example of generating VHDL testbench for register map module

This example demonstrates how to use the VhdlTestbench generator
to create a testbench for a register map module with AXI-Lite interface.
"""

import sys
sys.path.insert(0, '../..')

from corsair import generators, RegisterMap, Register, BitField

# Create a register map with various register types
rmap = RegisterMap()
rmap.add_registers([
    Register('CTRL', 'Control register', 0x0).add_bitfields([
        BitField('EN', 'Enable bit', lsb=0, width=1, access='rw', reset=0, hardware='o'),
        BitField('MODE', 'Operation mode', lsb=1, width=2, access='rw', reset=0, hardware='o'),
        BitField('START', 'Start operation', lsb=3, width=1, access='rw', reset=0, hardware='o'),
    ]),
    Register('STATUS', 'Status register', 0x4).add_bitfields([
        BitField('READY', 'Ready flag', lsb=0, width=1, access='ro', reset=1, hardware='i'),
        BitField('ERROR', 'Error flag', lsb=1, width=1, access='ro', reset=0, hardware='i'),
        BitField('BUSY', 'Busy flag', lsb=2, width=1, access='ro', reset=0, hardware='i'),
    ]),
    Register('DATA', 'Data register', 0x8).add_bitfields([
        BitField('VALUE', 'Data value', lsb=0, width=16, access='rw', reset=0, hardware='o'),
    ]),
    Register('CONFIG', 'Configuration register', 0xC).add_bitfields([
        BitField('THRESHOLD', 'Threshold value', lsb=0, width=8, access='rw', reset=128, hardware='o'),
        BitField('GAIN', 'Gain setting', lsb=8, width=4, access='rw', reset=1, hardware='o'),
    ]),
])

# Generate the register map module with AXI-Lite interface
print("Generating register map module with AXI-Lite interface...")
generators.Vhdl(
    rmap,
    path='regs.vhd',
    interface='axil'
).generate()
print("  -> Generated: regs.vhd")

# Generate the testbench for the register map module
print("\nGenerating testbench...")
generators.VhdlTestbench(
    rmap,
    path='regs_tb.vhd',
    dut_file='regs.vhd',
    interface='axil'
).generate()
print("  -> Generated: regs_tb.vhd")

print("\nDone! You can now simulate the design using:")
print("  ghdl -a regs.vhd")
print("  ghdl -a regs_tb.vhd")
print("  ghdl -e regs_tb")
print("  ghdl -r regs_tb")

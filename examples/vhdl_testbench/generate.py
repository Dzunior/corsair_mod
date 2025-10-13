#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Example of generating VHDL testbench for AXI-Lite bridge

This example demonstrates how to use the VhdlTestbench generator
to create a testbench for an AXI-Lite to Local Bus bridge.
"""

import sys
sys.path.insert(0, '../..')

from corsair import generators

# Generate the DUT (Device Under Test)
print("Generating AXI-Lite to Local Bus bridge...")
generators.LbBridgeVhdl(
    path='axil2lb.vhd',
    bridge_type='axil'
).generate()
print("  -> Generated: axil2lb.vhd")

# Generate the testbench for the DUT
print("\nGenerating testbench...")
generators.VhdlTestbench(
    path='axil2lb_tb.vhd',
    dut_file='axil2lb.vhd',
    bridge_type='axil'
).generate()
print("  -> Generated: axil2lb_tb.vhd")

print("\nDone! You can now simulate the design using:")
print("  ghdl -a axil2lb.vhd")
print("  ghdl -a axil2lb_tb.vhd")
print("  ghdl -e axil2lb_tb")
print("  ghdl -r axil2lb_tb")

from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.add_verification_components()

SRC_PATH = Path(__file__).parent / "hw"

VU.add_library("src_lib").add_source_files([SRC_PATH / "*.vhd"])

VU.main()
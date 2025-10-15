.PHONY: all generate clean simulate

all: generate

generate:
	python3 generate.py

simulate: generate
	ghdl -a regs.vhd
	ghdl -a regs_tb.vhd
	ghdl -e regs_tb
	ghdl -r regs_tb

clean:
	rm -f *.vhd *.o *.cf regs_tb

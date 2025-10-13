.PHONY: all generate clean simulate

all: generate

generate:
	python3 generate.py

simulate: generate
	ghdl -a axil2lb.vhd
	ghdl -a axil2lb_tb.vhd
	ghdl -e axil2lb_tb
	ghdl -r axil2lb_tb

clean:
	rm -f *.vhd *.o *.cf axil2lb_tb

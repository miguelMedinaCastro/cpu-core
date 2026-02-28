TB = memory_impl_tb
SRC = memory_impl.vhdl $(TB).vhdl 
GHDLFLAGS = --std=08 -fsynopsys

all: run

analyze:
	ghdl -a  $(GHDLFLAGS) $(SRC)

elaborate: analyze
	ghdl -e $(GHDLFLAGS) memory_impl_tb

run: elaborate
	ghdl -r memory_impl_tb --vcd=memoria.vcd

wave: 
	gtkwave memoria.vcd

clean:
	ghdl --clean
	rm -f *.o *.cf

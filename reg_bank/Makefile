TB = reg_bank_tb
SRC = reg_bank.vhdl $(TB).vhdl 
GHDLFLAGS = --std=08 -fsynopsys

all: run

analyze:
	ghdl -a  $(GHDLFLAGS) $(SRC)

elaborate: analyze
	ghdl -e $(GHDLFLAGS) $(TB)

run: elaborate
	ghdl -r $(TB) --vcd=reg.vcd

wave: 
	gtkwave reg.vcd

clean:
	ghdl --clean
	rm -f *.o *.cf

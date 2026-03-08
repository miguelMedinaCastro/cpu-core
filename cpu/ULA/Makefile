GHDL      = ghdl
GHDLFLAGS = --std=08 -fsynopsys

SRC = ula_1bit.vhdl
TB  = ula_1bit_tb.vhdl
TOP = ula_1bit_tb
WAVE = ula.vcd

all: run

analyze:
	$(GHDL) -a $(GHDLFLAGS) $(SRC)
	$(GHDL) -a $(GHDLFLAGS) $(TB)

elab:
	$(GHDL) -e $(GHDLFLAGS) $(TOP)

run: analyze elab
	$(GHDL) -r $(GHDLFLAGS) $(TOP) --vcd=$(WAVE)

wave:
	gtkwave $(WAVE)

clean:
	$(GHDL) --clean
	rm -f $(WAVE)
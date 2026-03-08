SRC=somador_Nbits.vhdl
TB=full_adder_tb.vhdl
TOP=full_adder_tb
WAVE=wave.vcd

all: run

analyze:
	$(GHDL) -a $(SRC)
	$(GHDL) -a $(TB)

elab:
	$(GHDL) -e $(TOP)

run: analyze elab
	$(GHDL) -r $(TOP) --vcd=$(WAVE)

clean:
	rm -f *.o *.cf $(WAVE)

GHDLFLAGS = --std=08 -fsynopsys

SRC_1bit = ula_1bit.vhdl
TB_1bit  = ula_1bit_tb.vhdl
TOP_1bit = ula_1bit_tb

WAVE_1bit = ula_1bit.vcd

SRC_Nbits = ula_Nbits.vhdl
TB_Nbits  = ula_Nbits_tb.vhdl
TOP_Nbits = ula_Nbits_tb

WAVE_Nbits = ula_Nbits.vcd

all: run

analyze:
# 	ghdl -a $(GHDLFLAGS) $(SRC_1bit)
# 	ghdl -a $(GHDLFLAGS) $(TB_1bit)
	
# 	n bits
	ghdl -a $(GHDLFLAGS) $(SRC_Nbits)
	ghdl -a $(GHDLFLAGS) $(TB_Nbits)
	
elab:
# 	ghdl -e $(GHDLFLAGS) $(TOP_1bit)
# n bits
	ghdl -e $(GHDLFLAGS) $(TOP_Nbits)

run: analyze elab
# 	ghdl -r $(GHDLFLAGS) $(TOP_1bit) --vcd=$(WAVE_1bit)

# n bits
	ghdl -r $(GHDLFLAGS) $(TOP_Nbits) --vcd=$(WAVE_Nbits)


wave_1bit:
	gtkwave $(WAVE_1bit)

wave_Nbit:
	gtkwave $(WAVE_Nbits)

clean:
	$(GHDL) --clean
	rm -f $(WAVE)
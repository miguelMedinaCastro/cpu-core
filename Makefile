SRC_DIR=cpu
TB_DIR=testbench

FLAGS=--std=08 -fsynopsys

WAVE ?=


full_adder:
	ghdl -a $(FLAGS) $(SRC_DIR)/full_adder/somador_Nbits.vhdl
	ghdl -a $(FLAGS) $(TB_DIR)/somador_Nbits_tb.vhdl 
	ghdl -e $(FLAGS) somador_Nbits_tb
	ghdl -r $(FLAGS) somador_Nbits_tb

instruction_memory:
	ghdl -a $(FLAGS) $(SRC_DIR)/instruction_memory/instruction_memory.vhdl
	ghdl -a $(FLAGS) $(TB_DIR)/instruction_memory_tb.vhdl 
	ghdl -e $(FLAGS) instruction_memory_tb
	ghdl -r $(FLAGS) instruction_memory_tb --wave=instruction_memory.vcd

memory:
	ghdl -a $(FLAGS) $(SRC_DIR)/memory/memory.vhdl
	ghdl -a $(FLAGS) $(TB_DIR)/memory_tb.vhdl 
	ghdl -e $(FLAGS) memory_tb
	ghdl -r $(FLAGS) memory_tb --vcd=memory.vcd

# mux:
# 	ghdl -a $(FLAGS) $(SRC_DIR)/instruction_memory/instruction_memory.vhdl
# 	ghdl -a $(TB_DIR)/instruction_memory_tb.vhdl 
# 	ghdl -e $(FLAGS) instruction_memory_tb
# 	ghdl -r $(FLAGS) instruction_memory_tb --wave=instruction_memory.vcd

register_bank:
	ghdl -a $(FLAGS) $(SRC_DIR)/reg_bank/reg_bank.vhdl
	ghdl -a $(FLAGS) $(TB_DIR)/reg_bank_tb.vhdl 
	ghdl -e $(FLAGS) reg_bank_tb
	ghdl -r $(FLAGS) reg_bank_tb --vcd=reg_bank.vcd

# register:
# 	ghdl -a $(FLAGS) $(SRC_DIR)/register/bitregister.vhdl
# 	ghdl -a $(FLAGS) $(SRC_DIR)/register/bitregister_par.vhdl
# 	ghdl -a $(TB_DIR)/reg_bank_tb.vhdl 
# 	ghdl -e $(FLAGS) reg_bank_tb
# 	ghdl -r $(FLAGS) reg_bank_tb --wave=reg_bank.vcd

ula:
	ghdl -a $(FLAGS) $(SRC_DIR)/ULA/ula_Nbits.vhdl
	ghdl -a $(FLAGS) $(SRC_DIR)/ULA/ula_Nbits_tb.vhdl 
	ghdl -e $(FLAGS) ula_Nbits_tb
	ghdl -r $(FLAGS) ula_Nbits_tb --vcd=ula.vcd


fsm:
	ghdl -a $(FLAGS) $(SRC_DIR)/FSM/fsm.vhdl
	ghdl -a $(FLAGS) $(SRC_DIR)/FSM/fsm_tb.vhdl 
	ghdl -e $(FLAGS) fsm_tb
	ghdl -r $(FLAGS) fsm_tb --wave=fsm.ghw
wave:
	gtkwave fsm.ghw
	
clean:
	rm -f *.cf *.vcd $(TB)

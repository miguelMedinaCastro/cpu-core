
-----------------------------------------------------------------------------------------
--  Representação da CPU ALVO
-----------------------------------------------------------------------------------------
--  Modulo HDL com a implementação Estrutural da CPU
--  Entradas: CLK e RST
--  Saídas:   OPCODE (apenas para verificação)
-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.MEM_PKG.all;


entity CPU is
   generic(
      NBits_EndM  :  natural := 008;   -- Num. de Bits de Endereçamento MEMÓRIA
      NBits_EndR  :  natural := 003;   -- Num. de Bits de Endereçamento REGISTRADORES
      NBits_Dado  :  natural := 016;   -- Num. de Bits de Dados (Tamanho PALAVRA)
      N_Palavras  :  natural := 256;   -- Num. de Palavras das Memórias
      N_Register  :  natural := 008;   -- Num. de REGISTRADORES
      NBits_OPco  :  natural := 005);  -- Num. de Bits de OpCode
   port (

      -- VERIFICACAO ---------------------------------------------------------------------
      ESTADO_FSM_FPGA   :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 1 DISPLAY DE 7 SEGMENTOS
      OPCODE_OUT_FPGA   :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 1 DISPLAY DE 7 SEGMENTOS

      PC_OUT_FPGA       :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  -- 2 DISPLAYS DE 7 SEGMENTOS

      WRPC_OUT_FPGA     :  OUT STD_LOGIC;                     -- 1 LED
      WRIR_OUT_FPGA     :  OUT STD_LOGIC;                     -- 1 LED
      WRREG_OUT_FPGA    :  OUT STD_LOGIC;                     -- 1 LED
      WRMEM_OUT_FPGA    :  OUT STD_LOGIC;                     -- 1 LED
      RDMEM_OUT_FPGA    :  OUT STD_LOGIC;                     -- 1 LED
      MUXPC_OUT_FPGA    :  OUT STD_LOGIC;                     -- 1 LED
      MUXAREG_OUT_FPGA  :  OUT STD_LOGIC;                     -- 1 LED
      MUXDREG_OUT_FPGA  :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  -- 2 LEDS
      OPULA_OUT_FPGA    :  OUT STD_LOGIC_VECTOR(2 DOWNTO 0);  -- 3 LEDS

      FLAG_C_OUT_FPGA   :  OUT STD_LOGIC;                     -- 1 LED
      FLAG_V_OUT_FPGA   :  OUT STD_LOGIC;                     -- 1 LED
      FLAG_N_OUT_FPGA   :  OUT STD_LOGIC;                     -- 1 LED
      FLAG_Z_OUT_FPGA   :  OUT STD_LOGIC;                     -- 1 LED
      ------------------------------------------------------------------------------------

      rst     :  in   std_logic;                                    -- Reset
      clk     :  in   std_logic);                                   -- Clock

end CPU;


architecture CPU of CPU is

   constant ZERO     :  std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');
   constant opLDA    :  std_logic_vector(NBits_OPco - 1 downto 0) :=  "00001";
   constant opLDAi   :  std_logic_vector(NBits_OPco - 1 downto 0) :=  "00010";

   -- REGISTRADORES INTERNOS
   signal PC   : std_logic_vector(NBits_EndM - 1 downto 0) := (others => '0');   -- REG Program Counter
   signal IR   : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- REG de Instrução
   signal MAR  : std_logic_vector(NBits_EndM - 1 downto 0) := (others => '0');   -- REG de Endereço de Memória
   signal MDR  : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- REG de Dado Lido de Memória
   signal A    : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- REG Entrada A da ULA
   signal B    : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- REG Entrada B da ULA
   signal R    : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- REG Saída da ULA

   -- SINAIS DE CONTROLE gerados pela FSM
   signal wrPC     : std_logic := '0';                                  -- Habilitação Escrita PC
   signal wrIR     : std_logic := '0';                                  -- Habilitação Escrita IR
   signal wrReg    : std_logic := '0';                                  -- Habilitação Escrita GPRs
   signal wrMem    : std_logic := '0';                                  -- Habilitação Escrita Mem. Dados
   signal rdMem    : std_logic := '0';                                  -- Habilitação Leitura Mem. Dados
   signal muxPC    : std_logic := '0';                                  -- Seleção MUX Entrada do PC
   signal muxAReg  : std_logic := '0';                                  -- Seleção MUX ENDEREÇO Escrita GPRs
   signal muxDReg  : std_logic_vector(1 downto 0) := (others => '0');   -- Seleção MUX DADO de Escrita GPRs
   signal opULA    : std_logic_vector(2 downto 0) := (others => '0');   -- Seleção OPERAÇÃO da ULA

   -- MULTIPLEXADORES
   signal MUX_add_pc  : std_logic_vector(NBits_EndM - 1 downto 0) := (others => '0');  -- MUX da Entrada do PC
   signal MUX_addr_w  : std_logic_vector(NBits_EndR - 1 downto 0) := (others => '0');  -- MUX de ENDEREÇO Escrita GPRs
   signal MUX_data_w  : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');  -- MUX de DADO de Escrita GPRs

   -- Saídas do DECODIFICADOR
   signal addr_MAR  : std_logic_vector(NBits_EndM - 1 downto 0) := (others => '0');   -- Valor a ser escrito em MAR
   signal addr_r1   : std_logic_vector(NBits_EndR - 1 downto 0) := (others => '0');   -- Endereço de Leitura 1 GPRs
   signal addr_r2   : std_logic_vector(NBits_EndR - 1 downto 0) := (others => '0');   -- Endereço de Leitura 2 GPRs
   signal addr_w1   : std_logic_vector(NBits_EndR - 1 downto 0) := (others => '0');   -- Endereço de Escrita 1 GPRs
   signal addr_w2   : std_logic_vector(NBits_EndR - 1 downto 0) := (others => '0');   -- Endereço de Escrita 2 GPRs
   signal data_w1   : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- Dado para Escrita GPRs

   -- Saidas do BANCO DE REGISTRADORES
   signal GPR_data_r1  : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- Dado Leitura 1 GPRs
   signal GPR_data_r2  : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- Dado leitura 2 GPRs

   -- FLAGs da ULA
   signal flag_C  : std_logic := '0';    -- Flag CARRY
   signal flag_V  : std_logic := '0';    -- Flad OVERFLOW
   signal flag_N  : std_logic := '0';    -- Flad NEGATIVO  (usado em JN)
   signal flag_Z  : std_logic := '0';    -- Flag ZERO      (usado em JZ)

   -- Outros Sinais
   signal PC_mais_1  : std_logic_vector(NBits_EndM - 1 downto 0) := (others => '0');   -- Saída Incremento do PC
   signal IMEM_data  : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- Saída DADOs da Memória
   signal ULA_out    : std_logic_vector(NBits_Dado - 1 downto 0) := (others => '0');   -- Saída Resultado da ULA
   signal OPinterno  : std_logic_vector(NBits_OPco - 1 downto 0) := (others => '0');   -- Opcode Interno
   signal Zcomposto  : std_logic := '0';
   signal Ncomposto  : std_logic := '0';


begin


   -- VERIFICACAO ------------------------------
   OPCODE_OUT_FPGA   <=  OPinterno (3 downto 0);
   PC_OUT_FPGA       <=  PC;
   wrPC_OUT_FPGA     <=  wrPC;
   wrIR_OUT_FPGA     <=  wrIR;   
   wrReg_OUT_FPGA    <=  wrReg;  
   wrMem_OUT_FPGA    <=  wrMem;  
   rdMem_OUT_FPGA    <=  rdMem;  
   muxPC_OUT_FPGA    <=  muxPC;  
   muxAReg_OUT_FPGA  <=  muxAReg;
   muxDReg_OUT_FPGA  <=  muxDReg;
   FLAG_C_OUT_FPGA   <=  flag_C;
   FLAG_V_OUT_FPGA   <=  flag_V;
   FLAG_N_OUT_FPGA   <=  Ncomposto;
   FLAG_Z_OUT_FPGA   <=  Zcomposto;
   ---------------------------------------------


   --------------------------------------------------
   -- INSTÂNCIAS DOS COMPONENTES DA CPU
   --------------------------------------------------

   Bloco_IMEM:  entity  work.IMEM      -- Instância da MEMÓRIA DE INSTRUÇÕES
      generic map (
         NBits_EndM  =>  NBits_EndM,
         NBits_Dado  =>  NBits_Dado,
         N_Palavras  =>  N_Palavras)
      port map (
         rst     =>  rst,
         clk     =>  clk,
         addr_r  =>  PC,
         data_r  =>  IMEM_data );


   Bloco_DMEM:  entity  work.DMEM      -- Instância da MEMÓRIA DE DADOS
      generic map (
         NBits_EndM  =>  NBits_EndM,
         NBits_Dado  =>  NBits_Dado,
         N_Palavras  =>  N_Palavras)
      port map (
         rst      =>  rst,
         clk      =>  clk,
         rd_en    =>  rdMem,
         wr_en    =>  wrMem,
         addr_rw  =>  MAR,
         data_w   =>  A,
         data_r   =>  MDR );


   Bloco_GPR:  entity  work.GPR        -- Instância do BANCO DE REGISTRADORES
      generic map (
         NBits_EndR  =>  NBits_EndR,
         NBits_Dado  =>  NBits_Dado,
         N_Register  =>  N_Register )
      port map (
         rst      =>  rst,
         clk      =>  clk,
         addr_r1  =>  addr_r1,
         addr_r2  =>  addr_r2,
         data_r1  =>  GPR_data_r1,
         data_r2  =>  GPR_data_r2,
         wr_en    =>  wrReg,
         addr_w1  =>  mux_addr_w,
         data_w1  =>  mux_data_w );


   Bloco_DECOD:  entity  work.DECOD    -- Instância do DECODIFICADOR DE INTRUÇÃO
      generic map (
         NBits_EndM  =>  NBits_EndM,
         NBits_EndR  =>  NBits_EndR,
         NBits_Dado  =>  NBits_Dado )
      port map (
         IR       =>  IR,
         opcode   =>  OPinterno,
         reg_MAR  =>  addr_MAR,
         addr_r1  =>  addr_r1,
         addr_r2  =>  addr_r2,
         addr_w1  =>  addr_w1,
         addr_w2  =>  addr_w2,
         data_w1  =>  data_w1 );


   Bloco_ULA:  entity  work.ULA        -- Instância da UNIDADE LÓGICA E ARITMÉTICA
      generic map (
         NBITS  =>  NBits_Dado )
      port map (
         A       =>  A,
         B       =>  B,
         FUNC    =>  opULA,
         R       =>  ULA_out,
         flag_C  =>  flag_C,
         flag_V  =>  flag_V,
         flag_N  =>  flag_N,
         flag_Z  =>  flag_Z );


   Bloco_INC:  entity  work.FAD        -- Instancia do SOMADOR INCREMENTADOR do PC
      generic map(
         NBITS  =>  NBits_EndM )
      port map(
         A    =>  PC,
         B    =>  "00000001",
         Cin  =>  '0',
         S    =>  PC_mais_1 );


   Bloco_UC :  entity  work.FSM        -- Instancia da FSM da UNIDADE DE CONTROLE
      port map (

         -- VERIFICACAO --------------------
         ESTADO_FSM_FPGA =>  ESTADO_FSM_FPGA,
         -----------------------------------

         rst      =>  rst,
         clk      =>  clk,
         opcode   =>  OPinterno,
         Z        =>  Zcomposto,
         N        =>  Ncomposto,
         wrPC     =>  wrPC,
         wrIR     =>  wrIR,
         wrReg    =>  wrReg,
         rdMem    =>  rdMem,
         wrMem    =>  wrMem,
         muxPC    =>  muxPC,
         muxAReg  =>  muxAReg,
         muxDReg  =>  muxDReg,
         opULA    =>  opULA );


   --------------------------------------------------
   -- Operação dos MULTIPLEXADORES
   --------------------------------------------------

     -- Entrada Endereço GPRs
    MUX_addr_w  <=  addr_w1      when  muxAReg = '0'  else
                    addr_w2      when  muxAReg = '1'  else
                    MUX_addr_w;

    -- Entrada Dados GPRs
    MUX_data_w  <=  data_w1      when  muxDReg = "00" and (OPinterno = opLDAi) else
                    MDR          when  muxDReg = "01" and (OPinterno = opLDA)  else
                    R            when  muxDReg = "10"                          else
                    MUX_data_w;


   --------------------------------------------------
   -- Atualização dos REGISTRADORES INTERNOS
   --------------------------------------------------

   IR   <=  IMEM_data  when  wrIR = '1' ;


   process (clk, rst) begin

      if rst = '1' then

         PC   <=  (others => '0');

      elsif clk'event and clk = '1' then

         MAR  <=  addr_MAR;

         A    <=  GPR_data_r1;
         B    <=  GPR_data_r2;
         R    <=  ULA_out;

         if      wrPC = '1' and  muxPC = '1'  then   PC  <=  PC_mais_1;
         elsif   wrPC = '1' and  muxPC = '0'  then   PC  <=  MAR;
         end if;

      end if;

   end process;


   --------------------------------------------------
   -- Lógica para União Flags ULA + Flags LDA/LDAi
   --------------------------------------------------

   Ncomposto  <=  '1'  when  MUX_data_w(NBits_Dado - 1) = '1'      else flag_N;
   Zcomposto  <=  '1'  when  MUX_data_w = ZERO                     else flag_Z;


end architecture;




-----------------------------------------------------------------------------------------
--  TestBench da CPU
-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CPU_TB is
end entity;

architecture CPU_TB of CPU_TB is

   signal rst     :  std_logic  := '0';
   signal clk     :  std_logic  := '0';

begin


   -- Instancia da CPU
   dut_CPU:  entity  work.CPU
      port map(
         clk     =>  clk,
         rst     =>  rst);


   -- Processo RESET
   process begin
      rst  <=  '1';      wait for 5 ns;
      rst  <=  '0';      wait;
   end process;


   -- Processo CLOCK
   process begin
      wait for 10 ns;
      clk  <=  not(clk);
   end process;


end architecture;


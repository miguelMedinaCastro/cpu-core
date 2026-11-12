
-----------------------------------------------------------------------------------------
--  Representação de uma Memória ROM
-----------------------------------------------------------------------------------------
--  Modulo HDL com a implementação do DECODIFICADOR DE INSTRUÇÕES
--  Entrada: Registrador de Instrução (IR)
--  Saidas:  - Endereço de Memória (1 para Leitura - MAR)
--           - Endereços de GPRs (2 para Leituras e 1 para Escrita)
--           - Valor Imediato da Instrução
--           - OpCode da Instrução recebida
-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DECOD is
   generic(
      NBits_EndM  :  natural := 08;    -- Num. de Bits de Endereçamento MEMÓRIA
      NBits_EndR  :  natural := 03;    -- Num. de Bits de Endereçamento REGISTRADORES
      NBits_Dado  :  natural := 16;    -- Num. de Bits de Dados (Tamanho PALAVRA)
      NBits_OPco  :  natural := 05);   -- Num. de Bits de OpCode
   port(
      IR       :  in   std_logic_vector(NBits_Dado - 1 downto 0);   -- Entrada INSTRUÇÃO
      opcode   :  out  std_logic_vector(NBits_OPco - 1 downto 0);   -- Saída de OpCode
      reg_MAR  :  out  std_logic_vector(NBits_EndM - 1 downto 0);   -- Saída para Reg MAR
      addr_r1  :  out  std_logic_vector(NBits_EndR - 1 downto 0);   -- End. Leitura REG1
      addr_r2  :  out  std_logic_vector(NBits_EndR - 1 downto 0);   -- End. Leitura REG2
      addr_w1  :  out  std_logic_vector(NBits_EndR - 1 downto 0);   -- End. Escrita REG1
      addr_w2  :  out  std_logic_vector(NBits_EndR - 1 downto 0);   -- End. Escrita REG2
      data_w1  :  out  std_logic_vector(NBits_Dado - 1 downto 0));  -- Dado Escrita
end DECOD;


architecture DECOD of DECOD is

   signal EXTEND  :  std_logic_vector(NBits_Dado - NBits_EndM - 1 downto 0) := (others => '0');

begin

   -- Separação baseada nos FORMATOs de INSTRUÇÃO
   opcode   <=  IR(15 downto 11);
   addr_r1  <=  IR(10 downto 08);
   addr_r2  <=  IR(07 downto 05);
   addr_w1  <=  IR(10 downto 08);
   addr_w2  <=  IR(02 downto 00);
   reg_MAR  <=  IR(07 downto 00);

   -- ESTENSÃO de SINAL (suporte a Valores Positivos e Negativos)
   EXTEND   <=  (others => IR(7));
   data_w1  <=  EXTEND & IR(7 downto 0);

end architecture;




-----------------------------------------------------------------------------------------
--  TestBench da Memória ROM
-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DECOD_TB is
end entity;


architecture DECOD_TB of DECOD_TB is

   signal IR       :  std_logic_vector(15 downto 0)  :=  (others => '0');
   signal opcode   :  std_logic_vector(04 downto 0)  :=  (others => '0');
   signal reg_MAR  :  std_logic_vector(07 downto 0)  :=  (others => '0');
   signal addr_r1  :  std_logic_vector(02 downto 0)  :=  (others => '0');
   signal addr_r2  :  std_logic_vector(02 downto 0)  :=  (others => '0');
   signal addr_w1  :  std_logic_vector(02 downto 0)  :=  (others => '0');
   signal addr_w2  :  std_logic_vector(02 downto 0)  :=  (others => '0');
   signal data_w1  :  std_logic_vector(15 downto 0)  :=  (others => '0');

begin

   -- Instancia do Bloco DECOD
   dut: entity  work.DECOD  port map(  IR       =>  IR,
                                       opcode   =>  opcode,
                                       reg_MAR  =>  reg_MAR,
                                       addr_r1  =>  addr_r1,
                                       addr_r2  =>  addr_r2,
                                       addr_w1  =>  addr_w1,
                                       addr_w2  =>  addr_w2,
                                       data_w1  =>  data_w1 );


   -- Processo ESTIMULOS
   process begin
      wait for 15 ns;

      -- Teste usando CONTAGENS                                     OPCODE   ADDRs
      IR  <=  "00000"&"000"&"000"&"00"&"111";  wait for 20 ns;    --  00    0  0  7
      IR  <=  "00001"&"001"&"001"&"00"&"110";  wait for 20 ns;    --  01    1  1  6
      IR  <=  "00010"&"010"&"010"&"00"&"101";  wait for 20 ns;    --  02    2  2  5
      IR  <=  "00011"&"011"&"011"&"00"&"100";  wait for 20 ns;    --  03    3  3  4
      IR  <=  "00100"&"000"&"100"&"00"&"011";  wait for 20 ns;    --  04    0  4  3
      IR  <=  "00101"&"001"&"101"&"00"&"010";  wait for 20 ns;    --  05    1  5  2
      IR  <=  "00110"&"010"&"110"&"00"&"001";  wait for 20 ns;    --  06    2  6  1
      IR  <=  "00111"&"011"&"111"&"00"&"000";  wait for 20 ns;    --  07    3  7  0

      wait for 100 ns;

      -- Teste usando CONTAGENS                                   MAR    DATA
      IR  <=  "00000"&"000"&"0000"&"0001";  wait for 20 ns;    --  01    0001
      IR  <=  "00000"&"000"&"1000"&"0010";  wait for 20 ns;    --  82    FF82
      IR  <=  "00000"&"000"&"0000"&"0011";  wait for 20 ns;    --  03    0003
      IR  <=  "00000"&"000"&"1000"&"0100";  wait for 20 ns;    --  84    FF84
      IR  <=  "00000"&"000"&"1001"&"0101";  wait for 20 ns;    --  95    FF95
      IR  <=  "00000"&"000"&"1010"&"0110";  wait for 20 ns;    --  A6    FFA6
      IR  <=  "00000"&"000"&"1011"&"0111";  wait for 20 ns;    --  B7    FFB7
      IR  <=  "00000"&"000"&"1100"&"1000";  wait for 20 ns;    --  C8    FFC8

      wait for 100 ns;

      report "FIM !!!" severity failure;

   end process;

end architecture;


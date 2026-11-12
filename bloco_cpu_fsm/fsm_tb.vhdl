library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm_tb is
end entity;

architecture sim of fsm_tb is

  constant tamanho_OPCODE : natural := 5;

  component fsm
    generic (
      tamanho_OPCODE : natural := 5
    );
    port (
      clk     : in std_logic;
      reset   : in std_logic;

      opcode  : in std_logic_vector(tamanho_OPCODE - 1 downto 0);
      z       : in std_logic;
      n       : in std_logic;

      wrPC    : out std_logic;
      wrIR    : out std_logic;
      wrReg   : out std_logic;
      rdMem   : out std_logic;
      wrMem   : out std_logic;
      muxPC   : out std_logic;
      muxAReg : out std_logic;
      muxDReg : out std_logic_vector(1 downto 0);
      opULA   : out std_logic_vector(2 downto 0) := "000"
    );
  end component;

  signal clk                                              : std_logic                                     := '0';
  signal reset                                            : std_logic                                     := '1';
  signal opcode                                           : std_logic_vector(tamanho_OPCODE - 1 downto 0) := (others => '0');
  signal z, n                                             : std_logic                                     := '0';
  signal wrPC, wrIR, wrReg, rdMem, wrMem, muxPC, muxAReg   : std_logic;
  signal muxDReg                                          : std_logic_vector(1 downto 0);
  signal opULA                                            : std_logic_vector(2 downto 0);

  constant OP_LDA  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00001";
  constant OP_LDAi : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00010";
  constant OP_STA  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00011";
  constant OP_ADD  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00100";
  constant OP_SUB  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00101";
  constant OP_AND  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00110";
  constant OP_OR   : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "00111";
  constant OP_NOT  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "01000";
  constant OP_JZ   : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "01001";
  constant OP_JN   : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "01011";
  constant OP_JMP  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "01100";
  constant OP_HLT  : std_logic_vector(tamanho_OPCODE - 1 downto 0) := "01101";

begin

  uut : fsm
  generic map (
    tamanho_OPCODE => tamanho_OPCODE
  )
  port map (
    clk     => clk,
    reset   => reset,
    opcode  => opcode,
    z       => z,
    n       => n,
    wrPC    => wrPC,
    wrIR    => wrIR,
    wrReg   => wrReg,
    rdMem   => rdMem,
    wrMem   => wrMem,
    muxPC   => muxPC,
    muxAReg => muxAReg,
    muxDReg => muxDReg,
    opULA   => opULA
  );

  process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  process
  begin

    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    
    opcode <= OP_LDA;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_LDA"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0' and wrReg = '0' and rdMem = '0' and wrMem = '0'
      report "falha no ESTADO_DECODIFICA - OP_LDA"
      severity error;

    wait for 10 ns;
    assert rdMem = '1' and muxAReg = '0' and muxDReg = "01"
      report "falha no ESTADO_LE_MEM - OP_LDA"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and rdMem = '0'
      report "falha no ESTADO_ESCREVE_REG - OP_LDA"
      severity error;

    opcode <= OP_LDAi;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_LDAi"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_LDAi"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and muxAReg = '0' and muxDReg = "00"
      report "falha no ESTADO_ESCREVE_REG_2 - OP_LDAi"
      severity error;

    opcode <= OP_STA;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_STA"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_STA"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert wrMem = '1'
      report "falha no ESTADO_ESCREVE_MEM - OP_STA"
      severity error;

    opcode <= OP_ADD;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_ADD"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_ADD"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert opULA = "000"
      report "falha no ESTADO_ULA_EXECUTA - OP_ADD"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and opULA = "000"
      report "falha no ESTADO_ESCREVE_REG_3 - OP_ADD"
      severity error;

    opcode <= OP_SUB;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_SUB"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_SUB"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert opULA = "001"
      report "falha no ESTADO_ULA_EXECUTA - OP_SUB"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and opULA = "000"
      report "falha no ESTADO_ESCREVE_REG_3 - OP_SUB"
      severity error;

    opcode <= OP_AND;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_AND"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_AND"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert opULA = "100"
      report "falha no ESTADO_ULA_EXECUTA - OP_AND"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and opULA = "000"
      report "falha no ESTADO_ESCREVE_REG_3 - OP_AND"
      severity error;

    opcode <= OP_OR;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_OR"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_OR"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert opULA = "110"
      report "falha no ESTADO_ULA_EXECUTA - OP_OR"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and opULA = "000"
      report "falha no ESTADO_ESCREVE_REG_3 - OP_OR"
      severity error;

    opcode <= OP_NOT;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_NOT"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_NOT"
      severity error;

    wait for 10 ns;

    wait for 10 ns;
    assert opULA = "111"
      report "falha no ESTADO_ULA_EXECUTA - OP_NOT"
      severity error;

    wait for 10 ns;
    assert wrReg = '1' and opULA = "000"
      report "falha no ESTADO_ESCREVE_REG_3 - OP_NOT"
      severity error;

    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    opcode <= OP_JMP;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1' and rdMem = '1' and wrMem = '0' and
           muxPC = '1' and muxAReg = '1' and muxDReg = "10"
      report "falha no ESTADO_BUSCA - OP_JMP"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_JMP"
      severity error;

    wait for 10 ns;
    assert wrPC = '1' and muxPC = '0'
      report "falha no ESTADO_ESCREVE_PC - OP_JMP"
      severity error;

    opcode <= OP_JZ;
    z      <= '1';

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1'
      report "falha no ESTADO_BUSCA - OP_JZ z=1"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_JZ z=1"
      severity error;

    wait for 10 ns;
    assert wrPC = '1' and muxPC = '0'
      report "falha no ESTADO_ESCREVE_PC - OP_JZ z=1"
      severity error;

    opcode <= OP_JZ;
    z      <= '0';

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1'
      report "falha no ESTADO_BUSCA - OP_JZ z=0"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_JZ z=0"
      severity error;

    wait for 10 ns;
    assert wrPC = '0'
      report "falha no ESTADO_ESCREVE_PC - OP_JZ z=0, nao deveria escrever PC"
      severity error;

    opcode <= OP_JN;
    n      <= '1';

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1'
      report "falha no ESTADO_BUSCA - OP_JN n=1"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_JN n=1"
      severity error;

    wait for 10 ns;
    assert wrPC = '1' and muxPC = '0'
      report "falha no ESTADO_ESCREVE_PC - OP_JN n=1"
      severity error;

    opcode <= OP_JN;
    n      <= '0';

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1'
      report "falha no ESTADO_BUSCA - OP_JN n=0"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_JN n=0"
      severity error;

    wait for 10 ns;
    assert wrPC = '0'
      report "falha no ESTADO_ESCREVE_PC - OP_JN n=0, nao deveria escrever PC"
      severity error;

    
    opcode <= OP_HLT;

    wait for 10 ns;
    assert wrPC = '1' and wrIR = '1'
      report "falha no ESTADO_BUSCA - OP_HLT"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0'
      report "falha no ESTADO_DECODIFICA - OP_HLT"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0' and wrReg = '0'
      report "falha no ESTADO_FIM - OP_HLT"
      severity error;

    wait for 10 ns;
    assert wrPC = '0' and wrIR = '0' and wrReg = '0'
      report "falha: ESTADO_FIM nao permaneceu travado - OP_HLT"
      severity error;

    assert false
      report "fim: tudo passou"
      severity failure;

    wait;

  end process;

end architecture;

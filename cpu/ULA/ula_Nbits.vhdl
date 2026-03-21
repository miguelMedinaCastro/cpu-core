library ieee;
use ieee.std_logic_1164.all;

entity ula_Nbits is
  generic (
    bitsOperations : natural := 3;
    bits           : natural := 4
  );
  port (
    A, B    : in std_logic_vector(bits - 1 downto 0);
    Cin     : in std_logic;
    op_code : in std_logic_vector(bitsOperations - 1 downto 0);
    Saida   : out std_logic_vector(bits - 1 downto 0);
    Cout    : out std_logic
  );
end entity;

architecture behavior of ula_Nbits is

  signal fio_and : std_logic_vector(bits - 1 downto 0);
  signal fio_or  : std_logic_vector(bits - 1 downto 0);
  signal fio_not : std_logic_vector(bits - 1 downto 0);

  signal fio_subtracao  : std_logic_vector(bits - 1 downto 0);
  signal cout_subtracao : std_logic;

  signal fio_adder  : std_logic_vector(bits - 1 downto 0);
  signal cout_adder : std_logic;

  signal B_adder   : std_logic_vector(bits - 1 downto 0);
  signal Cin_adder : std_logic;
begin

  B_adder <= B when op_code = "000" else
    not B when op_code = "001" else
      B;

  Cin_adder <= Cin when op_code = "000" else
    '1' when op_code = "001" else
      Cin;

  ADDER : entity work.somadorNbits
    generic map(
      N => bits
    )
    port map
    (
      A     => A,
      B     => B_adder,
      Cin   => Cin_adder,
      Saida => fio_adder,
      Cout  => cout_adder
    );

  fio_and <= A and B;
  fio_or  <= A or B;
  fio_not <= not B;

  Saida <= 
    fio_adder when (op_code = "000" or op_code = "001") else
    fio_and when (op_code = "010") else
    fio_or when (op_code = "011") else
    fio_not when (op_code = "100") else
    (others => '0');

  Cout <= 
    cout_adder when (op_code = "000" or op_code = "001") else
    '0';

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_1bit is
  generic ( 
    bitsOperations : natural
  );
  port (
    A, B, Cin : in std_logic;
    op_code   : in std_logic_vector(bitsOperations - 1 downto 0);
    Saida     : out std_logic;
    Cout      : out std_logic
  );
end entity;

architecture behavior of ula_1bit is

  signal fio_and : std_logic;
  signal fio_or  : std_logic;
  signal fio_not : std_logic;

  signal AxB             : std_logic;
  signal fio_full_adder  : std_logic;
  signal cout_full_adder : std_logic;

  signal B_seletivo : std_logic;

begin

  fio_and <= A and B;
  fio_or  <= A or B;
  fio_not <= not A;

  B_seletivo <= (not B) when (op_code = "001") else B;
  AxB        <= A xor B_seletivo;

  fio_full_adder  <= AxB xor Cin;
  cout_full_adder <= (AxB and Cin) or (A and B_seletivo);

  Saida <= fio_full_adder when (op_code = "000" or op_code = "001") else
    fio_and when (op_code = "010") else
    fio_or when (op_code = "011") else
    fio_not when (op_code = "100") else
    '0';

  Cout <= cout_full_adder when (op_code = "000" or op_code = "001") else
    '0';

end architecture;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_Nbits is
  generic (
    bits         : natural := 4;
    bits_op_code : natural := 3
  );
  port (
    A, B    : in std_logic_vector(bits - 1 downto 0);
    Cin     : in std_logic;
    op_code : in std_logic_vector(bits_op_code - 1 downto 0);
    Saida   : out std_logic_vector(bits - 1 downto 0);
    Cout    : out std_logic
  );
end entity ula_Nbits;

architecture behavior of ula_Nbits is

  signal carries : std_logic_vector(bits downto 0);

begin

  carries(0) <= '1' when (op_code = "001") else Cin;

  ULA : for i in 0 to bits - 1 generate
    ULA_i : entity work.ula_1bit
      generic map(
        bitsOperations => bits_op_code
      )
      port map
      (
        A       => A(i),
        B       => B(i),
        Cin     => carries(i),
        op_code => op_code,
        Saida   => Saida(i),
        Cout    => carries(i + 1)
      );
  end generate;

  Cout <= carries(bits);
end architecture;

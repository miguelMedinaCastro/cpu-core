library ieee;
use ieee.std_logic_1164.all;

entity ula_1bit is
  generic (
    bitsOperations : natural := 3
  );
  port (
    A, B, Cin : in std_logic;
    op_code   : in std_logic_vector(bitsOperations - 1 downto 0);
    S         : out std_logic;
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

  signal fio_subtracao  : std_logic;
  signal cout_subtracao : std_logic;

begin
  fio_and <= A and B;
  fio_or  <= A or B;
  fio_not <= not A;

  AxB <= A xor B;

  -- full adder
  fio_full_adder  <= AxB xor Cin;
  cout_full_adder <= (AxB and Cin) or (A and B);

  -- sub
  fio_subtracao  <= AxB xor Cin;
  cout_subtracao <= (not A and B) or (Cin and not AxB);

  S <= fio_full_adder when (op_code = "000") else
    fio_subtracao when (op_code = "001") else
    fio_and when (op_code = "010") else
    fio_or when (op_code = "011") else
    fio_not when (op_code = "100") else
    '0';

  Cout <= cout_full_adder when (op_code = "000") else
    cout_subtracao when (op_code = "001") else
    '0';
end architecture;

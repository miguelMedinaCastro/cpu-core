library ieee;
use ieee.std_logic_1164.all;

entity ula_1bit_tb is
end entity ula_1bit_tb;

architecture behavior of ula_1bit_tb is

  constant bitsOperation : natural := 3;

  signal A       : std_logic                                    := '0';
  signal B       : std_logic                                    := '0';
  signal Cin     : std_logic                                    := '0';
  signal op_code : std_logic_vector(bitsOperation - 1 downto 0) := "000";

  signal S    : std_logic;
  signal Cout : std_logic;

begin

  uut : entity work.ula_1bit
    port map
    (
      A       => A,
      B       => B,
      Cin     => Cin,
      op_code => op_code,
      S       => S,
      Cout    => Cout
    );

  process
  begin
    op_code <= "000";
    A       <= '0';
    B       <= '1';
    Cin     <= '0'; -- 0 + 1 + 0 = Soma 1, Carry 0
    wait for 10 ns;

    A   <= '1';
    B   <= '1';
    Cin <= '0'; -- 1 + 1 + 0 = Soma 0, Carry 1 (Vai um!)
    wait for 10 ns;

    A   <= '1';
    B   <= '1';
    Cin <= '1'; -- 1 + 1 + 1 = Soma 1, Carry 1
    wait for 10 ns;

    op_code <= "001";
    A       <= '1';
    B       <= '0';
    Cin     <= '0'; -- 1 - 0 - 0 = Result 1, Borrow 0
    wait for 10 ns;

    A   <= '0';
    B   <= '1';
    Cin <= '0'; -- 0 - 1 - 0 = Result 1, Borrow 1 (Emprestou!)
    wait for 10 ns;

    op_code <= "010";
    A       <= '1';
    B       <= '1';
    Cin     <= '0'; -- 1 AND 1 = 1 (Carry tem que ser 0)
    wait for 10 ns;

    A   <= '1';
    B   <= '0';
    Cin <= '0'; -- 1 AND 0 = 0
    wait for 10 ns;

    op_code <= "011";
    A       <= '0';
    B       <= '1';
    Cin     <= '0'; -- 0 OR 1 = 1
    wait for 10 ns;

    op_code <= "100";
    A       <= '0';
    B       <= '1';
    Cin     <= '1'; -- (B e Ci são ignorados)
    wait for 10 ns;

    A   <= '1';
    B   <= '0';
    Cin <= '0'; -- NOT 1 = 0
    wait for 10 ns;

    wait;
  end process;

end architecture;
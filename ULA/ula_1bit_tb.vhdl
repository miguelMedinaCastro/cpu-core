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

    -- fazer um CONTADOR! assim testa todos
  process
  begin
    op_code <= "000";  A <= '0'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
    
    op_code <= "001";  A <= '0'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '1'; wait for 10 ns;

    op_code <= "010";  A <= '0'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '1'; wait for 10 ns;

      op_code <= "011";  A <= '0'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '1'; wait for 10 ns;

      

    op_code <= "100";  A <= '0'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '0'; B  <= '1';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '0';    Cin  <= '1'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '0'; wait for 10 ns;
      A <= '1'; B  <= '1';    Cin  <= '1'; wait for 10 ns;



    wait;
  end process;

end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity bitregister_tb is
end bitregister_tb;

architecture sim of bitregister_tb is

  constant N : natural := 8;

  signal Rin       : std_logic := '0';
  signal Clock     : std_logic := '0';
  signal R_serial  : std_logic := '0';
  signal Q         : std_logic_vector(N - 1 downto 0);

begin

  uut: entity work.bitregister
    generic map (
      N => N
    )
    port map (
      Rin      => Rin,
      Clock    => Clock,
      R_serial => R_serial,
      Q        => Q
    );

  clk_proc : process
  begin
    Clock <= '0';
    wait for 5 ns;
    Clock <= '1';
    wait for 5 ns;
  end process;

  stim_proc : process
  begin
    Rin <= '1';

    R_serial <= '1'; wait for 10 ns;
    R_serial <= '0'; wait for 10 ns;
    R_serial <= '1'; wait for 10 ns;
    R_serial <= '1'; wait for 10 ns;
    R_serial <= '0'; wait for 10 ns;
    R_serial <= '0'; wait for 10 ns;
    R_serial <= '1'; wait for 10 ns;
    R_serial <= '1'; wait for 10 ns;

    Rin <= '0';

    wait;
  end process;

end sim;

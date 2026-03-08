library ieee;
use ieee.std_logic_1164.all;

entity bitregister_par_tb is
end bitregister_par_tb;

architecture sim of bitregister_par_tb is

  constant N : natural := 8;

  signal R     : std_logic_vector(N - 1 downto 0) := (others => '0');
  signal Rin   : std_logic := '0';
  signal Clock : std_logic := '0';
  signal Q     : std_logic_vector(N - 1 downto 0);

begin

  uut: entity work.bitregister_par
    generic map (
      N => N
    )
    port map (
      R     => R,
      Rin   => Rin,
      Clock => Clock,
      Q     => Q
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
    R   <= "10101010";
    Rin <= '1';
    wait for 10 ns;

    R <= "11110000";
    wait for 10 ns;

    Rin <= '0';
    R   <= "00000000";
    wait for 20 ns;

    assert false report "Fim da simulacao" severity failure;
  end process;
end sim;

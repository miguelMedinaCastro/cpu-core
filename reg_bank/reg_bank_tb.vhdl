library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity reg_bank_tb is
end entity;

architecture tb of reg_bank_tb is
  --dar nome significativo
  constant X : natural := 3;
  constant Y : natural := 16;
  constant Z : natural := 8; --declarar z = 2 elevado na x

  signal r_addr_1 : std_logic_vector(X - 1 downto 0) := (others => '0');
  signal r_addr_2 : std_logic_vector(X - 1 downto 0) := (others => '0');
  signal w_addr   : std_logic_vector(X - 1 downto 0) := (others => '0');
  signal w        : std_logic;
  signal reset    : std_logic;
  signal clk      : std_logic;
  signal data_i   : std_logic_vector(Y - 1 downto 0) := (others => '0');
  signal data_o_1 : std_logic_vector(Y - 1 downto 0);
  signal data_o_2 : std_logic_vector(Y - 1 downto 0);

begin
  clk_process : process
  begin
    clk <= '0';
    wait for 10 ns;

    clk <= '1';
    wait for 10 ns;
  end process;

  uut : entity work.reg_bank
    port map
    (
      r_addr_1 => r_addr_1,
      r_addr_2 => r_addr_2,
      w_addr   => w_addr,
      clk      => clk,
      w        => w,
      --reset    => reset,
      data_i   => data_i,
      data_o_1 => data_o_1,
      data_o_2 => data_o_2
    );

  process
  begin
    w <= '1';
    for i in 0 to Z - 1 loop
      w_addr <= std_logic_vector(to_unsigned(i, 3));
      data_i <= std_logic_vector(to_unsigned(i * 10, Y));
      wait until rising_edge(clk);
    end loop;

    assert FALSE
        report "fim"
        severity FAILURE;
  end process;

  r_addr_1 <= "001";
  r_addr_2 <= "100";

end architecture;

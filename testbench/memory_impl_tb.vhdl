library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity memory_impl_tb is
end entity;

architecture tb of memory_impl_tb is

  constant X : natural := 8;
  constant Y : natural := 16;
  constant Z : natural := 256;

  signal clk         : std_logic                        := '0';
  signal r           : std_logic                        := '0';
  signal w           : std_logic                        := '0';
  signal addr        : std_logic_vector(X - 1 downto 0) := (others => '0');
  signal data_i      : std_logic_vector(Y - 1 downto 0) := (others => '0');
  signal data_o      : std_logic_vector(Y - 1 downto 0);
  signal addr_i      : natural := 0;
  signal read_addr_i : natural := 0;

  file mem_file : text open read_mode is "memoria.txt";

begin
  clk_process : process
  begin
    clk <= '0';
    wait for 10 ns;

    clk <= '1';
    wait for 10 ns;
  end process;

  uut : entity work.memory_impl
    port map
    (
      clk    => clk,
      r      => r,
      w      => w,
      addr   => addr,
      data_i => data_i,
      data_o => data_o
    );

  process (clk)

    variable line_v : line;
    variable value : std_logic_vector(Y - 1 downto 0);

  begin
    if rising_edge(clk) then
      r <= '0';
      w <= '0';
      if not endfile(mem_file) and addr_i <= Z - 1 then
        w <= '1';

        readline(mem_file, line_v);
        read(line_v, value);

        addr <= std_logic_vector(to_unsigned(addr_i, X));
        data_i <= value;

        addr_i <= addr_i + 1;
      else
        r <= '1';
        addr <= std_logic_vector(to_unsigned(read_addr_i, X));
        read_addr_i <= read_addr_i + 1; --255
        if read_addr_i = Z + 1 then
          assert FALSE
          report "fim"
          severity FAILURE;
        end if;

      end if;
    end if;
  end process;
end architecture;

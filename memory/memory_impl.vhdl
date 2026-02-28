library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--descrever agora que nem vida real, usando portas logicas, acompanha um decodificador
--descricao de memoria RTL, opencors

entity memory_impl is
  generic (
    X : natural := 8;
    Y : natural := 16;
    Z : natural := 256
  );
  port (
    addr   : in std_logic_vector(X - 1 downto 0);
    data_i : in std_logic_vector(Y - 1 downto 0);
    clk    : in std_logic;
    r      : in std_logic;
    w      : in std_logic;
    data_o : out std_logic_vector(Y - 1 downto 0)
  );
end memory_impl;
architecture behavior of memory_impl is

  type memory is array(Z - 1 downto 0) of std_logic_vector(Y - 1 downto 0);

  signal mem : memory;

begin
  process (clk)
  begin
    if rising_edge(clk) then
      if w = '1' then
        mem(to_integer(unsigned(addr))) <= data_i;
      elsif r = '1' then
        data_o <= mem(to_integer(unsigned(addr)));
      end if;
    end if;
  end process;
end behavior;
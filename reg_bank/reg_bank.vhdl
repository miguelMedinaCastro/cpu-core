library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_bank is
  generic (
    X : NATURAL := 3;
    Y : natural := 16;
    Z : NATURAL := 2**X
  );
  port (
    r_addr_1 : in std_logic_vector(X - 1 downto 0);
    r_addr_2 : in std_logic_vector(X - 1 downto 0);
    w_addr   : in std_logic_vector(X - 1 downto 0);
    clk      : in std_logic;
    -- r          : in std_logic;
    w        : in std_logic;
    --reset    : in std_logic;
    data_i   : in std_logic_vector(Y - 1 downto 0);
    data_o_1 : out std_logic_vector(Y - 1 downto 0);
    data_o_2 : out std_logic_vector(Y - 1 downto 0)
  );
end reg_bank;
architecture behavior of reg_bank is

  type reg_array is array(Z - 1 downto 0) of std_logic_vector(Y - 1 downto 0);

  signal regs : reg_array;

begin
  process (clk)
  begin
    if rising_edge(clk) then
      --if reset = '1' then 
      --regs <= (others => (others => '0'));
      data_o_1 <= regs(to_integer(unsigned(r_addr_1)));
      data_o_2 <= regs(to_integer(unsigned(r_addr_2)));
      if w = '1' then
        regs(to_integer(unsigned(w_addr))) <= data_i;
        --regs(to_integer(unsigned(w_addr))) <= data_i;
    end if;
  end if;
  end process;


end behavior;
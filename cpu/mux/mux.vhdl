library ieee;
use ieee.std_logic_1164.all;

entity mux is
  generic (
    bits : natural := 16
  );
  port (
    A, B      : in std_logic_vector(bits - 1 downto 0);
    selection : in std_logic;
    result    : out STD_LOGIC_VECTOR(bits - 1 downto 0)
  );
end entity;

architecture behavior of mux is

begin
    result <= A when selection = '0' else B;
    

end architecture;

-- incompleto
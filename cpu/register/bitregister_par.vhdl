library ieee;
use ieee.std_logic_1164.all;

entity bitregister_par is 
  generic (
    N : natural := 8
  );
  port (
    R             : in  std_logic_vector(N - 1 downto 0);
    Rin, Clock    : in  std_logic;
    Q             : out std_logic_vector(N - 1 downto 0)
  );
end bitregister_par;

architecture behavior of bitregister_par is
  begin
    process
    begin
      wait until Clock'event and Clock = '1';
        if Rin = '1' then Q <= R;
        end if ; 
      end process;
end behavior ;

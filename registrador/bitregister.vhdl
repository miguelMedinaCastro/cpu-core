library ieee;
use ieee.std_logic_1164.all;

entity bitregister is 
  generic (
    N : natural := 8
  );
  port (
    Rin , Clock, R_serial : in  std_logic;
    Q                     : out std_logic_vector(N - 1 downto 0)
  );
end bitregister;

architecture behavior of bitregister is

  signal Q_int : std_logic_vector(N - 1 downto 0);

  begin
    process
    begin
      wait until Clock'event and Clock = '1';
      if Rin = '1' then
        Q_int <= Q_int(N - 2 downto 0) & R_serial;
      end if ;
    end process;

    Q <= Q_int;
end behavior ;

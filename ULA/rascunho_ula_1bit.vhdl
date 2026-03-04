library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity rascunho_ula_1bit is
  
  port (
    A, B, Ci : in std_logic;
    op        : in std_logic_vector(1 downto 0);
    S         : out std_logic;
    Co        : out std_logic

  );
end entity;

architecture behavior of rascunho_ula_1bit is
  
  signal S_and : std_logic;
  signal S_Or  : std_logic;
  signal S_Not : std_logic;

  signal S_Fad : std_logic;
  signal AxB   : std_logic;
  signal AxBCi : std_logic;

begin
  S_and <= A and B;
  S_Or <=  A or B;
  S_Not <= not A;

  AxB <= A xor B;
  S_Fad <= AxB xor Ci;
  AxBCi <= AxB and Ci;
  Co <= AxBCi or S_and;

  S <= S_and when (op = "00") else
      S_Or when (op = "01") else 
      S_Not when (op = "11") else 
      S_Fad; 
        
  
end architecture;
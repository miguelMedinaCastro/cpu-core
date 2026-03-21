library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_Nbits_tb is
end entity ula_Nbits_tb;

architecture behavior of ula_Nbits_tb is

  constant bits_operations : natural                                        := 3;
  constant bits            : natural                                        := 4;
  constant operations      : natural                                        := (2 ** bits_operations) * 10;
  constant totalBits       : natural                                        := bits_operations + (2 * bits) + 1;

  signal A                 : std_logic_vector(bits - 1 downto 0)            := (others => '0');
  signal B                 : std_logic_vector(bits - 1 downto 0)            := (others => '0');
  signal Cin               : std_logic                                      := '0';
  signal op_code           : std_logic_vector(bits_operations - 1 downto 0) := (others => '0');

  signal Saida : std_logic_vector(bits - 1 downto 0);
  signal Cout  : std_logic;

  signal count : UNSIGNED(totalBits - 1 downto 0) := (others => '0') ;
  
begin

  op_code <= STD_LOGIC_VECTOR(count(totalBits - 1 downto (2*bits) + 1));
  A <= STD_LOGIC_VECTOR(count(2*bits downto bits + 1));
  B <= STD_LOGIC_VECTOR(count(bits downto 1));
  Cin <= count(0);

  ULA_DUT : entity work.ula_Nbits
    generic map(
      bitsOperations => bits_operations,
      bits           => bits
    )
    port map
    (
      A       => A,
      B       => B,
      Cin     => Cin,
      op_code => op_code,
      Saida   => Saida,
      Cout    => Cout
    );

  counter : process
  begin

    wait for  10 ns;

    if count = (count'range => '1') then
      wait;
    else
      count <= count + 1;
    end if;

    -- colocar assert
    -- assert 
    --   report "deu certo"
    --   severity FAILURE;
    
  end process;

end architecture;
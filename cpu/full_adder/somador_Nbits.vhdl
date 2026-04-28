library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is -- mudar nome
  port (
    A, B, Cin : in std_logic;
    Saida     : out std_logic;
    Cout      : out std_logic
  );
end somador;

architecture behavior of somador is

begin
  -- Cálculo do bit de resultado (Paridade)
  Saida <= A xor B xor Cin;

  -- Lógica de Maioria para o transporte (Se dois ou mais forem '1', o Carry é '1')
  Cout  <= (A and B) or (A and Cin) or (B and Cin);

end architecture;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somadorNbits is
  generic (
    tamanho_dos_vetores : natural := 16
  );

  port (
    A, B  : in std_logic_vector(tamanho_dos_vetores - 1 downto 0);
    Cin   : in std_logic;
    Saida : out std_logic_vector(tamanho_dos_vetores - 1 downto 0);
    Cout  : out std_logic
  );
end somadorNbits;

architecture comportamentoNbits of somadorNbits is

  signal cin_interno : std_logic_vector(tamanho_dos_vetores downto 0);

begin
  cin_interno(0) <= Cin;

  ADDER_GEN : for i in 0 to tamanho_dos_vetores - 1 generate
    FA : entity work.somador
      port map
      (
        A     => A(i),
        B     => B(i),
        Cin   => cin_interno(i),
        Saida => Saida(i),
        Cout  => cin_interno(i + 1)
      );
  end generate;

  Cout <= cin_interno(tamanho_dos_vetores);

end comportamentoNbits;
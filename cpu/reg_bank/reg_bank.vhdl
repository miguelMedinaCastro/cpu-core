library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores is
  generic (
    tamanho_endereco     : natural := 3;
    tamanho_dado         : natural := 16;
    quantidade_registros : natural := 2 ** tamanho_endereco
  );
  port (
    endereco_leitura_1 : in std_logic_vector(tamanho_endereco - 1 downto 0);
    endereco_leitura_2 : in std_logic_vector(tamanho_endereco - 1 downto 0);
    endereco_escrita   : in std_logic_vector(tamanho_endereco - 1 downto 0);
    clock      : in std_logic;
    escrita        : in std_logic;
    dado_entrada_i   : in std_logic_vector(tamanho_dado - 1 downto 0);
    dado_saida_1 : out std_logic_vector(tamanho_dado - 1 downto 0);
    dado_saida_2 : out std_logic_vector(tamanho_dado - 1 downto 0)
  );
end banco_registradores;
architecture comportamento of banco_registradores is

  type vetor_registradores is array(quantidade_registros - 1 downto 0) of std_logic_vector(tamanho_dado - 1 downto 0);

  signal registradores : vetor_registradores;

begin
  process (clock)
  begin
    if rising_edge(clock) then
      dado_saida_1 <= registradores(to_integer(unsigned(endereco_leitura_1)));
      dado_saida_2 <= registradores(to_integer(unsigned(endereco_leitura_2)));
      if escrita = '1' then
        registradores(to_integer(unsigned(endereco_escrita))) <= dado_entrada_i;
      end if;
    end if;
  end process;
end comportamento;
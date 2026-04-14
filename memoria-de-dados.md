---
icon: memory
---

# Memória de Dados

> A RAM de trabalho onde as variáveis do programa vivem.

Se a Memória de Instruções é a estante com a partitura do programa, a Memória de Dados é a bancada de trabalho onde a CPU guarda os materiais que está usando. É aqui que as variáveis do programa residem: contadores, vetores, resultados intermediários — tudo que precisa persistir além de um único ciclo de clock.

Diferente da ROM de instruções, a Memória de Dados é uma RAM (Random Access Memory): pode ser lida e escrita a qualquer momento durante a execução, no endereço que a CPU especificar.

***

### Como funciona

A Memória de Dados participa em dois tipos de instrução:

1. LOAD (Leitura): A CPU envia um endereço e ativa `leitura = '1'`. A memória devolve o valor de 16 bits guardado naquela posição. Esse valor passa pelo MUX  e é salvo em um registrador.
2. STORE (Escrita): A CPU envia um endereço, um valor de 16 bits e ativa `escrita_ativa = '1'`. Na próxima borda de subida do clock, o valor é gravado permanentemente naquela posição.

> **Analogia:** Pense na Memória de Dados como um grande armário de gavetas numeradas. O Decodificador diz: "gaveta 42". Com `escrita_ativa = 1`, a CPU guarda algo lá dentro. Com `leitura = 1`, a CPU abre a gaveta e pega o que estava guardado. A diferença em relação aos Registradores é que esse armário tem centenas de gavetas, mas leva um ciclo a mais para abrir cada uma.

***

### Características

* RAM de leitura e escrita (diferente da ROM de instruções)
* Tamanho configurável via `generic`: endereço de `X` bits, dados de `Y` bits, `Z` posições
* Escrita síncrona: gravação ocorre na borda de subida do clock com `WE = '1'`
* Leitura síncrona: dado disponível no ciclo seguinte ao clock com `r = '1'`
* Inicializada com zeros por padrão

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic (
    bits_endereco   : natural := 8;
    bits_dado       : natural := 16;
    numero_posicoes : natural := 256
  );
  port (
    endereco          : in  std_logic_vector(bits_endereco-1 downto 0);
    clock             : in  std_logic;
    escrita_ativa     : in  std_logic;
    leitura           : in  std_logic;
    entrada_dado      : in  std_logic_vector(bits_dado-1 downto 0);
    saida_dado        : out std_logic_vector(bits_dado-1 downto 0)
  );
end ram;

architecture comportamento of ram is
  type memoria is array(numero_posicoes-1 downto 0) of std_logic_vector(bits_dado-1 downto 0);
  signal mem : memoria := (others => (others => '0'));
begin
  process(clock)
  begin
    if rising_edge(clock) then
      if escrita_ativa = '1' then
        mem(to_integer(unsigned(endereco))) <= entrada_dado;
      end if;
      if leitura = '1' then
        saida_dado <= mem(to_integer(unsigned(endereco)));
      end if;
    end if;
  end process;
end comportamento;
```

***

### Conexão com outros módulos

A Memória de Dados recebe o endereço e o dado de entrada (`entrada_dado`) vindos da ULA e do Banco de Registradores. Os sinais `escrita_ativada` e `leitura` são controlados pelo Decodificador. A saída `saida_dado` vai para o **MUX,** que decide se o Banco de Registradores deve receber esse valor (instrução `load`) ou o resultado direto da ULA (instrução aritmética).

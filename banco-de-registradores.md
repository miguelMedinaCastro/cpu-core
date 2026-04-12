---
description: O armário de memória ultrarrápida da CPU.
---

# Banco de Registradores

Se um Registrador é uma única "caixa" de memória, o _Banco de Registradores_ é o armário completo. Ele reúne múltiplos registradores de 16 bits em um único módulo, com uma lógica de endereçamento que permite à CPU escolher exatamente qual caixa quer ler ou escrever — tudo em um único ciclo de clock.

O Banco de Registradores é o coração do _caminho de dados(DATAPATCH)_ da CPU: é daqui que a ULA busca os números para fazer seus cálculos, e é aqui que os resultados são devolvidos para serem guardados.

***

### Como funciona

Os sinais `endereco_leitura_1` e `endereco_leitura_2` indicam quais registradores serão lidos.\
Na borda de subida do clock, os valores desses registradores são colocados em:

* `dado_saida_1`
* `dado_saida_2`

Ou seja: a leitura é sincronizada com o clock, não imediata.

***

**Uso dos dados (ex: ULA):**\
Os valores presentes em `dado_saida_1` e `dado_saida_2` podem ser usados por outros componentes (como uma ULA) para realizar operações (soma, AND, OR, ...).

***

**Escrita no banco:**\
O sinal `endereco_escrita` define qual registrador será atualizado.\
O valor a ser escrito vem de `dado_entrada_i`.

* Se `escrita = '1'`, o valor é armazenado
* Se `escrita = '0'`, nada é alterado

Tudo isso acontece na borda de subida do clock.

> **Analogia:** Imagine uma bancada com 8 calculadoras numeradas. Você diz: "pegue o número da calculadora 2 e o número da calculadora 5, some-os, e guarde o resultado na calculadora 1." Isso é exatamente o que o Banco de Registradores faz em um ciclo de clock.

***

### Características

* Contém múltiplos registradores de tamanho de 16 bits via `generic` (`tamanho_dado`)
* A quantidade de registradores também é configurável (`quantidade_registros = 2 ** tamanho_endereco`)
* Possui duas portas de leitura, porém:
  * São sincronizadas com o clock
* Possui uma porta de escrita sincronizada com o clock
* O acesso aos registradores é feito por endereços:
  * `endereco_leitura_1`
  * `endereco_leitura_2`
  * `endereco_escrita`
* A escrita é controlada pelo sinal `escrita`:
  * Quando `escrita = '1'`, o dado é armazenado no registrador selecionado
  * Quando `escrita = '0'`, nenhum registrador é alterado
* As leituras retornam os valores dos registradores no momento da borda de subida do clock

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
    clock              : in std_logic;
    escrita            : in std_logic;
    dado_entrada_i     : in std_logic_vector(tamanho_dado - 1 downto 0);
    dado_saida_1       : out std_logic_vector(tamanho_dado - 1 downto 0);
    dado_saida_2       : out std_logic_vector(tamanho_dado - 1 downto 0)
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
```

***

### Conexão com outros módulos

O Banco de Registradores é o intermediário central da CPU. Ele recebe ordens da Unidade de Controle (quais registradores ler e escrever), entrega operandos para a ULA processar, e recebe de volta o resultado calculado. O MUX de writeback decide se o valor que entra na porta `escrita` vem da ULA ou da Memória de Dados (no caso de uma instrução de `load`).

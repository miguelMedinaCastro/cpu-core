---
description: Descrição completa de memória de instruções
icon: readme
---

# Memória de Instruções

> A ROM que guarda o programa a ser executado.

A Memória de Instruções é o componente que armazena o programa que a CPU vai executar. Ela funciona como uma estante numerada onde cada posição guarda uma instrução de 16 bits — e o número da posição é o endereço fornecido pelo Program Counter(PC).

Diferente da Memória de Dados (que pode ser lida e escrita durante a execução), a Memória de Instruções é uma _ROM_ (Read-Only Memory): o programa é definido antes da simulação e não muda durante a execução. Isso reflete a separação clássica da Arquitetura Harvard, onde instruções e dados trafegam por barramentos independentes.

***

### Como funciona

O funcionamento da Memória de Instruções está ligado diretamente ao primeiro estágio do ciclo da CPU:

1. Endereço de entrada: O Program Counter envia o endereço da próxima instrução a ser buscada.
2. Leitura síncrona: Na borda de subida do clock, com o sinal de leitura (`leitura = '1'`) ativo, a memória acessa internamente o vetor `mem` no índice indicado pelo endereço.
3. Saída da instrução: O valor de 16 bits armazenado naquela posição é disponibilizado na saída `saida_dado`.
4. Decodificação: Esse valor vai direto para o Decodificador, que interpreta os bits e aciona os controles corretos para toda a CPU.

> **Dica de visualização:** Imagine a Memória de Instruções como uma tabela de duas colunas — endereço à esquerda, código binário à direita. Isso torna imediatamente claro que "software nada mais é do que números guardados em uma tabela física dentro do chip."

***

### Características

* Armazena um vetor de instruções de 16 bits cada
* Tamanho configurável via `generic`: `bits_endereco` bits de endereço, `bits_dado` bits de dado, `numero_posicoes` posições
* Somente leitura durante a execução (comportamento de ROM)
* Leitura síncrona: responde na borda de subida do clock com `leitura = '1'`
* O programa é definido diretamente no código VHDL como um sinal inicializado

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity implementacao_memoria_instrucoes is
  generic (
    bits_endereco   : natural := 8;    
    bits_dado       : natural := 16;   
    numero_posicoes : natural := 256   
  );
  port (
    endereco     : in  std_logic_vector(bits_endereco-1 downto 0);
    clock        : in  std_logic;
    leitura      : in  std_logic;
    saida_dado   : out std_logic_vector(bits_dado-1 downto 0)
  );
end implementacao_memoria_instrucoes

architecture comportamento of implementacao_memoria_instrucoes is
  type memoria_instrucoes is array(numero_posicoes-1 downto 0) of std_logic_vector(bits_dado-1 downto 0);

  -- Programa gravado na ROM:
  signal memoria : memoria_instrucoes := (
    0 => x"0001",  -- instrução 0
    1 => x"0013",  -- instrução 1
    2 => x"0003",  -- instrução 2
    3 => x"0004",  -- instrução 3
    4 => x"0005",  -- instrução 4
    others => x"0000"  -- NOP (sem operação)
  );
begin
  process(clock)
  begin
    if rising_edge(clock) then
      if leitura = '1' then
        saida_dado <= memoria(to_integer(unsigned(endereco)));
      end if;
    end if;
  end process;
end comportamento;
```

***

### Conexão com outros módulos

A Memória de Instruções recebe o endereço diretamente do PC. Sua saída — a instrução de 16 bits — vai para o Decodificador, que vai separar o `opcode` dos campos de registrador e acionar todos os sinais de controle necessários. Sem a Memória de Instruções, o hardware saberia calcular, mas não saberia o que, quando ou com quais dados calcular.

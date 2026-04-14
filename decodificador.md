---
description: Descrição completa do decodificador
---

# Decodificador

> Transfoma bits em ações.

O Decodificador não realiza cálculos por conta própria. Sua função é ler a instrução que veio da Memória de Instruções, entender o que ela manda fazer e acionar os sinais de controle corretos em todos os outros módulos para que a operação aconteça de forma coordenada.

É o Decodificador que transforma um número binário como `0001 010 011 001 000` em ações concretas: "leia o Reg2, leia o Reg3, mande a ULA somar, salve o resultado no Reg1."

***

### O ciclo de execução

Toda instrução da CPU passa por quatro etapas, e o Decodificador participa ativamente de três delas:

1. Fetch (Busca): O Program Counter envia um endereço para a Memória de Instruções, que devolve a instrução de 16 bits daquela posição.
2. Decode (Decodificação): O Decodificador recebe os 16 bits. Os primeiros formam o `opcode` (código da operação); os demais carregam endereços de registradores e valores imediatos.
3. Execute (Execução): Com base no `opcode`, o Decodificador ativa os sinais corretos — `ula_op`, `reg_WE`, `mem_WE`, `mux_sel`, `jump`.
4. Writeback (Escrita): Se a instrução produz um resultado, o sinal `reg_WE` autoriza que ele seja salvo no registrador de destino.

***

### Sinais de controle gerados

| Sinal     | Destino                | Função                                        |
| --------- | ---------------------- | --------------------------------------------- |
| `ula_op`  | ULA                    | Define a operação a executar (soma, AND, …)   |
| `reg_WE`  | Banco de Registradores | Autoriza escrita no registrador de destino    |
| `mem_WE`  | Memória de Dados       | Autoriza escrita na RAM (instrução `store`)   |
| `mux_sel` | MUX de writeback       | Escolhe entre resultado da ULA ou dado da RAM |
| `jump`    | Program Counter        | Sinaliza desvio para novo endereço            |

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity decodificador is
  port (
    instrucao : in  std_logic_vector(15 downto 0);
    sel_A     : out std_logic_vector(2 downto 0);
    sel_B     : out std_logic_vector(2 downto 0);
    sel_W     : out std_logic_vector(2 downto 0);
    ula_op    : out std_logic_vector(2 downto 0);
    reg_WE    : out std_logic;
    mem_WE    : out std_logic;
    mux_sel   : out std_logic;
    jump      : out std_logic
  );
end decodificador;

architecture behavior of decodificador is
  signal op : std_logic_vector(3 downto 0);
begin
  op     <= instrucao(15 downto 12);
  sel_A  <= instrucao(11 downto 9);
  sel_B  <= instrucao(8  downto 6);
  sel_W  <= instrucao(5  downto 3);

  process(op)
  begin
    -- valores padrão
    ula_op  <= "000";
    reg_WE  <= '0';
    mem_WE  <= '0';
    mux_sel <= '0';
    jump    <= '0';

    case op is
      when "0001" => ula_op <= "000"; reg_WE <= '1';              -- ADD
      when "0010" => ula_op <= "001"; reg_WE <= '1';              -- SUB
      when "0011" => ula_op <= "010"; reg_WE <= '1';              -- AND
      when "0100" => ula_op <= "011"; reg_WE <= '1';              -- OR
      when "0101" => ula_op <= "100"; reg_WE <= '1';              -- NOT
      when "0110" => mux_sel <= '1';  reg_WE <= '1';              -- LOAD
      when "0111" => mem_WE  <= '1';                              -- STORE
      when "1000" => jump    <= '1';                              -- JUMP
      when others => null;
    end case;
  end process;
end behavior;
```

> **Dica de simulação:** No GTKWave, adicione todos os sinais de controle e execute uma sequência de instruções variadas. Você verá os sinais mudando a cada ciclo como um painel de controle, refletindo fielmente o `opcode` de cada instrução.

***

### Conexão com outros módulos

O Decodificador está no centro de tudo. Ele recebe instruções da Memória de Instruções, comanda a ULA via `ula_op`, autoriza escritas no Banco de Registradores via `reg_WE`, controla o MUX via `mux_sel`, acessa a Memória de Dados via `mem_WE` e direciona o Program Counter em caso de salto via `jump`.

---
icon: arrows-split-up-and-left
---

# Multiplexador

> O interruptor de trilhos do caminho de dados.

O Multiplexador (MUX) é um dos componentes mais simples e ao mesmo tempo mais essenciais da CPU. Ele tem múltiplas entradas de dados, mas apenas uma saída — e um sinal de seleção (`sel`) determina qual das entradas será conectada à saída em um dado momento.

O MUX não realiza nenhum cálculo: ele apenas roteia sinais. Mas sem ele, a CPU não conseguiria reutilizar os mesmos fios para transportar tipos diferentes de dados dependendo da instrução atual.

***

### Como funciona

1. Entradas de dados: O MUX recebe dois (ou mais) sinais de 16 bits. Por exemplo, `entrada_0` pode ser o resultado da ULA e `entrada_1` pode ser um dado lido da Memória de Dados.
2. Sinal de seleção (`sel`): Um bit de controle gerado pelo Decodificador indica qual das entradas deve passar para a saída.
3. Saída: Apenas a entrada selecionada aparece na saída. As outras são bloqueadas.

> **Analogia:** O MUX é como uma bifurcação ferroviária com uma alavanca. Dois trens chegam por trilhos diferentes, mas apenas um pode seguir em frente — e quem puxa a alavanca é o Decodificador.

***

### Onde o MUX aparece na CPU

O MUX é instanciado em vários pontos do caminho de dados, cada um com uma função diferente:

MUX de Writeback Decide qual valor será gravado no Banco de Registradores ao final de uma instrução.

* `sel = 0` → resultado da ULA (instrução aritmética ou lógica)
* `sel = 1` → dado lido da Memória de Dados (instrução `load`)

MUX do Program Counter Decide para onde o PC vai avançar.

* `sel = 0` → `PC + 1` (próxima instrução sequencial)
* `sel = 1` → endereço de salto (instrução `jump` ou `branch`)

MUX de Operando Imediato Decide qual valor será o segundo operando da ULA.

* `sel = 0` → valor lido de um registrador (`sel_B`)
* `sel = 1` → constante embutida na própria instrução (valor imediato)

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
  generic ( N : natural := 16 );
  port (
    entrada_0 : in  std_logic_vector(N-1 downto 0);
    entrada_1 : in  std_logic_vector(N-1 downto 0);
    sel       : in  std_logic;
    saida     : out std_logic_vector(N-1 downto 0)
  );
end mux2x1;

architecture comportamento of mux2x1 is
begin
  saida <= entrada_1 when sel = '1' else entrada_0;
end comportamento;
```

Note como o código VHDL de um MUX cabe em uma única linha de lógica: `when/else`. Isso ilustra bem a elegância da descrição de hardware — o que seria um parágrafo de código em software vira um fio com uma condição.

***

### Conexão com outros módulos

O MUX é instanciado diretamente no Top Level da CPU. No caso do MUX de writeback, ele fica entre a ULA e a Memória de Dados de um lado, e o Banco de Registradores do outro. O sinal de seleção `mux_sel` é sempre gerado pelo Decodificador de acordo com o tipo de instrução executada.

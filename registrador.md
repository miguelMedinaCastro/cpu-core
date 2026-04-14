# Registrador

> O elemento de memória mais simples e rápido de toda a CPU.

Um Registrador é construído a partir de um circuito chamado Flip-Flop tipo D, que tem a capacidade de "congelar" e armazenar um único bit de informação enquanto houver energia. Em uma CPU de 16 bits, cada registrador agrupa 16 desses Flip-Flops em paralelo, formando uma "caixa" capaz de guardar um número inteiro de 16 bits.

A grande vantagem do registrador é a sua velocidade: diferente da memória RAM, que leva vários ciclos de clock para responder, o registrador está dentro do próprio chip da CPU e responde em uma fração de nanossegundo.

***

### Como funciona

O registrador opera de forma sincronizada com o clock da CPU — o pulso constante que cadencia todas as operações do processador.

1. Entrada de dado&#x73;**:** O valor a ser armazenado chega pela porta `D` (Data), um vetor de 16 bits.
2. Sinal de escrita (`escrita_ativada`): Se esse sinal estiver em `1`, o registrador está "desbloqueado" para receber um novo valor.
3. Borda de subida do clock: No instante exato em que o clock sobe de `0` para `1`, o Flip-Flop captura e congela o valor que estava na entrada `D`.
4. Saída (`Q`): O valor congelado fica disponível continuamente na saída `Q`, podendo ser lido a qualquer momento por outros componentes.

> **Analogia:** Pense no registrador como uma lousa com um botão de "salvar". Enquanto o botão não é pressionado, qualquer valor pode chegar pela entrada sem ser registrado. No momento em que o clock pulsa com `escrita_ativada = 1`, o valor é fotografado e guardado até o próximo salvamento.

***

### Características

* Armazena 16 bits (`std_logic_vector(15 downto 0)`)
* Síncrono: só atualiza seu valor na borda de subida do clock
* Controlado pelo sinal `escrita_ativada`: protege o dado contra sobrescrita acidental
* Leitura assíncrona: a saída `Q` está sempre disponível, sem precisar de clock
* Parametrizável via `generic`: o mesmo código cria registradores de 4, 8, 32 bits

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity registrador is
  generic (
    bits_registrador : natural := 16
  );
  port (
    clock          : in  std_logic;
    escrita_ativa  : in  std_logic;
    D              : in  std_logic_vector(bits_registrador-1 downto 0);
    Q              : out std_logic_vector(bits_registrador-1 downto 0)
  );
end registrador;

architecture comportamento of registrador is
begin
  process(clock)
  begin
    if rising_edge(clock) then
      if escrita_ativada = '1' then
        Q <= D;
      end if;
    end if;
  end process;
end comportamento;
```

***

### Conexão com outros módulos

O Registrador é a unidade básica que compõe o Banco de Registradores. Individualmente, ele também está presente no Program Counter (PC) — que é um registrador especial que guarda o endereço da próxima instrução. A Unidade de Controle é quem decide quando ativar o sinal `escrita_ativada`, protegendo o valor guardado de ser sobrescrito no momento errado.

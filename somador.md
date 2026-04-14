---
description: Descrição completa do Full Adder da CPU 16 bits
icon: plus
---

# Somador

> O módulo fundamental de toda operação aritmética da CPU.

O somador é o circuito responsável por somar bits individualmente, levando em conta o transporte vindo da posição anterior. O somador resolve o problema real da soma binária: ele recebe três entradas e produz duas saídas.

Combinando 16 somadores em cadeia, construímos o `somadorNbits` — a espinha dorsal da nossa ULA.

***

### A unidade básica: `somador`

O primeiro passo é definir a menor unidade de soma. Este circuito recebe dois bits (`A` e `B`) e um bit de transporte de entrada (`Cin`), e produz:

* `Saida`**:** o resultado da soma dos três bits (lógica de paridade — XOR)
* `Cout`**:** o transporte para a próxima posição (lógica de maioria — AND/OR)

#### Tabela verdade

| A | B | Cin | Saida | Cout |
| - | - | --- | ----- | ---- |
| 0 | 0 | 0   | 0     | 0    |
| 0 | 0 | 1   | 1     | 0    |
| 0 | 1 | 0   | 1     | 0    |
| 0 | 1 | 1   | 0     | 1    |
| 1 | 0 | 0   | 1     | 0    |
| 1 | 0 | 1   | 0     | 1    |
| 1 | 1 | 0   | 0     | 1    |
| 1 | 1 | 1   | 1     | 1    |

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity somador is
  port (
    A, B, Cin : in  std_logic;
    Saida     : out std_logic;
    Cout      : out std_logic
  );
end somador;

architecture behavior of somador is
begin
  -- Cálculo do bit de resultado (Paridade)
  Saida <= A xor B xor Cin;

  -- Lógica de Maioria para o transporte (se dois ou mais forem '1', o Carry é '1')
  Cout  <= (A and B) or (A and Cin) or (B and Cin);
end behavior;
```

***

### A escalabilidade: `somadorNbits`

Uma CPU de 16 bits não pode somar apenas um bit por vez. Precisamos de uma "corrente" de somadores. É aqui que o VHDL brilha com o uso de `generic` e `generate`.

O `somadorNbits` usa um parâmetro `N` que permite criar um somador de 4, 8, 16 ou até 64 bits apenas mudando um número — sem reescrever o código.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity somadorNbits is
  generic (
    tamanho_dos_vetores : natural := 16
  );
  port (
    A, B  : in  std_logic_vector(tamanho_dos_vetores-1 downto 0);
    Cin   : in  std_logic;
    Saida : out std_logic_vector(tamanho_dos_vetores-1 downto 0);
    Cout  : out std_logic
  );
end somadorNbits;

architecture comportamentoNbits of somadorNbits is
  signal cin_interno : std_logic_vector(tamanho_dos_vetores downto 0);
begin
  cin_interno(0) <= Cin;

  ADDER_GEN : for i in 0 to tamanho_dos_vetores-1 generate
    FA : entity work.somador
      port map (
        A     => A(i),
        B     => B(i),
        Cin   => cin_interno(i),
        Saida => Saida(i),
        Cout  => cin_interno(i+1)
      );
  end generate;

  Cout <= cin_interno(tamanho_dos_vetores);
end comportamentoNbits;
```

***

### Como funciona a conexão em cascata

Para que a soma de números grandes funcione, o "vai um" de um bit deve ser passado para o próximo. No código, isso é feito através do sinal `cin_interno`:

* `cin_interno(0)`**:** Recebe o transporte inicial (normalmente `0`; `1` para subtração em complemento de dois).
* O laço `ADDER_GEN`: Funciona como uma "impressora 3D" de hardware — ele instancia `N` cópias do `somador` básico e as conecta em série.
* Conexão de carry: O `Cout` do somador `i` é conectado diretamente ao `Cin` do somador `i + 1`.

> **Dica de simulação:** Ao rodar no GTKWave, observe o sinal `cin_interno` bit a bit. Você verá o "vai um" se propagando da posição `0` até a posição `15`, como uma onda passando por cada somador da corrente.

***

### Conexão com outros módulos

O `somadorNbits` com `N := 16` é instanciado diretamente dentro da ULA para realizar operações de soma. Para a subtração, a Unidade de Controle inverte os bits do operando `B` (porta NOT) e aciona o `Cin` inicial com `1`, realizando o complemento de dois sem nenhum circuito adicional.

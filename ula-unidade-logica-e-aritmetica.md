---
icon: microchip
---

# ULA - Unidade Lógica e Aritmética

> O motor de processamento da CPU.

A ULA é o componente que executa, de fato, todas as contas e comparações que um programa solicita. Se a Unidade de Controle é o maestro que diz o que fazer, a ULA é onde o trabalho realmente acontece.

Ela recebe dois operandos de 16 bits — vindos do Banco de Registradores — e um código de operação (`op`) que define o que deve ser feito naquele ciclo. O resultado é enviado de volta pelo caminho de dados, e "incluir flags no futuro".

***

### Operações suportadas

#### Aritméticas

* Soma (`op = "000"`): Usa o `somadorNbits` com `Cin = 0`.
* Subtração (`op = "001"`): Usa o `somadorNbits` com os bits de `B` invertidos e `Cin = 1` — o equivalente ao complemento de dois, sem hardware extra.

#### Lógicas (bit a bit)

* AND (`op = "010"`): Resultado é `1` apenas onde ambos os bits correspondentes são `1`.
* OR (`op = "011"`): Resultado é `1` onde pelo menos um dos bits é `1`.
* NOT (`op = "100"`): Inverte todos os 16 bits do operando `A`.
* XOR (`op = "101"`): Resultado é `1` onde os bits são diferentes.

#### Flags de saída

| Flag         | Ativada quando...              | Uso típico                   |
| ------------ | ------------------------------ | ---------------------------- |
| Zero (Z)     | O resultado é `0x0000`         | Desvio condicional `if == 0` |
| Negativo (N) | O bit mais significativo é `1` | Comparações com sinal        |
| Carry (C)    | Há transporte além do bit 15   | Overflow sem sinal           |

***

### Código VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_1bit is
  generic ( 
    bits_necessarios : natural
  );
  port (
    A, B, Cin : in std_logic;
    op_code   : in std_logic_vector(bits_necessarios - 1 downto 0);
    Saida     : out std_logic;
    Cout      : out std_logic
  );
end entity;

architecture comportamento of ula_1bit is

  signal fio_and : std_logic;
  signal fio_or  : std_logic;
  signal fio_not : std_logic;

  signal AxB             : std_logic;
  signal fio_full_adder  : std_logic;
  signal cout_full_adder : std_logic;

  signal B_seletivo : std_logic;

begin

  fio_and <= A and B;
  fio_or  <= A or B;
  fio_not <= not A;

  B_seletivo <= (not B) when (op_code = "001") else B;
  AxB        <= A xor B_seletivo;

  fio_full_adder  <= AxB xor Cin;
  cout_full_adder <= (AxB and Cin) or (A and B_seletivo);

  Saida <= fio_full_adder when (op_code = "000" or op_code = "001") else
    fio_and when (op_code = "010") else
    fio_or when (op_code = "011") else
    fio_not when (op_code = "100") else
    '0';

  Cout <= cout_full_adder when (op_code = "000" or op_code = "001") else
    '0';

end architecture;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_Nbits is
  generic (
    bits         : natural := 4;
    bits_op_code : natural := 3
  );
  port (
    A, B    : in std_logic_vector(bits - 1 downto 0);
    Cin     : in std_logic;
    op_code : in std_logic_vector(bits_op_code - 1 downto 0);
    Saida   : out std_logic_vector(bits - 1 downto 0);
    Cout    : out std_logic
  );
end entity ula_Nbits;

architecture behavior of ula_Nbits is

  signal carries : std_logic_vector(bits downto 0);

begin

  carries(0) <= '1' when (op_code = "001") else Cin;

  ULA : for i in 0 to bits - 1 generate
    ULA_i : entity work.ula_1bit
      generic map(
        bitsOperations => bits_op_code
      )
      port map
      (
        A       => A(i),
        B       => B(i),
        Cin     => carries(i),
        op_code => op_code,
        Saida   => Saida(i),
        Cout    => carries(i + 1)
      );
  end generate;

  Cout <= carries(bits);
end architecture;

```

> **Analogia:** Pense na ULA como uma calculadora científica com vários modos. O `op` é como apertar `+`, `-` ou `AND`. Os operandos `A` e `B` são os números digitados. As Flags são os indicadores de "resultado negativo", "resultado zero" ou "overflow" que aparecem no visor.

***

### Conexão com outros módulos

A ULA recebe os operandos `A` e `B` do **Banco de Registradores** e o sinal `op` do **Decodificador**. O resultado segue para o **MUX de writeback**, que decide se ele vai diretamente ao Banco de Registradores ou espera pela memória. As Flags (`Z`, `N`, `C`) retornam ao **Decodificador**, que as usa para decidir se deve ou não executar um desvio condicional (`branch`).

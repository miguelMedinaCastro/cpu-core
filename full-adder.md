---
description: Descrição completa do Full Adder da CPU 16 bits
icon: plus
---

# Full Adder

Para que uma CPU realize cálculos, ela precisa de um componente capaz de somar bits individualmente, levando em conta o transporte de operações anteriores. Esse componente é o Full Adder.

#### 1. A Unidade Básica: `somador`

O primeiro passo é definir a unidade mínima de soma. Este circuito recebe dois bits (_**A**_ e _**B**_) e um bit de transporte de entrada Carry in(_**Cin**_).

<figure><img src=".gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

***

#### 2. A Escalabilidade: `somadorNbits`

Uma CPU de 16 bits não pode somar apenas um bit por vez. Precisamos de uma "corrente" de somadores. É aqui que o VHDL brilha com o uso de Generics e Generate Statements.

O  `somadorNbits` é um código flexível. Ele usa um parâmetro `N` que permite que esse mesmo código crie um somador de 4, 8, 16 ou até 64 bits apenas mudando um número.

<figure><img src=".gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

**Como funciona a conexão em cascata:**

Para que a soma de números grandes funcione, o "vai um" de um bit deve ser passado para o próximo. No código, isso é feito através do sinal `cin_interno`.

* `cin_interno(0)`: Recebe o transporte inicial (geralmente zero).
* O Laço `ADDER_GEN`: Este trecho do código é como uma "impressora 3D" de hardware. Ele instancia (cria) `N` cópias do seu `somador` básico e as conecta em série.
* Conexão de Carry: O `Cout` do somador `i` é conectado diretamente ao `Cin` do somador `i + 1`.

<figure><img src=".gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

***

#### 3. Visualizando o Fluxo de Dados

Ao simular esse código com ferramentas como GHDL e GTKWave, você verá o sinal de transporte "viajando" através da cadeia de somadores.

***

No contexto da nossa CPU de 16 bits, este componente será instanciado com `N := 16`, formando a espinha dorsal da nossa ULA (Unidade Lógica e Aritmética). É essa estrutura que permite ao computador entender que 1 + 1 não é apenas 0, mas sim 0 com "vai um" para a próxima casa decimal binária.



### Código completo

<figure><img src=".gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

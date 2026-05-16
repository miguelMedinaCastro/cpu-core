<h1 align="center">Bem-vindo à CPU Didática!</h1>

## Visão Geral

Neste tutorial, você irá aprender desde os primeiros passos em VHDL até a Simulação e Prototipação em FPGA de uma CPU de 16 bits completa.O objetivo deste projeto é servir como uma porta de entrada para o estudo de arquitetura e organização de computadores, permitindo que qualquer pessoa consiga acompanhar mesmo com pouca experiência prévia.

Este tutorial é voltado para estudantes que querem entender como uma CPU funciona na prática.

Ao final deste tutorial, você será capaz de:

- Entender os componentes principais de uma CPU;
- Ler e interpretar código VHDL;
- Descrever e simular circuitos digitais.

---

## Antes de começar

Para que você consiga simular a nossa CPU e entender as formas de onda de simulação, você precisará preparar o seu ambiente.

### Conhecimentos prévios

- Familiaridade básica com terminal (linha de comando).

### Ferramentas e Softwares necessários

- **GHDL:**  Simulador de código aberto para a linguagem VHDL;
- **GTKWave:**  Visualizador de formas de onda para visualizar os sinais da CPU no tempo;
- **Git:** Ferramenta para baixar o código do nosso repositório oficial;
- Editor de código de sua preferência, nesse tutorial será utilizado Visual Studio Code.

---

# Fundamentos

## O que é uma CPU?

A CPU (Unidade Central de Processamento) é popularmente conhecida como o “cérebro” de qualquer dispositivo eletrônico, desde o seu smartphone até o seu computador. É ela a responsável por ler instruções da memória e executar todos os cálculos e comandos necessários para que os programas funcionem.

Para que a CPU funcione, ela é dividida em blocos menores, sendo os principais:

- *ULA (Unidade Lógica e Aritmética)*: É o bloco responsável por fazer somas, subtrações e comparações entre os bits.
- *Registradores*: Pequenas memórias ultrarrápidas que guardam os operandos usados nas operações feitas pela ULA.
- *Unidade de Controle*: O “maestro” que organiza tudo. Ele lê a instrução e diz para a ULA e para os Registradores o que eles devem fazer no momento exato.

---

## Introdução ao VHDL

Para compreender o VHDL (*VHSIC Hardware Description Language*), é preciso primeiro desaprender o conceito tradicional de programação.

Em linguagens como Python, JavaScript ou Java, você desenvolve Software. Este software é um conjunto de instruções lógicas que um processador (hardware pré-existente) executa de forma sequencial, uma após a outra. O foco aqui é o algoritmo.

O VHDL não é uma linguagem de programação, mas sim uma Linguagem de Descrição de Hardware. Ao escrever em VHDL, você não está ditando o que um processador deve “fazer”, mas sim descrevendo o que o hardware é.

Todo código em VHDL possui uma estrutura básica dividida em duas partes principais: `Entity` e `Architecture`.

A `Entity` representa a interface do componente. Ela define o nome do módulo e quais sinais entram e saem do circuito. Em outras palavras, a Entity descreve como outros componentes podem se comunicar com aquele hardware. É nela que declaramos as portas de entrada (`in`) e saída (`out`) do circuito.

Já a `Architecture` descreve o funcionamento interno do componente. Nela são implementadas as operações lógicas, conexões internas e comportamentos do circuito. Enquanto a Entity mostra “o que entra e o que sai”, a Architecture mostra “como o circuito funciona internamente”.

As portas (`ports`) representam os pontos de comunicação entre o circuito e o ambiente externo. Uma porta do tipo `in` recebe dados, enquanto uma porta do tipo `out` envia dados para outros módulos. Existe também o tipo `inout`, utilizado quando um sinal pode funcionar tanto como entrada quanto como saída.

Outro conceito importante são os `signals`. Os signals funcionam como fios internos do circuito, sendo responsáveis por transportar sinais entre diferentes partes da arquitetura. Eles permitem criar conexões internas entre componentes e armazenar temporariamente valores lógicos durante a simulação.

O VHDL também utiliza estruturas chamadas `process`. Um process é utilizado para descrever comportamentos sequenciais, principalmente em circuitos sincronizados por clock, como registradores e máquinas de estado. Dentro de um process, as instruções são executadas em sequência sempre que ocorre um evento específico, como a borda de subida do clock.

Por exemplo, em um registrador, o process normalmente espera a subida do clock para copiar um valor da entrada para a saída. Esse comportamento representa exatamente o funcionamento físico de flip-flops utilizados em circuitos digitais.

Abaixo está um exemplo simples da estrutura básica de um módulo em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity exemplo is
    port (
        A : in std_logic;
        B : in std_logic;
        S : out std_logic
    );
end exemplo;

architecture comportamento of exemplo is
begin
    S <= A and B;
end comportamento;
```

Nesse exemplo, a `Entity` define duas entradas (`A` e `B`) e uma saída (`S`). Já a `Architecture` implementa uma porta lógica AND, fazendo com que a saída `S` receba o resultado lógico entre `A` e `B`.

Além disso, o VHDL utiliza estruturas chamadas `process`. Um process é utilizado para descrever comportamentos sequenciais dentro do hardware, principalmente em circuitos sincronizados por clock, como registradores, contadores e máquinas de estado.

Enquanto boa parte do VHDL funciona de forma concorrente, as instruções dentro de um process são executadas em sequência sempre que ocorre um evento específico. Esse evento normalmente é definido através de sinais de controle, como o clock.

Um exemplo muito comum é o uso do process para representar registradores. Nesse caso, o circuito espera a borda de subida do clock (`rising_edge(clock)`) para armazenar um novo valor. Isso simula exatamente o comportamento físico dos flip-flops utilizados em hardware digital.

Abaixo está um exemplo simples da estrutura básica de um módulo em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity exemplo is
    port (
        clock : in std_logic;
        A : in std_logic;
        B : in std_logic;
        S : out std_logic
    );
end exemplo;

architecture comportamento of exemplo is
begin

    process(clock)
    begin
        if rising_edge(clock) then
            S <= A and B;
        end if;
    end process;

end comportamento;
```

Nesse exemplo, a `Entity` define as entradas e saídas do circuito. Já a `Architecture` implementa a lógica interna do componente.

O `process(clock)` indica que o bloco será executado sempre que houver alteração no sinal de clock. A instrução `rising_edge(clock)` verifica especificamente a borda de subida do clock, momento em que a saída `S` recebe o resultado lógico da operação AND entre `A` e `B`.

---

## CPU alvo

A CPU desenvolvida neste projeto é uma arquitetura didática de 16 bits criada com o objetivo de demonstrar os principais conceitos envolvidos no funcionamento interno de um processador. Ela foi construída utilizando VHDL e organizada em módulos independentes, permitindo compreender separadamente cada parte da arquitetura e como elas trabalham em conjunto.

A CPU segue uma organização baseada em registradores, possuindo uma Unidade Lógica e Aritmética (ULA), Banco de Registradores, Memória de Instruções, Memória de Dados, Decodificador, Multiplexadores (MUX) e um Program Counter (PC). Todos esses componentes se comunicam através do datapath da CPU.

## Conjunto e Formato de Instruções

As instruções da CPU possuem tamanho fixo de 16 bits. Cada instrução é dividida em campos responsáveis por definir a operação que será executada e quais registradores serão utilizados.

O formato geral das instruções é organizado da seguinte forma:

```
[ OPCODE ][ REG_A ][ REG_B ][ REG_DEST ]
 4 bits     3 bits   3 bits    3 bits
```

O campo `OPCODE` identifica qual operação será realizada pela CPU. Já os campos de registradores indicam quais operandos devem ser lidos e onde o resultado será armazenado.

A CPU suporta instruções aritméticas, lógicas, acesso à memória e desvios.

## Instruções suportadas

| Opcode | Instrução | Descrição |
| --- | --- | --- |
| 0001 | ADD | Soma dois registradores |
| 0010 | SUB | Subtração |
| 0011 | AND | Operação lógica AND |
| 0100 | OR | Operação lógica OR |
| 0101 | NOT | Inversão lógica |
| 0110 | LOAD | Carrega dado da memória |
| 0111 | STORE | Armazena dado na memória |
| 1000 | JUMP | Realiza salto |

As operações aritméticas e lógicas são executadas pela ULA, enquanto as instruções `LOAD` e `STORE` utilizam a Memória de Dados.

## Estrutura do Datapath

O datapath representa o caminho percorrido pelos dados dentro da CPU. Ele conecta todos os módulos responsáveis pelo processamento das instruções.

O funcionamento da CPU ocorre em etapas:

### 1. Busca da instrução (Fetch)

O Program Counter (PC) envia um endereço para a Memória de Instruções. A memória então devolve a instrução de 16 bits armazenada naquela posição.

### 2. Decodificação (Decode)

A instrução é enviada ao Decodificador. O Decodificador separa os campos da instrução e interpreta o opcode, gerando sinais de controle para toda a CPU.

Esses sinais determinam qual operação a ULA deve executar, quais registradores receberá o resultado, se haverá escrita na memória e se ocorrerá um salto.

### 3. Execução (Execute)

O Banco de Registradores fornece os operandos para a ULA. A ULA executa a operação indicada pelo Decodificador.

Dependendo da instrução, o resultado pode voltar ao Banco de Registradores, ser enviado para a Memória de Dados e alterar o Program Counter (PC).

### 4. Writeback

O resultado final é armazenado no registrador de destino através do caminho de writeback controlado pelo MUX.

---

## Conexões dos Blocos

Os principais módulos da CPU se conectam da seguinte forma:

- O Program Counter envia endereços para a Memória de Instruções;
- A Memória de Instruções envia instruções para o Decodificador;
- O Decodificador controla:
    - Banco de Registradores;
    - ULA;
    - Memória RAM;
    - Multiplexadores;
    - Program Counter;
- O Banco de Registradores fornece operandos para a ULA;
- A ULA envia resultados para:
    - Banco de Registradores;
    - Memória RAM;
    - Lógica de desvios;
- O MUX seleciona qual dado será escrito de volta nos registradores.

Essa organização representa uma arquitetura simples de datapath utilizada em CPUs reais.

---

## Linguagem Assembly da CPU

A CPU utiliza uma linguagem Assembly simples e didática, baseada diretamente nas instruções suportadas pelo hardware.

Cada instrução Assembly corresponde diretamente a um opcode executado pela CPU.

### Exemplos de instruções

#### Soma

```nasm
ADD R1, R2, R3
```

Realiza:

```nasm
R1 = R2 + R3
```

---

#### Subtração

```nasm
SUB R1, R2, R3
```

Realiza:

```nasm
R1 = R2 - R3
```

---

#### Operação lógica AND

```nasm
AND R1, R2, R3
```

Realiza:

```nasm
R1 = R2 AND R3
```

---

#### Carregamento da memória

```nasm
LOAD R1, [R2]
```

Carrega para `R1` o valor armazenado no endereço apontado por `R2`.

---

#### Escrita na memória

```nasm
STORE R1, [R2]
```

Armazena na memória o valor de `R1` no endereço apontado por `R2`.

---

#### Salto

```nasm
JUMP endereco
```

Altera o Program Counter para um novo endereço de instrução.

---

A linguagem Assembly permite observar diretamente como o software conversa com o hardware da CPU. Cada instrução escrita em Assembly é convertida em uma sequência binária que será interpretada pelo Decodificador e executada pelos módulos internos do processador.

## Preparando o Ambiente

Como o VHDL descreve o hardware, não podemos simplesmente executá-lo com
um duplo clique como fazemos com um programa comum. Precisamos de
ferramentas específicas para compilar o código, simular o tempo passando e
visualizar a energia (os sinais lógicos) fluindo pelos fios virtuais.

Abaixo, você vai conhecer o trio de ferramentas que usaremos neste projeto e
como preparar o seu ambiente de desenvolvimento.

### GHDL

O GHDL é um simulador de código aberto para a linguagem VHDL. O trabalho dele
é ler todos os nossos arquivos de texto (onde descrevemos as portas lógicas e
conexões), verificar se a sintaxe está correta e criar um modelo executável da
nossa CPU.

É ele quem faz a "matemática" nos bastidores, calculando em que momento cada
sinal elétrico muda de 0 para 1.

### GTKWAVE

Quando o GHDL termina a simulação, ele cospe um arquivo cheio de dados de
tempo e sinais elétricos (geralmente com a extensão .vcd ou .ghw ). Ler isso em
formato de texto é impossível para um ser humano. É aí que entra o GTKWave.

Ele é um visualizador de formas de onda (waveforms). Com ele, você consegue ver
gráficos coloridos mostrando exatamente o que estava acontecendo dentro de
cada registrador e de cada porta lógica em qualquer milissegundo da simulação.

### Makefile

Para rodar o GHDL, compilar cada arquivo individualmente e depois abrir o
GTKWave, você teria que digitar vários comandos longos e chatos no terminal toda
vez que fizesse uma pequena alteração no código.

O Makefile (usado pela ferramenta make ) serve para automatizar isso. Nós já
deixamos um arquivo chamado Makefile pronto na raiz do repositório com as
"receitas" de todos os comandos. Assim, com uma única palavra, você compila e
roda tudo.

### Instalação

No Linux/Ubuntu:

```bash
sudo apt update
sudo apt install ghdl gtkwave make git
```

Dica para usuários de Windows: Se você não usa Linux, a recomendação oficial
é instalar o WSL (Windows Subsystem for Linux) para rodar o Ubuntu dentro do
seu Windows. Depois de configurar o WSL, basta rodar o comando acima no
terminal dele. Você também precisará de um servidor X (como o VcXsrv) para
abrir a interface gráfica do GTKWave no Windows

---

### Clonando o Projeto

```bash
git clone https://github.com/miguelMedinaCastro/cpu-core.git
cd cpu-core
```

---

### Executando a Simulação

```bash
make
```

Caso o GTKWave não abra automaticamente:

```bash
gtkwave nome_do_arquivo_gerado.vcd
```

Pronto! Agora você tem um laboratório de eletrônica digital rodando no seu computador. Sinta-se à vontade para alterar os sinais nos arquivos detestbench (os arquivos que injetam sinais de teste na CPU) e rodar o `make`
novamente para ver o que acontece nos gráficos do GTKWave.

---

# Módulos

Agora que você já entende os fundamentos teóricos e configurou o seu ambiente
de simulação, é hora explorar nossa CPU de 16 bits.

Em VHDL, é uma excelente prática dividir o projeto em pequenos blocos
independentes — os módulos. Cada módulo tem uma responsabilidade bem
definida, pode ser testado isoladamente e se comunica com os outros através de
portas ( `port` ). Essa abordagem facilita o desenvolvimento, o teste e a
compreensão da arquitetura como um todo.

Abaixo estão os principais módulos que compõem a nossa CPU. Clique em
qualquer um para ver a descrição completa, o código VHDL e exemplos de
simulação.

## Decodificador e Multiplexador

O Decodificador é responsável por interpretar as instruções recebidas da Memória de Instruções. Ele analisa o opcode da instrução e gera os sinais de controle necessários para coordenar toda a CPU, definindo quais módulos devem ser ativados em cada ciclo. Através dele, a CPU sabe quando escrever em registradores, acessar memória, executar operações na ULA ou realizar desvios.

O Multiplexador (MUX) é um componente utilizado para selecionar entre diferentes entradas de dados. Ele funciona como uma chave eletrônica controlada pelo Decodificador. Dependendo da instrução executada, o MUX escolhe qual informação será encaminhada para a saída, permitindo compartilhar caminhos de dados entre diferentes operações da CPU.

## Somador e Subtrator

O Somador é o circuito responsável por realizar operações de soma binária entre operandos. Ele é construído a partir de Full Adders conectados em sequência, permitindo realizar operações com múltiplos bits. Além da soma, o circuito também propaga o sinal de carry (“vai um”) entre os bits.

A operação de subtração é implementada utilizando complemento de dois. Nesse método, os bits do segundo operando são invertidos e um carry inicial igual a `1` é aplicado ao somador. Dessa forma, a CPU consegue realizar subtrações sem a necessidade de um circuito separado exclusivamente para subtrair.

## Banco de Registradores

O Banco de Registradores é uma memória interna ultrarrápida utilizada para armazenar temporariamente dados durante a execução das instruções. Ele contém vários registradores acessados diretamente pela CPU para leitura e escrita de operandos.

Neste projeto, o Banco de Registradores possui múltiplas portas de leitura e uma porta de escrita, permitindo que a CPU leia dois operandos simultaneamente e armazene o resultado da operação em um registrador de destino ao final do ciclo.

## Memórias

A CPU utiliza dois tipos principais de memória: Memória de Instruções e Memória de Dados.

A Memória de Instruções funciona como uma ROM, armazenando o programa que será executado pela CPU. O Program Counter envia um endereço para essa memória, que devolve a instrução correspondente daquele local.

Já a Memória de Dados funciona como uma RAM, permitindo leitura e escrita durante a execução do programa. Ela é utilizada para armazenar variáveis, resultados intermediários e dados manipulados pelas instruções `LOAD` e `STORE`.

## Unidade Lógica e Aritmética

A Unidade Lógica e Aritmética (ULA) é o componente responsável por executar operações matemáticas e lógicas dentro da CPU. Ela recebe operandos vindos do Banco de Registradores e executa operações definidas pelo Decodificador.

Entre as operações suportadas estão soma, subtração, AND, OR, NOT e XOR. A ULA também gera sinais de status, conhecidos como flags, que indicam informações importantes sobre o resultado da operação, como resultado zero, valor negativo ou ocorrência de carry.

## Unidade de Controle

A Unidade de Controle é o componente responsável por coordenar o funcionamento geral da CPU. Ela interpreta as instruções recebidas, gera sinais de controle e sincroniza a comunicação entre os módulos internos do processador.

Seu papel é garantir que cada componente execute sua função no momento correto. A Unidade de Controle determina, por exemplo, quando a ULA deve operar, quando registradores devem ser escritos, quando a memória deve ser acessada e quando o Program Counter deve realizar um salto para outra instrução.

---

# Blocos

## Registrador

O registrador é um módulo utilizado para armazenar temporariamente dados dentro da CPU durante a execução das instruções. Ele funciona como uma pequena memória interna de alta velocidade, permitindo que informações importantes permaneçam rapidamente acessíveis ao processador.

Os registradores são utilizados constantemente pela CPU para guardar operandos, resultados de operações aritméticas, endereços de memória e valores intermediários necessários durante o processamento das instruções.

Diferente da memória RAM, que possui maior capacidade porém acesso mais lento, os registradores ficam diretamente integrados ao processador, permitindo leituras e escritas extremamente rápidas.

O funcionamento do registrador é controlado pelo clock da CPU. Em geral, ele recebe um valor através da entrada de dados (`D`) e armazena esse valor apenas quando o sinal de escrita está habilitado e ocorre a borda de subida do clock (`rising_edge(clock)`).

Depois que o valor é armazenado, ele permanece disponível na saída (`Q`) até que um novo dado seja escrito no registrador.

Os principais sinais de um registrador são:

- `clock`: sinal de sincronização da CPU;
- `escrita`: habilita o armazenamento de novos dados;
- `D`: entrada de dados;
- `Q`: saída contendo o valor armazenado.

Na arquitetura da CPU, os registradores são utilizados em diversos módulos, principalmente no Banco de Registradores, no Program Counter e em estruturas temporárias utilizadas pela ULA e pela Unidade de Controle.

Exemplo em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity registrador is
	generic (
		bits_registrador : natural := 16
	);
	port (
		clock         : in std_logic;
		escrita_ativa : in std_logic;
		D             : in std_logic_vector(bits_registrador-1 downto 0);
		Q             : out std_logic_vector(bits_registrador-1 downto 0)
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

## Testbench do Registrador

O Testbench (TB) é um módulo utilizado para testar e simular o funcionamento de componentes em VHDL. Ele não representa hardware físico da CPU, mas sim um ambiente de simulação responsável por verificar se o circuito está funcionando corretamente.

No caso do registrador, o Testbench permite gerar sinais de clock, alterar entradas e observar o comportamento da saída ao longo do tempo.

Durante a simulação, o TB envia diferentes valores para a entrada `D`, ativa o sinal de escrita e verifica se o registrador realmente armazena os dados na borda de subida do clock.

Um Testbench normalmente:

- Instancia o módulo que será testado;
- Gera sinais de entrada;
- Controla o clock;
- Simula diferentes cenários de funcionamento;
- Permite visualizar os resultados no simulador.

Exemplo de Testbench para o registrador:

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity registrador_tb is
end registrador_tb;

architecture simulacao of registrador_tb is

    signal clock   : std_logic := '0';
    signal escrita : std_logic := '0';
    signal D       : std_logic_vector(15 downto 0);
    signal Q       : std_logic_vector(15 downto 0);

begin

    uut: entity work.registrador
        port map (
            clock   => clock,
            escrita => escrita,
            D       => D,
            Q       => Q
        );

    clock_process : process
    begin

        while true loop
            clock <= '0';
            wait for 10 ns;

            clock <= '1';
            wait for 10 ns;
        end loop;

    end process;

    stim_process : process
    begin

        escrita <= '1';

        D <= "0000000000001010";
        wait for 20 ns;

        D <= "0000000000011111";
        wait for 20 ns;

        escrita <= '0';

        D <= "1111111111111111";
        wait for 20 ns;

        wait;

    end process;

end simulacao;
```

Nesse Testbench:

- O processo `clock_process` gera continuamente o sinal de clock;
- O processo `stim_process` envia diferentes valores para a entrada `D`;
- Quando `escrita = '1'`, o registrador armazena os dados;
- Quando `escrita = '0'`, o valor armazenado permanece inalterado.

Através da simulação é possível visualizar o comportamento do registrador e confirmar se o circuito está funcionando corretamente antes da implementação em hardware real.

## Conexão com outros módulos

O Registrador é a unidade básica que compõe o Banco de Registradores. Individualmente, ele também implementa registradores de controle como PC e IR. O Program Counter (PC), por exemplo, guarda o endereço da próxima instrução. A Unidade de Controle é quem decide quando ativar o sinal `escrita_ativada` , protegendo o valor guardado de ser sobrescrito no momento errado.

---

## Banco de Registradores

O Banco de Registradores é um conjunto de registradores organizados em um único módulo, com lógica de endereçamento que permite à CPU escolher exatamente qual registrador quer ler ou escrever a cada ciclo de clock.

Enquanto um registrador isolado armazena apenas um valor, o Banco de Registradores reúne vários deles (em geral 8 ou 16), funcionando como uma memória interna de acesso instantâneo para a ULA.

O Banco de Registradores é o ponto central do caminho de dados da CPU: é daqui que a ULA busca os operandos para realizar seus cálculos, e é aqui que os resultados são devolvidos após o processamento.

Ele possui duas portas de leitura e uma de escrita, todas operando de forma síncrona com o clock:

- `endereco_leitura_1` e `endereco_leitura_2`: indicam quais registradores serão lidos;
- `dado_saida_1` e `dado_saida_2`: entregam os valores lidos para a ULA;
- `endereco_escrita`: indica qual registrador receberá o resultado;
- `dado_entrada_i`: traz o valor a ser escrito;
- `escrita`: habilita a gravação no registrador selecionado.

Toda operação — tanto de leitura quanto de escrita — ocorre na borda de subida do clock, garantindo sincronismo com os demais módulos.

Exemplo em VHDL:

```vhdl
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
        endereco_leitura_1 : in  std_logic_vector(tamanho_endereco-1 downto 0);
        endereco_leitura_2 : in  std_logic_vector(tamanho_endereco-1 downto 0);
        endereco_escrita   : in  std_logic_vector(tamanho_endereco-1 downto 0);
        clock              : in  std_logic;
        escrita            : in  std_logic;
        dado_entrada_i     : in  std_logic_vector(tamanho_dado-1 downto 0);
        dado_saida_1       : out std_logic_vector(tamanho_dado-1 downto 0);
        dado_saida_2       : out std_logic_vector(tamanho_dado-1 downto 0)
    );
end banco_registradores;

architecture comportamento of banco_registradores is
    type vetor_registradores is array(quantidade_registros-1 downto 0)
        of std_logic_vector(tamanho_dado-1 downto 0);
    signal registradores : vetor_registradores;
begin
    process(clock)
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

## Testbench do Banco de Registradores

O Testbench do Banco de Registradores verifica se a escrita e a leitura em endereços diferentes funcionam corretamente e de forma independente. Ele escreve valores em registradores distintos e confirma que cada leitura retorna exatamente o valor esperado.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity banco_registradores_tb is
end banco_registradores_tb;

architecture simulacao of banco_registradores_tb is

    signal clock              : std_logic := '0';
    signal escrita            : std_logic := '0';
    signal endereco_leitura_1 : std_logic_vector(2 downto 0) := (others => '0');
    signal endereco_leitura_2 : std_logic_vector(2 downto 0) := (others => '0');
    signal endereco_escrita   : std_logic_vector(2 downto 0) := (others => '0');
    signal dado_entrada_i     : std_logic_vector(15 downto 0) := (others => '0');
    signal dado_saida_1       : std_logic_vector(15 downto 0);
    signal dado_saida_2       : std_logic_vector(15 downto 0);

begin

    uut: entity work.banco_registradores
        port map (
            clock              => clock,
            escrita            => escrita,
            endereco_leitura_1 => endereco_leitura_1,
            endereco_leitura_2 => endereco_leitura_2,
            endereco_escrita   => endereco_escrita,
            dado_entrada_i     => dado_entrada_i,
            dado_saida_1       => dado_saida_1,
            dado_saida_2       => dado_saida_2
        );

    clock_process : process
    begin
        while true loop
            clock <= '0'; wait for 10 ns;
            clock <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_process : process
    begin
        -- Escreve 0x000A no registrador 0
        escrita <= '1';
        endereco_escrita <= "000";
        dado_entrada_i   <= x"000A";
        wait for 20 ns;

        -- Escreve 0x001F no registrador 3
        endereco_escrita <= "011";
        dado_entrada_i   <= x"001F";
        wait for 20 ns;

        -- Lê os dois registradores simultaneamente
        escrita            <= '0';
        endereco_leitura_1 <= "000";
        endereco_leitura_2 <= "011";
        wait for 20 ns;

        -- Tenta escrever com escrita desabilitada (nada deve mudar)
        dado_entrada_i   <= x"FFFF";
        endereco_escrita <= "000";
        wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- O processo `clock_process` gera o sinal de clock continuamente;
- O processo `stim_process` escreve valores em registradores diferentes e depois os lê ao mesmo tempo pelas duas portas de leitura;
- Quando `escrita = '0'`, nenhum registrador é alterado, mesmo que haja um endereço e dado válidos na entrada.

## Conexão com outros módulos

O Banco de Registradores recebe ordens do Decodificador (quais registradores ler e escrever) e entrega os operandos diretamente para a ULA. O resultado calculado pela ULA retorna ao Banco de Registradores através do MUX de writeback, que decide se o valor a ser gravado vem da ULA ou da Memória de Dados (no caso de uma instrução de `load`).

---

## Somador

O somador é o circuito responsável por somar bits individualmente, levando em conta o transporte (carry) vindo da posição anterior. Ele recebe três entradas — dois bits (`A` e `B`) e um carry de entrada (`Cin`) — e produz duas saídas: o bit de resultado (`Saida`) e o carry de saída (`Cout`).

Sozinho, o Full Adder soma apenas 1 bit. Para somar números de 16 bits, 16 instâncias dele são encadeadas em série, formando o `somadorNbits`. O carry de saída de cada posição é passado como carry de entrada da posição seguinte — o mesmo mecanismo do "vai um" que usamos na soma manual.

O `somadorNbits` é parametrizável via `generic`: mudando apenas um número, o mesmo código gera somadores de 4, 8, 16 ou 32 bits. Isso é feito com o comando `generate` do VHDL, que instancia N cópias do Full Adder e as conecta em cascata automaticamente.

Esse módulo também é responsável pela subtração: basta inverter os bits de `B` e setar `Cin = '1'`, realizando o complemento de dois sem nenhum circuito adicional.

Exemplo em VHDL:

```vhdl
-- Full Adder de 1 bit
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
    Saida <= A xor B xor Cin;
    Cout  <= (A and B) or (A and Cin) or (B and Cin);
end behavior;

-- Somador de N bits encadeado
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

## Testbench do Somador

O Testbench do somador testa casos representativos: soma simples, soma com carry, overflow e subtração via complemento de dois.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity somadorNbits_tb is
end somadorNbits_tb;

architecture simulacao of somadorNbits_tb is

    signal A, B   : std_logic_vector(15 downto 0) := (others => '0');
    signal Cin    : std_logic := '0';
    signal Saida  : std_logic_vector(15 downto 0);
    signal Cout   : std_logic;

begin

    uut: entity work.somadorNbits
        generic map (tamanho_dos_vetores => 16)
        port map (A => A, B => B, Cin => Cin, Saida => Saida, Cout => Cout);

    stim_process : process
    begin
        -- Soma simples: 5 + 3 = 8
        A <= x"0005"; B <= x"0003"; Cin <= '0';
        wait for 20 ns;

        -- Soma com carry de entrada: 1 + 1 + 1 = 3
        A <= x"0001"; B <= x"0001"; Cin <= '1';
        wait for 20 ns;

        -- Overflow: 0xFFFF + 1 = 0x0000 com Cout = '1'
        A <= x"FFFF"; B <= x"0001"; Cin <= '0';
        wait for 20 ns;

        -- Subtração via complemento de dois: 9 - 3 = 6
        -- B recebe NOT(3) = 0xFFFC, Cin = '1'
        A <= x"0009"; B <= x"FFFC"; Cin <= '1';
        wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- O somador é combinacional, então não há clock — a saída muda imediatamente com os valores de entrada;
- Cada `wait for 20 ns` avança o tempo de simulação para observar os resultados no GTKWave;
- O caso de subtração demonstra como o complemento de dois elimina a necessidade de um circuito separado para subtrair.

## Conexão com outros módulos

O `somadorNbits` é instanciado diretamente dentro da ULA para realizar operações de soma e subtração. Para a subtração, a ULA inverte os bits do operando `B` e aciona o `Cin` inicial com `'1'`, realizando o complemento de dois sem nenhum hardware adicional.

---

## ULA - Unidade Lógica e Aritmética

A ULA é o componente que executa todas as operações aritméticas e lógicas que um programa solicita. Ela recebe dois operandos de 16 bits vindos do Banco de Registradores e um código de operação (`op_code`) vindo do Decodificador, e entrega o resultado de volta ao caminho de dados.

As operações suportadas pela ULA são:

| op_code | Operação | Descrição |
| --- | --- | --- |
| `"000"` | ADD | Soma A + B |
| `"001"` | SUB | Subtração A − B via complemento de dois |
| `"010"` | AND | Operação lógica bit a bit |
| `"011"` | OR | Operação lógica bit a bit |
| `"100"` | NOT | Inversão de todos os bits de A |
| `"101"` | XOR | Exclusivo bit a bit |

Além do resultado, a ULA gera três **flags de status** que indicam propriedades do resultado calculado:

- Zero (Z): ativo quando o resultado é `0x0000`. Usado em desvios condicionais.
- Negativo (N): ativo quando o bit mais significativo é `'1'`, indicando resultado negativo.
- Carry (C): ativo quando há transporte além do bit 15, indicando overflow sem sinal.

A ULA é construída encadeando 16 instâncias de uma `ula_1bit`, da mesma forma que o `somadorNbits` encadeia Full Adders. Cada `ula_1bit` recebe o `op_code` e calcula em paralelo as diferentes operações possíveis, selecionando apenas a correta na saída.

Exemplo em VHDL:

```vhdl
-- ULA de 1 bit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_1bit is
    generic (
        bits_necessarios : natural
    );
    port (
        A, B, Cin : in  std_logic;
        op_code   : in  std_logic_vector(bits_necessarios-1 downto 0);
        Saida     : out std_logic;
        Cout      : out std_logic
    );
end entity;

architecture comportamento of ula_1bit is
    signal fio_and, fio_or, fio_not : std_logic;
    signal B_seletivo, AxB          : std_logic;
    signal fio_full_adder, cout_fa  : std_logic;
begin
    fio_and    <= A and B;
    fio_or     <= A or  B;
    fio_not    <= not A;

    B_seletivo <= (not B) when (op_code = "001") else B;
    AxB        <= A xor B_seletivo;

    fio_full_adder <= AxB xor Cin;
    cout_fa        <= (AxB and Cin) or (A and B_seletivo);

    Saida <= fio_full_adder when (op_code = "000" or op_code = "001") else
             fio_and        when  op_code = "010" else
             fio_or         when  op_code = "011" else
             fio_not        when  op_code = "100" else
             '0';

    Cout <= cout_fa when (op_code = "000" or op_code = "001") else '0';
end comportamento;

-- ULA de N bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_Nbits is
    generic (
        bits         : natural := 16;
        bits_op_code : natural := 3
    );
    port (
        A, B    : in  std_logic_vector(bits-1 downto 0);
        Cin     : in  std_logic;
        op_code : in  std_logic_vector(bits_op_code-1 downto 0);
        Saida   : out std_logic_vector(bits-1 downto 0);
        Cout    : out std_logic
    );
end entity ula_Nbits;

architecture behavior of ula_Nbits is
    signal carries : std_logic_vector(bits downto 0);
begin
    carries(0) <= '1' when (op_code = "001") else Cin;

    ULA : for i in 0 to bits-1 generate
        ULA_i : entity work.ula_1bit
            generic map (bits_necessarios => bits_op_code)
            port map (
                A       => A(i),
                B       => B(i),
                Cin     => carries(i),
                op_code => op_code,
                Saida   => Saida(i),
                Cout    => carries(i+1)
            );
    end generate;

    Cout <= carries(bits);
end architecture;
```

## Testbench da ULA

O Testbench da ULA verifica cada operação individualmente, testando também os casos extremos como resultado zero e resultado negativo.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity ula_tb is
end ula_tb;

architecture simulacao of ula_tb is

    signal A, B   : std_logic_vector(15 downto 0) := (others => '0');
    signal Cin    : std_logic := '0';
    signal op     : std_logic_vector(2 downto 0) := "000";
    signal Saida  : std_logic_vector(15 downto 0);
    signal Cout   : std_logic;

begin

    uut: entity work.ula_Nbits
        generic map (bits => 16, bits_op_code => 3)
        port map (A => A, B => B, Cin => Cin, op_code => op,
                  Saida => Saida, Cout => Cout);

    stim_process : process
    begin
        -- ADD: 10 + 5 = 15
        A <= x"000A"; B <= x"0005"; op <= "000"; wait for 20 ns;

        -- SUB: 10 - 10 = 0 (flag Zero deve ser '1')
        A <= x"000A"; B <= x"000A"; op <= "001"; wait for 20 ns;

        -- AND: 0xFF00 and 0x0FF0 = 0x0F00
        A <= x"FF00"; B <= x"0FF0"; op <= "010"; wait for 20 ns;

        -- OR: 0xFF00 or 0x00FF = 0xFFFF
        A <= x"FF00"; B <= x"00FF"; op <= "011"; wait for 20 ns;

        -- NOT: not 0xFF00 = 0x00FF
        A <= x"FF00"; op <= "100"; wait for 20 ns;

        -- SUB com resultado negativo: 5 - 10 = -5 (flag Negativo deve ser '1')
        A <= x"0005"; B <= x"000A"; op <= "001"; wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- A ULA é combinacional — sem clock. A saída muda imediatamente ao trocar `A`, `B` ou `op_code`;
- Para verificar as flags `Z` e `N`, adicione sinais derivados no TB ou observe diretamente no GTKWave.

## Conexão com outros módulos

A ULA recebe os operandos `A` e `B` do Banco de Registradores e o sinal `op_code` do Decodificador. O resultado segue para o MUX de writeback, que decide se ele vai diretamente ao Banco de Registradores ou se aguarda dado da memória. As flags (`Z`, `N`, `C`) retornam ao Decodificador, que as usa para decidir se deve ou não executar um desvio condicional (`branch`).

---

## Decodificador

O Decodificador não realiza cálculos. Sua função é ler a instrução de 16 bits vinda da Memória de Instruções, identificar o opcode e acionar os sinais de controle corretos em todos os outros módulos, coordenando o que cada um deve fazer naquele ciclo.

É o Decodificador que transforma um padrão de bits como `0001 010 011 001 000` em ações concretas: "leia o Reg2, leia o Reg3, mande a ULA somar, salve o resultado no Reg1."

Toda instrução passa por quatro etapas, e o Decodificador participa ativamente de três delas:

1. Fetch: o Program Counter envia um endereço à Memória de Instruções, que devolve a instrução de 16 bits.
2. Decode: o Decodificador recebe os 16 bits e os divide em campos: os 4 bits mais significativos formam o opcode, e os demais carregam endereços de registradores.
3. Execute: com base no opcode, o Decodificador ativa os sinais `ula_op`, `reg_WE`, `mem_WE`, `mux_sel` e `jump`.
4. Writeback: se a instrução produz resultado, `reg_WE = '1'` autoriza a gravação no registrador de destino.

Os sinais de controle gerados pelo Decodificador são:

- `ula_op`: define a operação da ULA;
- `reg_WE`: habilita escrita no Banco de Registradores;
- `mem_WE`: habilita escrita na Memória de Dados (instrução `store`);
- `mux_sel`: seleciona entre resultado da ULA ou dado da RAM;
- `jump`: sinaliza desvio de fluxo para o Program Counter.

Exemplo em VHDL:

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
    op    <= instrucao(15 downto 12);
    sel_A <= instrucao(11 downto 9);
    sel_B <= instrucao(8  downto 6);
    sel_W <= instrucao(5  downto 3);

    process(op)
    begin
        -- valores padrão (evita latches indesejados)
        ula_op  <= "000";
        reg_WE  <= '0';
        mem_WE  <= '0';
        mux_sel <= '0';
        jump    <= '0';

        case op is
            when "0001" => ula_op <= "000"; reg_WE <= '1'; -- ADD
            when "0010" => ula_op <= "001"; reg_WE <= '1'; -- SUB
            when "0011" => ula_op <= "010"; reg_WE <= '1'; -- AND
            when "0100" => ula_op <= "011"; reg_WE <= '1'; -- OR
            when "0101" => ula_op <= "100"; reg_WE <= '1'; -- NOT
            when "0110" => mux_sel <= '1';  reg_WE <= '1'; -- LOAD
            when "0111" => mem_WE  <= '1';                 -- STORE
            when "1000" => jump    <= '1';                 -- JUMP
            when others => null;
        end case;
    end process;
end behavior;
```

## Testbench do Decodificador

O Testbench do Decodificador injeta palavras de instrução completas e verifica se os sinais de controle de saída correspondem ao esperado para cada opcode.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity decodificador_tb is
end decodificador_tb;

architecture simulacao of decodificador_tb is

    signal instrucao : std_logic_vector(15 downto 0) := (others => '0');
    signal sel_A     : std_logic_vector(2 downto 0);
    signal sel_B     : std_logic_vector(2 downto 0);
    signal sel_W     : std_logic_vector(2 downto 0);
    signal ula_op    : std_logic_vector(2 downto 0);
    signal reg_WE    : std_logic;
    signal mem_WE    : std_logic;
    signal mux_sel   : std_logic;
    signal jump      : std_logic;

begin

    uut: entity work.decodificador
        port map (
            instrucao => instrucao,
            sel_A     => sel_A,
            sel_B     => sel_B,
            sel_W     => sel_W,
            ula_op    => ula_op,
            reg_WE    => reg_WE,
            mem_WE    => mem_WE,
            mux_sel   => mux_sel,
            jump      => jump
        );

    stim_process : process
    begin
        -- ADD: opcode=0001, sel_A=010, sel_B=011, sel_W=001
        instrucao <= "0001" & "010" & "011" & "001" & "000";
        wait for 20 ns;

        -- SUB
        instrucao <= "0010" & "001" & "010" & "011" & "000";
        wait for 20 ns;

        -- LOAD: mux_sel deve ser '1', reg_WE = '1'
        instrucao <= "0110" & "001" & "000" & "010" & "000";
        wait for 20 ns;

        -- STORE: mem_WE deve ser '1', reg_WE = '0'
        instrucao <= "0111" & "001" & "010" & "000" & "000";
        wait for 20 ns;

        -- JUMP: jump deve ser '1', demais em '0'
        instrucao <= "1000" & "000" & "000" & "000" & "000";
        wait for 20 ns;

        -- Instrução desconhecida: todos os sinais devem ficar no padrão
        instrucao <= "1111" & "000" & "000" & "000" & "000";
        wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- O Decodificador é combinacional — a saída muda imediatamente ao trocar a instrução;
- Para cada instrução injetada, é possível verificar no GTKWave se os sinais de controle corretos foram ativados;
- O caso `when others` garante que instruções desconhecidas não gerem sinais inesperados.

## Conexão com outros módulos

O Decodificador está no centro de tudo. Ele recebe instruções da Memória de Instruções, comanda a ULA via `ula_op`, autoriza escritas no Banco de Registradores via `reg_WE`, controla o MUX via `mux_sel`, acessa a Memória de Dados via `mem_WE` e direciona o Program Counter em caso de salto via `jump`.

---

## MUX — Multiplexador 2x1

O Multiplexador (MUX) é um componente que possui múltiplas entradas de dados, mas apenas uma saída. Um sinal de seleção (`sel`) determina qual das entradas é conectada à saída em cada momento.

O MUX não realiza nenhum cálculo — ele apenas roteia sinais. Sem ele, a CPU não conseguiria reutilizar os mesmos fios para transportar tipos diferentes de dados dependendo da instrução em execução.

Na CPU Didática, o MUX aparece em diferentes pontos do caminho de dados, cada um com uma função:

- MUX de Writeback: decide o que será gravado no Banco de Registradores.
    - `sel = '0'` → resultado da ULA (instrução aritmética ou lógica)
    - `sel = '1'` → dado lido da Memória de Dados (instrução `load`)
- MUX do Program Counter: decide para onde o PC vai avançar.
    - `sel = '0'` → PC + 1 (próxima instrução sequencial)
    - `sel = '1'` → endereço de salto (instrução `jump` ou `branch`)
- MUX de Operando Imediato: decide qual é o segundo operando da ULA.
    - `sel = '0'` → valor lido de um registrador
    - `sel = '1'` → constante embutida na própria instrução (valor imediato)

Exemplo em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
    generic (
        N : natural := 16
    );
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

## Testbench do MUX

O Testbench do MUX verifica se a saída segue corretamente a entrada selecionada e muda de forma imediata ao trocar o sinal `sel`.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity mux2x1_tb is
end mux2x1_tb;

architecture simulacao of mux2x1_tb is

    signal entrada_0 : std_logic_vector(15 downto 0) := x"AAAA";
    signal entrada_1 : std_logic_vector(15 downto 0) := x"BBBB";
    signal sel       : std_logic := '0';
    signal saida     : std_logic_vector(15 downto 0);

begin

    uut: entity work.mux2x1
        generic map (N => 16)
        port map (
            entrada_0 => entrada_0,
            entrada_1 => entrada_1,
            sel       => sel,
            saida     => saida
        );

    stim_process : process
    begin
        -- sel = '0': saida deve ser entrada_0 (0xAAAA)
        sel <= '0'; wait for 20 ns;

        -- sel = '1': saida deve ser entrada_1 (0xBBBB)
        sel <= '1'; wait for 20 ns;

        -- Troca entrada_0 com sel = '0'
        entrada_0 <= x"1234";
        sel       <= '0'; wait for 20 ns;

        -- Volta sel = '1': saida ainda deve ser entrada_1 (0xBBBB)
        sel <= '1'; wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- O MUX é combinacional — a saída muda instantaneamente ao trocar `sel`;
- Os testes confirmam que apenas a entrada selecionada aparece na saída, independente do valor da outra.

## Conexão com outros módulos

O MUX é instanciado diretamente no Top Level da CPU. O sinal de seleção `mux_sel` é sempre gerado pelo Decodificador de acordo com o tipo de instrução executada. No caso do MUX de writeback, ele fica posicionado entre a ULA e a Memória de Dados de um lado, e o Banco de Registradores do outro.

---

## Memória de Instruções (ROM)

A Memória de Instruções armazena o programa que a CPU vai executar. Ela funciona como uma tabela numerada onde cada posição guarda uma instrução de 16 bits. O número da posição é o endereço fornecido pelo Program Counter.

Diferente da Memória de Dados, a Memória de Instruções é somente leitura durante a execução: o programa é definido antes da simulação, diretamente no código VHDL, e não muda enquanto a CPU está rodando. Esse comportamento reflete a separação clássica da **Arquitetura Harvard**, onde instruções e dados trafegam por barramentos independentes.

Seu funcionamento segue o primeiro estágio do ciclo da CPU:

1. O Program Counter envia o endereço da próxima instrução a ser buscada;
2. Na borda de subida do clock, com `leitura = '1'` ativo, a memória acessa o vetor interno no índice indicado pelo endereço;
3. O valor de 16 bits daquela posição é disponibilizado em `saida_dado`;
4. Esse valor vai direto ao Decodificador, que interpreta os bits e aciona os controles da CPU.

Para alterar o programa que a CPU executa, basta editar os valores de inicialização do `signal memoria` e recompilar — sem modificar nenhuma outra parte do hardware.

Exemplo em VHDL:

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
        endereco   : in  std_logic_vector(bits_endereco-1 downto 0);
        clock      : in  std_logic;
        leitura    : in  std_logic;
        saida_dado : out std_logic_vector(bits_dado-1 downto 0)
    );
end implementacao_memoria_instrucoes;

architecture comportamento of implementacao_memoria_instrucoes is
    type memoria_instrucoes is array(numero_posicoes-1 downto 0)
        of std_logic_vector(bits_dado-1 downto 0);

    signal memoria : memoria_instrucoes := (
        0      => x"1000",  -- instrução 0
        1      => x"2013",  -- instrução 1
        2      => x"3003",  -- instrução 2
        3      => x"4004",  -- instrução 3
        others => x"0000"   -- NOP (sem operação)
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

## Testbench da Memória de Instruções

O Testbench percorre diferentes endereços e verifica se a instrução correta é entregue em cada posição, além de confirmar que a leitura não ocorre quando `leitura = '0'`.

```vhdl
`library ieee;
use ieee.std_logic_1164.all;
entity memoria_instrucoes_tb is
end memoria_instrucoes_tb;
architecture simulacao of memoria_instrucoes_tb is
signal clock      : std_logic := '0';
signal leitura    : std_logic := '0';
signal endereco   : std_logic_vector(7 downto 0) := (others => '0');
signal saida_dado : std_logic_vector(15 downto 0);

begin
uut: entity work.implementacao_memoria_instrucoes
    port map (
        clock      => clock,
        leitura    => leitura,
        endereco   => endereco,
        saida_dado => saida_dado
    );

clock_process : process
begin
    while true loop
        clock <= '0'; wait for 10 ns;
        clock <= '1'; wait for 10 ns;
    end loop;
end process;

stim_process : process
begin
    leitura <= '1';

    -- Lê endereço 0: espera 0x1000
    endereco <= x"00"; wait for 20 ns;

    -- Lê endereço 1: espera 0x2013
    endereco <= x"01"; wait for 20 ns;

    -- Lê endereço 3: espera 0x4004
    endereco <= x"03"; wait for 20 ns;

    -- Lê endereço não inicializado: espera 0x0000 (NOP)
    endereco <= x"FF"; wait for 20 ns;

    -- Desabilita leitura: saida_dado não deve mudar
    leitura  <= '0';
    endereco <= x"00"; wait for 20 ns;

    wait;
end process;

end simulacao;`
```

Nesse Testbench:

- `saida_dado` só se atualiza após a borda de subida do clock com `leitura = '1'`;
- Endereços não inicializados retornam `0x0000` (NOP), graças ao `others => x"0000"`;
- Com `leitura = '0'`, a saída permanece congelada no último valor lido.

## Conexão com outros módulos

A Memória de Instruções recebe o endereço diretamente do Program Counter. Sua saída — a instrução de 16 bits — vai para o Decodificador, que separa o opcode dos campos de registrador e aciona todos os sinais de controle necessários. Sem ela, o hardware saberia calcular, mas não saberia o quê, quando ou com quais dados calcular.

---

## Memória de Dados (RAM)

*A RAM de trabalho onde as variáveis do programa vivem.*

A Memória de Dados é onde a CPU guarda os materiais que está usando durante a execução: contadores, vetores, resultados intermediários — tudo que precisa persistir além de um único ciclo de clock.

Diferente da Memória de Instruções (ROM), a Memória de Dados é uma RAM: pode ser lida e escrita a qualquer momento durante a execução, no endereço que a CPU especificar.

Ela participa de dois tipos de instrução:

- LOAD (leitura): a CPU envia um endereço e ativa `leitura = '1'`. Na borda de clock, a memória devolve o valor de 16 bits guardado naquela posição. Esse valor passa pelo MUX de writeback e é salvo em um registrador.
- STORE (escrita): a CPU envia um endereço, um valor de 16 bits e ativa `escrita_ativa = '1'`. Na próxima borda de subida do clock, o valor é gravado permanentemente naquela posição.

Ambas as operações são síncronas com o clock, o que significa que a resposta de uma leitura só estará disponível no ciclo seguinte ao comando.

Exemplo em VHDL:

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
        endereco      : in  std_logic_vector(bits_endereco-1 downto 0);
        clock         : in  std_logic;
        escrita_ativa : in  std_logic;
        leitura       : in  std_logic;
        entrada_dado  : in  std_logic_vector(bits_dado-1 downto 0);
        saida_dado    : out std_logic_vector(bits_dado-1 downto 0)
    );
end ram;

architecture comportamento of ram is
    type memoria is array(numero_posicoes-1 downto 0)
        of std_logic_vector(bits_dado-1 downto 0);
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

## Testbench da Memória de Dados

O Testbench verifica as operações de STORE e LOAD em diferentes endereços, além de confirmar que dados gravados permanecem intactos quando `escrita_ativa = '0'`.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity ram_tb is
end ram_tb;

architecture simulacao of ram_tb is

    signal clock         : std_logic := '0';
    signal escrita_ativa : std_logic := '0';
    signal leitura       : std_logic := '0';
    signal endereco      : std_logic_vector(7 downto 0) := (others => '0');
    signal entrada_dado  : std_logic_vector(15 downto 0) := (others => '0');
    signal saida_dado    : std_logic_vector(15 downto 0);

begin

    uut: entity work.ram
        port map (
            clock         => clock,
            escrita_ativa => escrita_ativa,
            leitura       => leitura,
            endereco      => endereco,
            entrada_dado  => entrada_dado,
            saida_dado    => saida_dado
        );

    clock_process : process
    begin
        while true loop
            clock <= '0'; wait for 10 ns;
            clock <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_process : process
    begin
        -- STORE 0x00FF no endereço 0x10
        escrita_ativa <= '1';
        endereco      <= x"10";
        entrada_dado  <= x"00FF";
        wait for 20 ns;

        -- STORE 0xABCD no endereço 0x20
        endereco     <= x"20";
        entrada_dado <= x"ABCD";
        wait for 20 ns;

        -- LOAD do endereço 0x10: espera 0x00FF
        escrita_ativa <= '0';
        leitura       <= '1';
        endereco      <= x"10";
        wait for 20 ns;

        -- LOAD do endereço 0x20: espera 0xABCD
        endereco <= x"20";
        wait for 20 ns;

        -- LOAD de endereço nunca escrito: espera 0x0000
        endereco <= x"00";
        wait for 20 ns;

        -- Tentativa de escrita com escrita_ativa = '0' (nada deve mudar)
        escrita_ativa <= '0';
        entrada_dado  <= x"FFFF";
        endereco      <= x"10";
        wait for 20 ns;

        -- Confirma que 0x10 ainda é 0x00FF
        leitura  <= '1';
        endereco <= x"10";
        wait for 20 ns;

        wait;
    end process;

end simulacao;
```

Nesse Testbench:

- O processo `clock_process` gera o clock continuamente;
- O STORE ocorre com `escrita_ativa = '1'` e o valor é gravado na borda de clock;
- O LOAD ocorre com `leitura = '1'` e o dado fica disponível no ciclo seguinte;
- Endereços nunca escritos retornam `0x0000` graças à inicialização `(others => (others => '0'))`.

## Conexão com outros módulos

A Memória de Dados recebe o endereço e o `entrada_dado` vindos da ULA e do Banco de Registradores. Os sinais `escrita_ativa` e `leitura` são controlados pelo Decodificador. A saída `saida_dado` vai para o MUX de writeback, que decide se o Banco de Registradores deve receber esse valor (instrução `load`) ou o resultado direto da ULA (instrução aritmética ou lógica).

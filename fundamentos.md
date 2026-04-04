---
description: 'Módulo de Fundamentos: CPU, Portas Lógicas e VHDL'
---

# Fundamentos

Abaixo, você vai entender de forma simplificada o que é uma CPU, como ela toma decisões usando Portas Lógicas e como usamos a linguagem VHDL para "desenhar" tudo isso.

***

### 1. O que é uma CPU?



_"minha ideia seria colocar mesmo as imagens das portas lógicas e codigos em seus respectivo lugar em toda a documentação"_



A CPU (Unidade Central de Processamento) é popularmente conhecida como o "cérebro" de qualquer dispositivo eletrônico, desde o seu smartphone até o seu computador. É ela a responsável por ler instruções da memória e executar todos os cálculos e comandos necessários para que os programas funcionem.

No nosso repositório, estamos simulando uma CPU de 16 bits. Isso significa que as "vias" (barramentos) por onde as informações passam e os cálculos realizados lidam com pacotes de 16 zeros e uns (bits) de uma única vez.

Para que a CPU funcione, ela é dividida em blocos menores (que você encontrará implementados nas pastas do projeto), sendo os principais:

* ULA (Unidade Lógica e Aritmética): O verdadeiro "calculador". É o bloco responsável por fazer somas, subtrações e comparações.
* Registradores: Pequenas "caixas" de memória ultrarrápidas que guardam os números enquanto a CPU faz as contas.
* Unidade de Controle: O "maestro" que organiza tudo. Ele lê a instrução e diz para a ULA e para os Registradores o que eles devem fazer no momento exato.

***

### 2. O que são Portas Lógicas?

Você já deve ter ouvido falar que os computadores "pensam" apenas em 0s e 1s, certo? Na prática, o `1` significa que há energia elétrica passando (ligado) e o `0` significa a ausência dessa energia (desligado).

Para manipular essa energia e tomar decisões matemáticas, os processadores usam microcomponentes eletrônicos (os famosos transistores) organizados em algo chamado Portas Lógicas. Elas são os tijolos fundamentais da nossa CPU.

Existem algumas portas básicas que fazem operações simples com a eletricidade:

* Porta AND (E): Só emite sinal `1` na saída se todas as entradas forem `1`. É como um sistema de segurança que só destrava a porta se o cartão _E_ a senha estiverem corretos.
* Porta OR (OU): Emite sinal `1` se pelo menos uma das entradas for `1`.
* Porta NOT (NÃO): Serve para inverter o sinal. Se entra `1`, sai `0`. Se entra `0`, sai `1`.

Combinando e agrupando milhares dessas portas lógicas, nós conseguimos criar uma ULA capaz de somar números complexos e, a partir disso, construir uma CPU inteira.

***

### 3. O que é VHDL?

Quando falamos de programação comum (como Python, JavaScript ou C), você escreve um Software: um conjunto de instruções que vai rodar dentro de uma CPU que já existe e já foi fabricada.

O VHDL (_VHSIC Hardware Description Language_) é fundamentalmente diferente. Ele é uma Linguagem de Descrição de Hardware.

Ao escrever código em VHDL, você não está criando um programa passo a passo. Você está usando texto para descrever como os componentes eletrônicos estão conectados fisicamente. É como escrever o projeto arquitetônico ou a planta elétrica de uma casa.

No repositório `cpu-core`, os arquivos VHDL dizem exatamente como os fios virtuais ligam a Unidade de Controle aos Registradores, e como as Portas Lógicas estão arranjadas dentro da ULA. Com a ajuda de programas simuladores (como o GHDL e o GTKWave mencionados na raiz do projeto), podemos ler esse "texto arquitetônico" e simular virtualmente como a energia elétrica circularia nele no mundo real.

***

### Resumo da Obra

Para amarrar todo o conhecimento:

1. O mundo digital só entende zeros e uns (energia ligada ou desligada).
2. Usamos as Portas Lógicas para manipular essa energia com lógica matemática.
3. Usamos o VHDL para descrever o diagrama dessas portas lógicas em formato de texto.
4. O resultado desse conjunto de código bem estruturado é uma CPU de 16 bits, pronta para calcular dados e processar informações!

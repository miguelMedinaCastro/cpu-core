---
description: 'Módulos da CPU: Entendendo a Arquitetura por Dentro'
---

# Módulos

Agora que você já entende os fundamentos teóricos e configurou o seu ambiente de simulação, é hora de "abrir o capô" da nossa CPU de 16 bits. Em VHDL, é uma excelente prática dividir o projeto em pequenos blocos (módulos), facilitando o desenvolvimento, o teste e a compreensão.

Nesta página, vamos detalhar os principais módulos que compõem uma cpu e entender o papel de cada um deles.

***

### 1. Somador Completo (_Full Adder_)



_"vou colocar as imagens e os codigos nos exemplos, mandando apenas para pegar o feedback"_



O Somador Completo é o coração da matemática dentro da CPU. Antes de somarmos 16 bits de uma vez, precisamos saber somar 1 único bit. O _Full Adder_ recebe três entradas:

* A e B: Os dois bits que você quer somar.
* Cin (Carry-In): O "vai um" da soma anterior.

E ele gera duas saídas:

* S (Soma): O resultado da soma atual.
* Cout (Carry-Out): O "vai um" que será passado para a próxima casa decimal (ou melhor, binária).

Para construir um somador de 16 bits, nós simplesmente "colamos" 16 desses módulos um do lado do outro, conectando o `Cout` de um no `Cin` do próximo (arquitetura conhecida como _Ripple Carry Adder_).

### 2. Unidade Lógica e Aritmética (ULA / ALU)

A ULA é o verdadeiro "motor" de processamento. Ela encapsula o Somador de 16 bits e adiciona várias outras funções. No nosso projeto, a ULA recebe dois números de 16 bits e um sinal de controle que diz a ela qual operação realizar no momento.

As operações típicas incluem:

* Aritméticas: Soma (usando os _Full Adders_), Subtração (invertendo um dos números e somando 1).
* Lógicas: AND bit a bit, OR bit a bit, NOT (inversão).

Dependendo da instrução atual, a ULA processa os dados e joga o resultado na saída, além de gerar _Flags_ (bandeiras), que são sinais de 1 bit para avisar se o resultado foi zero, se foi negativo ou se estourou o limite de 16 bits (_overflow_).



### 3. Banco de Registradores (_Register File_)

A ULA calcula muito rápido, mas ela não tem onde guardar os resultados. É para isso que serve o Banco de Registradores. Ele é um conjunto de pequenas memórias ultrarrápidas construídas com _Flip-Flops_ (circuitos que "congelam" um bit de informação).

Em uma CPU de 16 bits, cada registrador guarda 16 bits. O banco permite que a CPU:

1. Escolha um registrador para ler o primeiro número (Ex: `RegA`).
2. Escolha outro para ler o segundo número (Ex: `RegB`).
3. Escolha um terceiro registrador para salvar o resultado que vai sair da ULA.

### 4. Contador de Programa (PC - _Program Counter_)

Como a CPU sabe qual é a próxima linha de código que ela deve executar? O responsável por isso é o módulo PC.

Ele é basicamente um registrador especial que guarda o endereço da instrução atual na memória. Toda vez que um ciclo de máquina termina, o PC é atualizado:

* Normalmente, ele apenas soma `+1` ao seu valor, apontando para a próxima instrução.
* Se houver um comando de "pulo" (_Jump_ ou _Branch_, como em um `if/else`), o PC recebe um endereço completamente novo para desviar o fluxo do programa.

### 5. Memória (RAM e ROM)

A CPU não trabalha sozinha; ela precisa buscar instruções e ler/escrever dados em algum lugar. O projeto descreve módulos de memória para interagir com a CPU:

* Memória de Instruções (ROM): Onde o "código" do programa fica armazenado. O endereço fornecido pelo PC aponta para cá, e a memória devolve a instrução de 16 bits que deve ser executada.
* Memória de Dados (RAM): Onde as variáveis do programa ficam salvas. A CPU pode pedir para ler uma informação daqui ou mandar um resultado da ULA para ser gravado em um endereço específico.

### 6. Unidade de Controle (_Control Unit_)

Se a ULA é o motor e a Memória é o tanque de combustível, a Unidade de Controle é o cérebro que dirige o carro. Este módulo recebe a instrução crua da memória (por exemplo, um código binário como `0010 1000 0000 0000`) e a "decodifica".

A partir dessa decodificação, ela aciona diversos "fios de controle" espalhados pela CPU:

* Manda um sinal para o Banco de Registradores liberar o `Reg1`.
* Manda um sinal para a ULA avisando que a operação atual é uma SOMA.
* Manda um sinal dizendo se o resultado deve ser salvo de volta em um registrador ou na memória RAM.

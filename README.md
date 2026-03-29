---
description: >-
  Um guia passo a passo para construir e simular sua própria CPU de 16 bits em
  VHDL
icon: microchip
---

# CPU Didática

### Visão Geral

Neste tutorial, você irá aprender desde os primeiros passos em VHDL até a simulação de uma CPU de 16 bits completa. O objetivo deste projeto é servir como uma porta de entrada para o estudo de arquitetura de computadores, permitindo que qualquer pessoa consiga acompanhar mesmo com pouca experiência prévia. Este tutorial é voltado para:

* Estudantes de computação/engenharia;
* Pessoas que querem entender como uma CPU funciona na prática.

Assume-se que você possua apenas:

* Familiaridade básica com terminal (linha de comando).

Ao final deste tutorial, você será capaz de:

* Entender o papel de cada componente de uma CPU;
* Ler e interpretar código VHDL;
* Compilar e simular circuitos digitais;
* Explorar e modificar módulos da CPU.

### Background

Uma CPU (Unidade Central de Processamento) é o “cérebro” do computador. Mesmo as CPUs modernas sendo extremamente complexas, elas são construídas a partir de conceitos simples:

* Operações lógicas e aritméticas (ALU);
* Armazenamento de dados (Registradores e Memória);
* Controle de execução (Unidade de Controle).

### Antes de Começar (Pré-requisitos)

Para simular a nossa CPU no seu computador, você precisará instalar algumas ferramentas gratuitas e de código aberto. Antes de iniciar as tarefas abaixo, certifique-se de ter:

* **GHDL:** Um simulador de código aberto para a linguagem VHDL.
* **GTKWave:** Um visualizador de formas de onda (waveform) para vermos os sinais da CPU funcionando no tempo.
* **Git:** Para baixar o código do repositório.
* Um editor de código da sua preferência (recomendamos o **VS Code** com a extensão VHDL).

### Clonando e Simulando

Para começar a colocar a mão na massa, vamos baixar o projeto do GitHub e rodar a nossa primeira simulação de teste.

1.  **Clone o repositório** para a sua máquina local: Abra o seu terminal e digite:

    ```bash
    git clone https://github.com/miguelMedinaCastro/cpu-core.git
    ```

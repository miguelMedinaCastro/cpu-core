---
description: 'Preparando o Ambiente: GHDL, GTKWave e Makefiles'
icon: screwdriver-wrench
---

# Preparando o Ambiente

Como o VHDL descreve o hardware, não podemos simplesmente executá-lo com um duplo clique como fazemos com um programa comum. Precisamos de ferramentas específicas para compilar o código, simular o tempo passando e visualizar a energia (os sinais lógicos) fluindo pelos fios virtuais.

Abaixo, você vai conhecer o trio de ferramentas que usaremos neste projeto e como preparar o seu ambiente de desenvolvimento.

***

### 1. As Nossas Ferramentas de Trabalho

#### GHDL

O GHDL é um simulador de código aberto para a linguagem VHDL. O trabalho dele é ler todos os nossos arquivos de texto (onde descrevemos as portas lógicas e conexões), verificar se a sintaxe está correta e criar um modelo executável da nossa CPU.

É ele quem faz a "matemática" nos bastidores, calculando em que momento cada sinal elétrico muda de `0` para `1`.

#### GTKWave

Quando o GHDL termina a simulação, ele cospe um arquivo cheio de dados de tempo e sinais elétricos (geralmente com a extensão `.vcd` ou `.ghw`). Ler isso em formato de texto é impossível para um ser humano. É aí que entra o GTKWave.

Ele é um visualizador de formas de onda (waveforms). Com ele, você consegue ver gráficos coloridos mostrando exatamente o que estava acontecendo dentro de cada registrador e de cada porta lógica em qualquer milissegundo da simulação.

#### Makefile

Para rodar o GHDL, compilar cada arquivo individualmente e depois abrir o GTKWave, você teria que digitar vários comandos longos e chatos no terminal toda vez que fizesse uma pequena alteração no código.

O Makefile (usado pela ferramenta `make`) serve para automatizar isso. Nós já deixamos um arquivo chamado `Makefile` pronto na raiz do repositório com as "receitas" de todos os comandos. Assim, com uma única palavra, você compila e roda tudo.

***

### 2. Instalando os Softwares

Para rodar o projeto, você precisará instalar essas ferramentas no seu sistema operacional. A forma mais fácil de fazer isso é usando um ambiente Linux (distros derivadas do Debian como Ubuntu, ou o WSL se você estiver no Windows).

Abra o seu terminal e digite o seguinte comando para instalar o pacote completo:

```
sudo apt update
sudo apt install ghdl gtkwave make git
```

> Dica para usuários de Windows: Se você não usa Linux, a recomendação oficial é instalar o WSL (Windows Subsystem for Linux) para rodar o Ubuntu dentro do seu Windows. Depois de configurar o WSL, basta rodar o comando acima no terminal dele. Você também precisará de um servidor X (como o VcXsrv) para abrir a interface gráfica do GTKWave no Windows.

***

### 3. Rodando o Projeto na Prática

Com tudo instalado, o processo para simular a nossa CPU é extremamente simples graças ao Makefile.

Passo 1: Baixe o código do repositório para o seu computador usando o Git.

Bash

```
git clone https://github.com/miguelMedinaCastro/cpu-core.git
cd cpu-core
```

Passo 2: Compile e simule a CPU! Basta digitar o comando abaixo na raiz do projeto:

Bash

```
make
```

_(Esse comando vai olhar para o nosso `Makefile`, descobrir a ordem certa de compilar os arquivos da ULA, dos Registradores e do Top Level, executar a simulação e gerar o arquivo de ondas)._

Passo 3: Caso o `make` já não abra o GTKWave automaticamente (dependendo de como o Makefile do repositório está configurado), você pode abrir o visualizador de ondas digitando:

Bash

```
gtkwave nome_do_arquivo_gerado.vcd
```

Pronto! Agora você tem um laboratório de eletrônica digital rodando perfeitamente no seu computador. Sinta-se à vontade para alterar os sinais nos arquivos de _testbench_ (os arquivos que injetam sinais de teste na CPU) e rodar o `make` novamente para ver o que acontece nos gráficos do GTKWave.

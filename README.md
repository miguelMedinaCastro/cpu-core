# CPU Didática 1.0

Implementação de um **núcleo de CPU em VHDL** desenvolvido para fins didáticos, simulação e estudo de arquitetura de computadores. O projeto contém módulos básicos de hardware digital, como uma **ULA (Unidade Lógica e Aritmética)** e um **somador parametrizável em N bits**, além de testbenches para validação.

---

# 1. Visão Geral

O projeto **cpu-core** implementa componentes fundamentais de um processador digital utilizando **VHDL**. A arquitetura é modular, permitindo que cada componente seja desenvolvido, testado e reutilizado independentemente.

---

# 2. Objetivos

- Investigar o uso de CPUs em HDL no ensino de SDs
- Praticar o uso de Ferramentas de Projeto e Desenvolvimento de HW
- Projetar e Desenvolver Bloco de HW em HDL     
- Praticar o uso de FPGAs e Prototipação de HW

## Objetivos Específicos

- Propor uma Arquitetura de Computador simplificada e didática
- Projetar uma Organização interna da CPU baseada na Arquitetura
- Descrever e Simular a mesma CPU usando HDL
- Prototipar a CPU descrita em HDL usando FPGA
- Documentar e Disponibilizar o Simulador Tutorial da CPU HDL
- Validar o Simulador e o Tutorial com usuários reais

---

# 3. Tecnologias Utilizadas

<div align="center">
  
| Tecnologia | Descrição |
|---|---|
| VHDL | Linguagem de descrição de hardware |
| GHDL | Simulador VHDL |
| GTKWave | Visualização de sinais |
| Make | Automação de build e simulação |

</div>

---

# 4. Organização

A organização é composta por módulos independentes que representam componentes de um processador.
Abaixo está a árvore completa de arquivos do projeto:

```text
├── cpu
│   ├── decoder
│   │   └── decoder2x4.vhdl
│   ├── full_adder
│   │   └── somador_Nbits.vhdl
│   ├── instruction_memory
│   │   ├── instruction_memory.vhdl
│   ├── memory
│   │   ├── memoria.txt
│   │   └── memory.vhdl
│   ├── mux
│   │   ├── mux_tb.vhdl
│   │   └── mux.vhdl
│   ├── reg_bank
│   │   └── reg_bank.vhdl
│   ├── register
│   │   ├── bitregister_par.vhdl
│   │   └── bitregister.vhdl
│   └── ULA
│       ├── ula_1bit_tb.vhdl
│       ├── ula_1bit.vhdl
│       ├── ula_Nbits_tb.vhdl
│       ├── ula_Nbits.vhdl
├── Makefile
├── testbench
│   ├── bitregister_par_tb.vhdl
│   ├── bitregister_tb.vhdl
│   ├── decoder_tb.vhd
│   ├── instruction_memory.vhdl
│   ├── memory_tb.vhdl
│   ├── reg_bank_tb.vhdl
│   └── somador_Nbits_tb.vhdl
```
## Guia dos Módulos   
* **`decoder/` (Decodificador 2x4):**
  * **O que faz:** Recebe um sinal de entrada de 2 bits e ativa uma de suas 4 saídas. 
  * **Como é usado:** Essencial para a Unidade de Controle ou para o endereçamento interno do Banco de Registradores, traduzindo códigos binários em sinais de habilitação.

* **`full_adder/` (Somador de N-bits):**
  * **O que faz:** Realiza a soma aritmética de duas palavras binárias de tamanho configurável (N-bits).
  * **Como é usado:** Geralmente utilizado para calcular o próximo endereço do *Program Counter* (PC + 4) ou calcular endereços de salto.

* **`instruction_memory/` (Memória de Instruções):**
  * **O que faz:** Atua como a ROM (Read-Only Memory) do sistema.
  * **Como é usado:** Recebe o endereço atual do PC e "cospe" a instrução de 32 bits (ou tamanho correspondente à arquitetura) que deve ser decodificada e executada no ciclo atual.

* **`memory/` (Memória de Dados):**
  * **O que faz:** A RAM do processador. Armazena as variáveis e dados gerados durante a execução do programa.
  * **Como é usado:** É acessada por instruções de `Load` (leitura) e `Store` (escrita). Note que há um arquivo `memoria.txt` que é usado para inicializar a memória com valores predefinidos antes da simulação começar.

* **`mux/` (Multiplexador):**
  * **O que faz:** Um seletor de rotas. Recebe múltiplas entradas de dados e deixa apenas uma passar para a saída, com base em um sinal de controle.
  * **Como é usado:** Espalhado por todo o Datapath para tomar decisões, como escolher se a entrada da ULA vem de um registrador ou de um valor imediato (*ALUSrc*), ou se o dado a ser salvo no registrador vem da ULA ou da Memória (*MemtoReg*).

* **`register/` (Registradores Simples):**
  * **O que faz:** Implementações de *flip-flops* para armazenar bits individuais (`bitregister.vhdl`) ou palavras inteiras (`bitregister_par.vhdl`).
  * **Como é usado:** Servem como os blocos construtores de estado da CPU. O *Program Counter* (PC), por exemplo, é instanciado a partir de um registrador paralelo.

* **`reg_bank/` (Banco de Registradores):**
  * **O que faz:** Um conjunto agrupado de registradores de uso geral.
  * **Como é usado:** Possui portas de leitura (para buscar os operandos de uma instrução) e porta de escrita (para salvar o resultado da ULA ou da Memória). É controlado pelos campos da instrução atual (ex: `rs`, `rt`, `rd`).

* **`ULA/` (Unidade Lógica e Aritmética):**
  * **O que faz:** O "cérebro" matemático do processador. 
  * **Como é usado:** Ela recebe dois operandos e um código de operação da Unidade de Controle para realizar somas, subtrações, AND, OR, NOT, XOR, ...

* **`testbench/` (Ambiente de Testes):**
  * **O que faz:** Contém os arquivos de simulação (os "laboratórios de teste"). 
  * **Como usar:** Nenhum código dessa pasta vai para o hardware real. Deve-se compilar o módulo desejado (ex: `mux.vhdl`) junto com seu respectivo testbench (ex: `mux_tb.vhdl`) usando uma ferramenta como GHDL para injetar sinais artificiais e ver como o módulo reage nas formas de onda geradas no arquivo `.vcd`.

# 5. Fluxo de Simulação
O projeto utiliza GHDL para simulação.   
## 1. Análise   
Compila os arquivos VHDL    
`ghdl -a arquivo.vhdl`
## 2. Elabora    
Cria o executável da simulação.    
`ghdl -e arquivo.vhdl`    
## 3. Execução   
`ghdl -r testbench --vcd=wave.vcd`    

# Objetivo futuro   
Síntese em FPGA  

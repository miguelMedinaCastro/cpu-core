---
description: 'Módulos da CPU: Entendendo a Arquitetura por Dentro'
icon: layer
---

# Módulos

Agora que você já entende os fundamentos teóricos e configurou o seu ambiente de simulação, é hora de "abrir o capô" da nossa CPU de 16 bits.

Em VHDL, é uma excelente prática dividir o projeto em pequenos blocos independentes — os _módulos_. Cada módulo tem uma responsabilidade bem definida, pode ser testado isoladamente e se comunica com os outros através de portas (`port`). Essa abordagem facilita o desenvolvimento, o teste e a compreensão da arquitetura como um todo.

Abaixo estão os principais módulos que compõem a nossa CPU. Clique em qualquer um para ver a descrição completa, o código VHDL e exemplos de simulação.

***

### [full-adder.md](full-adder.md "mention")

O elemento de memória mais básico da CPU. Construído com Flip-Flops tipo D, ele armazena 16 bits de informação e só atualiza seu valor na borda de subida do clock — garantindo que os dados não mudem em momentos indevidos.

### Banco de Registradores

O "armário" de memória ultrarrápida da CPU. Reúne múltiplos registradores em um único módulo com duas portas de leitura e uma de escrita simultâneas, permitindo que a ULA receba dois operandos ao mesmo tempo e devolva o resultado ao registrador de destino.

***

### Somador

O tijolo fundamental de toda operação aritmética. O somador soma dois bits levando em conta o transporte da posição anterior. Encadeando 16 deles em série, formamos o `somadorNbits` — a espinha dorsal da ULA.

***

### Unidade Lógica e Aritmética (ULA)

O motor de processamento da CPU. A ULA recebe dois operandos de 16 bits e um código de operação, e executa somas, subtrações e operações lógicas (AND, OR, NOT, XOR). Também gera Flags de status (Zero, Negativo, Carry) usadas em desvios condicionais.

***

### Decodificador

O maestro da CPU. O Decodificador lê a instrução de 16 bits vinda da memória, identifica o `opcode` e aciona os sinais de controle corretos em todos os outros módulos — dizendo à ULA o que calcular, ao Banco de Registradores onde ler e escrever, e ao PC se deve avançar ou saltar.

***

### Multiplexador (MUX)

O interruptor de trilhos da CPU. O MUX tem múltiplas entradas e uma única saída, e um sinal de seleção decide qual entrada passa adiante. Ele aparece em vários pontos do caminho de dados: no writeback (ULA ou memória?), no PC (avançar ou saltar?) e na escolha entre registrador e valor imediato.

***

### Memória de Instruções

A ROM que guarda o programa a ser executado. Organizada como uma tabela de endereços, ela entrega uma instrução de 16 bits ao Decodificador a cada ciclo de clock, conforme o endereço fornecido pelo Program Counter.

***

### Memória de Dados

A RAM de trabalho da CPU. Diferente da ROM de instruções, ela pode ser lida e escrita durante a execução — é onde as variáveis do programa ficam guardadas. Instruções de `load` leem daqui; instruções de `store` escrevem aqui.

***

### Program Counter (PC)

O ponteiro de leitura da CPU. O PC guarda o endereço da próxima instrução a ser buscada e avança automaticamente a cada ciclo (`PC + 1`). Quando uma instrução de `jump` ou `branch` é executada, ele salta diretamente para o endereço indicado.

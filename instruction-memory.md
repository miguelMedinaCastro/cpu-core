---
description: Descrição completa de Instruction Memory
---

# Instruction Memory

A Memória de Instruções é um componente de armazenamento (geralmente uma ROM) que guarda o código binário do programa que a CPU deve executar.

Diferente da memória de dados (onde guardamos variáveis), a memória de instruções é organizada como uma estante de livros, onde cada "livro" é uma instrução de 16 bits (no caso da sua arquitetura).

***

### 2. Como ela funciona no ciclo da CPU?

A Memória de Instruções opera no primeiro estágio de qualquer processador: o Fetch (Busca). O processo funciona assim:

1. O Endereço: O Program Counter (PC) — que é um registrador que funciona como um ponteiro — envia para a Memória de Instruções o endereço da próxima ordem.
2. A Saída: A Memória de Instruções olha para aquele endereço e "cospe" o valor binário que está guardado lá (a instrução).
3. O Destino: Esse binário vai para a Unidade de Controle, que vai decodificar se aquela ordem é para usar o seu Somador, fazer um salto (Jump) ou mover um dado.

***

### 3. Implementação em VHDL

<figure><img src=".gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

***

***

### 4. A Conexão com o seu Somador

Aqui está o ponto onde tudo se une:

* A Instruction Memory entrega um código como `0001` (que significa "Soma").
* A Unidade de Controle entende esse código e ativa o sinal `selecao_soma`.
* Esse sinal "liga" o seu somadorNbits, que pega os valores dos registradores e faz o cálculo.

#### Por que ela é importante?

Sem a Memória de Instruções, o seu hardware seria "burro". Ele saberia somar, mas não saberia quando somar ou quais números usar. Ela transforma um circuito eletrônico em um computador programável.

***

***

Dica para o seu projeto: Ao criar a imagem da Memória de Instruções, desenhe-a como uma tabela. Na coluna da esquerda, o endereço (0, 1, 2...); na coluna da direita, o código binário. Isso ajuda muito a visualizar que o software nada mais é do que números guardados em uma tabela física dentro do chip.

Faz sentido como o Program Counter "varre" essa memória para dar ordens à ULA?

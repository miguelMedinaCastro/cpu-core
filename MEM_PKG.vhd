library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package MEM_PKG is

    type Memory is array (255 downto 0) of std_logic_vector(15 downto 0);
    function Cria_Memoria (constant TIPO  : in natural)  return Memory;

end package;


package body MEM_PKG is

    constant NTEST : natural := 00;      --  SELECAO do PROGRAMA DE TESTE
                                         --     00 = Contador de  1  a  5
                                         --     01 = Contador de  3  a  9
                                         --     02 = Contador de -5  a 10
                                         --     03 = Contador de -7  a -1
                                         --     04 = Comparador  3  e  4
                                         --     05 = Comparador  5  e  3
                                         --     06 = Comparador  5  e  5
                                         --     07 = Comparador -3  e -4
                                         --     08 = Multiplicação 5 e 3
                                         --     09 = Multiplicação 3 e 5
                                         --     10 = Multiplicação 5 e 0
                                         --     11 = Multiplicação 0 e 4
                                         --     12 = Teste LDA, LDAi e STA
                                         --     13 = Teste ADD e SUB
                                         --     14 = Teste AND, OR e NOT
                                         --     15 = Teste Flags Z e N
                                         --     16 = Teste Flags C e V

    -- Função que Preenche a Memória (0 = INSTRUÇÕES e 1 = DADOS)
    function Cria_Memoria (constant TIPO  : in natural) return Memory is

        variable iMEM : Memory  :=  (others => (others => '0'));
        variable dMEM : Memory  :=  (others => (others => '0'));

      begin


         case  NTEST  is

            -----------------------------------------------------------------------------
            when  00    =>               -- CONTADOR de 1 a 5
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --              LDA   R0, CNT
                iMEM(01) := x"0901";     --              LDA   R1, END
                iMEM(02) := x"1201";     --              LDAi  R2, 1
                iMEM(03) := x"2040";     --     CONTA:   ADD   R0, R2, R0
                iMEM(04) := x"1800";     --              STA   R0, CNT
                iMEM(05) := x"2903";     --              SUB   R1, R0, R3
                iMEM(06) := x"4808";     --              JZ    FIM
                iMEM(07) := x"6003";     --              JMP   CONTA
                iMEM(08) := x"6800";     --       FIM:   HLT
                                         -- .data
                dMEM(00) := x"0001";     --       CNT:   DB    1
                dMEM(01) := x"0005";     --       END:   DB    5


            -----------------------------------------------------------------------------
            when  01    =>               -- CONTADOR de 3 a 9
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --              LDA   R0, CNT
                iMEM(01) := x"0901";     --              LDA   R1, END
                iMEM(02) := x"1201";     --              LDAi  R2, 1
                iMEM(03) := x"2040";     --     CONTA:   ADD   R0, R2, R0
                iMEM(04) := x"1800";     --              STA   R0, CNT
                iMEM(05) := x"2903";     --              SUB   R1, R0, R3
                iMEM(06) := x"4808";     --              JZ    FIM
                iMEM(07) := x"6003";     --              JMP   CONTA
                iMEM(08) := x"6800";     --       FIM:   HLT
                                         -- .data
                dMEM(00) := x"0003";     --       CNT:   DB    3
                dMEM(01) := x"0009";     --       END:   DB    9


            -----------------------------------------------------------------------------
            when  02    =>               -- CONTADOR de -5 a 10
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --              LDA   R0, CNT
                iMEM(01) := x"0901";     --              LDA   R1, END
                iMEM(02) := x"1201";     --              LDAi  R2, 1
                iMEM(03) := x"2040";     --     CONTA:   ADD   R0, R2, R0
                iMEM(04) := x"1800";     --              STA   R0, CNT
                iMEM(05) := x"2903";     --              SUB   R1, R0, R3
                iMEM(06) := x"4808";     --              JZ    FIM
                iMEM(07) := x"6003";     --              JMP   CONTA
                iMEM(08) := x"6800";     --       FIM:   HLT
                                         -- .data
                dMEM(00) := x"FFFB";     --       CNT:   DB    65531    ; -5
                dMEM(01) := x"000A";     --       END:   DB    10


            -----------------------------------------------------------------------------
            when  03    =>               -- CONTADOR de -7 a -1
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --              LDA   R0, CNT
                iMEM(01) := x"0901";     --              LDA   R1, END
                iMEM(02) := x"1201";     --              LDAi  R2, 1
                iMEM(03) := x"2040";     --     CONTA:   ADD   R0, R2, R0
                iMEM(04) := x"1800";     --              STA   R0, CNT
                iMEM(05) := x"2903";     --              SUB   R1, R0, R3
                iMEM(06) := x"4808";     --              JZ    FIM
                iMEM(07) := x"6003";     --              JMP   CONTA
                iMEM(08) := x"6800";     --       FIM:   HLT
                                         -- .data
                dMEM(00) := x"FFF9";     --       CNT:   DB    65529    ; -7
                dMEM(01) := x"FFFF";     --       END:   DB    65535    ; -1


            -----------------------------------------------------------------------------
            when  04    =>               -- COMPARADOR 3 e 4
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --               LDA   R1, N1
                iMEM(01) := x"0A01";     --               LDA   R2, N2
                iMEM(02) := x"1301";     --               LDAi  R3, 1
                iMEM(03) := x"2A20";     --      TESTA:   SUB   R2, R1, R0
                iMEM(04) := x"480A";     --               JZ    CASO3
                iMEM(05) := x"5808";     --               JN    CASO2
                iMEM(06) := x"1B02";     --      CASO1:   STA   R3, N1menorN2
                iMEM(07) := x"600B";     --               JMP   FIM
                iMEM(08) := x"1B03";     --      CASO2:   STA   R3, N1maiorN2
                iMEM(09) := x"600B";     --               JMP   FIM
                iMEM(10) := x"1B04";     --      CASO3:   STA   R3, N1igualN2
                iMEM(11) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0003";     --         N1:   DB    3
                dMEM(01) := x"0004";     --         N2:   DB    4
                dMEM(02) := x"0000";     --  N1menorN2:   DB    0
                dMEM(03) := x"0000";     --  N1maiorN2:   DB    0
                dMEM(04) := x"0000";     --  N1igualN2:   DB    0


            -----------------------------------------------------------------------------
            when  05    =>               -- COMPARADOR 5 e 3
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --               LDA   R1, N1
                iMEM(01) := x"0A01";     --               LDA   R2, N2
                iMEM(02) := x"1301";     --               LDAi  R3, 1
                iMEM(03) := x"2A20";     --      TESTA:   SUB   R2, R1, R0
                iMEM(04) := x"480A";     --               JZ    CASO3
                iMEM(05) := x"5808";     --               JN    CASO2
                iMEM(06) := x"1B02";     --      CASO1:   STA   R3, N1menorN2
                iMEM(07) := x"600B";     --               JMP   FIM
                iMEM(08) := x"1B03";     --      CASO2:   STA   R3, N1maiorN2
                iMEM(09) := x"600B";     --               JMP   FIM
                iMEM(10) := x"1B04";     --      CASO3:   STA   R3, N1igualN2
                iMEM(11) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0005";     --         N1:   DB    5
                dMEM(01) := x"0003";     --         N2:   DB    3
                dMEM(02) := x"0000";     --  N1menorN2:   DB    0
                dMEM(03) := x"0000";     --  N1maiorN2:   DB    0
                dMEM(04) := x"0000";     --  N1igualN2:   DB    0


            -----------------------------------------------------------------------------
            when  06    =>               -- COMPARADOR 5 e 5
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --               LDA   R1, N1
                iMEM(01) := x"0A01";     --               LDA   R2, N2
                iMEM(02) := x"1301";     --               LDAi  R3, 1
                iMEM(03) := x"2A20";     --      TESTA:   SUB   R2, R1, R0
                iMEM(04) := x"480A";     --               JZ    CASO3
                iMEM(05) := x"5808";     --               JN    CASO2
                iMEM(06) := x"1B02";     --      CASO1:   STA   R3, N1menorN2
                iMEM(07) := x"600B";     --               JMP   FIM
                iMEM(08) := x"1B03";     --      CASO2:   STA   R3, N1maiorN2
                iMEM(09) := x"600B";     --               JMP   FIM
                iMEM(10) := x"1B04";     --      CASO3:   STA   R3, N1igualN2
                iMEM(11) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0005";     --         N1:   DB    5
                dMEM(01) := x"0005";     --         N2:   DB    5
                dMEM(02) := x"0000";     --  N1menorN2:   DB    0
                dMEM(03) := x"0000";     --  N1maiorN2:   DB    0
                dMEM(04) := x"0000";     --  N1igualN2:   DB    0


            -----------------------------------------------------------------------------
            when  07    =>               -- COMPARADOR -3 e -4
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --               LDA   R1, N1
                iMEM(01) := x"0A01";     --               LDA   R2, N2
                iMEM(02) := x"1301";     --               LDAi  R3, 1
                iMEM(03) := x"2A20";     --      TESTA:   SUB   R2, R1, R0
                iMEM(04) := x"480A";     --               JZ    CASO3
                iMEM(05) := x"5808";     --               JN    CASO2
                iMEM(06) := x"1B02";     --      CASO1:   STA   R3, N1menorN2
                iMEM(07) := x"600B";     --               JMP   FIM
                iMEM(08) := x"1B03";     --      CASO2:   STA   R3, N1maiorN2
                iMEM(09) := x"600B";     --               JMP   FIM
                iMEM(10) := x"1B04";     --      CASO3:   STA   R3, N1igualN2
                iMEM(11) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"FFFD";     --         N1:   DB    65533    ; -3
                dMEM(01) := x"FFFC";     --         N2:   DB    65532    ; -4
                dMEM(02) := x"0000";     --  N1menorN2:   DB    0
                dMEM(03) := x"0000";     --  N1maiorN2:   DB    0
                dMEM(04) := x"0000";     --  N1igualN2:   DB    0


            -----------------------------------------------------------------------------
            when  08    =>               -- MULTIPLICAÇÃO de 5 e 3
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --     SEZERO:   LDA   R1, N1
                iMEM(01) := x"480F";     --               JZ    FIM
                iMEM(02) := x"0A01";     --               LDA   R2, N2
                iMEM(03) := x"480F";     --               JZ    FIM
                iMEM(04) := x"1301";     --               LDAi  R3, 1
                iMEM(05) := x"0C02";     --               LDA   R4, RE
                iMEM(06) := x"2947";     --      TESTA:   SUB   R1, R2, R7
                iMEM(07) := x"580A";     --               JN    MULT
                iMEM(08) := x"0A00";     --     INVERT:   LDA   R2, N1
                iMEM(09) := x"0901";     --               LDA   R1, N2
                iMEM(10) := x"2444";     --       MULT:   ADD   R4, R2, R4
                iMEM(11) := x"1C02";     --               STA   R4, RE
                iMEM(12) := x"2961";     --               SUB   R1, R3, R1
                iMEM(13) := x"480F";     --               JZ    FIM
                iMEM(14) := x"600A";     --               JMP   MULT
                iMEM(15) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0005";     --         N1:   DB    5
                dMEM(01) := x"0003";     --         N2:   DB    3
                dMEM(02) := x"0000";     --         RE:   DB    0


            -----------------------------------------------------------------------------
            when  09    =>               -- MULTIPLICAÇÃO de 3 e 5
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --     SEZERO:   LDA   R1, N1
                iMEM(01) := x"480F";     --               JZ    FIM
                iMEM(02) := x"0A01";     --               LDA   R2, N2
                iMEM(03) := x"480F";     --               JZ    FIM
                iMEM(04) := x"1301";     --               LDAi  R3, 1
                iMEM(05) := x"0C02";     --               LDA   R4, RE
                iMEM(06) := x"2947";     --      TESTA:   SUB   R1, R2, R7
                iMEM(07) := x"580A";     --               JN    MULT
                iMEM(08) := x"0A00";     --     INVERT:   LDA   R2, N1
                iMEM(09) := x"0901";     --               LDA   R1, N2
                iMEM(10) := x"2444";     --       MULT:   ADD   R4, R2, R4
                iMEM(11) := x"1C02";     --               STA   R4, RE
                iMEM(12) := x"2961";     --               SUB   R1, R3, R1
                iMEM(13) := x"480F";     --               JZ    FIM
                iMEM(14) := x"600A";     --               JMP   MULT
                iMEM(15) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0003";     --         N1:   DB    3
                dMEM(01) := x"0005";     --         N2:   DB    5
                dMEM(02) := x"0000";     --         RE:   DB    0


            -----------------------------------------------------------------------------
            when  10    =>               -- MULTIPLICAÇÃO de 5 e 0
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --     SEZERO:   LDA   R1, N1
                iMEM(01) := x"480F";     --               JZ    FIM
                iMEM(02) := x"0A01";     --               LDA   R2, N2
                iMEM(03) := x"480F";     --               JZ    FIM
                iMEM(04) := x"1301";     --               LDAi  R3, 1
                iMEM(05) := x"0C02";     --               LDA   R4, RE
                iMEM(06) := x"2947";     --      TESTA:   SUB   R1, R2, R7
                iMEM(07) := x"580A";     --               JN    MULT
                iMEM(08) := x"0A00";     --     INVERT:   LDA   R2, N1
                iMEM(09) := x"0901";     --               LDA   R1, N2
                iMEM(10) := x"2444";     --       MULT:   ADD   R4, R2, R4
                iMEM(11) := x"1C02";     --               STA   R4, RE
                iMEM(12) := x"2961";     --               SUB   R1, R3, R1
                iMEM(13) := x"480F";     --               JZ    FIM
                iMEM(14) := x"600A";     --               JMP   MULT
                iMEM(15) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0005";     --         N1:   DB    5
                dMEM(01) := x"0000";     --         N2:   DB    0
                dMEM(02) := x"0000";     --         RE:   DB    0


            -----------------------------------------------------------------------------
            when  11    =>               -- MULTIPLICAÇÃO de 0 e 4
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --     SEZERO:   LDA   R1, N1
                iMEM(01) := x"480F";     --               JZ    FIM
                iMEM(02) := x"0A01";     --               LDA   R2, N2
                iMEM(03) := x"480F";     --               JZ    FIM
                iMEM(04) := x"1301";     --               LDAi  R3, 1
                iMEM(05) := x"0C02";     --               LDA   R4, RE
                iMEM(06) := x"2947";     --      TESTA:   SUB   R1, R2, R7
                iMEM(07) := x"580A";     --               JN    MULT
                iMEM(08) := x"0A00";     --     INVERT:   LDA   R2, N1
                iMEM(09) := x"0901";     --               LDA   R1, N2
                iMEM(10) := x"2444";     --       MULT:   ADD   R4, R2, R4
                iMEM(11) := x"1C02";     --               STA   R4, RE
                iMEM(12) := x"2961";     --               SUB   R1, R3, R1
                iMEM(13) := x"480F";     --               JZ    FIM
                iMEM(14) := x"600A";     --               JMP   MULT
                iMEM(15) := x"6800";     --        FIM:   HLT
                                         -- .data
                dMEM(00) := x"0000";     --         N1:   DB    0
                dMEM(01) := x"0004";     --         N2:   DB    4
                dMEM(02) := x"0000";     --         RE:   DB    0


            -----------------------------------------------------------------------------
            when  12    =>               -- MOVIMENTAÇÃO DE DADOS (LDA, LDAi e STA)
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --     LDA   R0, v0p
                iMEM(01) := x"0901";     --     LDA   R1, v1p
                iMEM(02) := x"0A02";     --     LDA   R2, v1n
                iMEM(03) := x"1202";     --     LDAi  R2, 2
                iMEM(04) := x"1A03";     --     STA   R2, v2p
                iMEM(05) := x"1303";     --     LDAi  R3, 3
                iMEM(06) := x"1B05";     --     STA   R3, v3p
                iMEM(07) := x"1404";     --     LDAi  R4, 4
                iMEM(08) := x"1C07";     --     STA   R4, v4p
                iMEM(09) := x"1505";     --     LDAi  R5, 5
                iMEM(10) := x"1D09";     --     STA   R5, v5p
                iMEM(11) := x"1606";     --     LDAi  R6, 6
                iMEM(12) := x"1E0B";     --     STA   R6, v6p
                iMEM(13) := x"1707";     --     LDAi  R7, 7
                iMEM(14) := x"1F0D";     --     STA   R7, v7p
                iMEM(15) := x"12FE";     --     LDAi  R2, 254   ; -2
                iMEM(16) := x"1A04";     --     STA   R2, v2n
                iMEM(17) := x"13FD";     --     LDAi  R3, 253   ; -3
                iMEM(18) := x"1B06";     --     STA   R3, v3n
                iMEM(19) := x"14FC";     --     LDAi  R4, 252   ; -4
                iMEM(20) := x"1C08";     --     STA   R4, v4n
                iMEM(21) := x"15FB";     --     LDAi  R5, 251   ; -5
                iMEM(22) := x"1D0A";     --     STA   R5, v5n
                iMEM(23) := x"16FA";     --     LDAi  R6, 250   ; -6
                iMEM(24) := x"1E0C";     --     STA   R6, v6n
                iMEM(25) := x"17F9";     --     LDAi  R7, 249   ; -7
                iMEM(26) := x"1F0E";     --     STA   R7, v7n
                iMEM(27) := x"107F";     --     LDAi  R0, 127
                iMEM(28) := x"180F";     --     STA   R0, v127p
                iMEM(29) := x"1181";     --     LDAi  R1, 129   ; -127
                iMEM(30) := x"1910";     --     STA   R1, v127n
                iMEM(31) := x"6800";     --     HLT
                                         -- .data
                dMEM(00) := x"0000";     --    v0p:   DB  0
                dMEM(01) := x"0001";     --    v1p:   DB  1
                dMEM(02) := x"FFFF";     --    v1n:   DB  65535
                dMEM(03) := x"0000";     --    v2p:   DB  0    ; 0002
                dMEM(04) := x"0000";     --    v2n:   DB  0    ; FFFE
                dMEM(05) := x"0000";     --    v3p:   DB  0    ; 0003
                dMEM(06) := x"0000";     --    v3n:   DB  0    ; FFFD
                dMEM(07) := x"0000";     --    v4p:   DB  0    ; 0004
                dMEM(08) := x"0000";     --    v4n:   DB  0    ; FFFC
                dMEM(09) := x"0000";     --    v5p:   DB  0    ; 0005
                dMEM(10) := x"0000";     --    v5n:   DB  0    ; FFFB
                dMEM(11) := x"0000";     --    v6p:   DB  0    ; 0006
                dMEM(12) := x"0000";     --    v6n:   DB  0    ; FFFA
                dMEM(13) := x"0000";     --    v7p:   DB  0    ; 0007
                dMEM(14) := x"0000";     --    v7n:   DB  0    ; FFF9
                dMEM(15) := x"0000";     --  v127p:   DB  0    ; 007F
                dMEM(16) := x"0000";     --  v127n:   DB  0    ; FF81


            -----------------------------------------------------------------------------
            when  13    =>               -- OPERAÇÕES ARITMÉTICAS (ADD e SUB)
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"1404";     --     LDAi  R4, 4
                iMEM(01) := x"1202";     --     LDAi  R2, 2
                iMEM(02) := x"2281";     --     ADD   R2, R4, R1
                iMEM(03) := x"1907";     --     STA   R1, v6p
                iMEM(04) := x"2C41";     --     SUB   R4, R2, R1
                iMEM(05) := x"1901";     --     STA   R1, v2p
                iMEM(06) := x"2A81";     --     SUB   R2, R4, R1
                iMEM(07) := x"1902";     --     STA   R1, v2n
                iMEM(08) := x"1403";     --     LDAi  R4, 3
                iMEM(09) := x"12FE";     --     LDAi  R2, 254      ; -2
                iMEM(10) := x"2441";     --     ADD   R4, R2, R1
                iMEM(11) := x"1900";     --     STA   R1, v1p
                iMEM(12) := x"2C41";     --     SUB   R4, R2, R1
                iMEM(13) := x"1905";     --     STA   R1, v5p
                iMEM(14) := x"2A81";     --     SUB   R2, R4, R1
                iMEM(15) := x"1906";     --     STA   R1, v5n
                iMEM(16) := x"14FD";     --     LDAi  R4, 253      ; -3
                iMEM(17) := x"12FA";     --     LDAi  R2, 250      ; -6
                iMEM(18) := x"2441";     --     ADD   R4, R2, R1
                iMEM(19) := x"1908";     --     STA   R1, v9n
                iMEM(20) := x"2C41";     --     SUB   R4, R2, R1
                iMEM(21) := x"1903";     --     STA   R1, v3p
                iMEM(22) := x"2A81";     --     SUB   R2, R4, R1
                iMEM(23) := x"1904";     --     STA   R1, v3n
                iMEM(24) := x"6800";     --     HLT
                                         -- .data
                dMEM(00) := x"0000";     --    v1p:   DB  0    ; 0001
                dMEM(01) := x"0000";     --    v2p:   DB  0    ; 0002
                dMEM(02) := x"0000";     --    v2n:   DB  0    ; FFFE
                dMEM(03) := x"0000";     --    v3p:   DB  0    ; 0003
                dMEM(04) := x"0000";     --    v3n:   DB  0    ; FFFD
                dMEM(05) := x"0000";     --    v5p:   DB  0    ; 0005
                dMEM(06) := x"0000";     --    v5n:   DB  0    ; FFFB
                dMEM(07) := x"0000";     --    v6p:   DB  0    ; 0006
                dMEM(08) := x"0000";     --    v9n:   DB  0    ; FFF7


            -----------------------------------------------------------------------------
            when  14    =>               -- OPERAÇÕES LÓGICAS (AND, OR e NOT)
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0800";     --     LDA   R0, v00FF
                iMEM(01) := x"0901";     --     LDA   R1, v0F0F
                iMEM(02) := x"0A02";     --     LDA   R2, v5A5A
                iMEM(03) := x"3023";     --     AND   R0, R1, R3
                iMEM(04) := x"1B03";     --     STA   R3, v000F
                iMEM(05) := x"3044";     --     AND   R0, R2, R4
                iMEM(06) := x"1C04";     --     STA   R4, v005A
                iMEM(07) := x"3823";     --     OR    R0, R1, R3
                iMEM(08) := x"1B05";     --     STA   R3, v0FFF
                iMEM(09) := x"3844";     --     OR    R0, R2, R4
                iMEM(10) := x"1C06";     --     STA   R4, v5AFF
                iMEM(11) := x"4103";     --     NOT   R1, R3
                iMEM(12) := x"1B07";     --     STA   R3, vF0F0
                iMEM(13) := x"4204";     --     NOT   R2, R4
                iMEM(14) := x"1C08";     --     STA   R4, vA5A5
                                         -- .data
                dMEM(00) := x"00FF";     --   v00FF:  DB  255
                dMEM(01) := x"0F0F";     --   v0F0F:  DB  3855
                dMEM(02) := x"5A5A";     --   v5A5A:  DB  23130
                dMEM(03) := x"0000";     --   v000F:  DB  0    ; 000F
                dMEM(04) := x"0000";     --   v005A:  DB  0    ; 005A
                dMEM(05) := x"0000";     --   v0FFF:  DB  0    ; 0FFF
                dMEM(06) := x"0000";     --   v5AFF:  DB  0    ; 5AFF
                dMEM(07) := x"0000";     --   vF0F0:  DB  0    ; F0F0
                dMEM(08) := x"0000";     --   vA5A5:  DB  0    ; A5A5


            -----------------------------------------------------------------------------
            when  15    =>               -- OPERAÇÕES DE DESVIOS/SALTO (JMP, JZ e JN)
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"1101";     --           LDAi  R1, 1
                iMEM(01) := x"4848";     --           JZ    FIM
                iMEM(02) := x"5848";     --           JN    FIM
                iMEM(03) := x"1200";     --           LDAi  R2, 0
                iMEM(04) := x"5848";     --           JN    FIM
                iMEM(05) := x"4840";     --           JZ    L01
                iMEM(06) := x"13FF";     --    L02:   LDAi  R3, 255
                iMEM(07) := x"4848";     --           JZ    FIM
                iMEM(08) := x"5812";     --           JN    L03
                iMEM(09) := x"2144";     --    L06:   ADD   R1, R2, R4
                iMEM(10) := x"4848";     --           JZ    FIM
                iMEM(11) := x"5848";     --           JN    FIM
                iMEM(12) := x"2165";     --           ADD   R1, R3, R5
                iMEM(13) := x"5848";     --           JN    FIM
                iMEM(14) := x"4842";     --           JZ    L07
                iMEM(15) := x"2266";     --    L08:   ADD   R2, R3, R6
                iMEM(16) := x"4848";     --           JZ    FIM
                iMEM(17) := x"581B";     --           JN    L09
                iMEM(18) := x"0901";     --    L03:   LDA   R1, v1p
                iMEM(19) := x"4848";     --           JZ    FIM
                iMEM(20) := x"5848";     --           JN    FIM
                iMEM(21) := x"0A00";     --           LDA   R2, v0p
                iMEM(22) := x"5848";     --           JN    FIM
                iMEM(23) := x"4841";     --           JZ    L04
                iMEM(24) := x"0B02";     --    L05:   LDA   R3, v1n
                iMEM(25) := x"4848";     --           JZ    FIM
                iMEM(26) := x"5809";     --           JN    L06
                iMEM(27) := x"2944";     --    L09:   SUB   R1, R2, R4
                iMEM(28) := x"4848";     --           JZ    FIM
                iMEM(29) := x"5848";     --           JN    FIM
                iMEM(30) := x"2985";     --           SUB   R1, R4, R5
                iMEM(31) := x"5848";     --           JN    FIM
                iMEM(32) := x"4843";     --           JZ    L10
                iMEM(33) := x"2A26";     --    L11:   SUB   R2, R1, R6
                iMEM(34) := x"4848";     --           JZ    FIM
                iMEM(35) := x"582D";     --           JN    L12
                iMEM(36) := x"3944";     --    L15:   OR    R1, R2, R4
                iMEM(37) := x"4848";     --           JZ    FIM
                iMEM(38) := x"5848";     --           JN    FIM
                iMEM(39) := x"3AA5";     --           OR    R2, R5, R5
                iMEM(40) := x"5848";     --           JN    FIM
                iMEM(41) := x"4845";     --           JZ    L16
                iMEM(42) := x"3966";     --    L17:   OR    R1, R3, R6
                iMEM(43) := x"4848";     --           JZ    FIM
                iMEM(44) := x"5836";     --           JN    L18
                iMEM(45) := x"3A84";     --    L12:   OR    R2, R4, R4
                iMEM(46) := x"4848";     --           JZ    FIM
                iMEM(47) := x"5848";     --           JN    FIM
                iMEM(48) := x"3145";     --           AND   R1, R2, R5
                iMEM(49) := x"5848";     --           JN    FIM
                iMEM(50) := x"4844";     --           JZ    L13
                iMEM(51) := x"33C6";     --    L14:   AND   R3, R6, R6
                iMEM(52) := x"4848";     --           JZ    FIM
                iMEM(53) := x"5824";     --           JN    L15
                iMEM(54) := x"0A03";     --    L18:   LDA   R2, vX
                iMEM(55) := x"4204";     --           NOT   R2, R4
                iMEM(56) := x"4848";     --           JZ    FIM
                iMEM(57) := x"5848";     --           JN    FIM
                iMEM(58) := x"4305";     --           NOT   R3, R5
                iMEM(59) := x"5848";     --           JN    FIM
                iMEM(60) := x"4846";     --           JZ    L19
                iMEM(61) := x"4106";     --    L20:   NOT   R1, R6
                iMEM(62) := x"4848";     --           JZ    FIM
                iMEM(63) := x"5847";     --           JN    TOK
                iMEM(64) := x"6006";     --    L01:   JMP   L02
                iMEM(65) := x"6018";     --    L04:   JMP   L05
                iMEM(66) := x"600F";     --    L07:   JMP   L08
                iMEM(67) := x"6021";     --    L10:   JMP   L11
                iMEM(68) := x"6033";     --    L13:   JMP   L14
                iMEM(69) := x"602A";     --    L16:   JMP   L17
                iMEM(70) := x"603D";     --    L19:   JMP   L20
                iMEM(71) := x"1904";     --    TOK:   STA   R1, OK
                iMEM(72) := x"6800";     --    FIM:   HLT
                                         -- .data
                dMEM(00) := x"0000";     --    v0p:   DB    0
                dMEM(01) := x"0001";     --    v1p:   DB    1
                dMEM(02) := x"FFFF";     --    v1n:   DB    65535   ; FFFF
                dMEM(03) := x"8001";     --     vX:   DB    32769   ; 8001
                dMEM(04) := x"0000";     --     OK:   DB    0


            -----------------------------------------------------------------------------
            when  16    =>                -- FLAGs CARRY e OVERFLOW
            -----------------------------------------------------------------------------
                                         -- .text
                iMEM(00) := x"0900";     --      LDA   R1, in8001
                iMEM(01) := x"0A01";     --      LDA   R2, in0000
                iMEM(02) := x"0B02";     --      LDA   R3, inFFFF
                iMEM(03) := x"0C03";     --      LDA   R4, in0001
                iMEM(04) := x"0D04";     --      LDA   R5, in8080
                iMEM(05) := x"2140";     --      ADD   R1, R2, R0
                iMEM(06) := x"1805";     --      STA   R0, a8001
                iMEM(07) := x"2060";     --      ADD   R0, R3, R0
                iMEM(08) := x"1806";     --      STA   R0, a8000c
                iMEM(09) := x"2060";     --      ADD   R0, R3, R0
                iMEM(10) := x"1807";     --      STA   R0, a7FFFcv
                iMEM(11) := x"2060";     --      ADD   R0, R3, R0
                iMEM(12) := x"1808";     --      STA   R0, a7FFEc
                iMEM(13) := x"2080";     --      ADD   R0, R4, R0
                iMEM(14) := x"1809";     --      STA   R0, a7FFF
                iMEM(15) := x"2080";     --      ADD   R0, R4, R0
                iMEM(16) := x"180A";     --      STA   R0, a8000v
                iMEM(17) := x"2860";     --      SUB   R0, R3, R0
                iMEM(18) := x"180B";     --      STA   R0, s8001
                iMEM(19) := x"2880";     --      SUB   R0, R4, R0
                iMEM(20) := x"180C";     --      STA   R0, s8000c
                iMEM(21) := x"2880";     --      SUB   R0, R4, R0
                iMEM(22) := x"180D";     --      STA   R0, s7FFFcv
                iMEM(23) := x"2860";     --      SUB   R0, R3, R0
                iMEM(24) := x"180E";     --      STA   R0, s8000v
                iMEM(25) := x"28A0";     --      SUB   R0, R5, R0
                iMEM(26) := x"180F";     --      STA   R0, sFF80
                iMEM(27) := x"28A0";     --      SUB   R0, R5, R0
                iMEM(28) := x"1810";     --      STA   R0, s7F00c
                iMEM(29) := x"6800";     --      HLT
                                         -- .data
                dMEM(00) := x"8001";     --   in8001:  DB  32769
                dMEM(01) := x"0000";     --   in0000:  DB  0
                dMEM(02) := x"FFFF";     --   inFFFF:  DB  65535
                dMEM(03) := x"0001";     --   in0001:  DB  1
                dMEM(04) := x"8080";     --   in8080:  DB  32896
                dMEM(05) := x"0000";     --    a8001:  DB  0    ; 8001
                dMEM(06) := x"0000";     --   a8000c:  DB  0    ; 8000 - CARRY
                dMEM(07) := x"0000";     --  a7FFFcv:  DB  0    ; 7FFF - CARRY e OVERFLOW
                dMEM(08) := x"0000";     --   a7FFEc:  DB  0    ; 7FFE - CARRY
                dMEM(09) := x"0000";     --    a7FFF:  DB  0    ; 7FFF
                dMEM(10) := x"0000";     --   a8000v:  DB  0    ; 8000 - OVERFLOW
                dMEM(11) := x"0000";     --    s8001:  DB  0    ; 8001
                dMEM(12) := x"0000";     --   s8000c:  DB  0    ; 8000 - CARRY
                dMEM(13) := x"0000";     --  s7FFFcv:  DB  0    ; 7FFF - CARRY e OVERFLOW
                dMEM(14) := x"0000";     --   s8000v:  DB  0    ; 8000 - OVERFLOW
                dMEM(15) := x"0000";     --    sFF80:  DB  0    ; FF80
                dMEM(16) := x"0000";     --   s7F00c:  DB  0    ; 7F00 - CARRY

            when  others    =>     null;

         end case;

         if TIPO = 0 then return iMEM;      -- Retorna Memória de Instruções
                     else return dMEM;      -- Retorna Memória de Dados
         end if;

    end function;

end package body;



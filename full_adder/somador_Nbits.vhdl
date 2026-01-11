library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_Nbits is
    port (
        A, B , Cin :   in  std_logic;
        S          :   out std_logic;
        Cout       :   out std_logic
    );
end somador_Nbits;

architecture comportamento1bit of somador_Nbits is
    
begin
    S    <= A xor B xor Cin ;
    Cout <= (A and B) or (A and Cin) or (B and Cin);

end architecture;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somadorNbits is
    generic (
        N : natural := 4
    );

    port (
        A, B : in  std_logic_vector(N - 1 downto 0);
        Cin  : in  std_logic;
        S    : out std_logic_vector(N - 1 downto 0);
        Cout : out std_logic
    );
end somadorNbits;

architecture comportamentoNbits of somadorNbits is

    signal cin_interno : std_logic_vector(N downto 0);

begin
    cin_interno(0) <= Cin;

    ADDER_GEN : for i in 0 to N-1 generate
        FA : entity work.somador_Nbits
            port map (
                A => A(i),
                B => B(i),
                Cin => cin_interno(i),
                S => S(i),
                Cout => cin_interno(i+1)
            );
    end generate ;

    Cout <= cin_interno(N);

end comportamentoNbits ;
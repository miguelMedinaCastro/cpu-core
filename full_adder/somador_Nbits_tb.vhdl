library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_Nbits_tb is
end somador_Nbits_tb;

architecture sim of somador_Nbits_tb is

    constant N : natural := 4;

    signal A, B : std_logic_vector(N-1 downto 0);
    signal S    : std_logic_vector(N-1 downto 0);
    signal Cin  : std_logic;
    signal Cout : std_logic;
    
    signal contador : std_logic_vector(N downto 0);

begin
    DUT : entity work.somadorNbits
        generic map (
            N => N
        )

        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            S    => S,
            Cout => Cout
        );

    -- process
    -- begin
        
    --     contador <= std_logic_vector(unsigned(contador) + 1);
    --     wait for 10 ns;
        
    --     if contador = "11111" then
    --         wait;
    --     end if;
    -- end process;

    process
    begin
   -- 0 + 0
        A <= "0000"; B <= "0000"; Cin <= '0';
        wait for 10 ns;

        -- 1 + 1
        A <= "0001"; B <= "0001"; Cin <= '0';
        wait for 10 ns;

        -- 3 + 5 = 8
        A <= "0011"; B <= "0101"; Cin <= '0';
        wait for 10 ns;

        -- 7 + 8 = 15
        A <= "0111"; B <= "1000"; Cin <= '0';
        wait for 10 ns;

        -- 15 + 1 = 16
        A <= "1111"; B <= "0001"; Cin <= '0';
        wait for 10 ns;
        wait; -- fim do TB
    end process;
end architecture;
